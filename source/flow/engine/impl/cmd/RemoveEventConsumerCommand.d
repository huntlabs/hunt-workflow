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
module flow.engine.impl.cmd.RemoveEventConsumerCommand;

import flow.common.api.FlowableIllegalArgumentException;
import flow.common.interceptor.Command;
import flow.common.interceptor.CommandContext;
import flow.engine.impl.util.CommandContextUtil;
import flow.event.registry.api.EventRegistryEventConsumer;
import hunt.Object;

class RemoveEventConsumerCommand : Command!Void {

    protected EventRegistryEventConsumer eventConsumer;

    this(EventRegistryEventConsumer eventConsumer) {
        this.eventConsumer = eventConsumer;
    }

    override
    public Void execute(CommandContext commandContext) {
        if (eventConsumer is null) {
            throw new FlowableIllegalArgumentException("event consumer is null.");
        }

        CommandContextUtil.getEventRegistry().removeFlowableEventRegistryEventConsumer(eventConsumer);

        return null;
    }

}
