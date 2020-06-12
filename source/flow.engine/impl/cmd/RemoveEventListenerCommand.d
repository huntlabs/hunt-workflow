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
module flow.engine.impl.cmd.RemoveEventListenerCommand;

import flow.common.api.FlowableIllegalArgumentException;
import flow.common.api.deleg.event.FlowableEventListener;
import flow.common.interceptor.Command;
import flow.common.interceptor.CommandContext;
import flow.engine.impl.util.CommandContextUtil;
import hunt.Object;
/**
 * Command that removes an event-listener from the process engine.
 *
 * @author Frederik Heremans
 */
class RemoveEventListenerCommand : Command!Void {

    protected FlowableEventListener listener;

    this(FlowableEventListener listener) {
        super();
        this.listener = listener;
    }

    public Void execute(CommandContext commandContext) {
        if (listener is null) {
            throw new FlowableIllegalArgumentException("listener is null.");
        }

        CommandContextUtil.getProcessEngineConfiguration(commandContext).getEventDispatcher().removeEventListener(listener);

        return null;
    }

}
