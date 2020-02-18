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



import flow.common.api.deleg.Expression;
import flow.engine.delegate.DelegateExecution;
import flow.engine.delegate.ExecutionListener;

/**
 * An {@link ExecutionListener} that evaluates a {@link Expression} when notified.
 * 
 * @author Frederik Heremans
 */
class ExpressionExecutionListener implements ExecutionListener {

    protected Expression expression;

    public ExpressionExecutionListener(Expression expression) {
        this.expression = expression;
    }

    @Override
    public void notify(DelegateExecution execution) {
        // Return value of expression is ignored
        expression.getValue(execution);
    }

    /**
     * returns the expression text for this execution listener. Comes in handy if you want to check which listeners you already have.
     */
    public string getExpressionText() {
        return expression.getExpressionText();
    }
}
