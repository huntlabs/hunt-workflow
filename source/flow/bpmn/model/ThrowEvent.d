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

module flow.bpmn.model.ThrowEvent;

import flow.bpmn.model.Event;
import flow.bpmn.model.BaseElement;
import flow.bpmn.model.FlowElement;
/**
 * @author Tijs Rademakers
 */
class ThrowEvent : Event {
   alias setValues = BaseElement.setValues;
   alias setValues = FlowElement.setValues;
   alias setValues = Event.setValues;
    override
    public ThrowEvent clone() {
        ThrowEvent clone = new ThrowEvent();
        clone.setValues(this);
        return clone;
    }

    override
    string getClassType()
    {
      return "throwEvent";
    }

    public void setValues(ThrowEvent otherEvent) {
        super.setValues(otherEvent);
    }
}
