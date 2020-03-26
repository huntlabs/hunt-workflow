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
module flow.bpmn.converter.converter.parser.MessageFlowParser;


import flow.bpmn.converter.constants.BpmnXMLConstants;
import flow.bpmn.model.BpmnModel;
import flow.bpmn.model.MessageFlow;
import hunt.xml;
/**
 * @author Tijs Rademakers
 */
class MessageFlowParser : BpmnXMLConstants {

    public void parse(Element xtr, BpmnModel model)  {
        string id = xtr.firstAttribute(ATTRIBUTE_ID) is null ? "" : xtr.firstAttribute(ATTRIBUTE_ID).getValue;
        if (id.length != 0) {
            MessageFlow messageFlow = new MessageFlow();
            messageFlow.setId(id);

            string name = xtr.firstAttribute(ATTRIBUTE_NAME) is null ? "" : xtr.firstAttribute(ATTRIBUTE_NAME).getValue;
            if (name.length != 0) {
                messageFlow.setName(name);
            }

            string sourceRef = xtr.firstAttribute(ATTRIBUTE_FLOW_SOURCE_REF) is null ? "" : xtr.firstAttribute(ATTRIBUTE_FLOW_SOURCE_REF).getValue;
            if (sourceRef.length != 0) {
                messageFlow.setSourceRef(sourceRef);
            }

            string targetRef = xtr.firstAttribute(ATTRIBUTE_FLOW_TARGET_REF) is null ? "" : xtr.firstAttribute(ATTRIBUTE_FLOW_TARGET_REF).getValue;
            if (targetRef.length != 0) {
                messageFlow.setTargetRef(targetRef);
            }

            string messageRef = xtr.firstAttribute(ATTRIBUTE_MESSAGE_REF) is null ? "" : xtr.firstAttribute(ATTRIBUTE_MESSAGE_REF).getValue;
            if (messageRef.length != 0) {
                messageFlow.setMessageRef(messageRef);
            }

            model.addMessageFlow(messageFlow);
        }
    }
}
