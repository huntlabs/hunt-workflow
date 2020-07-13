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
module flow.bpmn.converter.converter.child.FlowableHttpResponseHandlerParser;


import flow.bpmn.converter.converter.util.BpmnXMLUtil;
import flow.bpmn.model.BaseElement;
import flow.bpmn.model.BpmnModel;
import flow.bpmn.model.FlowableHttpResponseHandler;
import flow.bpmn.model.HttpServiceTask;
import flow.bpmn.model.ImplementationType;
import flow.bpmn.converter.converter.child.BaseChildElementParser;
import flow.bpmn.converter.constants.BpmnXMLConstants;
import hunt.xml;
import std.uni;
import hunt.logging;
import flow.bpmn.converter.converter.child.FieldExtensionParser;
/**
 * @author Tijs Rademakers
 */
class FlowableHttpResponseHandlerParser : BaseChildElementParser {

    override
    public void parseChildElement(Element xtr, BaseElement parentElement, BpmnModel model)  {

        FlowableHttpResponseHandler responseHandler = new FlowableHttpResponseHandler();
        BpmnXMLUtil.addXMLLocation(responseHandler, xtr);
        if (xtr.firstAttribute(ATTRIBUTE_LISTENER_CLASS) !is null && xtr.firstAttribute(ATTRIBUTE_LISTENER_CLASS).getValue.length != 0) {
            responseHandler.setImplementation(xtr.firstAttribute(ATTRIBUTE_LISTENER_CLASS).getValue);
            responseHandler.setImplementationType(ImplementationType.IMPLEMENTATION_TYPE_CLASS);

        } else if (xtr.firstAttribute(ATTRIBUTE_LISTENER_DELEGATEEXPRESSION) !is null && xtr.firstAttribute(ATTRIBUTE_LISTENER_DELEGATEEXPRESSION).getValue.length != 0) {
            responseHandler.setImplementation(xtr.firstAttribute(ATTRIBUTE_LISTENER_DELEGATEEXPRESSION).getValue);
            responseHandler.setImplementationType(ImplementationType.IMPLEMENTATION_TYPE_DELEGATEEXPRESSION);
        }

        if (cast(HttpServiceTask)parentElement !is null) {
            (cast(HttpServiceTask) parentElement).setHttpResponseHandler(responseHandler);
            parseChildElements(xtr, responseHandler, model, new FieldExtensionParser());
        }
    }

    override
    public string getElementName() {
        return ELEMENT_HTTP_RESPONSE_HANDLER;
    }
}
