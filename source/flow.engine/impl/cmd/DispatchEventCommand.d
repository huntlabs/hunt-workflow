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


import flow.common.api.FlowableException;
import flow.common.api.FlowableIllegalArgumentException;
import flow.common.api.deleg.event.FlowableEvent;
import flow.common.api.deleg.event.FlowableEventDispatcher;
import flow.common.interceptor.Command;
import flow.common.interceptor.CommandContext;
import flow.engine.impl.util.CommandContextUtil;

/**
 * Command that dispatches an event.
 *
 * @author Frederik Heremans
 */
class DispatchEventCommand implements Command!Void {

    protected FlowableEvent event;

    public DispatchEventCommand(FlowableEvent event) {
        this.event = event;
    }

    override
    public Void execute(CommandContext commandContext) {
        if (event is null) {
            throw new FlowableIllegalArgumentException("event is null");
        }

        FlowableEventDispatcher eventDispatcher = CommandContextUtil.getEventDispatcher();
        if (eventDispatcher !is null && eventDispatcher.isEnabled()) {
            eventDispatcher.dispatchEvent(event);
        } else {
            throw new FlowableException("Message dispatcher is disabled, cannot dispatch event");
        }

        return null;
    }

}
