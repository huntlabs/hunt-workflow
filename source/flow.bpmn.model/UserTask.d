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


import java.util.ArrayList;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;

/**
 * @author Tijs Rademakers
 */
class UserTask extends Task {

    protected string assignee;
    protected string owner;
    protected string priority;
    protected string formKey;
    protected string dueDate;
    protected string businessCalendarName;
    protected string category;
    protected string extensionId;
    protected List<string> candidateUsers = new ArrayList<>();
    protected List<string> candidateGroups = new ArrayList<>();
    protected List<FormProperty> formProperties = new ArrayList<>();
    protected List<FlowableListener> taskListeners = new ArrayList<>();
    protected string skipExpression;
    protected string validateFormFields;

    protected Map<string, Set<string>> customUserIdentityLinks = new HashMap<>();
    protected Map<string, Set<string>> customGroupIdentityLinks = new HashMap<>();

    protected List<CustomProperty> customProperties = new ArrayList<>();

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
        return extensionId !is null && !extensionId.isEmpty();
    }

    public List<string> getCandidateUsers() {
        return candidateUsers;
    }

    public void setCandidateUsers(List<string> candidateUsers) {
        this.candidateUsers = candidateUsers;
    }

    public List<string> getCandidateGroups() {
        return candidateGroups;
    }

    public void setCandidateGroups(List<string> candidateGroups) {
        this.candidateGroups = candidateGroups;
    }

    public List<FormProperty> getFormProperties() {
        return formProperties;
    }

    public void setFormProperties(List<FormProperty> formProperties) {
        this.formProperties = formProperties;
    }

    public List<FlowableListener> getTaskListeners() {
        return taskListeners;
    }

    public void setTaskListeners(List<FlowableListener> taskListeners) {
        this.taskListeners = taskListeners;
    }

    public void addCustomUserIdentityLink(string userId, string type) {
        Set<string> userIdentitySet = customUserIdentityLinks.get(type);

        if (userIdentitySet is null) {
            userIdentitySet = new HashSet<>();
            customUserIdentityLinks.put(type, userIdentitySet);
        }

        userIdentitySet.add(userId);
    }

    public void addCustomGroupIdentityLink(string groupId, string type) {
        Set<string> groupIdentitySet = customGroupIdentityLinks.get(type);

        if (groupIdentitySet is null) {
            groupIdentitySet = new HashSet<>();
            customGroupIdentityLinks.put(type, groupIdentitySet);
        }

        groupIdentitySet.add(groupId);
    }

    public Map<string, Set<string>> getCustomUserIdentityLinks() {
        return customUserIdentityLinks;
    }

    public void setCustomUserIdentityLinks(Map<string, Set<string>> customUserIdentityLinks) {
        this.customUserIdentityLinks = customUserIdentityLinks;
    }

    public Map<string, Set<string>> getCustomGroupIdentityLinks() {
        return customGroupIdentityLinks;
    }

    public void setCustomGroupIdentityLinks(Map<string, Set<string>> customGroupIdentityLinks) {
        this.customGroupIdentityLinks = customGroupIdentityLinks;
    }

    public List<CustomProperty> getCustomProperties() {
        return customProperties;
    }

    public void setCustomProperties(List<CustomProperty> customProperties) {
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

    @Override
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

        setCandidateGroups(new ArrayList<>(otherElement.getCandidateGroups()));
        setCandidateUsers(new ArrayList<>(otherElement.getCandidateUsers()));

        setCustomGroupIdentityLinks(otherElement.customGroupIdentityLinks);
        setCustomUserIdentityLinks(otherElement.customUserIdentityLinks);

        formProperties = new ArrayList<>();
        if (otherElement.getFormProperties() !is null && !otherElement.getFormProperties().isEmpty()) {
            for (FormProperty property : otherElement.getFormProperties()) {
                formProperties.add(property.clone());
            }
        }

        taskListeners = new ArrayList<>();
        if (otherElement.getTaskListeners() !is null && !otherElement.getTaskListeners().isEmpty()) {
            for (FlowableListener listener : otherElement.getTaskListeners()) {
                taskListeners.add(listener.clone());
            }
        }
    }
}
