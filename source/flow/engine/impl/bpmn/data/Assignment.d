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
module flow.engine.impl.bpmn.data.Assignment;

import flow.common.api.deleg.Expression;
import flow.engine.deleg.DelegateExecution;
import flow.variable.service.api.deleg.VariableScope;

/**
 * Implementation of the BPMN 2.0 'assignment'
 *
 * @author Esteban Robles Luna
 */
class Assignment {

    protected Expression fromExpression;

    protected Expression toExpression;

    this(Expression fromExpression, Expression toExpression) {
        this.fromExpression = fromExpression;
        this.toExpression = toExpression;
    }

    public void evaluate(DelegateExecution execution) {
        VariableScope variableScope = cast (VariableScope) execution;
        Object value = this.fromExpression.getValue(variableScope);
        this.toExpression.setValue(value, variableScope);
    }
}
