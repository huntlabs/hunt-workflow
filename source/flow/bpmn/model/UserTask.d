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

module flow.bpmn.model.UserTask;

import hunt.collection.ArrayList;
import hunt.collection.HashMap;
import hunt.collection.HashSet;
import hunt.collection.List;
import hunt.collection.Map;
import hunt.collection.Set;
import flow.bpmn.model.FormProperty;
import flow.bpmn.model.FlowableListener;
import flow.bpmn.model.CustomProperty;
import flow.bpmn.model.Task;
import flow.bpmn.model.BaseElement;
import flow.bpmn.model.FlowElement;
import flow.bpmn.model.FlowNode;
import flow.bpmn.model.Activity;
/**
 * @author Tijs Rademakers
 */
class UserTask : Task {

    alias setValues = BaseElement.setValues;
    alias setValues = FlowElement.setValues;
    alias setValues = FlowNode.setValues;
    alias setValues = Activity.setValues;
    protected string assignee;
    protected string owner;
    protected string priority;
    protected string formKey;
    protected string dueDate;
    protected string businessCalendarName;
    protected string category;
    protected string extensionId;
    protected List!string candidateUsers ;//= new ArrayList!string();
    protected List!string candidateGroups ;//= new ArrayList!string();
    protected List!FormProperty formProperties ;//= new ArrayList!string();
    protected List!FlowableListener taskListeners ;//= new ArrayList!string();
    protected string skipExpression;
    protected string validateFormFields;

    protected Map!(string, Set!string) customUserIdentityLinks ;//= new HashMap!(string, Set!string)();
    protected Map!(string, Set!string) customGroupIdentityLinks ;//= new HashMap!(string, Set!string)();

    protected List!CustomProperty customProperties ;//= new ArrayList!customProperties();

    this()
    {
      candidateUsers = new ArrayList!string();
      candidateGroups = new ArrayList!string();
      formProperties = new ArrayList!FormProperty();
      taskListeners = new ArrayList!FlowableListener();
      customUserIdentityLinks = new HashMap!(string, Set!string)();
      customGroupIdentityLinks = new HashMap!(string, Set!string)();
      customProperties = new ArrayList!CustomProperty();
    }

    override
    string getClassType()
    {
        return "userTask";
    }

    public string getAssignee() {
        return assignee;
    }

    public void setAssignee(string assignee) {
        this.assignee = assignee;
    }

    public string getOwner() {
        return owner;
    }

    public void setOwner(string owner) {
        this.owner = owner;
    }

    public string getPriority() {
        return priority;
    }

    public void setPriority(string priority) {
        this.priority = priority;
    }

    public string getFormKey() {
        return formKey;
    }

    public void setFormKey(string formKey) {
        this.formKey = formKey;
    }

    public string getDueDate() {
        return dueDate;
    }

    public void setDueDate(string dueDate) {
        this.dueDate = dueDate;
    }

    public string getBusinessCalendarName() {
        return businessCalendarName;
    }

    public void setBusinessCalendarName(string businessCalendarName) {
        this.businessCalendarName = businessCalendarName;
    }

    public string getCategory() {
        return category;
    }

    public void setCategory(string category) {
        this.category = category;
    }

    public string getExtensionId() {
        return extensionId;
    }

    public void setExtensionId(string extensionId) {
        this.extensionId = extensionId;
    }

    public bool isExtended() {
        return extensionId !is null && extensionId.length != 0;
    }

    public List!string getCandidateUsers() {
        return candidateUsers;
    }

    public void setCandidateUsers(List!string candidateUsers) {
        this.candidateUsers = candidateUsers;
    }

    public List!string getCandidateGroups() {
        return candidateGroups;
    }

    public void setCandidateGroups(List!string candidateGroups) {
        this.candidateGroups = candidateGroups;
    }

    public List!FormProperty getFormProperties() {
        return formProperties;
    }

    public void setFormProperties(List!FormProperty formProperties) {
        this.formProperties = formProperties;
    }

    public List!FlowableListener getTaskListeners() {
        return taskListeners;
    }

    public void setTaskListeners(List!FlowableListener taskListeners) {
        this.taskListeners = taskListeners;
    }

    public void addCustomUserIdentityLink(string userId, string type) {
        Set!string userIdentitySet = customUserIdentityLinks.get(type);

        if (userIdentitySet is null) {
            userIdentitySet = new HashSet!string();
            customUserIdentityLinks.put(type, userIdentitySet);
        }

        userIdentitySet.add(userId);
    }

    public void addCustomGroupIdentityLink(string groupId, string type) {
        Set!string groupIdentitySet = customGroupIdentityLinks.get(type);

        if (groupIdentitySet is null) {
            groupIdentitySet = new HashSet!string();
            customGroupIdentityLinks.put(type, groupIdentitySet);
        }

        groupIdentitySet.add(groupId);
    }

    public Map!(string, Set!string) getCustomUserIdentityLinks() {
        return customUserIdentityLinks;
    }

    public void setCustomUserIdentityLinks(Map!(string, Set!string) customUserIdentityLinks) {
        this.customUserIdentityLinks = customUserIdentityLinks;
    }

    public Map!(string, Set!string) getCustomGroupIdentityLinks() {
        return customGroupIdentityLinks;
    }

    public void setCustomGroupIdentityLinks(Map!(string, Set!string) customGroupIdentityLinks) {
        this.customGroupIdentityLinks = customGroupIdentityLinks;
    }

    public List!CustomProperty getCustomProperties() {
        return customProperties;
    }

    public void setCustomProperties(List!CustomProperty customProperties) {
        this.customProperties = customProperties;
    }

    public string getSkipExpression() {
        return skipExpression;
    }

    public void setSkipExpression(string skipExpression) {
        this.skipExpression = skipExpression;
    }

    public string getValidateFormFields() {
        return validateFormFields;
    }

    public void setValidateFormFields(string validateFormFields) {
        this.validateFormFields = validateFormFields;
    }

    override
    public UserTask clone() {
        UserTask clone = new UserTask();
        clone.setValues(this);
        return clone;
    }

    public void setValues(UserTask otherElement) {
        super.setValues(otherElement);
        setAssignee(otherElement.getAssignee());
        setOwner(otherElement.getOwner());
        setFormKey(otherElement.getFormKey());
        setDueDate(otherElement.getDueDate());
        setPriority(otherElement.getPriority());
        setCategory(otherElement.getCategory());
        setExtensionId(otherElement.getExtensionId());
        setSkipExpression(otherElement.getSkipExpression());
        setValidateFormFields(otherElement.getValidateFormFields());

        setCandidateGroups(new ArrayList!string(otherElement.getCandidateGroups()));
        setCandidateUsers(new ArrayList!string(otherElement.getCandidateUsers()));

        setCustomGroupIdentityLinks(otherElement.customGroupIdentityLinks);
        setCustomUserIdentityLinks(otherElement.customUserIdentityLinks);

        formProperties = new ArrayList!FormProperty();
        if (otherElement.getFormProperties() !is null && !otherElement.getFormProperties().isEmpty()) {
            foreach (FormProperty property ; otherElement.getFormProperties()) {
                formProperties.add(property.clone());
            }
        }

        taskListeners = new ArrayList!FlowableListener();
        if (otherElement.getTaskListeners() !is null && !otherElement.getTaskListeners().isEmpty()) {
            foreach (FlowableListener listener ; otherElement.getTaskListeners()) {
                taskListeners.add(listener.clone());
            }
        }
    }
}
