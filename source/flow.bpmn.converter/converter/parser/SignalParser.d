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
module flow.bpmn.converter.converter.parser.SignalParser;


import flow.bpmn.converter.constants.BpmnXMLConstants;
import flow.bpmn.converter.converter.util.BpmnXMLUtil;
import flow.bpmn.model.BpmnModel;
import flow.bpmn.model.Signal;
import hunt.xml;
/**
 * @author Tijs Rademakers
 */
class SignalParser : BpmnXMLConstants {

    public void parse(Element xtr, BpmnModel model)  {
        auto signalId = xtr.firstAttribute(ATTRIBUTE_ID);
        auto signalName = xtr.firstAttribute(ATTRIBUTE_NAME);

        Signal signal = new Signal(signalId is null ? "" : signalId.getValue, signalName is null ? "" : signalName.getValue);

        string scop = BpmnXMLUtil.getAttributeValue(ATTRIBUTE_SCOPE, xtr);
        if (scop !is null) {
            signal.setScope(scop);
        }

        BpmnXMLUtil.addXMLLocation(signal, xtr);
        BpmnXMLUtil.parseChildElements(ELEMENT_SIGNAL, signal, xtr, model);
        model.addSignal(signal);
    }
}
