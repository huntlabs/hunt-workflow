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
module flow.bpmn.converter.converter.child.FlowableMapExceptionParser;
import hunt.Exceptions;
import flow.bpmn.model.Activity;
import flow.bpmn.model.BaseElement;
import flow.bpmn.model.BpmnModel;
import flow.bpmn.model.MapExceptionEntry;
import flow.bpmn.converter.converter.child.BaseChildElementParser;
import flow.bpmn.converter.constants.BpmnXMLConstants;
import hunt.xml;
import std.uni;
import hunt.logging;
import std.string;
/**
 * @author Saeid Mirzaei
 */

class FlowableMapExceptionParser : BaseChildElementParser {

    override
    public string getElementName() {
        return MAP_EXCEPTION;
    }

    override
    public void parseChildElement(Element xtr, BaseElement parentElement, BpmnModel model)  {
        if (cast(Activity)parentElement is null)
            return;

        auto errorCode = xtr.firstAttribute(MAP_EXCEPTION_ERRORCODE);
        auto andChildren = xtr.firstAttribute(MAP_EXCEPTION_ANDCHILDREN);
        auto rootCause = xtr.firstAttribute(MAP_EXCEPTION_ROOTCAUSE);
        string exceptionClass = xtr.getText();
        bool hasChildrenBool = false;

        if ((andChildren !is null && andChildren.getValue.length != 0) || icmp(andChildren is null ? "" : andChildren.getValue,"false") == 0) {
            hasChildrenBool = false;
        } else if (icmp(andChildren,"true") == 0) {
            hasChildrenBool = true;
        } else {
            logError("XMLException andChildren is not valid bool in mapException with errorCode");
           // throw new XMLException("'" + andChildren + "' is not valid bool in mapException with errorCode=" + errorCode + " and class=" + exceptionClass);
        }

        if ((errorCode is null || errorCode.getValue.length == 0) ) {
            logError("No errorCode defined mapException with errorCode");
          //  throw new XMLException("No errorCode defined mapException with errorCode=" + errorCode + " and class=" + exceptionClass);
        }

        (cast(Activity) parentElement).getMapExceptions().add(new MapExceptionEntry(errorCode.getValue, exceptionClass, hasChildrenBool, rootCause.getValue));
    }
}
