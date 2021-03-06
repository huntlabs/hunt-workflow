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
module flow.bpmn.converter.converter.BusinessRuleTaskXMLConverter;

import flow.bpmn.converter.converter.util.BpmnXMLUtil;
import flow.bpmn.model.BaseElement;
import flow.bpmn.model.BpmnModel;
import flow.bpmn.model.BusinessRuleTask;
import flow.bpmn.converter.constants.BpmnXMLConstants;
import flow.bpmn.converter.converter.BaseBpmnXMLConverter;
import hunt.xml;
import std.uni;
/**
 * @author Tijs Rademakers
 */
class BusinessRuleTaskXMLConverter : BaseBpmnXMLConverter {

    override
    public TypeInfo getBpmnElementType() {
        return typeid(BusinessRuleTask);
    }

    override
    protected string getXMLElementName() {
        return ELEMENT_TASK_BUSINESSRULE;
    }

    override
    protected BaseElement convertXMLToElement(Element xtr, BpmnModel model)  {
        BusinessRuleTask businessRuleTask = new BusinessRuleTask();
        BpmnXMLUtil.addXMLLocation(businessRuleTask, xtr);
        businessRuleTask.setInputVariables(parseDelimitedList(BpmnXMLUtil.getAttributeValue(ATTRIBUTE_TASK_RULE_VARIABLES_INPUT, xtr)));
        businessRuleTask.setRuleNames(parseDelimitedList(BpmnXMLUtil.getAttributeValue(ATTRIBUTE_TASK_RULE_RULES, xtr)));
        businessRuleTask.setResultVariableName(BpmnXMLUtil.getAttributeValue(ATTRIBUTE_TASK_RULE_RESULT_VARIABLE, xtr));
        businessRuleTask.setClassName(BpmnXMLUtil.getAttributeValue(ATTRIBUTE_TASK_RULE_CLASS, xtr));
        string exclude = BpmnXMLUtil.getAttributeValue(ATTRIBUTE_TASK_RULE_EXCLUDE, xtr);
        if (icmp(ATTRIBUTE_VALUE_TRUE,exclude) == 0) {
            businessRuleTask.setExclude(true);
        }
        parseChildElements(getXMLElementName(), businessRuleTask, model, xtr);
        return businessRuleTask;
    }

    //override
    //protected void writeAdditionalAttributes(BaseElement element, BpmnModel model, XMLStreamWriter xtw)  {
    //    BusinessRuleTask businessRuleTask = (BusinessRuleTask) element;
    //    String inputVariables = convertToDelimitedString(businessRuleTask.getInputVariables());
    //    if (StringUtils.isNotEmpty(inputVariables)) {
    //        writeQualifiedAttribute(ATTRIBUTE_TASK_RULE_VARIABLES_INPUT, inputVariables, xtw);
    //    }
    //    String ruleNames = convertToDelimitedString(businessRuleTask.getRuleNames());
    //    if (StringUtils.isNotEmpty(ruleNames)) {
    //        writeQualifiedAttribute(ATTRIBUTE_TASK_RULE_RULES, ruleNames, xtw);
    //    }
    //    if (StringUtils.isNotEmpty(businessRuleTask.getResultVariableName())) {
    //        writeQualifiedAttribute(ATTRIBUTE_TASK_RULE_RESULT_VARIABLE, businessRuleTask.getResultVariableName(), xtw);
    //    }
    //    if (StringUtils.isNotEmpty(businessRuleTask.getClassName())) {
    //        writeQualifiedAttribute(ATTRIBUTE_TASK_RULE_CLASS, businessRuleTask.getClassName(), xtw);
    //    }
    //    if (businessRuleTask.isExclude()) {
    //        writeQualifiedAttribute(ATTRIBUTE_TASK_RULE_EXCLUDE, ATTRIBUTE_VALUE_TRUE, xtw);
    //    }
    //}
    //
    //override
    //protected void writeAdditionalChildElements(BaseElement element, BpmnModel model, XMLStreamWriter xtw)  {
    //}
}
