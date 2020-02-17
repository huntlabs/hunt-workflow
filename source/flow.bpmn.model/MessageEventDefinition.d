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
class MessageEventDefinition extends EventDefinition {

    protected string messageRef;
    protected string messageExpression;

    public string getMessageRef() {
        return messageRef;
    }

    public void setMessageRef(string messageRef) {
        this.messageRef = messageRef;
    }

    public string getMessageExpression() {
        return messageExpression;
    }

    public void setMessageExpression(string messageExpression) {
        this.messageExpression = messageExpression;
    }

    @Override
    public MessageEventDefinition clone() {
        MessageEventDefinition clone = new MessageEventDefinition();
        clone.setValues(this);
        return clone;
    }

    public void setValues(MessageEventDefinition otherDefinition) {
        super.setValues(otherDefinition);
        setMessageRef(otherDefinition.getMessageRef());
        setMessageExpression(otherDefinition.getMessageExpression());
    }
}
