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

module flow.engine.deleg.event.impl.FlowableProcessStartedEventImpl;




import hunt.collection.Map;
import hunt.Object;
import flow.common.api.deleg.event.FlowableEngineEventType;
import flow.engine.deleg.event.FlowableProcessStartedEvent;
import flow.engine.impl.persistence.entity.ExecutionEntity;
import flow.engine.deleg.event.impl.FlowableEntityWithVariablesEventImpl;

/**
 * An {@link flow.engine.deleg.event.FlowableCancelledEvent} implementation.
 *
 * @author martin.grofcik
 */
class FlowableProcessStartedEventImpl : FlowableEntityWithVariablesEventImpl , FlowableProcessStartedEvent {

    protected  string nestedProcessInstanceId;

    protected  string nestedProcessDefinitionId;

    this( Object entity,  IObject variables,  bool localScope) {
        super(entity, variables, localScope, FlowableEngineEventType.PROCESS_STARTED);
         ExecutionEntity executionEntity = cast(ExecutionEntity) entity;
        if (executionEntity !is null) {
            if (!executionEntity.isProcessInstanceType()) {
                executionEntity = executionEntity.getParent();
            }

             ExecutionEntity superExecution = executionEntity.getSuperExecution();
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

    public string getNestedProcessInstanceId() {
        return this.nestedProcessInstanceId;
    }

    public string getNestedProcessDefinitionId() {
        return this.nestedProcessDefinitionId;
    }

}
