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



import java.io.Serializable;

import flow.common.api.FlowableIllegalArgumentException;
import flow.common.interceptor.Command;
import flow.common.interceptor.CommandContext;
import flow.engine.impl.util.CommandContextUtil;
import flow.engine.task.Event;

/**
 * @author Frederik Heremans
 */
class GetTaskEventCmd implements Command<Event>, Serializable {

    private static final long serialVersionUID = 1L;
    protected string eventId;

    public GetTaskEventCmd(string eventId) {
        this.eventId = eventId;

        if (eventId == null) {
            throw new FlowableIllegalArgumentException("eventId is null");
        }
    }

    @Override
    public Event execute(CommandContext commandContext) {
        return CommandContextUtil.getCommentEntityManager(commandContext).findEvent(eventId);
    }
}
