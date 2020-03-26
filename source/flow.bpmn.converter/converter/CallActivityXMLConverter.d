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
module flow.bpmn.converter.converter.CallActivityXMLConverter;

import hunt.collection.HashMap;
import hunt.collection.Map;

import flow.bpmn.converter.constants.BpmnXMLConstants;
import flow.bpmn.converter.converter.child.BaseChildElementParser;
import flow.bpmn.converter.converter.child.InParameterParser;
import flow.bpmn.converter.converter.child.OutParameterParser;
import flow.bpmn.converter.converter.util.BpmnXMLUtil;
import flow.bpmn.model.BaseElement;
import flow.bpmn.model.BpmnModel;
import flow.bpmn.model.CallActivity;
import flow.bpmn.converter.constants.BpmnXMLConstants;
import flow.bpmn.converter.converter.BaseBpmnXMLConverter;
import hunt.xml;
import hunt.Boolean;
/**
 * @author Tijs Rademakers
 */
class CallActivityXMLConverter : BaseBpmnXMLConverter {

    protected Map!(string, BaseChildElementParser) childParserMap ;// = new HashMap<>();

    this() {
        childParserMap = new HashMap!(string, BaseChildElementParser);
        InParameterParser inParameterParser = new InParameterParser();
        childParserMap.put(inParameterParser.getElementName(), inParameterParser);
        OutParameterParser outParameterParser = new OutParameterParser();
        childParserMap.put(outParameterParser.getElementName(), outParameterParser);
    }

    override
    public TypeInfo getBpmnElementType() {
        return typeid(CallActivity);
    }

    override
    protected string getXMLElementName() {
        return ELEMENT_CALL_ACTIVITY;
    }

    override
    protected BaseElement convertXMLToElement(Element xtr, BpmnModel model)  {
        CallActivity callActivity = new CallActivity();
        BpmnXMLUtil.addXMLLocation(callActivity, xtr);
        callActivity.setCalledElement(xtr.firstAttribute(ATTRIBUTE_CALL_ACTIVITY_CALLEDELEMENT) is null ? "" : xtr.firstAttribute(ATTRIBUTE_CALL_ACTIVITY_CALLEDELEMENT).getValue);
        callActivity.setCalledElementType(BpmnXMLUtil.getAttributeValue(BpmnXMLConstants.ATTRIBUTE_CALL_ACTIVITY_CALLEDELEMENTTYPE, xtr));
        callActivity.setProcessInstanceName(BpmnXMLUtil.getAttributeValue(ATTRIBUTE_CALL_ACTIVITY_PROCESS_INSTANCE_NAME, xtr));
        callActivity.setBusinessKey(BpmnXMLUtil.getAttributeValue(ATTRIBUTE_BUSINESS_KEY, xtr));
        callActivity.setInheritBusinessKey(Boolean.parseBoolean(BpmnXMLUtil.getAttributeValue(ATTRIBUTE_INHERIT_BUSINESS_KEY, xtr)).booleanValue());
        callActivity.setInheritVariables(Boolean.valueOf(BpmnXMLUtil.getAttributeValue(ATTRIBUTE_CALL_ACTIVITY_INHERITVARIABLES, xtr)).booleanValue());
        callActivity.setSameDeployment(Boolean.valueOf(BpmnXMLUtil.getAttributeValue(ATTRIBUTE_SAME_DEPLOYMENT, xtr)).booleanValue());
        callActivity.setUseLocalScopeForOutParameters(Boolean.valueOf(BpmnXMLUtil.getAttributeValue(ATTRIBUTE_CALL_ACTIVITY_USE_LOCALSCOPE_FOR_OUTPARAMETERS, xtr)).booleanValue());
        callActivity.setCompleteAsync(Boolean.valueOf(BpmnXMLUtil.getAttributeValue(ATTRIBUTE_CALL_ACTIVITY_COMPLETE_ASYNC, xtr)).booleanValue());

        string fallbackToDefaultTenant = BpmnXMLUtil.getAttributeValue(ATTRIBUTE_FALLBACK_TO_DEFAULT_TENANT, xtr);
        if (fallbackToDefaultTenant.length != 0) {
            callActivity.setFallbackToDefaultTenant(Boolean.valueOf(fallbackToDefaultTenant).booleanValue());
        }

        string idVariableName = BpmnXMLUtil.getAttributeValue(BpmnXMLConstants.ATTRIBUTE_ID_VARIABLE_NAME, xtr);
        if (idVariableName.length != 0) {
            callActivity.setProcessInstanceIdVariableName(idVariableName);
        }

        parseChildElements(getXMLElementName(), callActivity, childParserMap, model, xtr);
        return callActivity;
    }

    //override
    //protected void writeAdditionalAttributes(BaseElement element, BpmnModel model, XMLStreamWriter xtw)  {
    //    CallActivity callActivity = (CallActivity) element;
    //    if (stringUtils.isNotEmpty(callActivity.getCalledElement())) {
    //        xtw.writeAttribute(ATTRIBUTE_CALL_ACTIVITY_CALLEDELEMENT, callActivity.getCalledElement());
    //    }
    //    if (stringUtils.isNotEmpty(callActivity.getCalledElementType())) {
    //        writeQualifiedAttribute(ATTRIBUTE_CALL_ACTIVITY_CALLEDELEMENTTYPE, callActivity.getCalledElementType(), xtw);
    //    }
    //    if (stringUtils.isNotEmpty(callActivity.getProcessInstanceName())) {
    //        writeQualifiedAttribute(ATTRIBUTE_CALL_ACTIVITY_PROCESS_INSTANCE_NAME, callActivity.getProcessInstanceName(), xtw);
    //    }
    //    if (stringUtils.isNotEmpty(callActivity.getBusinessKey())) {
    //        writeQualifiedAttribute(ATTRIBUTE_BUSINESS_KEY, callActivity.getBusinessKey(), xtw);
    //    }
    //    if (callActivity.isInheritBusinessKey()) {
    //        writeQualifiedAttribute(ATTRIBUTE_INHERIT_BUSINESS_KEY, "true", xtw);
    //    }
    //    if (callActivity.isUseLocalScopeForOutParameters()) {
    //        writeQualifiedAttribute(ATTRIBUTE_CALL_ACTIVITY_USE_LOCALSCOPE_FOR_OUTPARAMETERS, "true", xtw);
    //    }
    //    if (callActivity.isInheritVariables()) {
    //        writeQualifiedAttribute(ATTRIBUTE_CALL_ACTIVITY_INHERITVARIABLES, "true", xtw);
    //    }
    //    if (callActivity.isSameDeployment()) {
    //        writeQualifiedAttribute(ATTRIBUTE_SAME_DEPLOYMENT, "true", xtw);
    //    }
    //    if (callActivity.isCompleteAsync()) {
    //        writeQualifiedAttribute(ATTRIBUTE_CALL_ACTIVITY_COMPLETE_ASYNC, "true", xtw);
    //    }
    //    if (callActivity.getFallbackToDefaultTenant() !is null) {
    //        writeQualifiedAttribute(ATTRIBUTE_FALLBACK_TO_DEFAULT_TENANT, callActivity.getFallbackToDefaultTenant().tostring(), xtw);
    //    }
    //    if (callActivity.getProcessInstanceIdVariableName() !is null) {
    //        writeQualifiedAttribute(ATTRIBUTE_ID_VARIABLE_NAME, callActivity.getProcessInstanceIdVariableName(), xtw);
    //    }
    //}
    //
    //override
    //protected bool writeExtensionChildElements(BaseElement element, bool didWriteExtensionStartElement, XMLStreamWriter xtw)  {
    //    CallActivity callActivity = (CallActivity) element;
    //    didWriteExtensionStartElement = BpmnXMLUtil.writeIOParameters(ELEMENT_IN_PARAMETERS,
    //            callActivity.getInParameters(), didWriteExtensionStartElement, xtw);
    //    didWriteExtensionStartElement = BpmnXMLUtil.writeIOParameters(ELEMENT_OUT_PARAMETERS,
    //            callActivity.getOutParameters(), didWriteExtensionStartElement, xtw);
    //    return didWriteExtensionStartElement;
    //}
    //
    //override
    //protected void writeAdditionalChildElements(BaseElement element, BpmnModel model, XMLStreamWriter xtw)  {
    //}
}
