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


import java.util.ArrayList;
import java.util.List;

import com.fasterxml.jackson.annotation.JsonIgnore;

/**
 * @author Tijs Rademakers
 * @author Joram Barrez
 */
public abstract class FlowNode extends FlowElement {

    protected bool asynchronous;
    protected bool notExclusive;

    protected List<SequenceFlow> incomingFlows = new ArrayList<>();
    protected List<SequenceFlow> outgoingFlows = new ArrayList<>();

    @JsonIgnore
    protected Object behavior;

    public FlowNode() {

    }

    public bool isAsynchronous() {
        return asynchronous;
    }

    public void setAsynchronous(bool asynchronous) {
        this.asynchronous = asynchronous;
    }

    public bool isExclusive() {
        return !notExclusive;
    }

    public void setExclusive(bool exclusive) {
        this.notExclusive = !exclusive;
    }

    public bool isNotExclusive() {
        return notExclusive;
    }

    public void setNotExclusive(bool notExclusive) {
        this.notExclusive = notExclusive;
    }

    public Object getBehavior() {
        return behavior;
    }

    public void setBehavior(Object behavior) {
        this.behavior = behavior;
    }

    public List<SequenceFlow> getIncomingFlows() {
        return incomingFlows;
    }

    public void setIncomingFlows(List<SequenceFlow> incomingFlows) {
        this.incomingFlows = incomingFlows;
    }

    public List<SequenceFlow> getOutgoingFlows() {
        return outgoingFlows;
    }

    public void setOutgoingFlows(List<SequenceFlow> outgoingFlows) {
        this.outgoingFlows = outgoingFlows;
    }

    public void setValues(FlowNode otherNode) {
        super.setValues(otherNode);
        setAsynchronous(otherNode.isAsynchronous());
        setNotExclusive(otherNode.isNotExclusive());
    }
}
