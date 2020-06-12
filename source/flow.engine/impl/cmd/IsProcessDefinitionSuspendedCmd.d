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

module flow.engine.impl.cmd.IsProcessDefinitionSuspendedCmd;


import flow.common.interceptor.Command;
import flow.common.interceptor.CommandContext;
import flow.engine.compatibility.Flowable5CompatibilityHandler;
//import flow.engine.impl.util.Flowable5Util;
import flow.engine.impl.util.ProcessDefinitionUtil;

/**
 * @author Tijs Rademakers
 */
class IsProcessDefinitionSuspendedCmd : Command!bool {

    protected string processDefinitionId;

    this(string processDefinitionId) {
        this.processDefinitionId = processDefinitionId;
    }

    public bool execute(CommandContext commandContext) {
        // Backwards compatibility
        //if (Flowable5Util.isFlowable5ProcessDefinitionId(commandContext, processDefinitionId)) {
        //    Flowable5CompatibilityHandler compatibilityHandler = Flowable5Util.getFlowable5CompatibilityHandler();
        //    return compatibilityHandler.isProcessDefinitionSuspended(processDefinitionId);
        //}

        return ProcessDefinitionUtil.isProcessDefinitionSuspended(processDefinitionId);
    }
}
