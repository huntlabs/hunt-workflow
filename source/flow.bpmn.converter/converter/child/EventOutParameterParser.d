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
module flow.bpmn.converter.converter.child.EventOutParameterParser;


import flow.bpmn.model.BaseElement;
import flow.bpmn.model.BpmnModel;
import flow.bpmn.model.ExtensionAttribute;
import flow.bpmn.model.IOParameter;
import flow.bpmn.model.SendEventServiceTask;
import flow.bpmn.converter.converter.child.BaseChildElementParser;
import flow.bpmn.converter.constants.BpmnXMLConstants;
import hunt.xml;
import std.uni;
import hunt.logging;
import std.string;
import std.algorithm;

class EventOutParameterParser : BaseChildElementParser {

    override
    public string getElementName() {
        return ELEMENT_EVENT_OUT_PARAMETER;
    }

    override
    public void parseChildElement(Element xtr, BaseElement parentElement, BpmnModel model)  {
        auto source = xtr.firstAttribute(ATTRIBUTE_IOPARAMETER_SOURCE);
        auto sourceExpression = xtr.firstAttribute(ATTRIBUTE_IOPARAMETER_SOURCE_EXPRESSION);
        auto target = xtr.firstAttribute(ATTRIBUTE_IOPARAMETER_TARGET);
        auto targetExpression = xtr.firstAttribute(ATTRIBUTE_IOPARAMETER_TARGET_EXPRESSION);
        if (((source !is null && source.getValue().length != 0) || (sourceExpression !is null && sourceExpression.getValue().length != 0)) &&
                        ((target !is null && target.getValue().length != 0) || (targetExpression !is null && targetExpression.getValue().length != 0))) {

            IOParameter parameter = new IOParameter();
            if (sourceExpression !is null && sourceExpression.getValue().length != 0) {
                parameter.setSourceExpression(sourceExpression.getValue);
            } else {
                parameter.setSource(source.getValue);
            }

            if (targetExpression !is null && targetExpression.getValue().length != 0) {
                parameter.setTargetExpression(targetExpression.getValue);
            } else {
                parameter.setTarget(target.getValue);
            }

            Attribute arr = xtr.firstAttribute();
            while (arr !is null){
                string attributeName = arr.getName;
                if (ATTRIBUTE_IOPARAMETER_SOURCE == (attributeName) || ATTRIBUTE_IOPARAMETER_SOURCE_EXPRESSION == (attributeName) ||
                                ATTRIBUTE_IOPARAMETER_TARGET == (attributeName) || ATTRIBUTE_IOPARAMETER_TARGET_EXPRESSION == (attributeName)) {
                    arr = arr.nextAttribute;
                    continue;
                }

                ExtensionAttribute extensionAttribute = new ExtensionAttribute();
                extensionAttribute.setName(attributeName);
                extensionAttribute.setValue(arr.getValue());

                if (startsWith(arr.getName(),"xmlns")) {
                  extensionAttribute.setNamespace(arr.getValue());
                }
                if (startsWith(arr.getName(),"xmlns:")) {
                  long index = arr.getName().indexOf(":");
                  extensionAttribute.setNamespacePrefix(arr.getName[index + 1 .. $]);
                }
                //if (StringUtils.isNotEmpty(xtr.getAttributeNamespace(i))) {
                //    extensionAttribute.setNamespace(xtr.getAttributeNamespace(i));
                //}
                //if (StringUtils.isNotEmpty(xtr.getAttributePrefix(i))) {
                //    extensionAttribute.setNamespacePrefix(xtr.getAttributePrefix(i));
                //}
                parameter.addAttribute(extensionAttribute);
                arr = arr.nextAttribute;
            }

            (cast(SendEventServiceTask) parentElement).getEventOutParameters().add(parameter);
        }
    }
}
