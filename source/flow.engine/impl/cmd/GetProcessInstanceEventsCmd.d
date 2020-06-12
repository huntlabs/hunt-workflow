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

module flow.engine.impl.cmd.GetProcessInstanceEventsCmd;

import hunt.collection.List;

import flow.common.interceptor.Command;
import flow.common.interceptor.CommandContext;
import flow.engine.impl.util.CommandContextUtil;
import flow.engine.task.Event;

/**
 * @author Tom Baeyens
 */
class GetProcessInstanceEventsCmd : Command!(List!Event) {

    protected string processInstanceId;

    this(string processInstanceId) {
        this.processInstanceId = processInstanceId;
    }

    public List!Event execute(CommandContext commandContext) {
        return CommandContextUtil.getCommentEntityManager(commandContext).findEventsByProcessInstanceId(processInstanceId);
    }
}
