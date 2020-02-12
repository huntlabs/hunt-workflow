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


import flow.common.api.delegate.event.FlowableEngineEventType;
import flow.engine.delegate.event.FlowableEscalationEvent;

/**
 * An {@link FlowableEscalationEvent} implementation.
 */
class FlowableEscalationEventImpl extends FlowableActivityEventImpl implements FlowableEscalationEvent {

    protected string escalationCode;
    protected string escalationName;

    public FlowableEscalationEventImpl(FlowableEngineEventType type) {
        super(type);
    }

    @Override
    public string getEscalationCode() {
        return escalationCode;
    }

    public void setEscalationCode(string escalationCode) {
        this.escalationCode = escalationCode;
    }

    @Override
    public string getEscalationName() {
        return escalationName;
    }

    public void setEscalationName(string escalationName) {
        this.escalationName = escalationName;
    }
}
