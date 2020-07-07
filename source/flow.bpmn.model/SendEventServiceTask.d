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

module flow.bpmn.model.SendEventServiceTask;

import flow.bpmn.model.FlowElement;
import flow.bpmn.model.BaseElement;
import flow.bpmn.model.FlowNode;
import flow.bpmn.model.Activity;
import hunt.collection.ArrayList;
import hunt.collection.List;
import flow.bpmn.model.ServiceTask;
import flow.bpmn.model.IOParameter;
/**
 * @author Tijs Rademakers
 */
class SendEventServiceTask : ServiceTask {

    alias setValues = BaseElement.setValues;
    alias setValues = FlowNode.setValues;
    alias setValues = FlowElement.setValues;
    alias setValues = Activity.setValues;
    alias setValues = ServiceTask.setValues;
    protected string eventType;
    protected string triggerEventType;
    protected bool sendSynchronously;
    protected List!IOParameter eventInParameters ;//= new ArrayList<>();
    protected List!IOParameter eventOutParameters ;//= new ArrayList<>();

    this()
    {
      eventInParameters = new ArrayList!IOParameter;
      eventOutParameters = new ArrayList!IOParameter;
    }

    public string getEventType() {
        return eventType;
    }

    public void setEventType(string eventType) {
        this.eventType = eventType;
    }

    public string getTriggerEventType() {
        return triggerEventType;
    }

    public void setTriggerEventType(string triggerEventType) {
        this.triggerEventType = triggerEventType;
    }

    public bool isSendSynchronously() {
        return sendSynchronously;
    }

    public void setSendSynchronously(bool sendSynchronously) {
        this.sendSynchronously = sendSynchronously;
    }

    public List!IOParameter getEventInParameters() {
        return eventInParameters;
    }

    public void setEventInParameters(List!IOParameter eventInParameters) {
        this.eventInParameters = eventInParameters;
    }

    public List!IOParameter getEventOutParameters() {
        return eventOutParameters;
    }

    public void setEventOutParameters(List!IOParameter eventOutParameters) {
        this.eventOutParameters = eventOutParameters;
    }

    override
    public SendEventServiceTask clone() {
        SendEventServiceTask clone = new SendEventServiceTask();
        clone.setValues(this);
        return clone;
    }

    public void setValues(SendEventServiceTask otherElement) {
        super.setValues(otherElement);
        setEventType(otherElement.getEventType());
        setTriggerEventType(otherElement.getTriggerEventType());
        setSendSynchronously(otherElement.isSendSynchronously());

        eventInParameters = new ArrayList!IOParameter();
        if (otherElement.getEventInParameters() !is null && !otherElement.getEventInParameters().isEmpty()) {
            foreach (IOParameter parameter ; otherElement.getEventInParameters()) {
                eventInParameters.add(parameter.clone());
            }
        }

        eventOutParameters = new ArrayList!IOParameter();
        if (otherElement.getEventOutParameters() !is null && !otherElement.getEventOutParameters().isEmpty()) {
            foreach (IOParameter parameter ; otherElement.getEventOutParameters()) {
                eventOutParameters.add(parameter.clone());
            }
        }
    }
}
