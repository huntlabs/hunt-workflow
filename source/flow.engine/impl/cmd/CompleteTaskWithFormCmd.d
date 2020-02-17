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


import java.util.Map;

import org.flowable.bpmn.model.UserTask;
import flow.common.api.FlowableIllegalArgumentException;
import flow.common.interceptor.CommandContext;
import flow.engine.impl.cfg.ProcessEngineConfigurationImpl;
import flow.engine.impl.util.CommandContextUtil;
import flow.engine.impl.util.ProcessDefinitionUtil;
import flow.engine.impl.util.TaskHelper;
import org.flowable.form.api.FormFieldHandler;
import org.flowable.form.api.FormInfo;
import org.flowable.form.api.FormRepositoryService;
import org.flowable.form.api.FormService;
import org.flowable.task.service.impl.persistence.entity.TaskEntity;

/**
 * @author Tijs Rademakers
 */
class CompleteTaskWithFormCmd extends NeedsActiveTaskCmd<Void> {

    private static final long serialVersionUID = 1L;
    protected string formDefinitionId;
    protected string outcome;
    protected Map<string, Object> variables;
    protected Map<string, Object> transientVariables;
    protected bool localScope;

    public CompleteTaskWithFormCmd(string taskId, string formDefinitionId, string outcome, Map<string, Object> variables) {
        super(taskId);
        this.formDefinitionId = formDefinitionId;
        this.outcome = outcome;
        this.variables = variables;
    }

    public CompleteTaskWithFormCmd(string taskId, string formDefinitionId, string outcome,
            Map<string, Object> variables, bool localScope) {

        this(taskId, formDefinitionId, outcome, variables);
        this.localScope = localScope;
    }

    public CompleteTaskWithFormCmd(string taskId, string formDefinitionId, string outcome,
            Map<string, Object> variables, Map<string, Object> transientVariables) {

        this(taskId, formDefinitionId, outcome, variables);
        this.transientVariables = transientVariables;
    }

    @Override
    protected Void execute(CommandContext commandContext, TaskEntity task) {
        FormService formService = CommandContextUtil.getFormService();
        if (formService == null) {
            throw new FlowableIllegalArgumentException("Form engine is not initialized");
        }

        FormRepositoryService formRepositoryService = CommandContextUtil.getFormRepositoryService();
        FormInfo formInfo = formRepositoryService.getFormModelById(formDefinitionId);

        if (formInfo != null) {
            ProcessEngineConfigurationImpl processEngineConfiguration = CommandContextUtil.getProcessEngineConfiguration(commandContext);
            FormFieldHandler formFieldHandler = processEngineConfiguration.getFormFieldHandler();
            if (isFormFieldValidationEnabled(task, processEngineConfiguration, task.getProcessDefinitionId(), task.getTaskDefinitionKey())) {
                formService.validateFormFields(formInfo, variables);
            }

            // Extract raw variables and complete the task
            Map<string, Object> taskVariables = formService.getVariablesFromFormSubmission(formInfo, variables, outcome);

            // The taskVariables are the variables that should be used when completing the task
            // the actual variables should instead be used when saving the form instances
            if (task.getProcessInstanceId() != null) {
                formService.saveFormInstance(variables, formInfo, task.getId(), task.getProcessInstanceId(),
                                task.getProcessDefinitionId(), task.getTenantId(), outcome);
            } else {
                formService.saveFormInstanceWithScopeId(variables, formInfo, task.getId(), task.getScopeId(), task.getScopeType(),
                                task.getScopeDefinitionId(), task.getTenantId(), outcome);
            }

            formFieldHandler.handleFormFieldsOnSubmit(formInfo, task.getId(), task.getProcessInstanceId(), null, null, taskVariables, task.getTenantId());

            TaskHelper.completeTask(task, taskVariables, transientVariables, localScope, commandContext);

        } else {
            TaskHelper.completeTask(task, variables, transientVariables, localScope, commandContext);
        }

        return null;
    }

    protected bool isFormFieldValidationEnabled(TaskEntity task, ProcessEngineConfigurationImpl processEngineConfiguration, string processDefinitionId,
        string taskDefinitionKey) {
        if (processEngineConfiguration.isFormFieldValidationEnabled()) {
            UserTask userTask = (UserTask) ProcessDefinitionUtil.getBpmnModel(processDefinitionId).getFlowElement(taskDefinitionKey);
            string formFieldValidationExpression = userTask.getValidateFormFields();
            return TaskHelper.isFormFieldValidationEnabled(task, processEngineConfiguration, formFieldValidationExpression);
        }
        return false;
    }

    @Override
    protected string getSuspendedTaskException() {
        return "Cannot complete a suspended task";
    }

}
