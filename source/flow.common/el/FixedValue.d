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

module flow.common.el.FixedValue;


import flow.common.api.FlowableException;
import flow.common.api.deleg.Expression;
import flow.common.api.variable.VariableContainer;

/**
 * Expression that always returns the same value when <code>getValue</code> is called. Setting of the value is not supported.
 *
 * @author Frederik Heremans
 */
class FixedValue : Expression {

    private Object value;

    this(Object value) {
        this.value = value;
    }


    public Object getValue(VariableContainer variableContainer) {
        return value;
    }


    public void setValue(Object value, VariableContainer variableContainer) {
        throw new FlowableException("Cannot change fixed value");
    }


    public string getExpressionText() {
        return value.toString();
    }

}
