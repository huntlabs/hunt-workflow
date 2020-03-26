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
module flow.bpmn.converter.converter.ServiceTaskXMLConverter;

import hunt.collection.HashMap;
import hunt.collection.List;
import hunt.collection.Map;

import flow.bpmn.converter.constants.BpmnXMLConstants;
import flow.bpmn.converter.converter.child.BaseChildElementParser;
import flow.bpmn.converter.converter.child.EventInParameterParser;
import flow.bpmn.converter.converter.child.EventOutParameterParser;
import flow.bpmn.converter.converter.child.InParameterParser;
import flow.bpmn.converter.converter.child.OutParameterParser;
//import flow.bpmn.converter.converter.exp.FieldExtensionExport;
//import flow.bpmn.converter.converter.exp.MapExceptionExport;
import flow.bpmn.converter.converter.util.BpmnXMLUtil;
import flow.bpmn.model.AbstractFlowableHttpHandler;
import flow.bpmn.model.BaseElement;
import flow.bpmn.model.BpmnModel;
import flow.bpmn.model.CaseServiceTask;
import flow.bpmn.model.CustomProperty;
import flow.bpmn.model.ExtensionElement;
import flow.bpmn.model.HttpServiceTask;
import flow.bpmn.model.ImplementationType;
import flow.bpmn.model.SendEventServiceTask;
import flow.bpmn.model.ServiceTask;
import flow.bpmn.converter.constants.BpmnXMLConstants;
import flow.bpmn.converter.converter.BaseBpmnXMLConverter;
import hunt.xml;
import hunt.Boolean;

/**
 * @author Tijs Rademakers
 */
class ServiceTaskXMLConverter : BaseBpmnXMLConverter {

    protected Map!(string, BaseChildElementParser) caseServiceChildParserMap  ;//= new HashMap<>();
    protected Map!(string, BaseChildElementParser) sendEventServiceChildParserMap ;// = new HashMap<>();

    this() {
        caseServiceChildParserMap = new HashMap!(string, BaseChildElementParser);
        sendEventServiceChildParserMap = new HashMap!(string, BaseChildElementParser);
        // Case service
        InParameterParser inParameterParser = new InParameterParser();
        caseServiceChildParserMap.put(inParameterParser.getElementName(), inParameterParser);
        OutParameterParser outParameterParser = new OutParameterParser();
        caseServiceChildParserMap.put(outParameterParser.getElementName(), outParameterParser);

        // Send event service
        EventInParameterParser eventInParameterParser = new EventInParameterParser();
        sendEventServiceChildParserMap.put(eventInParameterParser.getElementName(), eventInParameterParser);
        EventOutParameterParser eventOutParameterParser = new EventOutParameterParser();
        sendEventServiceChildParserMap.put(eventOutParameterParser.getElementName(), eventOutParameterParser);
    }

    override
    public TypeInfo getBpmnElementType() {
        return typeid(ServiceTask);
    }

    override
    protected string getXMLElementName() {
        return ELEMENT_TASK_SERVICE;
    }

    override
    protected BaseElement convertXMLToElement(Element xtr, BpmnModel model)  {
        string serviceTaskType = BpmnXMLUtil.getAttributeValue(ATTRIBUTE_TYPE, xtr);

        ServiceTask serviceTask = null;
        if (ServiceTask.HTTP_TASK == (serviceTaskType)) {
            serviceTask = new HttpServiceTask();

        } else if (ServiceTask.CASE_TASK == (serviceTaskType)) {
            serviceTask = new CaseServiceTask();

        } else if (ServiceTask.SEND_EVENT_TASK == (serviceTaskType)) {
            serviceTask = new SendEventServiceTask();

        } else {
            serviceTask = new ServiceTask();
        }

        BpmnXMLUtil.addXMLLocation(serviceTask, xtr);
        if (BpmnXMLUtil.getAttributeValue(ATTRIBUTE_TASK_SERVICE_CLASS, xtr).length != 0) {
            serviceTask.setImplementationType(ImplementationType.IMPLEMENTATION_TYPE_CLASS);
            serviceTask.setImplementation(BpmnXMLUtil.getAttributeValue(ATTRIBUTE_TASK_SERVICE_CLASS, xtr));

        } else if (BpmnXMLUtil.getAttributeValue(ATTRIBUTE_TASK_SERVICE_EXPRESSION, xtr).length != 0) {
            serviceTask.setImplementationType(ImplementationType.IMPLEMENTATION_TYPE_EXPRESSION);
            serviceTask.setImplementation(BpmnXMLUtil.getAttributeValue(ATTRIBUTE_TASK_SERVICE_EXPRESSION, xtr));

        } else if (BpmnXMLUtil.getAttributeValue(ATTRIBUTE_TASK_SERVICE_DELEGATEEXPRESSION, xtr).length != 0) {
            serviceTask.setImplementationType(ImplementationType.IMPLEMENTATION_TYPE_DELEGATEEXPRESSION);
            serviceTask.setImplementation(BpmnXMLUtil.getAttributeValue(ATTRIBUTE_TASK_SERVICE_DELEGATEEXPRESSION, xtr));

        } else if ("##WebService" == (xtr.firstAttribute(ATTRIBUTE_TASK_IMPLEMENTATION) is null ? "" : xtr.firstAttribute(ATTRIBUTE_TASK_IMPLEMENTATION).getValue)) {
            serviceTask.setImplementationType(ImplementationType.IMPLEMENTATION_TYPE_WEBSERVICE);
            serviceTask.setOperationRef(parseOperationRef(xtr.firstAttribute(ATTRIBUTE_TASK_OPERATION_REF) is null ? "" : xtr.firstAttribute(ATTRIBUTE_TASK_OPERATION_REF).getValue, model));
        }

        serviceTask.setResultVariableName(BpmnXMLUtil.getAttributeValue(ATTRIBUTE_TASK_SERVICE_RESULTVARIABLE, xtr));
        if (serviceTask.getResultVariableName().length == 0) {
            serviceTask.setResultVariableName(BpmnXMLUtil.getAttributeValue("resultVariable", xtr));
        }

        serviceTask.setUseLocalScopeForResultVariable(Boolean.valueOf(BpmnXMLUtil.getAttributeValue(ATTRIBUTE_TASK_SERVICE_USE_LOCAL_SCOPE_FOR_RESULT_VARIABLE, xtr)).booleanValue());

        serviceTask.setType(serviceTaskType);
        serviceTask.setExtensionId(BpmnXMLUtil.getAttributeValue(ATTRIBUTE_TASK_SERVICE_EXTENSIONID, xtr));

        if (BpmnXMLUtil.getAttributeValue(ATTRIBUTE_TASK_SERVICE_SKIP_EXPRESSION, xtr).length != 0) {
            serviceTask.setSkipExpression(BpmnXMLUtil.getAttributeValue(ATTRIBUTE_TASK_SERVICE_SKIP_EXPRESSION, xtr));
        }

        if (cast(CaseServiceTask)serviceTask !is null) {
            convertCaseServiceTaskXMLProperties(cast(CaseServiceTask) serviceTask, model, xtr);
        } else if (cast(SendEventServiceTask)serviceTask !is null) {
            convertSendEventServiceTaskXMLProperties(cast(SendEventServiceTask) serviceTask, model, xtr);
        } else {
            parseChildElements(getXMLElementName(), serviceTask, model, xtr);
        }

        return serviceTask;
    }

    //override
    //protected void writeAdditionalAttributes(BaseElement element, BpmnModel model, XMLStreamWriter xtw)  {
    //
    //    if (element instanceof CaseServiceTask) {
    //        writeCaseServiceTaskAdditionalAttributes(element, model, xtw);
    //
    //    } else if (element instanceof SendEventServiceTask) {
    //        writeSendEventServiceAdditionalAttributes(element, model, xtw);
    //
    //    } else {
    //        writeServiceTaskAdditionalAttributes((ServiceTask) element, xtw);
    //
    //    }
    //}
    //
    //protected void writeCaseServiceTaskAdditionalAttributes(BaseElement element, BpmnModel model, XMLStreamWriter xtw)  {
    //    CaseServiceTask caseServiceTask = (CaseServiceTask) element;
    //    writeQualifiedAttribute(ATTRIBUTE_TYPE, ServiceTask.CASE_TASK, xtw);
    //
    //    if (stringUtils.isNotEmpty(caseServiceTask.getSkipExpression())) {
    //        writeQualifiedAttribute(ATTRIBUTE_TASK_SERVICE_SKIP_EXPRESSION, caseServiceTask.getSkipExpression(), xtw);
    //    }
    //    if (stringUtils.isNotEmpty(caseServiceTask.getCaseDefinitionKey())) {
    //        writeQualifiedAttribute(ATTRIBUTE_CASE_TASK_CASE_DEFINITION_KEY, caseServiceTask.getCaseDefinitionKey(), xtw);
    //    }
    //    if (stringUtils.isNotEmpty(caseServiceTask.getCaseInstanceName())) {
    //        writeQualifiedAttribute(ATTRIBUTE_CASE_TASK_CASE_INSTANCE_NAME, caseServiceTask.getCaseInstanceName(), xtw);
    //    }
    //    if (stringUtils.isNotEmpty(caseServiceTask.getBusinessKey())) {
    //        writeQualifiedAttribute(ATTRIBUTE_BUSINESS_KEY, caseServiceTask.getBusinessKey(), xtw);
    //    }
    //    if (caseServiceTask.isInheritBusinessKey()) {
    //        writeQualifiedAttribute(ATTRIBUTE_INHERIT_BUSINESS_KEY, "true", xtw);
    //    }
    //    if (caseServiceTask.isSameDeployment()) {
    //        writeQualifiedAttribute(ATTRIBUTE_SAME_DEPLOYMENT, "true", xtw);
    //    }
    //    if (caseServiceTask.isFallbackToDefaultTenant()) {
    //        writeQualifiedAttribute(ATTRIBUTE_FALLBACK_TO_DEFAULT_TENANT, "true", xtw);
    //    }
    //    if (stringUtils.isNotEmpty(caseServiceTask.getCaseInstanceIdVariableName())) {
    //        writeQualifiedAttribute(ATTRIBUTE_ID_VARIABLE_NAME, caseServiceTask.getCaseInstanceIdVariableName(), xtw);
    //    }
    //}
    //
    //protected void writeSendEventServiceAdditionalAttributes(BaseElement element, BpmnModel model, XMLStreamWriter xtw)  {
    //    SendEventServiceTask sendEventServiceTask = (SendEventServiceTask) element;
    //    writeQualifiedAttribute(ATTRIBUTE_TYPE, ServiceTask.SEND_EVENT_TASK, xtw);
    //
    //    if (stringUtils.isNotEmpty(sendEventServiceTask.getSkipExpression())) {
    //        writeQualifiedAttribute(ATTRIBUTE_TASK_SERVICE_SKIP_EXPRESSION, sendEventServiceTask.getSkipExpression(), xtw);
    //    }
    //
    //    if (sendEventServiceTask.isTriggerable()) {
    //        writeQualifiedAttribute(ATTRIBUTE_TRIGGERABLE, "true", xtw);
    //    }
    //}
    //
    //protected void writeServiceTaskAdditionalAttributes(ServiceTask element, XMLStreamWriter xtw)  {
    //    ServiceTask serviceTask = element;
    //
    //    if (ImplementationType.IMPLEMENTATION_TYPE_CLASS.equals(serviceTask.getImplementationType())) {
    //        writeQualifiedAttribute(ATTRIBUTE_TASK_SERVICE_CLASS, serviceTask.getImplementation(), xtw);
    //    } else if (ImplementationType.IMPLEMENTATION_TYPE_EXPRESSION.equals(serviceTask.getImplementationType())) {
    //        writeQualifiedAttribute(ATTRIBUTE_TASK_SERVICE_EXPRESSION, serviceTask.getImplementation(), xtw);
    //    } else if (ImplementationType.IMPLEMENTATION_TYPE_DELEGATEEXPRESSION.equals(serviceTask.getImplementationType())) {
    //        writeQualifiedAttribute(ATTRIBUTE_TASK_SERVICE_DELEGATEEXPRESSION, serviceTask.getImplementation(), xtw);
    //    }
    //
    //    if (stringUtils.isNotEmpty(serviceTask.getResultVariableName())) {
    //        writeQualifiedAttribute(ATTRIBUTE_TASK_SERVICE_RESULTVARIABLE, serviceTask.getResultVariableName(), xtw);
    //    }
    //    if (stringUtils.isNotEmpty(serviceTask.getType())) {
    //        writeQualifiedAttribute(ATTRIBUTE_TYPE, serviceTask.getType(), xtw);
    //    }
    //    if (stringUtils.isNotEmpty(serviceTask.getExtensionId())) {
    //        writeQualifiedAttribute(ATTRIBUTE_TASK_SERVICE_EXTENSIONID, serviceTask.getExtensionId(), xtw);
    //    }
    //    if (stringUtils.isNotEmpty(serviceTask.getSkipExpression())) {
    //        writeQualifiedAttribute(ATTRIBUTE_TASK_SERVICE_SKIP_EXPRESSION, serviceTask.getSkipExpression(), xtw);
    //    }
    //    if (serviceTask.isTriggerable()) {
    //        writeQualifiedAttribute(ATTRIBUTE_ACTIVITY_TRIGGERABLE, "true", xtw);
    //    }
    //
    //    if (serviceTask.isUseLocalScopeForResultVariable()) {
    //        writeQualifiedAttribute(ATTRIBUTE_TASK_SERVICE_USE_LOCAL_SCOPE_FOR_RESULT_VARIABLE, "true", xtw);
    //    }
    //}
    //
    //override
    //protected bool writeExtensionChildElements(BaseElement element, bool didWriteExtensionStartElement, XMLStreamWriter xtw)  {
    //    if (element instanceof CaseServiceTask) {
    //        return writeCaseServiceTaskExtensionChildElements(element, didWriteExtensionStartElement, xtw);
    //
    //    } else if (element instanceof SendEventServiceTask) {
    //        return writeSendServiceExtensionChildElements(element, didWriteExtensionStartElement, xtw);
    //
    //    } else {
    //        return writeServiceTaskExtensionChildElements((ServiceTask) element, didWriteExtensionStartElement, xtw);
    //
    //    }
    //}
    //
    //protected  bool writeServiceTaskExtensionChildElements(ServiceTask element, bool didWriteExtensionStartElement, XMLStreamWriter xtw)  {
    //    ServiceTask serviceTask = element;
    //
    //    if (!serviceTask.getCustomProperties().isEmpty()) {
    //        writeCustomProperties(serviceTask, didWriteExtensionStartElement, xtw);
    //
    //    } else {
    //        if (serviceTask instanceof HttpServiceTask) {
    //            didWriteExtensionStartElement = writeHttpTaskExtensionElements((HttpServiceTask) serviceTask, didWriteExtensionStartElement, xtw);
    //        }
    //
    //        didWriteExtensionStartElement = FieldExtensionExport.writeFieldExtensions(serviceTask.getFieldExtensions(), didWriteExtensionStartElement, xtw);
    //        didWriteExtensionStartElement = MapExceptionExport.writeMapExceptionExtensions(serviceTask.getMapExceptions(), didWriteExtensionStartElement, xtw);
    //    }
    //
    //    return didWriteExtensionStartElement;
    //}
    //
    //protected bool writeSendServiceExtensionChildElements(BaseElement element, bool didWriteExtensionStartElement, XMLStreamWriter xtw)  {
    //    SendEventServiceTask sendEventServiceTask = (SendEventServiceTask) element;
    //    if (!didWriteExtensionStartElement) {
    //        xtw.writeStartElement(ELEMENT_EXTENSIONS);
    //        didWriteExtensionStartElement = true;
    //    }
    //
    //    xtw.writeStartElement(FLOWABLE_EXTENSIONS_PREFIX, ELEMENT_EVENT_TYPE, FLOWABLE_EXTENSIONS_NAMESPACE);
    //    if (stringUtils.isNotEmpty(sendEventServiceTask.getEventType())) {
    //        xtw.writeCData(sendEventServiceTask.getEventType());
    //    } else {
    //        LOGGER.warn("No event type configured for send event task {}", sendEventServiceTask.getId());
    //    }
    //    xtw.writeEndElement();
    //
    //    if (stringUtils.isNotEmpty(sendEventServiceTask.getTriggerEventType())) {
    //        xtw.writeStartElement(FLOWABLE_EXTENSIONS_PREFIX, ELEMENT_TRIGGER_EVENT_TYPE, FLOWABLE_EXTENSIONS_NAMESPACE);
    //        xtw.writeCData(sendEventServiceTask.getTriggerEventType());
    //        xtw.writeEndElement();
    //    }
    //
    //    if (sendEventServiceTask.isSendSynchronously()) {
    //        xtw.writeStartElement(FLOWABLE_EXTENSIONS_PREFIX, ELEMENT_SEND_SYNCHRONOUSLY, FLOWABLE_EXTENSIONS_NAMESPACE);
    //        xtw.writeCData(string.valueOf(sendEventServiceTask.isSendSynchronously()));
    //        xtw.writeEndElement();
    //    }
    //
    //    BpmnXMLUtil.writeIOParameters(ELEMENT_EVENT_IN_PARAMETER, sendEventServiceTask.getEventInParameters(), didWriteExtensionStartElement, xtw);
    //    BpmnXMLUtil.writeIOParameters(ELEMENT_EVENT_OUT_PARAMETER, sendEventServiceTask.getEventOutParameters(), didWriteExtensionStartElement, xtw);
    //
    //    return didWriteExtensionStartElement;
    //}
    //
    //protected bool writeCaseServiceTaskExtensionChildElements(BaseElement element, bool didWriteExtensionStartElement, XMLStreamWriter xtw)  {
    //    CaseServiceTask caseServiceTask = (CaseServiceTask) element;
    //    didWriteExtensionStartElement = BpmnXMLUtil.writeIOParameters(ELEMENT_IN_PARAMETERS, caseServiceTask.getInParameters(), didWriteExtensionStartElement, xtw);
    //    didWriteExtensionStartElement = BpmnXMLUtil.writeIOParameters(ELEMENT_OUT_PARAMETERS, caseServiceTask.getOutParameters(), didWriteExtensionStartElement, xtw);
    //    return didWriteExtensionStartElement;
    //}
    //
    //
    //override
    //protected void writeAdditionalChildElements(BaseElement element, BpmnModel model, XMLStreamWriter xtw)  {
    //}
    //
    //protected void convertCaseServiceTaskXMLProperties(CaseServiceTask caseServiceTask, BpmnModel bpmnModel, XMLStreamReader xtr)  {
    //    string caseDefinitionKey = BpmnXMLUtil.getAttributeValue(ATTRIBUTE_CASE_TASK_CASE_DEFINITION_KEY, xtr);
    //    if (stringUtils.isNotEmpty(caseDefinitionKey)) {
    //        caseServiceTask.setCaseDefinitionKey(caseDefinitionKey);
    //    }
    //
    //    string caseInstanceName = BpmnXMLUtil.getAttributeValue(ATTRIBUTE_CASE_TASK_CASE_INSTANCE_NAME, xtr);
    //    if (stringUtils.isNotEmpty(caseInstanceName)) {
    //        caseServiceTask.setCaseInstanceName(caseInstanceName);
    //    }
    //
    //    caseServiceTask.setBusinessKey(BpmnXMLUtil.getAttributeValue(ATTRIBUTE_BUSINESS_KEY, xtr));
    //    caseServiceTask.setInheritBusinessKey(Boolean.parseBoolean(BpmnXMLUtil.getAttributeValue(ATTRIBUTE_INHERIT_BUSINESS_KEY, xtr)));
    //    caseServiceTask.setSameDeployment(Boolean.valueOf(BpmnXMLUtil.getAttributeValue(ATTRIBUTE_SAME_DEPLOYMENT, xtr)));
    //    caseServiceTask.setFallbackToDefaultTenant(Boolean.valueOf(BpmnXMLUtil.getAttributeValue(ATTRIBUTE_FALLBACK_TO_DEFAULT_TENANT, xtr)));
    //    caseServiceTask.setCaseInstanceIdVariableName(BpmnXMLUtil.getAttributeValue(ATTRIBUTE_ID_VARIABLE_NAME, xtr));
    //    parseChildElements(getXMLElementName(), caseServiceTask, caseServiceChildParserMap, bpmnModel, xtr);
    //}
    //
    //protected void convertSendEventServiceTaskXMLProperties(SendEventServiceTask sendEventServiceTask, BpmnModel bpmnModel, XMLStreamReader xtr)  {
    //    string triggerable = BpmnXMLUtil.getAttributeValue(ATTRIBUTE_TRIGGERABLE, xtr);
    //    if ("true".equalsIgnoreCase(triggerable)) {
    //        sendEventServiceTask.setTriggerable(true);
    //    }
    //
    //    parseChildElements(getXMLElementName(), sendEventServiceTask, sendEventServiceChildParserMap, bpmnModel, xtr);
    //
    //    // event related properties are parsed and stored as extension elements (makes export work automatically)
    //
    //    if (sendEventServiceTask.getExtensionElements() !is null) {
    //
    //        List<ExtensionElement> eventTypeExtensionElements = sendEventServiceTask.getExtensionElements().get(BpmnXMLConstants.ELEMENT_EVENT_TYPE);
    //        if (eventTypeExtensionElements !is null && !eventTypeExtensionElements.isEmpty()) {
    //            string eventTypeValue = eventTypeExtensionElements.get(0).getElementText();
    //            if (stringUtils.isNotEmpty(eventTypeValue)) {
    //                sendEventServiceTask.setEventType(eventTypeValue);
    //            }
    //        }
    //
    //        List<ExtensionElement> triggerEventTypeExtensionElements = sendEventServiceTask.getExtensionElements().get(BpmnXMLConstants.ELEMENT_TRIGGER_EVENT_TYPE);
    //        if (triggerEventTypeExtensionElements !is null && !triggerEventTypeExtensionElements.isEmpty()) {
    //            string triggerEventType = triggerEventTypeExtensionElements.get(0).getElementText();
    //            if (stringUtils.isNotEmpty(triggerEventType)) {
    //                sendEventServiceTask.setTriggerEventType(triggerEventType);
    //            }
    //        }
    //
    //        List<ExtensionElement> sendSyncExtensionElements = sendEventServiceTask.getExtensionElements().get(BpmnXMLConstants.ELEMENT_SEND_SYNCHRONOUSLY);
    //        if (sendSyncExtensionElements !is null && !sendSyncExtensionElements.isEmpty()) {
    //            string sendSyncValue = sendSyncExtensionElements.get(0).getElementText();
    //            if (stringUtils.isNotEmpty(sendSyncValue) && "true".equalsIgnoreCase(sendSyncValue)) {
    //                sendEventServiceTask.setSendSynchronously(true);
    //            }
    //        }
    //
    //    }
    //}
    //
    //protected bool writeCustomProperties(ServiceTask serviceTask, bool didWriteExtensionStartElement, XMLStreamWriter xtw)  {
    //    for (CustomProperty customProperty : serviceTask.getCustomProperties()) {
    //
    //        if (stringUtils.isEmpty(customProperty.getSimpleValue())) {
    //            continue;
    //        }
    //
    //        if (!didWriteExtensionStartElement) {
    //            xtw.writeStartElement(ELEMENT_EXTENSIONS);
    //            didWriteExtensionStartElement = true;
    //        }
    //        xtw.writeStartElement(FLOWABLE_EXTENSIONS_PREFIX, ELEMENT_FIELD, FLOWABLE_EXTENSIONS_NAMESPACE);
    //        xtw.writeAttribute(ATTRIBUTE_FIELD_NAME, customProperty.getName());
    //        if ((customProperty.getSimpleValue().contains("${") || customProperty.getSimpleValue().contains("#{")) && customProperty.getSimpleValue().contains("}")) {
    //
    //            xtw.writeStartElement(FLOWABLE_EXTENSIONS_PREFIX, ATTRIBUTE_FIELD_EXPRESSION, FLOWABLE_EXTENSIONS_NAMESPACE);
    //        } else {
    //            xtw.writeStartElement(FLOWABLE_EXTENSIONS_PREFIX, ELEMENT_FIELD_string, FLOWABLE_EXTENSIONS_NAMESPACE);
    //        }
    //        xtw.writeCharacters(customProperty.getSimpleValue());
    //        xtw.writeEndElement();
    //        xtw.writeEndElement();
    //    }
    //
    //    return didWriteExtensionStartElement;
    //}
    //
    //protected bool writeHttpTaskExtensionElements(HttpServiceTask httpServiceTask, bool didWriteExtensionStartElement, XMLStreamWriter xtw)  {
    //    if (httpServiceTask.getHttpRequestHandler() !is null) {
    //        if (!didWriteExtensionStartElement) {
    //            xtw.writeStartElement(ELEMENT_EXTENSIONS);
    //            didWriteExtensionStartElement = true;
    //        }
    //
    //        xtw.writeStartElement(FLOWABLE_EXTENSIONS_PREFIX, ELEMENT_HTTP_REQUEST_HANDLER, FLOWABLE_EXTENSIONS_NAMESPACE);
    //        writeHttpHandlerAttributes(httpServiceTask.getHttpRequestHandler(), xtw);
    //        xtw.writeEndElement();
    //    }
    //
    //    if (httpServiceTask.getHttpResponseHandler() !is null) {
    //        if (!didWriteExtensionStartElement) {
    //            xtw.writeStartElement(ELEMENT_EXTENSIONS);
    //            didWriteExtensionStartElement = true;
    //        }
    //
    //        xtw.writeStartElement(FLOWABLE_EXTENSIONS_PREFIX, ELEMENT_HTTP_RESPONSE_HANDLER, FLOWABLE_EXTENSIONS_NAMESPACE);
    //        writeHttpHandlerAttributes(httpServiceTask.getHttpResponseHandler(), xtw);
    //        xtw.writeEndElement();
    //    }
    //
    //    return didWriteExtensionStartElement;
    //}

    protected string parseOperationRef(string operationRef, BpmnModel model) {
        string result = null;
        if (operationRef.length != 0) {
            int indexOfP = operationRef.indexOf(':');
            if (indexOfP != -1) {
                string prefix = operationRef[0 .. indexOfP];
                string resolvedNamespace = model.getNamespace(prefix);
                result = resolvedNamespace ~ ":" ~ operationRef[indexOfP + 1 .. $];
            } else {
                result = model.getTargetNamespace() ~ ":" ~ operationRef;
            }
        }
        return result;
    }

    //protected void writeHttpHandlerAttributes(AbstractFlowableHttpHandler httpHandler, XMLStreamWriter xtw)  {
    //    if (ImplementationType.IMPLEMENTATION_TYPE_CLASS.equals(httpHandler.getImplementationType())) {
    //        xtw.writeAttribute(ATTRIBUTE_TASK_SERVICE_CLASS, httpHandler.getImplementation());
    //    } else if (ImplementationType.IMPLEMENTATION_TYPE_DELEGATEEXPRESSION.equals(httpHandler.getImplementationType())) {
    //        xtw.writeAttribute(ATTRIBUTE_TASK_SERVICE_DELEGATEEXPRESSION, httpHandler.getImplementation());
    //    }
    //}
}
