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

module flow.bpmn.model.SignalEventDefinition;

import flow.bpmn.model.EventDefinition;

/**
 * @author Tijs Rademakers
 */
class SignalEventDefinition : EventDefinition {

    protected string signalRef;
    protected string signalExpression;
    protected bool async;

    public string getSignalRef() {
        return signalRef;
    }

    public void setSignalRef(string signalRef) {
        this.signalRef = signalRef;
    }

    public string getSignalExpression() {
        return signalExpression;
    }

    public void setSignalExpression(string signalExpression) {
        this.signalExpression = signalExpression;
    }

    public bool isAsync() {
        return async;
    }

    public void setAsync(bool async) {
        this.async = async;
    }

    override
    public SignalEventDefinition clone() {
        SignalEventDefinition clone = new SignalEventDefinition();
        clone.setValues(this);
        return clone;
    }

    public void setValues(SignalEventDefinition otherDefinition) {
        super.setValues(otherDefinition);
        setSignalRef(otherDefinition.getSignalRef());
        setSignalExpression(otherDefinition.getSignalExpression());
        setAsync(otherDefinition.isAsync());
    }
}
