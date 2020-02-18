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
 
module flow.engine.delegate.event.impl.FlowableProcessStartedEventImpl;
 
 
 

import java.util.Map;

import flow.common.api.deleg.event.FlowableEngineEventType;
import flow.engine.delegate.event.FlowableProcessStartedEvent;
import flow.engine.impl.persistence.entity.ExecutionEntity;

/**
 * An {@link flow.engine.delegate.event.FlowableCancelledEvent} implementation.
 *
 * @author martin.grofcik
 */
class FlowableProcessStartedEventImpl : FlowableEntityWithVariablesEventImpl , FlowableProcessStartedEvent {

    protected final string nestedProcessInstanceId;

    protected final string nestedProcessDefinitionId;
    this( Object entity,  Map variables,  bool localScope) {
        super(entity, variables, localScope, FlowableEngineEventType.PROCESS_STARTED);
        if (entity instanceof ExecutionEntity) {
            ExecutionEntity executionEntity = (ExecutionEntity) entity;
            if (!executionEntity.isProcessInstanceType()) {
                executionEntity = executionEntity.getParent();
            }

            final ExecutionEntity superExecution = executionEntity.getSuperExecution();
            if (superExecution !is null) {
                this.nestedProcessDefinitionId = superExecution.getProcessDefinitionId();
                this.nestedProcessInstanceId = superExecution.getProcessInstanceId();
            } else {
                this.nestedProcessDefinitionId = null;
                this.nestedProcessInstanceId = null;
            }

        } else {
            this.nestedProcessDefinitionId = null;
            this.nestedProcessInstanceId = null;
        }
    }

    @Override
    public string getNestedProcessInstanceId() {
        return this.nestedProcessInstanceId;
    }

    @Override
    public string getNestedProcessDefinitionId() {
        return this.nestedProcessDefinitionId;
    }

}
