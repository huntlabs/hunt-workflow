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


import hunt.collection.Map;

import flow.bpmn.model.FlowElement;
import flow.common.api.FlowableIllegalArgumentException;
import flow.common.api.deleg.Expression;
import flow.engine.deleg.TransactionDependentExecutionListener;
import flow.variable.service.impl.el.NoExecutionVariableScope;

/**
 * @author Yvo Swillens
 */
class DelegateExpressionTransactionDependentExecutionListener implements TransactionDependentExecutionListener {

    protected Expression expression;

    public DelegateExpressionTransactionDependentExecutionListener(Expression expression) {
        this.expression = expression;
    }

    override
    public void notify(string processInstanceId, string executionId, FlowElement flowElement, Map!(string, Object) executionVariables, Map!(string, Object) customPropertiesMap) {
        NoExecutionVariableScope scope = new NoExecutionVariableScope();

        Object delegate = expression.getValue(scope);

        if (delegate instanceof TransactionDependentExecutionListener) {
            ((TransactionDependentExecutionListener) delegate).notify(processInstanceId, executionId, flowElement, executionVariables, customPropertiesMap);
        } else {
            throw new FlowableIllegalArgumentException("Delegate expression " + expression + " did not resolve to an implementation of " + TransactionDependentExecutionListener.class);
        }

    }

    /**
     * returns the expression text for this execution listener. Comes in handy if you want to check which listeners you already have.
     */
    public string getExpressionText() {
        return expression.getExpressionText();
    }

}
