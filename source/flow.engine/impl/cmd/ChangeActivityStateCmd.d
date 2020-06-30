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
module flow.engine.impl.cmd.ChangeActivityStateCmd;

import hunt.Exceptions;
import flow.common.api.FlowableIllegalArgumentException;
import flow.common.interceptor.Command;
import flow.common.interceptor.CommandContext;
import flow.engine.dynamic.DynamicStateManager;
import flow.engine.impl.runtime.ChangeActivityStateBuilderImpl;
import flow.engine.impl.util.CommandContextUtil;
import hunt.Object;
/**
 * @author Tijs Rademakers
 */
class ChangeActivityStateCmd : Command!Void {

    protected ChangeActivityStateBuilderImpl changeActivityStateBuilder;

    this(ChangeActivityStateBuilderImpl changeActivityStateBuilder) {
        this.changeActivityStateBuilder = changeActivityStateBuilder;
    }

    public Void execute(CommandContext commandContext) {
          implementationMissing(false);
        //if (changeActivityStateBuilder.getMoveExecutionIdList().size() == 0 && changeActivityStateBuilder.getMoveActivityIdList().size() == 0) {
        //    throw new FlowableIllegalArgumentException("No move execution or activity ids provided");
        //
        //} else if (changeActivityStateBuilder.getMoveActivityIdList().size() > 0 && (changeActivityStateBuilder.getProcessInstanceId() is null || changeActivityStateBuilder.getProcessInstanceId().length == 0)) {
        //    throw new FlowableIllegalArgumentException("Process instance id is required");
        //}
        //
        //DynamicStateManager dynamicStateManager = CommandContextUtil.getProcessEngineConfiguration(commandContext).getDynamicStateManager();
        //dynamicStateManager.moveExecutionState(changeActivityStateBuilder, commandContext);

        return null;
    }
}
