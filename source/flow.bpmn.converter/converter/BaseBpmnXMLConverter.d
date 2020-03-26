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
module flow.bpmn.converter.converter.BaseBpmnXMLConverter;

import hunt.collection.HashMap;
import hunt.collection.List;
import hunt.collection.Map;
import hunt.collection.ArrayList;
//import javax.xml.stream.XMLStreamReader;
//import javax.xml.stream.XMLStreamWriter;

import flow.bpmn.converter.constants.BpmnXMLConstants;
import flow.bpmn.converter.converter.child.BaseChildElementParser;
//import flow.bpmn.converter.converter.exp.FailedJobRetryCountExport;
//import flow.bpmn.converter.converter.exp.FlowableListenerExport;
//import flow.bpmn.converter.converter.exp.MultiInstanceExport;
import flow.bpmn.converter.converter.util.BpmnXMLUtil;
import flow.bpmn.model.Activity;
import flow.bpmn.model.Artifact;
import flow.bpmn.model.BaseElement;
import flow.bpmn.model.BpmnModel;
import flow.bpmn.model.CancelEventDefinition;
import flow.bpmn.model.CompensateEventDefinition;
import flow.bpmn.model.ConditionalEventDefinition;
import flow.bpmn.model.DataObject;
import flow.bpmn.model.ErrorEventDefinition;
import flow.bpmn.model.EscalationEventDefinition;
import flow.bpmn.model.Event;
import flow.bpmn.model.EventDefinition;
import flow.bpmn.model.ExtensionAttribute;
import flow.bpmn.model.ExtensionElement;
import flow.bpmn.model.FlowElement;
import flow.bpmn.model.FlowNode;
import flow.bpmn.model.FormProperty;
import flow.bpmn.model.FormValue;
import flow.bpmn.model.Gateway;
import flow.bpmn.model.MessageEventDefinition;
import flow.bpmn.model.Process;
import flow.bpmn.model.SequenceFlow;
import flow.bpmn.model.ServiceTask;
import flow.bpmn.model.SignalEventDefinition;
import flow.bpmn.model.StartEvent;
import flow.bpmn.model.SubProcess;
import flow.bpmn.model.TerminateEventDefinition;
import flow.bpmn.model.ThrowEvent;
import flow.bpmn.model.TimerEventDefinition;
import flow.bpmn.model.UserTask;
import flow.bpmn.model.ValuedDataObject;
import hunt.xml;
import std.concurrency : initOnce;
import std.uni;
import hunt.Exceptions;
import std.string;
/**
 * @author Tijs Rademakers
 * @author Joram Barrez
 */
abstract class BaseBpmnXMLConverter : BpmnXMLConstants {

     static List!ExtensionAttribute defaultElementAttributes() {
       __gshared List!ExtensionAttribute inst;
       return initOnce!inst(new ArrayList!ExtensionAttribute([new ExtensionAttribute(ATTRIBUTE_ID),new ExtensionAttribute(ATTRIBUTE_NAME)]));
     }

    static List!ExtensionAttribute defaultActivityAttributes() {
      __gshared List!ExtensionAttribute inst;
      return initOnce!inst(new ArrayList!ExtensionAttribute([new ExtensionAttribute(ATTRIBUTE_ACTIVITY_ASYNCHRONOUS),new ExtensionAttribute(ATTRIBUTE_ACTIVITY_EXCLUSIVE),new ExtensionAttribute(ATTRIBUTE_DEFAULT),new ExtensionAttribute(ATTRIBUTE_ACTIVITY_ISFORCOMPENSATION)]));
    }
    //protected static  List!ExtensionAttribute defaultElementAttributes = Arrays.asList(new ExtensionAttribute(ATTRIBUTE_ID), new ExtensionAttribute(ATTRIBUTE_NAME));

    //protected static  List!ExtensionAttribute defaultActivityAttributes = Arrays.asList(
    //        new ExtensionAttribute(ATTRIBUTE_ACTIVITY_ASYNCHRONOUS),
    //        new ExtensionAttribute(ATTRIBUTE_ACTIVITY_EXCLUSIVE),
    //        new ExtensionAttribute(ATTRIBUTE_DEFAULT),
    //        new ExtensionAttribute(ATTRIBUTE_ACTIVITY_ISFORCOMPENSATION));

    public void convertToBpmnModel(Element xtr, BpmnModel model, Process activeProcess, List!SubProcess activeSubProcessList) {
        Attribute elementId = xtr.firstAttribute(ATTRIBUTE_ID);

        //string elementId = xtr.firstAttribute(ATTRIBUTE_ID);
        Attribute elementName = xtr.firstAttribute(ATTRIBUTE_NAME);
        bool async = parseAsync(xtr);
        bool triggerable = parseTriggerable(xtr);
        bool notExclusive = parseNotExclusive(xtr);
        Attribute defaultFlow = xtr.firstAttribute(ATTRIBUTE_DEFAULT);
        bool isForCompensation = parseForCompensation(xtr);

        BaseElement parsedElement = convertXMLToElement(xtr, model);

         Artifact currentArtifact = cast(Artifact) parsedElement;
        if (currentArtifact !is null) {
            currentArtifact.setId(elementId is null? null : elementId.getValue);
            if (!activeSubProcessList.isEmpty()) {
                activeSubProcessList.get(activeSubProcessList.size() - 1).addArtifact(currentArtifact);

            } else {
                activeProcess.addArtifact(currentArtifact);
            }
        }

        FlowElement currentFlowElement = cast(FlowElement) parsedElement;
        if (currentFlowElement !is null) {
            currentFlowElement.setId(elementId is null? null : elementId.getValue);
            currentFlowElement.setName(elementName is null ? null : elementName.getValue);

             FlowNode flowNode = cast(FlowNode) currentFlowElement;
            if (flowNode !is null) {
                flowNode.setAsynchronous(async);
                flowNode.setNotExclusive(notExclusive);

                Activity activity = cast(Activity) currentFlowElement;
                if (activity !is null) {
                    activity.setForCompensation(isForCompensation);
                    if (defaultFlow !is null && (defaultFlow.getValue.length != 0)) {
                        activity.setDefaultFlow(defaultFlow.getValue);
                    }
                }

                Gateway gateway = cast(Gateway) currentFlowElement;
                if (gateway !is null) {
                    if (defaultFlow !is null && (defaultFlow.getValue.length != 0)) {
                        gateway.setDefaultFlow(defaultFlow.getValue);
                    }
                }

                ServiceTask serviceTask = cast(ServiceTask) currentFlowElement;
                if (serviceTask !is null) {
                    serviceTask.setTriggerable(triggerable);
                }
            }

            DataObject dateObj = cast(DataObject)currentFlowElement;
            if (dateObj !is null) {
                if (!activeSubProcessList.isEmpty()) {
                    SubProcess subProcess = activeSubProcessList.get(activeSubProcessList.size() - 1);
                    subProcess.getDataObjects().add(cast(ValuedDataObject) parsedElement);
                } else {
                    activeProcess.getDataObjects().add(cast(ValuedDataObject) parsedElement);
                }
            }

            if (!activeSubProcessList.isEmpty()) {

                SubProcess subProcess = activeSubProcessList.get(activeSubProcessList.size() - 1);
                subProcess.addFlowElement(currentFlowElement);

            } else {
                activeProcess.addFlowElement(currentFlowElement);
            }
        }
    }

    //public void convertToXML(XMLStreamWriter xtw, BaseElement baseElement, BpmnModel model)  {
    //    xtw.writeStartElement(getXMLElementName());
    //    bool didWriteExtensionStartElement = false;
    //    writeDefaultAttribute(ATTRIBUTE_ID, baseElement.getId(), xtw);
    //    if (baseElement instanceof FlowElement) {
    //        writeDefaultAttribute(ATTRIBUTE_NAME, ((FlowElement) baseElement).getName(), xtw);
    //    }
    //
    //    if (baseElement instanceof FlowNode) {
    //        final FlowNode flowNode = (FlowNode) baseElement;
    //        if (flowNode.isAsynchronous()) {
    //            writeQualifiedAttribute(ATTRIBUTE_ACTIVITY_ASYNCHRONOUS, ATTRIBUTE_VALUE_TRUE, xtw);
    //            if (flowNode.isNotExclusive()) {
    //                writeQualifiedAttribute(ATTRIBUTE_ACTIVITY_EXCLUSIVE, ATTRIBUTE_VALUE_FALSE, xtw);
    //            }
    //        }
    //
    //        if (baseElement instanceof Activity) {
    //            final Activity activity = (Activity) baseElement;
    //            if (activity.isForCompensation()) {
    //                writeDefaultAttribute(ATTRIBUTE_ACTIVITY_ISFORCOMPENSATION, ATTRIBUTE_VALUE_TRUE, xtw);
    //            }
    //            if (stringUtils.isNotEmpty(activity.getDefaultFlow())) {
    //                FlowElement defaultFlowElement = model.getFlowElement(activity.getDefaultFlow());
    //                if (defaultFlowElement instanceof SequenceFlow) {
    //                    writeDefaultAttribute(ATTRIBUTE_DEFAULT, activity.getDefaultFlow(), xtw);
    //                }
    //            }
    //        }
    //
    //        if (baseElement instanceof Gateway) {
    //            final Gateway gateway = (Gateway) baseElement;
    //            if (stringUtils.isNotEmpty(gateway.getDefaultFlow())) {
    //                FlowElement defaultFlowElement = model.getFlowElement(gateway.getDefaultFlow());
    //                if (defaultFlowElement instanceof SequenceFlow) {
    //                    writeDefaultAttribute(ATTRIBUTE_DEFAULT, gateway.getDefaultFlow(), xtw);
    //                }
    //            }
    //        }
    //    }
    //
    //    writeAdditionalAttributes(baseElement, model, xtw);
    //
    //    if (baseElement instanceof FlowElement) {
    //        final FlowElement flowElement = (FlowElement) baseElement;
    //        if (stringUtils.isNotEmpty(flowElement.getDocumentation())) {
    //
    //            xtw.writeStartElement(ELEMENT_DOCUMENTATION);
    //            xtw.writeCharacters(flowElement.getDocumentation());
    //            xtw.writeEndElement();
    //        }
    //    }
    //
    //    didWriteExtensionStartElement = writeExtensionChildElements(baseElement, didWriteExtensionStartElement, xtw);
    //    didWriteExtensionStartElement = writeListeners(baseElement, didWriteExtensionStartElement, xtw);
    //    didWriteExtensionStartElement = BpmnXMLUtil.writeExtensionElements(baseElement, didWriteExtensionStartElement, model.getNamespaces(), xtw);
    //    if (baseElement instanceof Activity) {
    //        final Activity activity = (Activity) baseElement;
    //        didWriteExtensionStartElement = FailedJobRetryCountExport.writeFailedJobRetryCount(activity, didWriteExtensionStartElement, xtw);
    //    }
    //
    //    if (didWriteExtensionStartElement) {
    //        xtw.writeEndElement();
    //    }
    //
    //    if (baseElement instanceof Activity) {
    //        final Activity activity = (Activity) baseElement;
    //        MultiInstanceExport.writeMultiInstance(activity, model, xtw);
    //
    //    }
    //
    //    writeAdditionalChildElements(baseElement, model, xtw);
    //
    //    xtw.writeEndElement();
    //}

    protected abstract TypeInfo getBpmnElementType();

    protected abstract BaseElement convertXMLToElement(Element xtr, BpmnModel model) ;

    protected abstract string getXMLElementName();

    //protected abstract void writeAdditionalAttributes(BaseElement element, BpmnModel model, XMLStreamWriter xtw) ;
    //
    //protected bool writeExtensionChildElements(BaseElement element, bool didWriteExtensionStartElement, XMLStreamWriter xtw)  {
    //    return didWriteExtensionStartElement;
    //}
    //
    //protected abstract void writeAdditionalChildElements(BaseElement element, BpmnModel model, XMLStreamWriter xtw) ;

    // To BpmnModel converter convenience methods

    protected void parseChildElements(string elementName, BaseElement parentElement, BpmnModel model, Element xtr)  {
        parseChildElements(elementName, parentElement, null, model, xtr);
    }

    protected void parseChildElements(string elementName, BaseElement parentElement, Map!(string, BaseChildElementParser) additionalParsers, BpmnModel model, Element xtr){

        Map!(string, BaseChildElementParser) childParsers = new HashMap!(string, BaseChildElementParser)();
        if (additionalParsers !is null) {
            childParsers.putAll(additionalParsers);
        }
        BpmnXMLUtil.parseChildElements(elementName, parentElement, xtr, childParsers, model);
    }



  private void loopNexSibling(Element n , ExtensionElement extensionElement, bool readyWithFormProperty)
  {
    Element node = n;
    while(!readyWithFormProperty && node !is null && node.getType == NodeType.Element)
    {
      //DOSOMETHING
      ExtensionElement childExtensionElement = parseExtensionElement(node);
      extensionElement.addChildElement(childExtensionElement);
      if (node.firstNode !is null  && node.firstNode.getType == NodeType.CDATA)
      {
        if (strip(node.firstNode.getText()).length != 0) {
            extensionElement.setElementText(strip(node.firstNode.getText()));
        }
      }


      Element child  = node.firstNode;
      if(child !is null && child.getType == NodeType.Element)
      {
        //DOSOMETHING
        ExtensionElement childExtensionElement = parseExtensionElement(child);
        extensionElement.addChildElement(childExtensionElement);
        if (child.firstNode !is null  && child.firstNode.getType == NodeType.CDATA)
        {
          if (strip(child.firstNode.getText()).length != 0) {
            extensionElement.setElementText(strip(child.firstNode.getText()));
          }
        }
        loopNexSibling(child.nextSibling , extensionElement ,readyWithFormProperty);
      }
      node = node.nextSibling;
    }
  }


    protected ExtensionElement parseExtensionElement(Element xtr) {
        //implementationMissing(false);
        ExtensionElement extensionElement = new ExtensionElement();
        extensionElement.setName(xtr.getName());
        //if (stringUtils.isNotEmpty(xtr.getNamespaceURI())) {
        //    extensionElement.setNamespace(xtr.getNamespaceURI());
        //}
        //if (stringUtils.isNotEmpty(xtr.getPrefix())) {
        //    extensionElement.setNamespacePrefix(xtr.getPrefix());
        //}

        BpmnXMLUtil.addCustomAttributes(xtr, extensionElement, defaultElementAttributes);

        bool readyWithExtensionElement = false;
        if (xtr !is null)
        {
            loopNexSibling(xtr.firstNode, extensionElement, readyWithExtensionElement);
        }
        //while (!readyWithExtensionElement && xtr.hasNext()) {
        //    xtr.next();
        //    if (xtr.isCharacters() || XMLStreamReader.CDATA == xtr.getEventType()) {
        //        if (stringUtils.isNotEmpty(xtr.getText().trim())) {
        //            extensionElement.setElementText(xtr.getText().trim());
        //        }
        //    } else if (xtr.isStartElement()) {
        //        ExtensionElement childExtensionElement = parseExtensionElement(xtr);
        //        extensionElement.addChildElement(childExtensionElement);
        //    } else if (xtr.isEndElement() && extensionElement.getName().equalsIgnoreCase(xtr.getLocalName())) {
        //        readyWithExtensionElement = true;
        //    }
        //}
        //return extensionElement;
    }

    protected bool parseAsync(Element xtr) {
        bool async = false;
        string asyncstring = BpmnXMLUtil.getAttributeValue(ATTRIBUTE_ACTIVITY_ASYNCHRONOUS, xtr);
        if (icmp(ATTRIBUTE_VALUE_TRUE,asyncstring) == 0) {
            async = true;
        }
        return async;
    }

    protected bool parseNotExclusive(Element xtr) {
        bool notExclusive = false;
        string exclusivestring = BpmnXMLUtil.getAttributeValue(ATTRIBUTE_ACTIVITY_EXCLUSIVE, xtr);
        if (icmp(ATTRIBUTE_VALUE_FALSE,(exclusivestring)) == 0) {
            notExclusive = true;
        }
        return notExclusive;
    }

    protected bool parseTriggerable(Element xtr) {
        string triggerable = BpmnXMLUtil.getAttributeValue(ATTRIBUTE_ACTIVITY_TRIGGERABLE, xtr);
        if (icmp(ATTRIBUTE_VALUE_TRUE,(triggerable)) == 0) {
            return true;
        }
        return false;
    }

    protected bool parseForCompensation(Element xtr) {
        bool isForCompensation = false;
        Attribute compensationstring = xtr.firstAttribute(ATTRIBUTE_ACTIVITY_ISFORCOMPENSATION);
        if (compensationstring !is null && icmp(ATTRIBUTE_VALUE_TRUE,(compensationstring.getValue)) == 0) {
            isForCompensation = true;
        }
        return isForCompensation;
    }

    protected List!string parseDelimitedList(string expression) {
        return BpmnXMLUtil.parseDelimitedList(expression);
    }

    // To XML converter convenience methods

    protected string convertToDelimitedstring(List!string stringList) {
        return BpmnXMLUtil.convertToDelimitedstring(stringList);
    }

    //protected bool writeFormProperties(FlowElement flowElement, bool didWriteExtensionStartElement, XMLStreamWriter xtw)  {
    //
    //    List<FormProperty> propertyList = null;
    //    if (flowElement instanceof UserTask) {
    //        propertyList = ((UserTask) flowElement).getFormProperties();
    //    } else if (flowElement instanceof StartEvent) {
    //        propertyList = ((StartEvent) flowElement).getFormProperties();
    //    }
    //
    //    if (propertyList !is null) {
    //
    //        for (FormProperty property : propertyList) {
    //
    //            if (stringUtils.isNotEmpty(property.getId())) {
    //
    //                if (!didWriteExtensionStartElement) {
    //                    xtw.writeStartElement(ELEMENT_EXTENSIONS);
    //                    didWriteExtensionStartElement = true;
    //                }
    //
    //                xtw.writeStartElement(FLOWABLE_EXTENSIONS_PREFIX, ELEMENT_FORMPROPERTY, FLOWABLE_EXTENSIONS_NAMESPACE);
    //                writeDefaultAttribute(ATTRIBUTE_FORM_ID, property.getId(), xtw);
    //
    //                writeDefaultAttribute(ATTRIBUTE_FORM_NAME, property.getName(), xtw);
    //                writeDefaultAttribute(ATTRIBUTE_FORM_TYPE, property.getType(), xtw);
    //                writeDefaultAttribute(ATTRIBUTE_FORM_EXPRESSION, property.getExpression(), xtw);
    //                writeDefaultAttribute(ATTRIBUTE_FORM_VARIABLE, property.getVariable(), xtw);
    //                writeDefaultAttribute(ATTRIBUTE_FORM_DEFAULT, property.getDefaultExpression(), xtw);
    //                writeDefaultAttribute(ATTRIBUTE_FORM_DATEPATTERN, property.getDatePattern(), xtw);
    //                if (!property.isReadable()) {
    //                    writeDefaultAttribute(ATTRIBUTE_FORM_READABLE, ATTRIBUTE_VALUE_FALSE, xtw);
    //                }
    //                if (!property.isWriteable()) {
    //                    writeDefaultAttribute(ATTRIBUTE_FORM_WRITABLE, ATTRIBUTE_VALUE_FALSE, xtw);
    //                }
    //                if (property.isRequired()) {
    //                    writeDefaultAttribute(ATTRIBUTE_FORM_REQUIRED, ATTRIBUTE_VALUE_TRUE, xtw);
    //                }
    //
    //                for (FormValue formValue : property.getFormValues()) {
    //                    if (stringUtils.isNotEmpty(formValue.getId())) {
    //                        xtw.writeStartElement(FLOWABLE_EXTENSIONS_PREFIX, ELEMENT_VALUE, FLOWABLE_EXTENSIONS_NAMESPACE);
    //                        xtw.writeAttribute(ATTRIBUTE_ID, formValue.getId());
    //                        xtw.writeAttribute(ATTRIBUTE_NAME, formValue.getName());
    //                        xtw.writeEndElement();
    //                    }
    //                }
    //
    //                xtw.writeEndElement();
    //            }
    //        }
    //    }
    //
    //    return didWriteExtensionStartElement;
    //}
    //
    //protected bool writeListeners(BaseElement element, bool didWriteExtensionStartElement, XMLStreamWriter xtw)  {
    //    return FlowableListenerExport.writeListeners(element, didWriteExtensionStartElement, xtw);
    //}
    //
    //protected void writeEventDefinitions(Event parentEvent, List<EventDefinition> eventDefinitions, BpmnModel model, XMLStreamWriter xtw)  {
    //    for (EventDefinition eventDefinition : eventDefinitions) {
    //        if (eventDefinition instanceof TimerEventDefinition) {
    //            writeTimerDefinition(parentEvent, (TimerEventDefinition) eventDefinition, model, xtw);
    //        } else if (eventDefinition instanceof SignalEventDefinition) {
    //            writeSignalDefinition(parentEvent, (SignalEventDefinition) eventDefinition, model, xtw);
    //        } else if (eventDefinition instanceof MessageEventDefinition) {
    //            writeMessageDefinition(parentEvent, (MessageEventDefinition) eventDefinition, model, xtw);
    //        } else if (eventDefinition instanceof ConditionalEventDefinition) {
    //            writeConditionalDefinition(parentEvent, (ConditionalEventDefinition) eventDefinition, model, xtw);
    //        } else if (eventDefinition instanceof ErrorEventDefinition) {
    //            writeErrorDefinition(parentEvent, (ErrorEventDefinition) eventDefinition, model, xtw);
    //        } else if (eventDefinition instanceof EscalationEventDefinition) {
    //            writeEscalationDefinition(parentEvent, (EscalationEventDefinition) eventDefinition, model, xtw);
    //        } else if (eventDefinition instanceof TerminateEventDefinition) {
    //            writeTerminateDefinition(parentEvent, (TerminateEventDefinition) eventDefinition, model, xtw);
    //        } else if (eventDefinition instanceof CancelEventDefinition) {
    //            writeCancelDefinition(parentEvent, (CancelEventDefinition) eventDefinition, model, xtw);
    //        } else if (eventDefinition instanceof CompensateEventDefinition) {
    //            writeCompensateDefinition(parentEvent, (CompensateEventDefinition) eventDefinition, model, xtw);
    //        }
    //    }
    //}
    //
    //protected void writeTimerDefinition(Event parentEvent, TimerEventDefinition timerDefinition, BpmnModel model, XMLStreamWriter xtw)  {
    //    xtw.writeStartElement(ELEMENT_EVENT_TIMERDEFINITION);
    //    if (stringUtils.isNotEmpty(timerDefinition.getCalendarName())) {
    //        writeQualifiedAttribute(ATTRIBUTE_CALENDAR_NAME, timerDefinition.getCalendarName(), xtw);
    //    }
    //    bool didWriteExtensionStartElement = BpmnXMLUtil.writeExtensionElements(timerDefinition, false, model.getNamespaces(), xtw);
    //    if (didWriteExtensionStartElement) {
    //        xtw.writeEndElement();
    //    }
    //    if (stringUtils.isNotEmpty(timerDefinition.getTimeDate())) {
    //        xtw.writeStartElement(ATTRIBUTE_TIMER_DATE);
    //        xtw.writeCharacters(timerDefinition.getTimeDate());
    //        xtw.writeEndElement();
    //
    //    } else if (stringUtils.isNotEmpty(timerDefinition.getTimeCycle())) {
    //        xtw.writeStartElement(ATTRIBUTE_TIMER_CYCLE);
    //
    //        if (stringUtils.isNotEmpty(timerDefinition.getEndDate())) {
    //            xtw.writeAttribute(FLOWABLE_EXTENSIONS_PREFIX, FLOWABLE_EXTENSIONS_NAMESPACE, ATTRIBUTE_END_DATE, timerDefinition.getEndDate());
    //        }
    //
    //        xtw.writeCharacters(timerDefinition.getTimeCycle());
    //        xtw.writeEndElement();
    //
    //    } else if (stringUtils.isNotEmpty(timerDefinition.getTimeDuration())) {
    //        xtw.writeStartElement(ATTRIBUTE_TIMER_DURATION);
    //        xtw.writeCharacters(timerDefinition.getTimeDuration());
    //        xtw.writeEndElement();
    //    }
    //
    //    xtw.writeEndElement();
    //}
    //
    //protected void writeSignalDefinition(Event parentEvent, SignalEventDefinition signalDefinition, BpmnModel model,
    //    XMLStreamWriter xtw)  {
    //    xtw.writeStartElement(ELEMENT_EVENT_SIGNALDEFINITION);
    //
    //    if (stringUtils.isNotEmpty(signalDefinition.getSignalRef())) {
    //        writeDefaultAttribute(ATTRIBUTE_SIGNAL_REF, signalDefinition.getSignalRef(), xtw);
    //    }
    //    if (stringUtils.isNotEmpty(signalDefinition.getSignalExpression())) {
    //        xtw.writeAttribute(FLOWABLE_EXTENSIONS_PREFIX, FLOWABLE_EXTENSIONS_NAMESPACE, ATTRIBUTE_SIGNAL_EXPRESSION, signalDefinition.getSignalExpression());
    //    }
    //
    //    if (parentEvent instanceof ThrowEvent && signalDefinition.isAsync()) {
    //        BpmnXMLUtil.writeQualifiedAttribute(ATTRIBUTE_ACTIVITY_ASYNCHRONOUS, "true", xtw);
    //    }
    //    bool didWriteExtensionStartElement = BpmnXMLUtil.writeExtensionElements(signalDefinition, false, model.getNamespaces(), xtw);
    //    if (didWriteExtensionStartElement) {
    //        xtw.writeEndElement();
    //    }
    //    xtw.writeEndElement();
    //}
    //
    //protected void writeCancelDefinition(Event parentEvent, CancelEventDefinition cancelEventDefinition, BpmnModel model,
    //    XMLStreamWriter xtw)  {
    //    xtw.writeStartElement(ELEMENT_EVENT_CANCELDEFINITION);
    //    bool didWriteExtensionStartElement = BpmnXMLUtil.writeExtensionElements(cancelEventDefinition, false, model.getNamespaces(), xtw);
    //    if (didWriteExtensionStartElement) {
    //        xtw.writeEndElement();
    //    }
    //    xtw.writeEndElement();
    //}
    //
    //protected void writeCompensateDefinition(Event parentEvent, CompensateEventDefinition compensateEventDefinition, BpmnModel model,
    //    XMLStreamWriter xtw)  {
    //    xtw.writeStartElement(ELEMENT_EVENT_COMPENSATEDEFINITION);
    //    writeDefaultAttribute(ATTRIBUTE_COMPENSATE_ACTIVITYREF, compensateEventDefinition.getActivityRef(), xtw);
    //    bool didWriteExtensionStartElement = BpmnXMLUtil.writeExtensionElements(compensateEventDefinition, false, model.getNamespaces(), xtw);
    //    if (didWriteExtensionStartElement) {
    //        xtw.writeEndElement();
    //    }
    //    xtw.writeEndElement();
    //}
    //
    //protected void writeMessageDefinition(Event parentEvent, MessageEventDefinition messageDefinition, BpmnModel model, XMLStreamWriter xtw)  {
    //    xtw.writeStartElement(ELEMENT_EVENT_MESSAGEDEFINITION);
    //
    //    string messageRef = messageDefinition.getMessageRef();
    //    if (stringUtils.isNotEmpty(messageRef)) {
    //        // remove the namespace from the message id if set
    //        if (messageRef.startsWith(model.getTargetNamespace())) {
    //            messageRef = messageRef.replace(model.getTargetNamespace(), "");
    //            messageRef = messageRef.replaceFirst(":", "");
    //        } else {
    //            for (string prefix : model.getNamespaces().keySet()) {
    //                string namespace = model.getNamespace(prefix);
    //                if (messageRef.startsWith(namespace)) {
    //                    messageRef = messageRef.replace(model.getTargetNamespace(), "");
    //                    messageRef = prefix + messageRef;
    //                }
    //            }
    //        }
    //    }
    //    writeDefaultAttribute(ATTRIBUTE_MESSAGE_REF, messageRef, xtw);
    //    bool didWriteExtensionStartElement = BpmnXMLUtil.writeExtensionElements(messageDefinition, false, model.getNamespaces(), xtw);
    //    if (didWriteExtensionStartElement) {
    //        xtw.writeEndElement();
    //    }
    //    xtw.writeEndElement();
    //}
    //
    //protected void writeConditionalDefinition(Event parentEvent, ConditionalEventDefinition conditionalDefinition, BpmnModel model, XMLStreamWriter xtw)  {
    //    xtw.writeStartElement(ELEMENT_EVENT_CONDITIONALDEFINITION);
    //    bool didWriteExtensionStartElement = BpmnXMLUtil.writeExtensionElements(conditionalDefinition, false, model.getNamespaces(), xtw);
    //    if (didWriteExtensionStartElement) {
    //        xtw.writeEndElement();
    //    }
    //
    //    if (stringUtils.isNotEmpty(conditionalDefinition.getConditionExpression())) {
    //        xtw.writeStartElement(ELEMENT_CONDITION);
    //        xtw.writeCharacters(conditionalDefinition.getConditionExpression());
    //        xtw.writeEndElement();
    //    }
    //
    //    xtw.writeEndElement();
    //}
    //
    //protected void writeErrorDefinition(Event parentEvent, ErrorEventDefinition errorDefinition, BpmnModel model, XMLStreamWriter xtw)  {
    //    xtw.writeStartElement(ELEMENT_EVENT_ERRORDEFINITION);
    //    writeDefaultAttribute(ATTRIBUTE_ERROR_REF, errorDefinition.getErrorCode(), xtw);
    //    bool didWriteExtensionStartElement = BpmnXMLUtil.writeExtensionElements(errorDefinition, false, model.getNamespaces(), xtw);
    //    if (didWriteExtensionStartElement) {
    //        xtw.writeEndElement();
    //    }
    //    xtw.writeEndElement();
    //}
    //
    //protected void writeEscalationDefinition(Event parentEvent, EscalationEventDefinition escalationDefinition, BpmnModel model,
    //                XMLStreamWriter xtw)  {
    //
    //    xtw.writeStartElement(ELEMENT_EVENT_ESCALATIONDEFINITION);
    //    writeDefaultAttribute(ATTRIBUTE_ESCALATION_REF, escalationDefinition.getEscalationCode(), xtw);
    //
    //    bool didWriteExtensionStartElement = BpmnXMLUtil.writeExtensionElements(escalationDefinition, false, model.getNamespaces(), xtw);
    //    if (didWriteExtensionStartElement) {
    //        xtw.writeEndElement();
    //    }
    //    xtw.writeEndElement();
    //}
    //
    //protected void writeTerminateDefinition(Event parentEvent, TerminateEventDefinition terminateDefinition, BpmnModel model,
    //    XMLStreamWriter xtw)  {
    //    xtw.writeStartElement(ELEMENT_EVENT_TERMINATEDEFINITION);
    //
    //    if (terminateDefinition.isTerminateAll()) {
    //        writeQualifiedAttribute(ATTRIBUTE_TERMINATE_ALL, "true", xtw);
    //    }
    //
    //    if (terminateDefinition.isTerminateMultiInstance()) {
    //        writeQualifiedAttribute(ATTRIBUTE_TERMINATE_MULTI_INSTANCE, "true", xtw);
    //    }
    //
    //    bool didWriteExtensionStartElement = BpmnXMLUtil.writeExtensionElements(terminateDefinition, false, model.getNamespaces(), xtw);
    //    if (didWriteExtensionStartElement) {
    //        xtw.writeEndElement();
    //    }
    //    xtw.writeEndElement();
    //}
    //
    //protected void writeDefaultAttribute(string attributeName, string value, XMLStreamWriter xtw)  {
    //    BpmnXMLUtil.writeDefaultAttribute(attributeName, value, xtw);
    //}
    //
    //protected void writeQualifiedAttribute(string attributeName, string value, XMLStreamWriter xtw)  {
    //    BpmnXMLUtil.writeQualifiedAttribute(attributeName, value, xtw);
    //}
}
