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

module flow.bpmn.model.SequenceFlow;

import hunt.collection.ArrayList;
import hunt.collection.List;
import flow.bpmn.model.FlowElement;
import hunt.Integer;
import flow.bpmn.model.BaseElement;


//import com.fasterxml.jackson.annotation.JsonIgnore;

/**
 * @author Tijs Rademakers
 * @author Joram Barrez
 */
class SequenceFlow : FlowElement {


    alias setValues = BaseElement.setValues;
    alias setValues = FlowElement.setValues;

    protected string conditionExpression;
    protected string sourceRef;
    protected string targetRef;
    protected string skipExpression;

    // Actual flow elements that match the source and target ref
    // Set during process definition parsing
   // @JsonIgnore
    protected FlowElement sourceFlowElement;

   // @JsonIgnore
    protected FlowElement targetFlowElement;

    /**
     * Graphical information: a list of waypoints: x1, y1, x2, y2, x3, y3, ..
     *
     * Added during parsing of a process definition.
     */
    protected List!Integer waypoints ;//= new ArrayList<>();

    this() {
        waypoints = new ArrayList!Integer;
    }

    this(string sourceRef, string targetRef) {
        this.sourceRef = sourceRef;
        this.targetRef = targetRef;
    }

    public string getConditionExpression() {
        return conditionExpression;
    }

    public void setConditionExpression(string conditionExpression) {
        this.conditionExpression = conditionExpression;
    }

    public string getSourceRef() {
        return sourceRef;
    }

    public void setSourceRef(string sourceRef) {
        this.sourceRef = sourceRef;
    }

    public string getTargetRef() {
        return targetRef;
    }

    public void setTargetRef(string targetRef) {
        this.targetRef = targetRef;
    }

    public string getSkipExpression() {
        return skipExpression;
    }

    public void setSkipExpression(string skipExpression) {
        this.skipExpression = skipExpression;
    }

    public FlowElement getSourceFlowElement() {
        return sourceFlowElement;
    }

    public void setSourceFlowElement(FlowElement sourceFlowElement) {
        this.sourceFlowElement = sourceFlowElement;
    }

    public FlowElement getTargetFlowElement() {
        return targetFlowElement;
    }

    public void setTargetFlowElement(FlowElement targetFlowElement) {
        this.targetFlowElement = targetFlowElement;
    }

    public List!Integer getWaypoints() {
        return waypoints;
    }

    public void setWaypoints(List!Integer waypoints) {
        this.waypoints = waypoints;
    }

    override
    public string toString() {
        return sourceRef ~ " --> " ~ targetRef;
    }

    override
    public SequenceFlow clone() {
        SequenceFlow clone = new SequenceFlow();
        clone.setValues(this);
        return clone;
    }

    public void setValues(SequenceFlow otherFlow) {
        super.setValues(otherFlow);
        setConditionExpression(otherFlow.getConditionExpression());
        setSourceRef(otherFlow.getSourceRef());
        setTargetRef(otherFlow.getTargetRef());
        setSkipExpression(otherFlow.getSkipExpression());
    }
}
