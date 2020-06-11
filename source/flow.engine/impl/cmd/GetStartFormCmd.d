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

module flow.engine.impl.cmd.GetStartFormCmd;


import flow.common.api.FlowableException;
import flow.common.api.FlowableObjectNotFoundException;
import flow.common.interceptor.Command;
import flow.common.interceptor.CommandContext;
import flow.engine.form.StartFormData;
import flow.engine.impl.form.FormHandlerHelper;
import flow.engine.impl.form.StartFormHandler;
import flow.engine.impl.util.CommandContextUtil;
//import flow.engine.impl.util.Flowable5Util;
import flow.engine.repository.ProcessDefinition;

/**
 * @author Tom Baeyens
 */
class GetStartFormCmd : Command!StartFormData {

    protected string processDefinitionId;

    this(string processDefinitionId) {
        this.processDefinitionId = processDefinitionId;
    }

    public StartFormData execute(CommandContext commandContext) {
        ProcessDefinition processDefinition = CommandContextUtil.getProcessEngineConfiguration(commandContext).getDeploymentManager().findDeployedProcessDefinitionById(processDefinitionId);
        if (processDefinition is null) {
            throw new FlowableObjectNotFoundException("No process definition found for id '" ~ processDefinitionId ~ "'", typeid(ProcessDefinition).toString);
        }

        //if (Flowable5Util.isFlowable5ProcessDefinition(processDefinition, commandContext)) {
        //    return Flowable5Util.getFlowable5CompatibilityHandler().getStartFormData(processDefinitionId);
        //}

        FormHandlerHelper formHandlerHelper = CommandContextUtil.getProcessEngineConfiguration(commandContext).getFormHandlerHelper();
        StartFormHandler startFormHandler = formHandlerHelper.getStartFormHandler(commandContext, processDefinition);
        if (startFormHandler is null) {
            throw new FlowableException("No startFormHandler defined in process '" + processDefinitionId + "'");
        }

        return startFormHandler.createStartFormData(processDefinition);
    }

}
