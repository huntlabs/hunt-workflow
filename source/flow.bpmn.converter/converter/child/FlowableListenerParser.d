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
module flow.bpmn.converter.converter.child.FlowableListenerParser;

import flow.bpmn.converter.converter.child.FieldExtensionParser;
import flow.bpmn.converter.converter.util.BpmnXMLUtil;
import flow.bpmn.model.FlowableListener;
import flow.bpmn.model.BaseElement;
import flow.bpmn.model.BpmnModel;
import flow.bpmn.model.ImplementationType;
import flow.bpmn.converter.converter.child.BaseChildElementParser;
import flow.bpmn.converter.constants.BpmnXMLConstants;
import hunt.xml;
/**
 * @author Tijs Rademakers
 * @author Yvo Swillens
 */
abstract class FlowableListenerParser : BaseChildElementParser {

    override
    public void parseChildElement(Element xtr, BaseElement parentElement, BpmnModel model)  {

        FlowableListener listener = new FlowableListener();
        BpmnXMLUtil.addXMLLocation(listener, xtr);
        if (xtr.firstAttribute(ATTRIBUTE_LISTENER_CLASS) !is null && xtr.firstAttribute(ATTRIBUTE_LISTENER_CLASS).getValue.length != 0) {
            listener.setImplementation(xtr.firstAttribute(ATTRIBUTE_LISTENER_CLASS).getValue);
            listener.setImplementationType(ImplementationType.IMPLEMENTATION_TYPE_CLASS);
        } else if (xtr.firstAttribute(ATTRIBUTE_LISTENER_EXPRESSION) !is null && xtr.firstAttribute(ATTRIBUTE_LISTENER_EXPRESSION).getValue.length != 0) {
            listener.setImplementation(xtr.firstAttribute(ATTRIBUTE_LISTENER_EXPRESSION).getValue);
            listener.setImplementationType(ImplementationType.IMPLEMENTATION_TYPE_EXPRESSION);
        } else if (xtr.firstAttribute(ATTRIBUTE_LISTENER_DELEGATEEXPRESSION) !is null && xtr.firstAttribute(ATTRIBUTE_LISTENER_DELEGATEEXPRESSION).getValue.length !=0) {
            listener.setImplementation(xtr.firstAttribute(ATTRIBUTE_LISTENER_DELEGATEEXPRESSION).getValue);
            listener.setImplementationType(ImplementationType.IMPLEMENTATION_TYPE_DELEGATEEXPRESSION);
        }
        listener.setEvent(xtr.firstAttribute(ATTRIBUTE_LISTENER_EVENT) is null ? "" : xtr.firstAttribute(ATTRIBUTE_LISTENER_EVENT).getValue);
        listener.setOnTransaction(xtr.firstAttribute(ATTRIBUTE_LISTENER_ON_TRANSACTION) is null ? "" : xtr.firstAttribute(ATTRIBUTE_LISTENER_ON_TRANSACTION).getValue);

        if (xtr.firstAttribute(ATTRIBUTE_LISTENER_CUSTOM_PROPERTIES_RESOLVER_CLASS) !is null && xtr.firstAttribute(ATTRIBUTE_LISTENER_CUSTOM_PROPERTIES_RESOLVER_CLASS).getValue.length != 0) {
            listener.setCustomPropertiesResolverImplementation(xtr.firstAttribute(ATTRIBUTE_LISTENER_CUSTOM_PROPERTIES_RESOLVER_CLASS).getValue);
            listener.setCustomPropertiesResolverImplementationType(ImplementationType.IMPLEMENTATION_TYPE_CLASS);
        } else if (xtr.firstAttribute(ATTRIBUTE_LISTENER_CUSTOM_PROPERTIES_RESOLVER_EXPRESSION) !is null && xtr.firstAttribute(ATTRIBUTE_LISTENER_CUSTOM_PROPERTIES_RESOLVER_EXPRESSION).getValue.length != 0) {
            listener.setCustomPropertiesResolverImplementation(xtr.firstAttribute(ATTRIBUTE_LISTENER_CUSTOM_PROPERTIES_RESOLVER_EXPRESSION).getValue);
            listener.setCustomPropertiesResolverImplementationType(ImplementationType.IMPLEMENTATION_TYPE_EXPRESSION);
        } else if (xtr.firstAttribute(ATTRIBUTE_LISTENER_CUSTOM_PROPERTIES_RESOLVER_DELEGATEEXPRESSION) !is null && xtr.firstAttribute(ATTRIBUTE_LISTENER_CUSTOM_PROPERTIES_RESOLVER_DELEGATEEXPRESSION).getValue.length != 0) {
            listener.setCustomPropertiesResolverImplementation(xtr.firstAttribute(ATTRIBUTE_LISTENER_CUSTOM_PROPERTIES_RESOLVER_DELEGATEEXPRESSION).getValue);
            listener.setCustomPropertiesResolverImplementationType(ImplementationType.IMPLEMENTATION_TYPE_DELEGATEEXPRESSION);
        }
        addListenerToParent(listener, parentElement);
        parseChildElements(xtr, listener, model, new FieldExtensionParser());
    }

    public abstract void addListenerToParent(FlowableListener listener, BaseElement parentElement);
}
