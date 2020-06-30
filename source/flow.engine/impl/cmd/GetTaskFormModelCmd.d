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
module flow.engine.impl.cmd.GetTaskFormModelCmd;

import hunt.time.LocalDateTime;
import hunt.collection.HashMap;
import hunt.collection.Map;

import flow.common.api.FlowableIllegalArgumentException;
import flow.common.api.FlowableObjectNotFoundException;
import flow.common.interceptor.Command;
import flow.common.interceptor.CommandContext;
import flow.engine.RepositoryService;
import flow.engine.impl.cfg.ProcessEngineConfigurationImpl;
import flow.engine.impl.util.CommandContextUtil;
import flow.engine.repository.Deployment;
import flow.engine.repository.ProcessDefinition;
import flow.form.api.FormFieldHandler;
import flow.form.api.FormInfo;
import flow.form.api.FormRepositoryService;
import flow.form.api.FormService;
import flow.task.api.TaskInfo;
import flow.task.api.history.HistoricTaskInstance;
import flow.variable.service.api.persistence.entity.VariableInstance;
/**
 * @author Tijs Rademakers
 */
class GetTaskFormModelCmd : Command!FormInfo {

    protected string taskId;
    protected bool ignoreVariables;

    this(string taskId, bool ignoreVariables) {
        this.taskId = taskId;
        this.ignoreVariables = ignoreVariables;
    }

    public FormInfo execute(CommandContext commandContext) {
        bool historic = false;

        ProcessEngineConfigurationImpl processEngineConfiguration = CommandContextUtil.getProcessEngineConfiguration(commandContext);
        FormService formService = CommandContextUtil.getFormService();
        if (formService is null) {
            throw new FlowableIllegalArgumentException("Form engine is not initialized");
        }

        TaskInfo task = CommandContextUtil.getTaskService(commandContext).getTask(taskId);
        Date endTime = null;
        if (task is null) {
            historic = true;
            task = CommandContextUtil.getHistoricTaskService(commandContext).getHistoricTask(taskId);
            if (task !is null) {
                endTime = (cast(HistoricTaskInstance) task).getEndTime();
            }
        }

        if (task is null) {
            throw new FlowableObjectNotFoundException("Task not found with id " ~ taskId);
        }

        Map!(string, Object) variables = new HashMap!(string, Object)();
        if (!ignoreVariables && task.getProcessInstanceId() !is null && task.getProcessInstanceId().length != 0) {

            if (!historic) {
                //processEngineConfiguration.getTaskService()
                //        .getVariableInstances(taskId).values()
                //        .stream()
                //        .forEach(variableInstance -> variables.putIfAbsent(variableInstance.getName(), variableInstance.getValue()));
                foreach (VariableInstance variableInstance ; processEngineConfiguration.getTaskService().getVariableInstances(taskId).values())
                {
                    variables.putIfAbsent(variableInstance.getName(), variableInstance.getValue());
                }

                //processEngineConfiguration.getRuntimeService().getVariableInstances(task.getProcessInstanceId()).values()
                //        .stream()
                //        .forEach(variableInstance -> variables.putIfAbsent(variableInstance.getName(), variableInstance.getValue()));

                foreach(VariableInstance variableInstance ; processEngineConfiguration.getRuntimeService().getVariableInstances(task.getProcessInstanceId()).values())
                {
                    variables.putIfAbsent(variableInstance.getName(), variableInstance.getValue());
                }


            } else {

                foreach(VariableInstance variableInstance ;  processEngineConfiguration.getHistoryService().createHistoricVariableInstanceQuery().taskId(taskId).list())
                {
                    variables.putIfAbsent(variableInstance.getVariableName(), variableInstance.getValue());
                }
                //processEngineConfiguration.getHistoryService()
                //        .createHistoricVariableInstanceQuery().taskId(taskId).list()
                //        .stream()
                //        .forEach(variableInstance -> variables.putIfAbsent(variableInstance.getVariableName(), variableInstance.getValue()));

                foreach (VariableInstance variableInstance ; processEngineConfiguration.getHistoryService().createHistoricVariableInstanceQuery().processInstanceId(task.getProcessInstanceId()).list())
                {
                    variables.putIfAbsent(variableInstance.getVariableName(), variableInstance.getValue());
                }
                //processEngineConfiguration.getHistoryService()
                //        .createHistoricVariableInstanceQuery().processInstanceId(task.getProcessInstanceId()).list()
                //        .stream()
                //        .forEach(variableInstance -> variables.putIfAbsent(variableInstance.getVariableName(), variableInstance.getValue()));

            }
        }

        string parentDeploymentId = null;
        if (task.getProcessDefinitionId() !is null && task.getProcessDefinitionId().length != 0) {
            RepositoryService repositoryService = processEngineConfiguration.getRepositoryService();
            ProcessDefinition processDefinition = repositoryService.getProcessDefinition(task.getProcessDefinitionId());
            Deployment deployment = repositoryService.createDeploymentQuery().deploymentId(processDefinition.getDeploymentId()).singleResult();
            parentDeploymentId = deployment.getParentDeploymentId();
        }

        FormInfo formInfo = null;
        if (ignoreVariables) {
            FormRepositoryService formRepositoryService = CommandContextUtil.getFormRepositoryService();
            formInfo = formRepositoryService.getFormModelByKeyAndParentDeploymentId(task.getFormKey(), parentDeploymentId,
                    task.getTenantId(), processEngineConfiguration.isFallbackToDefaultTenant());

        } else if (endTime !is null) {
            formInfo = formService.getFormInstanceModelByKeyAndParentDeploymentId(task.getFormKey(), parentDeploymentId,
                    taskId, task.getProcessInstanceId(), variables, task.getTenantId(), processEngineConfiguration.isFallbackToDefaultTenant());

        } else {
            formInfo = formService.getFormModelWithVariablesByKeyAndParentDeploymentId(task.getFormKey(), parentDeploymentId,
                    taskId, variables, task.getTenantId(), processEngineConfiguration.isFallbackToDefaultTenant());
        }

        // If form does not exists, we don't want to leak out this info to just anyone
        if (formInfo is null) {
            throw new FlowableObjectNotFoundException("Form model for task " ~ task.getTaskDefinitionKey() ~ " cannot be found for form key " ~ task.getFormKey());
        }

        FormFieldHandler formFieldHandler = CommandContextUtil.getProcessEngineConfiguration(commandContext).getFormFieldHandler();
        formFieldHandler.enrichFormFields(formInfo);

        return formInfo;
    }

}
