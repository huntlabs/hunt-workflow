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


import flow.common.api.FlowableIllegalArgumentException;
import flow.common.api.deleg.event.FlowableEntityEvent;
import flow.common.api.deleg.event.FlowableEvent;
import flow.common.api.deleg.event.FlowableEventListener;
import flow.common.util.ReflectUtil;

/**
 * An {@link FlowableEventListener} implementation which uses a classname to create a delegate {@link FlowableEventListener} instance to use for event notification. <br>
 * <br>
 * 
 * In case an entityClass was passed in the constructor, only events that are {@link FlowableEntityEvent}'s that target an entity of the given type, are dispatched to the delegate.
 * 
 * @author Frederik Heremans
 */
class DelegateFlowableEventListener extends BaseDelegateEventListener {

    protected string className;
    protected FlowableEventListener delegateInstance;
    protected bool failOnException;

    public DelegateFlowableEventListener(string className, Class<?> entityClass) {
        this.className = className;
        setEntityClass(entityClass);
    }

    @Override
    public void onEvent(FlowableEvent event) {
        if (isValidEvent(event)) {
            getDelegateInstance().onEvent(event);
        }
    }

    @Override
    public bool isFailOnException() {
        if (delegateInstance !is null) {
            return delegateInstance.isFailOnException();
        }
        return failOnException;
    }

    protected FlowableEventListener getDelegateInstance() {
        if (delegateInstance is null) {
            Object instance = ReflectUtil.instantiate(className);
            if (instance instanceof FlowableEventListener) {
                delegateInstance = (FlowableEventListener) instance;
            } else {
                // Force failing of the listener invocation, since the delegate
                // cannot be created
                failOnException = true;
                throw new FlowableIllegalArgumentException("Class " + className + " does not implement " + FlowableEventListener.class.getName());
            }
        }
        return delegateInstance;
    }
}