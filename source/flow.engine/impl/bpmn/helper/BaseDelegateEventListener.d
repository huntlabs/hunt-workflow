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


import flow.common.api.deleg.event.AbstractFlowableEventListener;
import flow.common.api.deleg.event.FlowableEntityEvent;
import flow.common.api.deleg.event.FlowableEvent;
import flow.common.api.deleg.event.FlowableEventListener;

/**
 * Base implementation of a {@link FlowableEventListener}, used when creating event-listeners that are part of a BPMN definition.
 * 
 * @author Frederik Heremans
 */
abstract class BaseDelegateEventListener extends AbstractFlowableEventListener {

    protected Class<?> entityClass;

    class<?> getEntityClass() {
        return entityClass;
    }

    public void setEntityClass(Class<?> entityClass) {
        this.entityClass = entityClass;
    }
    
    protected bool isValidEvent(FlowableEvent event) {
        bool valid = false;
        if (entityClass !is null) {
            if (event instanceof FlowableEntityEvent) {
                Object entity = ((FlowableEntityEvent) event).getEntity();
                if (entity !is null) {
                    valid = entityClass.isAssignableFrom(entity.getClass());
                }
            }
        } else {
            // If no class is specified, all events are valid
            valid = true;
        }
        return valid;
    }

}