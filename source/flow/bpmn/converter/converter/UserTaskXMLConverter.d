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
module flow.bpmn.converter.converter.UserTaskXMLConverter;

import hunt.collection.ArrayList;
import hunt.collection.HashMap;
import hunt.collection.HashSet;
import hunt.collection.List;
import hunt.collection.Map;
import hunt.collection.Set;

//import javax.xml.stream.XMLStreamReader;
//import javax.xml.stream.XMLStreamWriter;

import flow.bpmn.converter.converter.child.BaseChildElementParser;
import flow.bpmn.converter.converter.util.BpmnXMLUtil;
import flow.bpmn.converter.converter.util.CommaSplitter;
import flow.bpmn.model.BaseElement;
import flow.bpmn.model.BpmnModel;
import flow.bpmn.model.CustomProperty;
import flow.bpmn.model.ExtensionAttribute;
import flow.bpmn.model.Resource;
import flow.bpmn.model.UserTask;
import flow.bpmn.model.alfresco.AlfrescoUserTask;
import flow.bpmn.converter.constants.BpmnXMLConstants;
import flow.bpmn.converter.converter.BaseBpmnXMLConverter;
import hunt.xml;
import hunt.Exceptions;
import std.concurrency : initOnce;
import hunt.logging;
/**
 * @author Tijs Rademakers, Saeid Mirzaei
 */

class HumanPerformerParser : BaseChildElementParser {

  override
  public string getElementName() {
    return "humanPerformer";
  }

  override
  public void parseChildElement(Element xtr, BaseElement parentElement, BpmnModel model)  {
    implementationMissing(false);
    //string resourceElement = XMLStreamReaderUtil.moveDown(xtr);
    //if (stringUtils.isNotEmpty(resourceElement) && ELEMENT_RESOURCE_ASSIGNMENT.equals(resourceElement)) {
    //    string expression = XMLStreamReaderUtil.moveDown(xtr);
    //    if (stringUtils.isNotEmpty(expression) && ELEMENT_FORMAL_EXPRESSION.equals(expression)) {
    //        ((UserTask) parentElement).setAssignee(xtr.getElementText());
    //    }
    //}
  }
}

class PotentialOwnerParser : BaseChildElementParser {

  override
  public string getElementName() {
    return "potentialOwner";
  }

  override
  public void parseChildElement(Element xtr, BaseElement parentElement, BpmnModel model)  {
    //    string resourceElement = XMLStreamReaderUtil.moveDown(xtr);
    //    if (stringUtils.isNotEmpty(resourceElement) && ELEMENT_RESOURCE_ASSIGNMENT.equals(resourceElement)) {
    //        string expression = XMLStreamReaderUtil.moveDown(xtr);
    //        if (stringUtils.isNotEmpty(expression) && ELEMENT_FORMAL_EXPRESSION.equals(expression)) {
    //
    //            List<string> assignmentList = CommaSplitter.splitCommas(xtr.getElementText());
    //
    //            for (string assignmentValue : assignmentList) {
    //                if (assignmentValue is null) {
    //                    continue;
    //                }
    //
    //                assignmentValue = assignmentValue.trim();
    //
    //                if (assignmentValue.length() == 0) {
    //                    continue;
    //                }
    //
    //                string userPrefix = "user(";
    //                string groupPrefix = "group(";
    //                if (assignmentValue.startsWith(userPrefix)) {
    //                    assignmentValue = assignmentValue.substring(userPrefix.length(), assignmentValue.length() - 1).trim();
    //                    ((UserTask) parentElement).getCandidateUsers().add(assignmentValue);
    //                } else if (assignmentValue.startsWith(groupPrefix)) {
    //                    assignmentValue = assignmentValue.substring(groupPrefix.length(), assignmentValue.length() - 1).trim();
    //                    ((UserTask) parentElement).getCandidateGroups().add(assignmentValue);
    //                } else {
    //                    ((UserTask) parentElement).getCandidateGroups().add(assignmentValue);
    //                }
    //            }
    //        }
    //    } else if (stringUtils.isNotEmpty(resourceElement) && ELEMENT_RESOURCE_REF.equals(resourceElement)) {
    //        string resourceId = xtr.getElementText();
    //        if (model.containsResourceId(resourceId)) {
    //            Resource resource = model.getResource(resourceId);
    //            ((UserTask) parentElement).getCandidateGroups().add(resource.getName());
    //        } else {
    //            Resource resource = new Resource(resourceId, resourceId);
    //            model.addResource(resource);
    //            ((UserTask) parentElement).getCandidateGroups().add(resource.getName());
    //        }
    //    }
    //}
    implementationMissing( false);
  }
}

class CustomIdentityLinkParser : BaseChildElementParser {

  override
  public string getElementName() {
    return ELEMENT_CUSTOM_RESOURCE;
  }

  override
  public void parseChildElement(Element xtr, BaseElement parentElement, BpmnModel model)  {
    //    string identityLinkType = BpmnXMLUtil.getAttributeValue(ATTRIBUTE_NAME, xtr);
    //
    //    // the attribute value may be unqualified
    //    if (identityLinkType is null) {
    //        identityLinkType = xtr.getAttributeValue(null, ATTRIBUTE_NAME);
    //    }
    //
    //    if (identityLinkType is null)
    //        return;
    //
    //    string resourceElement = XMLStreamReaderUtil.moveDown(xtr);
    //    if (stringUtils.isNotEmpty(resourceElement) && ELEMENT_RESOURCE_ASSIGNMENT.equals(resourceElement)) {
    //        string expression = XMLStreamReaderUtil.moveDown(xtr);
    //        if (stringUtils.isNotEmpty(expression) && ELEMENT_FORMAL_EXPRESSION.equals(expression)) {
    //
    //            List<string> assignmentList = CommaSplitter.splitCommas(xtr.getElementText());
    //
    //            for (string assignmentValue : assignmentList) {
    //                if (assignmentValue is null) {
    //                    continue;
    //                }
    //
    //                assignmentValue = assignmentValue.trim();
    //
    //                if (assignmentValue.length() == 0) {
    //                    continue;
    //                }
    //
    //                string userPrefix = "user(";
    //                string groupPrefix = "group(";
    //                if (assignmentValue.startsWith(userPrefix)) {
    //                    assignmentValue = assignmentValue.substring(userPrefix.length(), assignmentValue.length() - 1).trim();
    //                    ((UserTask) parentElement).addCustomUserIdentityLink(assignmentValue, identityLinkType);
    //                } else if (assignmentValue.startsWith(groupPrefix)) {
    //                    assignmentValue = assignmentValue.substring(groupPrefix.length(), assignmentValue.length() - 1).trim();
    //                    ((UserTask) parentElement).addCustomGroupIdentityLink(assignmentValue, identityLinkType);
    //                } else {
    //                    ((UserTask) parentElement).addCustomGroupIdentityLink(assignmentValue, identityLinkType);
    //                }
    //            }
    //        }
    //    }
    //}
    implementationMissing( false);
  }
}


class UserTaskXMLConverter : BaseBpmnXMLConverter {

    protected Map!(string, BaseChildElementParser) childParserMap  ;//= new HashMap<>();

    //static Map!(string, BaseChildElementParser) childParserMap() {
    //  __gshared Map!(string, BaseChildElementParser) inst;
    //  return initOnce!inst(new HashMap!(string, BaseChildElementParser));
    //}

    static List!ExtensionAttribute defaultUserTaskAttributes() {
      __gshared List!ExtensionAttribute inst;
      return initOnce!inst(new ArrayList!ExtensionAttribute([new ExtensionAttribute(ATTRIBUTE_FORM_FORMKEY),
      new ExtensionAttribute(ATTRIBUTE_TASK_USER_DUEDATE),
      new ExtensionAttribute(ATTRIBUTE_TASK_USER_BUSINESS_CALENDAR_NAME),
      new ExtensionAttribute(ATTRIBUTE_TASK_USER_ASSIGNEE),
      new ExtensionAttribute(ATTRIBUTE_TASK_USER_OWNER),
      new ExtensionAttribute(ATTRIBUTE_TASK_USER_PRIORITY),
      new ExtensionAttribute(ATTRIBUTE_TASK_USER_CANDIDATEUSERS),
      new ExtensionAttribute(ATTRIBUTE_TASK_USER_CANDIDATEGROUPS),
      new ExtensionAttribute(ATTRIBUTE_TASK_USER_CATEGORY),
      new ExtensionAttribute(ATTRIBUTE_FORM_FIELD_VALIDATION),
      new ExtensionAttribute(ATTRIBUTE_TASK_SERVICE_EXTENSIONID),
      new ExtensionAttribute(ATTRIBUTE_TASK_USER_SKIP_EXPRESSION)
      ]));
    }

    /** default attributes taken from bpmn spec and from extension namespace */
    //protected static final List<ExtensionAttribute> defaultUserTaskAttributes = Arrays.asList(
    //        new ExtensionAttribute(ATTRIBUTE_FORM_FORMKEY),
    //        new ExtensionAttribute(ATTRIBUTE_TASK_USER_DUEDATE),
    //        new ExtensionAttribute(ATTRIBUTE_TASK_USER_BUSINESS_CALENDAR_NAME),
    //        new ExtensionAttribute(ATTRIBUTE_TASK_USER_ASSIGNEE),
    //        new ExtensionAttribute(ATTRIBUTE_TASK_USER_OWNER),
    //        new ExtensionAttribute(ATTRIBUTE_TASK_USER_PRIORITY),
    //        new ExtensionAttribute(ATTRIBUTE_TASK_USER_CANDIDATEUSERS),
    //        new ExtensionAttribute(ATTRIBUTE_TASK_USER_CANDIDATEGROUPS),
    //        new ExtensionAttribute(ATTRIBUTE_TASK_USER_CATEGORY),
    //        new ExtensionAttribute(ATTRIBUTE_FORM_FIELD_VALIDATION),
    //        new ExtensionAttribute(ATTRIBUTE_TASK_SERVICE_EXTENSIONID),
    //        new ExtensionAttribute(ATTRIBUTE_TASK_USER_SKIP_EXPRESSION));

    this() {
        childParserMap = new HashMap!(string, BaseChildElementParser);
        HumanPerformerParser humanPerformerParser = new HumanPerformerParser();
        childParserMap.put(humanPerformerParser.getElementName(), humanPerformerParser);
        PotentialOwnerParser potentialOwnerParser = new PotentialOwnerParser();
        childParserMap.put(potentialOwnerParser.getElementName(), potentialOwnerParser);
        //CustomIdentityLinkParser customIdentityLinkParser = new CustomIdentityLinkParser();
        childParserMap.put((new CustomIdentityLinkParser()).getElementName(), new CustomIdentityLinkParser());
    }

    override
    public TypeInfo getBpmnElementType() {
        return typeid(UserTask);
    }

    override
    protected string getXMLElementName() {
        return ELEMENT_TASK_USER;
    }

    override
    protected BaseElement convertXMLToElement(Element xtr, BpmnModel model)  {
        string formKey = BpmnXMLUtil.getAttributeValue(ATTRIBUTE_FORM_FORMKEY, xtr);

        UserTask userTask = null;
        if (formKey !is null && formKey.length != 0) {
            if (model.getUserTaskFormTypes() !is null && model.getUserTaskFormTypes().contains(formKey)) {
                userTask = new AlfrescoUserTask();
            }
        }
        if (userTask is null) {
            userTask = new UserTask();
        }
        BpmnXMLUtil.addXMLLocation(userTask, xtr);
        userTask.setDueDate(BpmnXMLUtil.getAttributeValue(ATTRIBUTE_TASK_USER_DUEDATE, xtr));
        userTask.setBusinessCalendarName(BpmnXMLUtil.getAttributeValue(ATTRIBUTE_TASK_USER_BUSINESS_CALENDAR_NAME, xtr));
        userTask.setCategory(BpmnXMLUtil.getAttributeValue(ATTRIBUTE_TASK_USER_CATEGORY, xtr));
        userTask.setFormKey(formKey);
        userTask.setValidateFormFields(BpmnXMLUtil.getAttributeValue(ATTRIBUTE_FORM_FIELD_VALIDATION, xtr));
        userTask.setAssignee(BpmnXMLUtil.getAttributeValue(ATTRIBUTE_TASK_USER_ASSIGNEE, xtr));
        userTask.setOwner(BpmnXMLUtil.getAttributeValue(ATTRIBUTE_TASK_USER_OWNER, xtr));
        userTask.setPriority(BpmnXMLUtil.getAttributeValue(ATTRIBUTE_TASK_USER_PRIORITY, xtr));

        if (BpmnXMLUtil.getAttributeValue(ATTRIBUTE_TASK_USER_CANDIDATEUSERS, xtr).length != 0) {
            string expression = BpmnXMLUtil.getAttributeValue(ATTRIBUTE_TASK_USER_CANDIDATEUSERS, xtr);
            userTask.getCandidateUsers().addAll(parseDelimitedList(expression));
        }

        if (BpmnXMLUtil.getAttributeValue(ATTRIBUTE_TASK_USER_CANDIDATEGROUPS, xtr).length != 0) {
            string expression = BpmnXMLUtil.getAttributeValue(ATTRIBUTE_TASK_USER_CANDIDATEGROUPS, xtr);
            logInfo("expression ^^^^^^^^^^^^^^^^^^^^^ %s",expression);
            userTask.getCandidateGroups().addAll(parseDelimitedList(expression));
        }

        userTask.setExtensionId(BpmnXMLUtil.getAttributeValue(ATTRIBUTE_TASK_SERVICE_EXTENSIONID, xtr));

        if (BpmnXMLUtil.getAttributeValue(ATTRIBUTE_TASK_USER_SKIP_EXPRESSION, xtr).length != 0 ) {
            string expression = BpmnXMLUtil.getAttributeValue(ATTRIBUTE_TASK_USER_SKIP_EXPRESSION, xtr);
            userTask.setSkipExpression(expression);
        }

        List!ExtensionAttribute all = new ArrayList!ExtensionAttribute;
        all.addAll(defaultElementAttributes);
        all.addAll(defaultActivityAttributes);
        all.addAll(defaultUserTaskAttributes);
        BpmnXMLUtil.addCustomAttributes(xtr, userTask, all);

        parseChildElements(getXMLElementName(), userTask, childParserMap, model, xtr);

        return userTask;
    }

    //override
    //protected void writeAdditionalAttributes(BaseElement element, BpmnModel model, XMLStreamWriter xtw)  {
    //    UserTask userTask = (UserTask) element;
    //    writeQualifiedAttribute(ATTRIBUTE_TASK_USER_ASSIGNEE, userTask.getAssignee(), xtw);
    //    writeQualifiedAttribute(ATTRIBUTE_TASK_USER_OWNER, userTask.getOwner(), xtw);
    //    writeQualifiedAttribute(ATTRIBUTE_TASK_USER_CANDIDATEUSERS, convertToDelimitedstring(userTask.getCandidateUsers()), xtw);
    //    writeQualifiedAttribute(ATTRIBUTE_TASK_USER_CANDIDATEGROUPS, convertToDelimitedstring(userTask.getCandidateGroups()), xtw);
    //    writeQualifiedAttribute(ATTRIBUTE_TASK_USER_DUEDATE, userTask.getDueDate(), xtw);
    //    writeQualifiedAttribute(ATTRIBUTE_TASK_USER_BUSINESS_CALENDAR_NAME, userTask.getBusinessCalendarName(), xtw);
    //    writeQualifiedAttribute(ATTRIBUTE_TASK_USER_CATEGORY, userTask.getCategory(), xtw);
    //    writeQualifiedAttribute(ATTRIBUTE_FORM_FORMKEY, userTask.getFormKey(), xtw);
    //    writeQualifiedAttribute(ATTRIBUTE_FORM_FIELD_VALIDATION, userTask.getValidateFormFields(), xtw);
    //    if (userTask.getPriority() !is null) {
    //        writeQualifiedAttribute(ATTRIBUTE_TASK_USER_PRIORITY, userTask.getPriority(), xtw);
    //    }
    //    if (stringUtils.isNotEmpty(userTask.getExtensionId())) {
    //        writeQualifiedAttribute(ATTRIBUTE_TASK_SERVICE_EXTENSIONID, userTask.getExtensionId(), xtw);
    //    }
    //    if (userTask.getSkipExpression() !is null) {
    //        writeQualifiedAttribute(ATTRIBUTE_TASK_USER_SKIP_EXPRESSION, userTask.getSkipExpression(), xtw);
    //    }
    //    // write custom attributes
    //    BpmnXMLUtil.writeCustomAttributes(userTask.getAttributes().values(), xtw, defaultElementAttributes,
    //            defaultActivityAttributes, defaultUserTaskAttributes);
    //}
    //
    //override
    //protected bool writeExtensionChildElements(BaseElement element, bool didWriteExtensionStartElement, XMLStreamWriter xtw)  {
    //    UserTask userTask = (UserTask) element;
    //    didWriteExtensionStartElement = writeFormProperties(userTask, didWriteExtensionStartElement, xtw);
    //    didWriteExtensionStartElement = writeCustomIdentities(element, didWriteExtensionStartElement, xtw);
    //    if (!userTask.getCustomProperties().isEmpty()) {
    //        for (CustomProperty customProperty : userTask.getCustomProperties()) {
    //
    //            if (stringUtils.isEmpty(customProperty.getSimpleValue())) {
    //                continue;
    //            }
    //
    //            if (!didWriteExtensionStartElement) {
    //                xtw.writeStartElement(ELEMENT_EXTENSIONS);
    //                didWriteExtensionStartElement = true;
    //            }
    //            xtw.writeStartElement(FLOWABLE_EXTENSIONS_PREFIX, customProperty.getName(), FLOWABLE_EXTENSIONS_NAMESPACE);
    //            xtw.writeCharacters(customProperty.getSimpleValue());
    //            xtw.writeEndElement();
    //        }
    //    }
    //    return didWriteExtensionStartElement;
    //}
    //
    //protected bool writeCustomIdentities(BaseElement element, bool didWriteExtensionStartElement, XMLStreamWriter xtw)  {
    //    UserTask userTask = (UserTask) element;
    //    if (userTask.getCustomUserIdentityLinks().isEmpty() && userTask.getCustomGroupIdentityLinks().isEmpty()) {
    //        return didWriteExtensionStartElement;
    //    }
    //
    //    if (!didWriteExtensionStartElement) {
    //        xtw.writeStartElement(ELEMENT_EXTENSIONS);
    //        didWriteExtensionStartElement = true;
    //    }
    //    Set<string> identityLinkTypes = new HashSet<>();
    //    identityLinkTypes.addAll(userTask.getCustomUserIdentityLinks().keySet());
    //    identityLinkTypes.addAll(userTask.getCustomGroupIdentityLinks().keySet());
    //    for (string identityType : identityLinkTypes) {
    //        writeCustomIdentities(userTask, identityType, userTask.getCustomUserIdentityLinks().get(identityType), userTask.getCustomGroupIdentityLinks().get(identityType), xtw);
    //    }
    //
    //    return didWriteExtensionStartElement;
    //}
    //
    //protected void writeCustomIdentities(UserTask userTask, string identityType, Set<string> users, Set<string> groups, XMLStreamWriter xtw)  {
    //    xtw.writeStartElement(FLOWABLE_EXTENSIONS_PREFIX, ELEMENT_CUSTOM_RESOURCE, FLOWABLE_EXTENSIONS_NAMESPACE);
    //    writeDefaultAttribute(ATTRIBUTE_NAME, identityType, xtw);
    //
    //    List<string> identityList = new ArrayList<>();
    //
    //    if (users !is null) {
    //        for (string userId : users) {
    //            identityList.add("user(" + userId + ")");
    //        }
    //    }
    //
    //    if (groups !is null) {
    //        for (string groupId : groups) {
    //            identityList.add("group(" + groupId + ")");
    //        }
    //    }
    //
    //    string delimitedstring = convertToDelimitedstring(identityList);
    //
    //    xtw.writeStartElement(ELEMENT_RESOURCE_ASSIGNMENT);
    //    xtw.writeStartElement(ELEMENT_FORMAL_EXPRESSION);
    //    xtw.writeCharacters(delimitedstring);
    //    xtw.writeEndElement(); // End ELEMENT_FORMAL_EXPRESSION
    //    xtw.writeEndElement(); // End ELEMENT_RESOURCE_ASSIGNMENT
    //
    //    xtw.writeEndElement(); // End ELEMENT_CUSTOM_RESOURCE
    //}
    //
    //override
    //protected void writeAdditionalChildElements(BaseElement element, BpmnModel model, XMLStreamWriter xtw)  {
    //}


}


