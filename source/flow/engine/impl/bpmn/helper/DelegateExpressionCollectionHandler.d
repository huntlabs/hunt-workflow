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
module flow.engine.impl.bpmn.helper.DelegateExpressionCollectionHandler;

import hunt.collection;

import flow.common.api.FlowableIllegalArgumentException;
import flow.common.api.deleg.Expression;
import flow.engine.deleg.DelegateExecution;
import flow.engine.impl.deleg.FlowableCollectionHandler;
import flow.engine.impl.bpmn.helper.DelegateExpressionUtil;
import hunt.Object;
/**
 * @author Lori Small
 */
class DelegateExpressionCollectionHandler : FlowableCollectionHandler {

	protected DelegateExecution execution;
	protected Expression expression;

    this(DelegateExecution execution, Expression expression) {
        this.execution = execution;
        this.expression = expression;
    }

	public IObject resolveCollection(Object collectionValue, DelegateExecution execution) {
		return getCollectionHandlerInstance(execution).resolveCollection(collectionValue, execution);
	}

    protected FlowableCollectionHandler getCollectionHandlerInstance(DelegateExecution execution) {
        Object delegateInstance = DelegateExpressionUtil.resolveDelegateExpression(expression, execution);
        if (cast(FlowableCollectionHandler)delegateInstance !is null) {
            return cast(FlowableCollectionHandler) delegateInstance;
        } else {
            throw new FlowableIllegalArgumentException(typeid(delegateInstance).toString ~ " doesn't implement " ~ typeid(FlowableCollectionHandler).toString);
        }
    }
}
