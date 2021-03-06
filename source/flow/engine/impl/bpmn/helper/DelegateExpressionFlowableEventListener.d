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
module flow.engine.impl.bpmn.helper.DelegateExpressionFlowableEventListener;

import flow.common.api.FlowableIllegalArgumentException;
import flow.common.api.deleg.Expression;
import flow.common.api.deleg.event.FlowableEntityEvent;
import flow.common.api.deleg.event.FlowableEvent;
import flow.common.api.deleg.event.FlowableEventListener;
import flow.variable.service.impl.el.NoExecutionVariableScope;
import flow.engine.impl.bpmn.helper.BaseDelegateEventListener;
import flow.engine.impl.bpmn.helper.DelegateExpressionUtil;
/**
 * An {@link FlowableEventListener} implementation which resolves an expression to a delegate {@link FlowableEventListener} instance and uses this for event notification. <br>
 * <br>
 * In case an entityClass was passed in the constructor, only events that are {@link FlowableEntityEvent}'s that target an entity of the given type, are dispatched to the delegate.
 *
 * @author Frederik Heremans
 */
class DelegateExpressionFlowableEventListener : BaseDelegateEventListener {

    protected Expression expression;
    protected bool failOnException;

    this(Expression expression, TypeInfo entityClass) {
        this.expression = expression;
        setEntityClass(entityClass);
    }

    override
    public void onEvent(FlowableEvent event) {
        if (isValidEvent(event)) {
            Object deleg = DelegateExpressionUtil.resolveDelegateExpression(expression, new NoExecutionVariableScope());
            if (cast(FlowableEventListener)deleg !is null) {
                // Cache result of isFailOnException() from delegate-instance
                // until next event is received. This prevents us from having to resolve
                // the expression twice when an error occurs.
                failOnException = (cast(FlowableEventListener) deleg).isFailOnException();

                // Call the delegate
                (cast(FlowableEventListener) deleg).onEvent(event);
            } else {

                // Force failing, since the exception we're about to throw
                // cannot be ignored, because it did not originate from the listener itself
                failOnException = true;
                throw new FlowableIllegalArgumentException("Delegate expression  did not resolve to an implementation of " ~ typeid(FlowableEventListener).toString);
            }
        }
    }


    override
    public bool isFailOnException() {
        return failOnException;
    }

}
