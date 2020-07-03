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

module flow.bpmn.model.ConditionalEventDefinition;

import flow.bpmn.model.BaseElement;
import flow.bpmn.model.EventDefinition;
/**
 * @author Tijs Rademakers
 */
class ConditionalEventDefinition : EventDefinition {

    alias setValues = BaseElement.setValues;

    protected string conditionExpression;

    public string getConditionExpression() {
        return conditionExpression;
    }

    public void setConditionExpression(string conditionExpression) {
        this.conditionExpression = conditionExpression;
    }

    override
    public ConditionalEventDefinition clone() {
        ConditionalEventDefinition clone = new ConditionalEventDefinition();
        clone.setValues(this);
        return clone;
    }

    public void setValues(ConditionalEventDefinition otherDefinition) {
        super.setValues(otherDefinition);
        setConditionExpression(otherDefinition.getConditionExpression());
    }
}
