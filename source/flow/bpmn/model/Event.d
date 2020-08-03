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

module flow.bpmn.model.Event;

import flow.bpmn.model.BaseElement;
import flow.bpmn.model.FlowElement;
import hunt.collection.ArrayList;
import hunt.collection.List;
import flow.bpmn.model.FlowNode;
import flow.bpmn.model.EventDefinition;
/**
 * @author Tijs Rademakers
 */
abstract class Event : FlowNode {

  alias setValues = BaseElement.setValues;
  alias setValues = FlowElement.setValues;
  alias setValues = FlowNode.setValues;

    protected List!EventDefinition eventDefinitions ;//= new ArrayList<>();

    this()
    {
      eventDefinitions = new ArrayList!EventDefinition;
    }

    override
    string getClassType()
    {
      return "event";
    }

    public List!EventDefinition getEventDefinitions() {
        return eventDefinitions;
    }

    public void setEventDefinitions(List!EventDefinition eventDefinitions) {
        this.eventDefinitions = eventDefinitions;
    }

    public void addEventDefinition(EventDefinition eventDefinition) {
        eventDefinitions.add(eventDefinition);
    }

    public void setValues(Event otherEvent) {
        super.setValues(otherEvent);

        eventDefinitions = new ArrayList!EventDefinition();
        if (otherEvent.getEventDefinitions() !is null && !otherEvent.getEventDefinitions().isEmpty()) {
            foreach (EventDefinition eventDef ; otherEvent.getEventDefinitions()) {
                eventDefinitions.add(eventDef.clone());
            }
        }
    }
}
