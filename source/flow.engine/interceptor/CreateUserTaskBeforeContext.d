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


import hunt.collection.List;

import flow.bpmn.model.UserTask;
import flow.engine.deleg.DelegateExecution;


class CreateUserTaskBeforeContext {

    protected UserTask userTask;
    protected DelegateExecution execution;
    protected string name;
    protected string description;
    protected string dueDate;
    protected string priority;
    protected string category;
    protected string formKey;
    protected string skipExpression;
    protected string assignee;
    protected string owner;
    protected List!string candidateUsers;
    protected List!string candidateGroups;

    public CreateUserTaskBeforeContext() {

    }

    public CreateUserTaskBeforeContext(UserTask userTask, DelegateExecution execution, string name, string description, string dueDate,
                    string priority, string category, string formKey, string skipExpression, string assignee, string owner,
                    List!string candidateUsers, List!string candidateGroups) {

        this.userTask = userTask;
        this.execution = execution;
        this.name = name;
        this.description = description;
        this.dueDate = dueDate;
        this.priority = priority;
        this.category = category;
        this.formKey = formKey;
        this.skipExpression = skipExpression;
        this.assignee = assignee;
        this.owner = owner;
        this.candidateUsers = candidateUsers;
        this.candidateGroups = candidateGroups;
    }

    public UserTask getUserTask() {
        return userTask;
    }

    public void setUserTask(UserTask userTask) {
        this.userTask = userTask;
    }

    public DelegateExecution getExecution() {
        return execution;
    }

    public void setExecution(DelegateExecution execution) {
        this.execution = execution;
    }

    public string getName() {
        return name;
    }

    public void setName(string name) {
        this.name = name;
    }

    public string getDescription() {
        return description;
    }

    public void setDescription(string description) {
        this.description = description;
    }

    public string getDueDate() {
        return dueDate;
    }

    public void setDueDate(string dueDate) {
        this.dueDate = dueDate;
    }

    public string getPriority() {
        return priority;
    }

    public void setPriority(string priority) {
        this.priority = priority;
    }

    public string getCategory() {
        return category;
    }

    public void setCategory(string category) {
        this.category = category;
    }

    public string getFormKey() {
        return formKey;
    }

    public void setFormKey(string formKey) {
        this.formKey = formKey;
    }

    public string getSkipExpression() {
        return skipExpression;
    }

    public void setSkipExpression(string skipExpression) {
        this.skipExpression = skipExpression;
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
}
