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

//          Copyright linse 2020.
// Distributed under the Boost Software License, Version 1.0.
//    (See accompanying file LICENSE_1_0.txt or copy at
//          http://www.boost.org/LICENSE_1_0.txt)}

module flow.engine.deleg.event.impl.FlowableProcessEventImpl;





import flow.common.api.deleg.event.FlowableEngineEventType;
import flow.common.event.FlowableEngineEventImpl;
import flow.common.interceptor.CommandContext;
import flow.engine.deleg.DelegateExecution;
import flow.engine.deleg.event.FlowableProcessEngineEvent;
import flow.engine.impl.util.CommandContextUtil;

/**
 * @author Joram Barrez
 */
class FlowableProcessEventImpl : FlowableEngineEventImpl , FlowableProcessEngineEvent {

    this(FlowableEngineEventType type) {
        super(type);
    }

    public DelegateExecution getExecution() {
        if (executionId !is null) {
            CommandContext commandContext = CommandContextUtil.getCommandContext();
            if (commandContext !is null) {
                return CommandContextUtil.getExecutionEntityManager(commandContext).findById(executionId);
            }
        }
        return null;
    }

}
