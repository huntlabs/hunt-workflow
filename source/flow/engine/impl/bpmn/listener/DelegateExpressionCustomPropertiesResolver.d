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
module flow.engine.impl.bpmn.listener.DelegateExpressionCustomPropertiesResolver;

import hunt.collection.Map;

import flow.common.api.FlowableIllegalArgumentException;
import flow.common.api.deleg.Expression;
import flow.engine.deleg.CustomPropertiesResolver;
import flow.engine.deleg.DelegateExecution;

/**
 * @author Yvo Swillens
 */
class DelegateExpressionCustomPropertiesResolver : CustomPropertiesResolver {

    protected Expression expression;

    this(Expression expression) {
        this.expression = expression;
    }

    override
    public Map!(string, Object) getCustomPropertiesMap(DelegateExecution execution) {
        // Note: we can't cache the result of the expression, because the
        // execution can change: eg.
        // delegateExpression='${mySpringBeanFactory.randomSpringBean()}'
        Object deleg = expression.getValue(execution);

        if (cast(CustomPropertiesResolver)deleg !is null) {
            return (cast(CustomPropertiesResolver) deleg).getCustomPropertiesMap(execution);
        } else {
            throw new FlowableIllegalArgumentException("Custom properties resolver delegate expression "  ~ " did not resolve to an implementation of " ~ typeid(CustomPropertiesResolver).toString);
        }
    }

    /**
     * returns the expression text for this execution listener. Comes in handy if you want to check which listeners you already have.
     */
    public string getExpressionText() {
        return expression.getExpressionText();
    }

}
