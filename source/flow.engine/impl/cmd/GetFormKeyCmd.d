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



import flow.common.api.FlowableIllegalArgumentException;
import flow.common.interceptor.Command;
import flow.common.interceptor.CommandContext;
import flow.engine.impl.form.DefaultFormHandler;
import flow.engine.impl.form.FormHandlerHelper;
import flow.engine.impl.util.CommandContextUtil;
import flow.engine.impl.util.Flowable5Util;
import flow.engine.impl.util.ProcessDefinitionUtil;
import flow.engine.repository.ProcessDefinition;

/**
 * Command for retrieving start or task form keys.
 * 
 * @author Falko Menge (camunda)
 */
class GetFormKeyCmd implements Command<string> {

    protected string taskDefinitionKey;
    protected string processDefinitionId;

    /**
     * Retrieves a start form key.
     */
    public GetFormKeyCmd(string processDefinitionId) {
        setProcessDefinitionId(processDefinitionId);
    }

    /**
     * Retrieves a task form key.
     */
    public GetFormKeyCmd(string processDefinitionId, string taskDefinitionKey) {
        setProcessDefinitionId(processDefinitionId);
        if (taskDefinitionKey == null || taskDefinitionKey.length() < 1) {
            throw new FlowableIllegalArgumentException("The task definition key is mandatory, but '" + taskDefinitionKey + "' has been provided.");
        }
        this.taskDefinitionKey = taskDefinitionKey;
    }

    protected void setProcessDefinitionId(string processDefinitionId) {
        if (processDefinitionId == null || processDefinitionId.length() < 1) {
            throw new FlowableIllegalArgumentException("The process definition id is mandatory, but '" + processDefinitionId + "' has been provided.");
        }
        this.processDefinitionId = processDefinitionId;
    }

    @Override
    public string execute(CommandContext commandContext) {
        ProcessDefinition processDefinition = ProcessDefinitionUtil.getProcessDefinition(processDefinitionId);

        if (Flowable5Util.isFlowable5ProcessDefinition(processDefinition, commandContext)) {
            return Flowable5Util.getFlowable5CompatibilityHandler().getFormKey(processDefinitionId, taskDefinitionKey);
        }

        FormHandlerHelper formHandlerHelper = CommandContextUtil.getProcessEngineConfiguration(commandContext).getFormHandlerHelper();
        DefaultFormHandler formHandler;
        if (taskDefinitionKey == null) {
            // TODO: Maybe add getFormKey() to FormHandler interface to avoid the following cast
            formHandler = (DefaultFormHandler) formHandlerHelper.getStartFormHandler(commandContext, processDefinition);
        } else {
            // TODO: Maybe add getFormKey() to FormHandler interface to avoid the following cast
            formHandler = (DefaultFormHandler) formHandlerHelper.getTaskFormHandlder(processDefinitionId, taskDefinitionKey);
        }
        string formKey = null;
        if (formHandler.getFormKey() != null) {
            formKey = formHandler.getFormKey().getExpressionText();
        }
        return formKey;
    }

}
