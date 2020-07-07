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

module flow.bpmn.model.SendTask;

import hunt.collection.ArrayList;
import flow.bpmn.model.TaskWithFieldExtensions;
import flow.bpmn.model.FieldExtension;
import flow.bpmn.model.BaseElement;
import flow.bpmn.model.FlowElement;
import flow.bpmn.model.FlowNode;
import flow.bpmn.model.Activity;

/**
 * @author Tijs Rademakers
 */
class SendTask : TaskWithFieldExtensions {

    alias setValues = BaseElement.setValues;
    alias setValues = FlowElement.setValues;
    alias setValues = FlowNode.setValues;
    alias setValues = Activity.setValues;

    protected string type;
    protected string implementationType;
    protected string operationRef;

    public string getType() {
        return type;
    }

    public void setType(string type) {
        this.type = type;
    }

    public string getImplementationType() {
        return implementationType;
    }

    public void setImplementationType(string implementationType) {
        this.implementationType = implementationType;
    }

    public string getOperationRef() {
        return operationRef;
    }

    public void setOperationRef(string operationRef) {
        this.operationRef = operationRef;
    }

    override
    public SendTask clone() {
        SendTask clone = new SendTask();
        clone.setValues(this);
        return clone;
    }

    public void setValues(SendTask otherElement) {
        super.setValues(otherElement);
        setType(otherElement.getType());
        setImplementationType(otherElement.getImplementationType());
        setOperationRef(otherElement.getOperationRef());

        fieldExtensions = new ArrayList!FieldExtension();
        if (otherElement.getFieldExtensions() !is null && !otherElement.getFieldExtensions().isEmpty()) {
            foreach (FieldExtension extension ; otherElement.getFieldExtensions()) {
                fieldExtensions.add(extension.clone());
            }
        }
    }
}
