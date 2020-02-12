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


import flow.common.api.delegate.event.FlowableEngineEventType;
import flow.common.event.FlowableEngineEventImpl;
import flow.common.interceptor.CommandContext;
import flow.engine.delegate.DelegateExecution;
import flow.engine.delegate.event.FlowableProcessEngineEvent;
import flow.engine.impl.util.CommandContextUtil;

/**
 * @author Joram Barrez
 */
class FlowableProcessEventImpl extends FlowableEngineEventImpl implements FlowableProcessEngineEvent {

    public FlowableProcessEventImpl(FlowableEngineEventType type) {
        super(type);
    }

    @Override
    public DelegateExecution getExecution() {
        if (executionId != null) {
            CommandContext commandContext = CommandContextUtil.getCommandContext();
            if (commandContext != null) {
                return CommandContextUtil.getExecutionEntityManager(commandContext).findById(executionId);
            }
        }
        return null;
    }

}
