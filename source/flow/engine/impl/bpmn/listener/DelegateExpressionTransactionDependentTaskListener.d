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
module flow.engine.impl.bpmn.listener.DelegateExpressionTransactionDependentTaskListener;

import hunt.collection.Map;

import flow.bpmn.model.Task;
import flow.common.api.FlowableIllegalArgumentException;
import flow.common.api.deleg.Expression;
import flow.engine.deleg.TransactionDependentTaskListener;
import flow.variable.service.impl.el.NoExecutionVariableScope;

/**
 * @author Yvo Swillens
 */
class DelegateExpressionTransactionDependentTaskListener : TransactionDependentTaskListener {

    protected Expression expression;

    this(Expression expression) {
        this.expression = expression;
    }

    public void notify(string processInstanceId, string executionId, Task task, Map!(string, Object) executionVariables, Map!(string, Object) customPropertiesMap) {
        NoExecutionVariableScope scop = new NoExecutionVariableScope();

        Object deleg = expression.getValue(scop);

        if (cast(TransactionDependentTaskListener)deleg !is null) {
            (cast(TransactionDependentTaskListener) deleg).notify(processInstanceId, executionId, task, executionVariables, customPropertiesMap);
        } else {
            throw new FlowableIllegalArgumentException("Delegate expression " ~ " did not resolve to an implementation of " ~ typeid(TransactionDependentTaskListener).toString);
        }

    }

    /**
     * returns the expression text for this task listener. Comes in handy if you want to check which listeners you already have.
     */
    public string getExpressionText() {
        return expression.getExpressionText();
    }

}
