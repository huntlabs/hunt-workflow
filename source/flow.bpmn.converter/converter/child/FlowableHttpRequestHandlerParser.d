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


import javax.xml.stream.XMLStreamReader;

import org.apache.commons.lang3.StringUtils;
import flow.bpmn.converter.converter.util.BpmnXMLUtil;
import flow.bpmn.model.BaseElement;
import flow.bpmn.model.BpmnModel;
import flow.bpmn.model.FlowableHttpRequestHandler;
import flow.bpmn.model.HttpServiceTask;
import flow.bpmn.model.ImplementationType;

/**
 * @author Tijs Rademakers
 */
public class FlowableHttpRequestHandlerParser extends BaseChildElementParser {

    @Override
    public void parseChildElement(XMLStreamReader xtr, BaseElement parentElement, BpmnModel model) throws Exception {

        FlowableHttpRequestHandler requestHandler = new FlowableHttpRequestHandler();
        BpmnXMLUtil.addXMLLocation(requestHandler, xtr);
        if (StringUtils.isNotEmpty(xtr.getAttributeValue(null, ATTRIBUTE_LISTENER_CLASS))) {
            requestHandler.setImplementation(xtr.getAttributeValue(null, ATTRIBUTE_LISTENER_CLASS));
            requestHandler.setImplementationType(ImplementationType.IMPLEMENTATION_TYPE_CLASS);

        } else if (StringUtils.isNotEmpty(xtr.getAttributeValue(null, ATTRIBUTE_LISTENER_DELEGATEEXPRESSION))) {
            requestHandler.setImplementation(xtr.getAttributeValue(null, ATTRIBUTE_LISTENER_DELEGATEEXPRESSION));
            requestHandler.setImplementationType(ImplementationType.IMPLEMENTATION_TYPE_DELEGATEEXPRESSION);
        }

        if (parentElement instanceof HttpServiceTask) {
            ((HttpServiceTask) parentElement).setHttpRequestHandler(requestHandler);
            parseChildElements(xtr, requestHandler, model, new FieldExtensionParser());
        }
    }

    @Override
    public String getElementName() {
        return ELEMENT_HTTP_REQUEST_HANDLER;
    }
}
