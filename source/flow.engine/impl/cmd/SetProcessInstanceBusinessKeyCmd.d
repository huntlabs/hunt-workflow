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

module flow.engine.impl.cmd.SetProcessInstanceBusinessKeyCmd;


import flow.common.api.FlowableIllegalArgumentException;
import flow.common.api.FlowableObjectNotFoundException;
import flow.common.interceptor.Command;
import flow.common.interceptor.CommandContext;
import flow.engine.impl.persistence.entity.ExecutionEntity;
import flow.engine.impl.persistence.entity.ExecutionEntityManager;
import flow.engine.impl.util.CommandContextUtil;
//import flow.engine.impl.util.Flowable5Util;
import flow.engine.runtime.ProcessInstance;
import hunt.Object;
/**
 * {@link Command} that changes the business key of an existing process instance.
 *
 * @author Tijs Rademakers
 */
class SetProcessInstanceBusinessKeyCmd : Command!Void {

    private  string processInstanceId;
    private  string businessKey;

    this(string processInstanceId, string businessKey) {
        if (processInstanceId is null || processInstanceId.length() < 1) {
            throw new FlowableIllegalArgumentException("The process instance id is mandatory, but '" ~ processInstanceId~ "' has been provided.");
        }
        if (businessKey is null) {
            throw new FlowableIllegalArgumentException("The business key is mandatory, but 'null' has been provided.");
        }

        this.processInstanceId = processInstanceId;
        this.businessKey = businessKey;
    }

    public Void execute(CommandContext commandContext) {
        ExecutionEntityManager executionManager = CommandContextUtil.getExecutionEntityManager(commandContext);
        ExecutionEntity processInstance = executionManager.findById(processInstanceId);
        if (processInstance is null) {
            throw new FlowableObjectNotFoundException("No process instance found for id = '" ~ processInstanceId ~ "'.");
        } else if (!processInstance.isProcessInstanceType()) {
            throw new FlowableIllegalArgumentException("A process instance id is required, but the provided id " ~ "'" ~ processInstanceId ~ "' " ~ "points to a child execution of process instance " ~ "'"
                    ~ processInstance.getProcessInstanceId() ~ "'. " ~ "Please invoke the "  ~ " with a root execution id.");
        }

        //if (Flowable5Util.isFlowable5ProcessDefinitionId(commandContext, processInstance.getProcessDefinitionId())) {
        //    CommandContextUtil.getProcessEngineConfiguration(commandContext).getFlowable5CompatibilityHandler().updateBusinessKey(processInstanceId, businessKey);
        //    return null;
        //}

        executionManager.updateProcessInstanceBusinessKey(processInstance, businessKey);

        return null;
    }
}
