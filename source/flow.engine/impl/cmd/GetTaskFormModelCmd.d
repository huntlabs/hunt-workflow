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
import java.util.Date;
import java.util.HashMap;
import java.util.Map;

import org.apache.commons.lang3.StringUtils;
import flow.common.api.FlowableIllegalArgumentException;
import flow.common.api.FlowableObjectNotFoundException;
import flow.common.interceptor.Command;
import flow.common.interceptor.CommandContext;
import flow.engine.RepositoryService;
import flow.engine.impl.cfg.ProcessEngineConfigurationImpl;
import flow.engine.impl.util.CommandContextUtil;
import flow.engine.repository.Deployment;
import flow.engine.repository.ProcessDefinition;
import org.flowable.form.api.FormFieldHandler;
import org.flowable.form.api.FormInfo;
import org.flowable.form.api.FormRepositoryService;
import org.flowable.form.api.FormService;
import org.flowable.task.api.TaskInfo;
import org.flowable.task.api.history.HistoricTaskInstance;

/**
 * @author Tijs Rademakers
 */
class GetTaskFormModelCmd implements Command<FormInfo>, Serializable {

    private static final long serialVersionUID = 1L;

    protected string taskId;
    protected boolean ignoreVariables;

    public GetTaskFormModelCmd(string taskId, boolean ignoreVariables) {
        this.taskId = taskId;
        this.ignoreVariables = ignoreVariables;
    }

    @Override
    public FormInfo execute(CommandContext commandContext) {
        boolean historic = false;

        ProcessEngineConfigurationImpl processEngineConfiguration = CommandContextUtil.getProcessEngineConfiguration(commandContext);
        FormService formService = CommandContextUtil.getFormService();
        if (formService == null) {
            throw new FlowableIllegalArgumentException("Form engine is not initialized");
        }

        TaskInfo task = CommandContextUtil.getTaskService(commandContext).getTask(taskId);
        Date endTime = null;
        if (task == null) {
            historic = true;
            task = CommandContextUtil.getHistoricTaskService(commandContext).getHistoricTask(taskId);
            if (task != null) {
                endTime = ((HistoricTaskInstance) task).getEndTime();
            }
        }

        if (task == null) {
            throw new FlowableObjectNotFoundException("Task not found with id " + taskId);
        }

        Map<string, Object> variables = new HashMap<>();
        if (!ignoreVariables && task.getProcessInstanceId() != null) {

            if (!historic) {
                processEngineConfiguration.getTaskService()
                        .getVariableInstances(taskId).values()
                        .stream()
                        .forEach(variableInstance -> variables.putIfAbsent(variableInstance.getName(), variableInstance.getValue()));

                processEngineConfiguration.getRuntimeService().getVariableInstances(task.getProcessInstanceId()).values()
                        .stream()
                        .forEach(variableInstance -> variables.putIfAbsent(variableInstance.getName(), variableInstance.getValue()));


            } else {

                processEngineConfiguration.getHistoryService()
                        .createHistoricVariableInstanceQuery().taskId(taskId).list()
                        .stream()
                        .forEach(variableInstance -> variables.putIfAbsent(variableInstance.getVariableName(), variableInstance.getValue()));

                processEngineConfiguration.getHistoryService()
                        .createHistoricVariableInstanceQuery().processInstanceId(task.getProcessInstanceId()).list()
                        .stream()
                        .forEach(variableInstance -> variables.putIfAbsent(variableInstance.getVariableName(), variableInstance.getValue()));

            }
        }

        string parentDeploymentId = null;
        if (StringUtils.isNotEmpty(task.getProcessDefinitionId())) {
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

        } else if (endTime != null) {
            formInfo = formService.getFormInstanceModelByKeyAndParentDeploymentId(task.getFormKey(), parentDeploymentId,
                    taskId, task.getProcessInstanceId(), variables, task.getTenantId(), processEngineConfiguration.isFallbackToDefaultTenant());

        } else {
            formInfo = formService.getFormModelWithVariablesByKeyAndParentDeploymentId(task.getFormKey(), parentDeploymentId,
                    taskId, variables, task.getTenantId(), processEngineConfiguration.isFallbackToDefaultTenant());
        }

        // If form does not exists, we don't want to leak out this info to just anyone
        if (formInfo == null) {
            throw new FlowableObjectNotFoundException("Form model for task " + task.getTaskDefinitionKey() + " cannot be found for form key " + task.getFormKey());
        }

        FormFieldHandler formFieldHandler = CommandContextUtil.getProcessEngineConfiguration(commandContext).getFormFieldHandler();
        formFieldHandler.enrichFormFields(formInfo);

        return formInfo;
    }

}
