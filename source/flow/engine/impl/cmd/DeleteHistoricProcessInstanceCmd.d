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

module flow.engine.impl.cmd.DeleteHistoricProcessInstanceCmd;


import flow.common.api.FlowableException;
import flow.common.api.FlowableIllegalArgumentException;
import flow.common.api.FlowableObjectNotFoundException;
import flow.common.interceptor.Command;
import flow.common.interceptor.CommandContext;
import flow.engine.compatibility.Flowable5CompatibilityHandler;
import flow.engine.history.HistoricProcessInstance;
import flow.engine.impl.util.CommandContextUtil;
//import flow.engine.impl.util.Flowable5Util;

/**
 * @author Frederik Heremans
 */
class DeleteHistoricProcessInstanceCmd : Command!Object {

    protected string processInstanceId;

    this(string processInstanceId) {
        this.processInstanceId = processInstanceId;
    }

    public Object execute(CommandContext commandContext) {
        if (processInstanceId is null) {
            throw new FlowableIllegalArgumentException("processInstanceId is null");
        }
        // Check if process instance is still running
        HistoricProcessInstance instance = CommandContextUtil.getHistoricProcessInstanceEntityManager(commandContext).findById(processInstanceId);

        if (instance is null) {
            throw new FlowableObjectNotFoundException("No historic process instance found with id: " ~ processInstanceId);
        }
        if (instance.getEndTime() is null) {
            throw new FlowableException("Process instance is still running, cannot delete historic process instance: " ~ processInstanceId);
        }

        //if (Flowable5Util.isFlowable5ProcessDefinitionId(commandContext, instance.getProcessDefinitionId())) {
        //    Flowable5CompatibilityHandler compatibilityHandler = Flowable5Util.getFlowable5CompatibilityHandler();
        //    compatibilityHandler.deleteHistoricProcessInstance(processInstanceId);
        //    return null;
        //}

        CommandContextUtil.getHistoryManager(commandContext).recordProcessInstanceDeleted(processInstanceId, instance.getProcessDefinitionId(), instance.getTenantId());

        return null;
    }

}
