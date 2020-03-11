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


import java.io.Serializable;
import hunt.collection.ArrayList;
import hunt.collection.HashSet;
import hunt.collection.List;
import hunt.collection.Set;

import org.apache.commons.lang3.StringUtils;
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
class GetFormDefinitionsForProcessDefinitionCmd implements Command<List<FormDefinition>>, Serializable {

    private static final long serialVersionUID = 1L;
    protected string processDefinitionId;
    protected FormRepositoryService formRepositoryService;

    public GetFormDefinitionsForProcessDefinitionCmd(string processDefinitionId) {
        this.processDefinitionId = processDefinitionId;
    }

    @Override
    public List<FormDefinition> execute(CommandContext commandContext) {
        ProcessDefinition processDefinition = ProcessDefinitionUtil.getProcessDefinition(processDefinitionId);

        if (processDefinition is null) {
            throw new FlowableObjectNotFoundException("Cannot find process definition for id: " + processDefinitionId, ProcessDefinition.class);
        }

        BpmnModel bpmnModel = ProcessDefinitionUtil.getBpmnModel(processDefinitionId);

        if (bpmnModel is null) {
            throw new FlowableObjectNotFoundException("Cannot find bpmn model for process definition id: " + processDefinitionId, BpmnModel.class);
        }

        if (CommandContextUtil.getFormRepositoryService() is null) {
            throw new FlowableException("Form repository service is not available");
        }

        formRepositoryService = CommandContextUtil.getFormRepositoryService();
        List<FormDefinition> formDefinitions = getFormDefinitionsFromModel(bpmnModel, processDefinition);

        return formDefinitions;
    }

    protected List<FormDefinition> getFormDefinitionsFromModel(BpmnModel bpmnModel, ProcessDefinition processDefinition) {
        Set!string formKeys = new HashSet<>();
        List<FormDefinition> formDefinitions = new ArrayList<>();

        // for all start events
        List<StartEvent> startEvents = bpmnModel.getMainProcess().findFlowElementsOfType(StartEvent.class, true);

        for (StartEvent startEvent : startEvents) {
            if (StringUtils.isNotEmpty(startEvent.getFormKey())) {
                formKeys.add(startEvent.getFormKey());
            }
        }

        // for all user tasks
        List<UserTask> userTasks = bpmnModel.getMainProcess().findFlowElementsOfType(UserTask.class, true);

        for (UserTask userTask : userTasks) {
            if (StringUtils.isNotEmpty(userTask.getFormKey())) {
                formKeys.add(userTask.getFormKey());
            }
        }

        for (string formKey : formKeys) {
            addFormDefinitionToCollection(formDefinitions, formKey, processDefinition);
        }

        return formDefinitions;
    }

    protected void addFormDefinitionToCollection(List<FormDefinition> formDefinitions, string formKey, ProcessDefinition processDefinition) {
        FormDefinitionQuery formDefinitionQuery = formRepositoryService.createFormDefinitionQuery().formDefinitionKey(formKey);
        Deployment deployment = CommandContextUtil.getDeploymentEntityManager().findById(processDefinition.getDeploymentId());
        if (deployment.getParentDeploymentId() !is null) {
            List<FormDeployment> formDeployments = formRepositoryService.createDeploymentQuery().parentDeploymentId(deployment.getParentDeploymentId()).list();

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
