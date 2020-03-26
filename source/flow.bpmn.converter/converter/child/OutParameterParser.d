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

module flow.bpmn.converter.converter.child.OutParameterParser;

import flow.bpmn.model.BaseElement;
import flow.bpmn.model.BpmnModel;
import flow.bpmn.model.CallActivity;
import flow.bpmn.model.CaseServiceTask;
import flow.bpmn.model.IOParameter;
import flow.bpmn.converter.converter.child.BaseChildElementParser;
import flow.bpmn.converter.constants.BpmnXMLConstants;
import hunt.xml;
import std.uni;

class OutParameterParser : BaseChildElementParser {

    override
    public string getElementName() {
        return ELEMENT_OUT_PARAMETERS;
    }

    override
    public void parseChildElement(Element xtr, BaseElement parentElement, BpmnModel model)  {
        auto source = xtr.firstAttribute(ATTRIBUTE_IOPARAMETER_SOURCE);
        auto sourceExpression = xtr.firstAttribute(ATTRIBUTE_IOPARAMETER_SOURCE_EXPRESSION);
        auto target = xtr.firstAttribute(ATTRIBUTE_IOPARAMETER_TARGET);
        if ((source !is null && source.getValue.length != 0 || sourceExpression !is null && sourceExpression.getValue.length != 0) && (target !is null && target.getValue.length != 0)) {

            IOParameter parameter = new IOParameter();
            if (sourceExpression !is null && sourceExpression.getValue.length != 0) {
                parameter.setSourceExpression(sourceExpression.getValue);
            } else {
                parameter.setSource(source.getValue);
            }

            parameter.setTarget(target.getValue);

            auto transientValue = xtr.firstAttribute(ATTRIBUTE_IOPARAMETER_TRANSIENT);
            if (transientValue !is null && icmp("true",transientValue) == 0) {
                parameter.setTransient(true);
            }

            if (  cast(CallActivity)parentElement !is null ) {
                (cast(CallActivity) parentElement).getOutParameters().add(parameter);

            } else if (cast(CaseServiceTask)parentElement !is null) {
                (cast(CaseServiceTask) parentElement).getOutParameters().add(parameter);
            }
        }
    }
}
