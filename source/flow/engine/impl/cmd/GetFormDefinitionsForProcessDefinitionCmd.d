/* Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
module flow.engine.impl.cmd.GetFormDefinitionsForProcessDefinitionCmd;

import hunt.collection.ArrayList;
import hunt.collection.HashSet;
import hunt.collection.List;
import hunt.collection.Set;

import flow.bpmn.model.BpmnModel;
import flow.bpmn.model.StartEvent;
import flow.bpmn.model.UserTask;
import flow.common.api.FlowableException;
import flow.common.api.FlowableObjectNotFoundException;
import flow.common.interceptor.Command;
import flow.common.interceptor.CommandContext;
import flow.engine.impl.util.CommandContextUtil;
import flow.engine.impl.util.ProcessDefinitionUtil;
import flow.engine.repository.Deployment;
import flow.engine.repository.ProcessDefinition;
import flow.form.api.FormDefinition;
import flow.form.api.FormDefinitionQuery;
import flow.form.api.FormDeployment;
import flow.form.api.FormRepositoryService;

/**
 * @author Yvo Swillens
 */
class GetFormDefinitionsForProcessDefinitionCmd : Command!(List!FormDefinition) {

    protected string processDefinitionId;
    protected FormRepositoryService formRepositoryService;

    this(string processDefinitionId) {
        this.processDefinitionId = processDefinitionId;
    }

    public List!FormDefinition execute(CommandContext commandContext) {
        ProcessDefinition processDefinition = ProcessDefinitionUtil.getProcessDefinition(processDefinitionId);

        if (processDefinition is null) {
            throw new FlowableObjectNotFoundException("Cannot find process definition for id: " ~ processDefinitionId);
        }

        BpmnModel bpmnModel = ProcessDefinitionUtil.getBpmnModel(processDefinitionId);

        if (bpmnModel is null) {
            throw new FlowableObjectNotFoundException("Cannot find bpmn model for process definition id: " ~ processDefinitionId);
        }

        if (CommandContextUtil.getFormRepositoryService() is null) {
            throw new FlowableException("Form repository service is not available");
        }

        formRepositoryService = CommandContextUtil.getFormRepositoryService();
        List!FormDefinition formDefinitions = getFormDefinitionsFromModel(bpmnModel, processDefinition);

        return formDefinitions;
    }

    protected List!FormDefinition getFormDefinitionsFromModel(BpmnModel bpmnModel, ProcessDefinition processDefinition) {
        Set!string formKeys = new HashSet!string();
        List!FormDefinition formDefinitions = new ArrayList!FormDefinition();

        // for all start events
        List!StartEvent startEvents = bpmnModel.getMainProcess().findFlowElementsOfType!StartEvent(typeid(StartEvent), true);

        foreach (StartEvent startEvent ; startEvents) {
            if (startEvent.getFormKey() !is null && startEvent.getFormKey().length != 0) {
                formKeys.add(startEvent.getFormKey());
            }
        }

        // for all user tasks
        List!UserTask userTasks = bpmnModel.getMainProcess().findFlowElementsOfType!UserTask(typeid(UserTask), true);

        foreach (UserTask userTask ; userTasks) {
            if (userTask.getFormKey() !is null && userTask.getFormKey().length != 0) {
                formKeys.add(userTask.getFormKey());
            }
        }

        foreach (string formKey ; formKeys) {
            addFormDefinitionToCollection(formDefinitions, formKey, processDefinition);
        }

        return formDefinitions;
    }

    protected void addFormDefinitionToCollection(List!FormDefinition formDefinitions, string formKey, ProcessDefinition processDefinition) {
        FormDefinitionQuery formDefinitionQuery = formRepositoryService.createFormDefinitionQuery().formDefinitionKey(formKey);
        Deployment deployment = CommandContextUtil.getDeploymentEntityManager().findById(processDefinition.getDeploymentId());
        if (deployment.getParentDeploymentId() !is null) {
            List!FormDeployment formDeployments = formRepositoryService.createDeploymentQuery().parentDeploymentId(deployment.getParentDeploymentId()).list();

            if (formDeployments !is null && formDeployments.size() > 0) {
                formDefinitionQuery.deploymentId(formDeployments.get(0).getId());
            } else {
                formDefinitionQuery.latestVersion();
            }

        } else {
            formDefinitionQuery.latestVersion();
        }

        FormDefinition formDefinition = formDefinitionQuery.singleResult();

        if (formDefinition !is null) {
            formDefinitions.add(formDefinition);
        }
    }
}
