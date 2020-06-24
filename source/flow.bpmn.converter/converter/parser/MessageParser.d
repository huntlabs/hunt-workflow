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
module flow.bpmn.converter.converter.parser.MessageParser;


import flow.bpmn.converter.constants.BpmnXMLConstants;
import flow.bpmn.converter.converter.util.BpmnXMLUtil;
import flow.bpmn.model.BpmnModel;
import flow.bpmn.model.Message;
import hunt.xml;
import std.string;
/**
 * @author Tijs Rademakers
 */
class MessageParser : BpmnXMLConstants {

    public void parse(Element xtr, BpmnModel model)  {
        if (xtr.firstAttribute(ATTRIBUTE_ID) !is null && xtr.firstAttribute(ATTRIBUTE_ID).getValue.length != 0) {
            auto messageId = xtr.firstAttribute(ATTRIBUTE_ID);
            auto messageName = xtr.firstAttribute(ATTRIBUTE_NAME);
            string itemRef = parseItemRef(xtr.firstAttribute(ATTRIBUTE_ITEM_REF) is null ? "" : xtr.firstAttribute(ATTRIBUTE_ITEM_REF).getValue, model);
            Message message = new Message(messageId is null ? "" : messageId.getValue, messageName is null ? "" : messageName.getValue, itemRef);
            BpmnXMLUtil.addXMLLocation(message, xtr);
            BpmnXMLUtil.parseChildElements(ELEMENT_MESSAGE, message, xtr, model);
            model.addMessage(message);
        }
    }

    protected string parseItemRef(string itemRef, BpmnModel model) {
        string result;
        if (itemRef.length != 0) {
            int indexOfP = cast(int)itemRef.indexOf(':');
            if (indexOfP != -1) {
                string prefix = itemRef[0 .. indexOfP];
                string resolvedNamespace = model.getNamespace(prefix);
                result = resolvedNamespace ~ ":" ~ itemRef[indexOfP + 1 .. $];
            } else {
                result = itemRef;
            }
        }
        return result;
    }
}
