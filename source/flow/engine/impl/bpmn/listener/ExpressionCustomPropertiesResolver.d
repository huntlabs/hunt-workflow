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
module flow.engine.impl.bpmn.listener.ExpressionCustomPropertiesResolver;


import hunt.collection.Map;

import flow.common.api.FlowableIllegalArgumentException;
import flow.common.api.deleg.Expression;
import flow.engine.deleg.CustomPropertiesResolver;
import flow.engine.deleg.DelegateExecution;

/**
 * An {@link CustomPropertiesResolver} that evaluates a {@link Expression} when notified.
 *
 * @author Yvo Swillens
 */
class ExpressionCustomPropertiesResolver : CustomPropertiesResolver {

    protected Expression expression;

    this(Expression expression) {
        this.expression = expression;
    }

    public Map!(string, Object) getCustomPropertiesMap(DelegateExecution execution) {
        Object expressionValue = expression.getValue(execution);
        return cast(Map!(string, Object)) expressionValue;
        //if (expressionValue instanceof Map) {
        //    return (Map!(string, Object)) expressionValue;
        //} else {
        //    throw new FlowableIllegalArgumentException("Custom properties resolver expression " + expression + " did not return a Map!(string, Object)");
        //}
    }

    /**
     * returns the expression text for this execution listener. Comes in handy if you want to check which listeners you already have.
     */
    public string getExpressionText() {
        return expression.getExpressionText();
    }
}
