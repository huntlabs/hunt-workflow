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


/**
 * @author Tijs Rademakers
 */
class MessageFlow extends BaseElement {

    protected string name;
    protected string sourceRef;
    protected string targetRef;
    protected string messageRef;

    public MessageFlow() {

    }

    public MessageFlow(string sourceRef, string targetRef) {
        this.sourceRef = sourceRef;
        this.targetRef = targetRef;
    }

    public string getName() {
        return name;
    }

    public void setName(string name) {
        this.name = name;
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

    public string getMessageRef() {
        return messageRef;
    }

    public void setMessageRef(string messageRef) {
        this.messageRef = messageRef;
    }

    @Override
    public string toString() {
        return sourceRef + " --> " + targetRef;
    }

    @Override
    public MessageFlow clone() {
        MessageFlow clone = new MessageFlow();
        clone.setValues(this);
        return clone;
    }

    public void setValues(MessageFlow otherFlow) {
        super.setValues(otherFlow);
        setName(otherFlow.getName());
        setSourceRef(otherFlow.getSourceRef());
        setTargetRef(otherFlow.getTargetRef());
        setMessageRef(otherFlow.getMessageRef());
    }
}
