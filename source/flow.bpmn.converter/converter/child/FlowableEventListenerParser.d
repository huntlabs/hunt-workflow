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
module flow.bpmn.converter.converter.child.FlowableEventListenerParser;

import flow.bpmn.converter.converter.util.BpmnXMLUtil;
import flow.bpmn.model.BaseElement;
import flow.bpmn.model.BpmnModel;
import flow.bpmn.model.EventListener;
import flow.bpmn.model.ImplementationType;
import flow.bpmn.model.Process;
import flow.bpmn.converter.converter.child.BaseChildElementParser;
import flow.bpmn.converter.constants.BpmnXMLConstants;
import hunt.xml;
import std.uni;
import hunt.logging;
import std.string;
/**
 * @author Frederik Heremans
 */
class FlowableEventListenerParser : BaseChildElementParser {

    override
    public void parseChildElement(Element xtr, BaseElement parentElement, BpmnModel model)  {
        EventListener listener = new EventListener();
        BpmnXMLUtil.addXMLLocation(listener, xtr);

        if (xtr.firstAttribute(ATTRIBUTE_LISTENER_CLASS) !is null && xtr.firstAttribute(ATTRIBUTE_LISTENER_CLASS).getValue.length != 0) {
            listener.setImplementation(xtr.firstAttribute(ATTRIBUTE_LISTENER_CLASS).getValue);
            listener.setImplementationType(ImplementationType.IMPLEMENTATION_TYPE_CLASS);

        } else if (xtr.firstAttribute(ATTRIBUTE_LISTENER_DELEGATEEXPRESSION) !is null && xtr.firstAttribute(ATTRIBUTE_LISTENER_DELEGATEEXPRESSION).getValue.length != 0) {
            listener.setImplementation(xtr.firstAttribute(ATTRIBUTE_LISTENER_DELEGATEEXPRESSION).getValue);
            listener.setImplementationType(ImplementationType.IMPLEMENTATION_TYPE_DELEGATEEXPRESSION);

        } else if (xtr.firstAttribute(ATTRIBUTE_LISTENER_THROW_EVENT_TYPE) !is null && xtr.firstAttribute(ATTRIBUTE_LISTENER_THROW_EVENT_TYPE).getValue.length != 0) {
            string eventType = xtr.firstAttribute(ATTRIBUTE_LISTENER_THROW_EVENT_TYPE).getValue;
            if (ATTRIBUTE_LISTENER_THROW_EVENT_TYPE_SIGNAL == (eventType)) {
                listener.setImplementationType(ImplementationType.IMPLEMENTATION_TYPE_THROW_SIGNAL_EVENT);
                listener.setImplementation(xtr.firstAttribute(ATTRIBUTE_LISTENER_THROW_SIGNAL_EVENT_NAME) is null ? "" : xtr.firstAttribute(ATTRIBUTE_LISTENER_THROW_SIGNAL_EVENT_NAME).getValue);
            } else if (ATTRIBUTE_LISTENER_THROW_EVENT_TYPE_GLOBAL_SIGNAL == (eventType)) {
                listener.setImplementationType(ImplementationType.IMPLEMENTATION_TYPE_THROW_GLOBAL_SIGNAL_EVENT);
                listener.setImplementation(xtr.firstAttribute(ATTRIBUTE_LISTENER_THROW_SIGNAL_EVENT_NAME) is null ? "" : xtr.firstAttribute(ATTRIBUTE_LISTENER_THROW_SIGNAL_EVENT_NAME).getValue);
            } else if (ATTRIBUTE_LISTENER_THROW_EVENT_TYPE_MESSAGE == (eventType)) {
                listener.setImplementationType(ImplementationType.IMPLEMENTATION_TYPE_THROW_MESSAGE_EVENT);
                listener.setImplementation(xtr.firstAttribute(ATTRIBUTE_LISTENER_THROW_MESSAGE_EVENT_NAME) is null ? "" : xtr.firstAttribute(ATTRIBUTE_LISTENER_THROW_MESSAGE_EVENT_NAME).getValue);
            } else if (ATTRIBUTE_LISTENER_THROW_EVENT_TYPE_ERROR == (eventType)) {
                listener.setImplementationType(ImplementationType.IMPLEMENTATION_TYPE_THROW_ERROR_EVENT);
                listener.setImplementation(xtr.firstAttribute(ATTRIBUTE_LISTENER_THROW_ERROR_EVENT_CODE) is null ? "" : xtr.firstAttribute(ATTRIBUTE_LISTENER_THROW_ERROR_EVENT_CODE).getValue);
            } else {
                listener.setImplementationType(ImplementationType.IMPLEMENTATION_TYPE_INVALID_THROW_EVENT);
            }
        }

        listener.setEvents(xtr.firstAttribute(ATTRIBUTE_LISTENER_EVENTS) is null ? "" : xtr.firstAttribute(ATTRIBUTE_LISTENER_EVENTS).getValue);
        listener.setEntityType(xtr.firstAttribute(ATTRIBUTE_LISTENER_ENTITY_TYPE) is null ? "" : xtr.firstAttribute(ATTRIBUTE_LISTENER_ENTITY_TYPE));

        if (xtr.firstAttribute(ATTRIBUTE_LISTENER_ON_TRANSACTION) !is null && xtr.firstAttribute(ATTRIBUTE_LISTENER_ON_TRANSACTION).getValue.length != 0){
            listener.setOnTransaction(xtr.firstAttribute(ATTRIBUTE_LISTENER_ON_TRANSACTION).getValue);
        }

        Process parentProcess = cast(Process) parentElement;
        parentProcess.getEventListeners().add(listener);
    }

    override
    public string getElementName() {
        return ELEMENT_EVENT_LISTENER;
    }
}
