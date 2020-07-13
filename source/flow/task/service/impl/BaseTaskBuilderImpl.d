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
module flow.task.service.impl.BaseTaskBuilderImpl;

import flow.common.interceptor.CommandExecutor;
import flow.identitylink.api.IdentityLinkInfo;
import flow.task.api.Task;
import flow.task.api.TaskBuilder;

import hunt.collection;
import hunt.time.LocalDateTime;
import hunt.collection.Set;

/**
 * Base implementation of the {@link TaskBuilder} interface
 *
 * @author martin.grofcik
 */
abstract class BaseTaskBuilderImpl : TaskBuilder {
    protected CommandExecutor commandExecutor;
    protected string _id;
    protected string _name;
    protected string _description;
    protected int _priority  ;//= Task.DEFAULT_PRIORITY;
    protected string ownerId;
    protected string assigneeId;
    protected Date _dueDate;
    protected string _category;
    protected string _parentTaskId;
    protected string _tenantId;
    protected string _formKey;
    protected string _taskDefinitionId;
    protected string _taskDefinitionKey;
    protected string _scopeId;
    protected string _scopeType;
    protected Set!IdentityLinkInfo _identityLinks  ;//= Collections.EMPTY_SET;

    this(CommandExecutor commandExecutor) {
        this.commandExecutor = commandExecutor;
        _identityLinks  = Collections.emptySet!IdentityLinkInfo;
        _priority = Task.DEFAULT_PRIORITY;
    }


    abstract Task create();


    public TaskBuilder id(string id) {
        this._id = id;
        return this;
    }


    public TaskBuilder name(string name) {
        this._name = name;
        return this;
    }


    public TaskBuilder description(string description) {
        this._description = description;
        return this;
    }


    public TaskBuilder priority(int priority) {
        this._priority = priority;
        return this;
    }


    public TaskBuilder owner(string ownerId) {
        this.ownerId = ownerId;
        return this;
    }


    public TaskBuilder assignee(string assigneId) {
        this.assigneeId = assigneId;
        return this;
    }


    public TaskBuilder dueDate(Date dueDate) {
        this._dueDate = dueDate;
        return this;
    }


    public TaskBuilder category(string category) {
        this._category = category;
        return this;
    }


    public TaskBuilder parentTaskId(string parentTaskId) {
        this._parentTaskId = parentTaskId;
        return this;
    }


    public TaskBuilder tenantId(string tenantId) {
        this._tenantId = tenantId;
        return this;
    }


    public TaskBuilder formKey(string formKey) {
        this._formKey = formKey;
        return this;
    }


    public TaskBuilder taskDefinitionId(string taskDefinitionId) {
        this._taskDefinitionId = taskDefinitionId;
        return this;
    }


    public TaskBuilder taskDefinitionKey(string taskDefinitionKey) {
        this._taskDefinitionKey = taskDefinitionKey;
        return this;
    }


    public TaskBuilder identityLinks(Set!IdentityLinkInfo identityLinks) {
        this._identityLinks = identityLinks;
        return this;
    }


    public TaskBuilder scopeId(string scopeId) {
        this._scopeId = scopeId;
        return this;
    }


    public TaskBuilder scopeType(string scopeType) {
        this._scopeType = scopeType;
        return this;
    }


    public string getId() {
        return _id;
    }


    public string getName() {
        return _name;
    }


    public string getDescription() {
        return _description;
    }


    public int getPriority() {
        return _priority;
    }


    public string getOwner() {
        return ownerId;
    }


    public string getAssignee() {
        return assigneeId;
    }


    public string getTaskDefinitionId() {
        return _taskDefinitionId;
    }


    public string getTaskDefinitionKey() {
        return _taskDefinitionKey;
    }


    public Date getDueDate() {
        return _dueDate;
    }


    public string getCategory() {
        return _category;
    }


    public string getParentTaskId() {
        return _parentTaskId;
    }


    public string getTenantId() {
        return _tenantId;
    }


    public string getFormKey() {
        return _formKey;
    }



    public Set!IdentityLinkInfo getIdentityLinks() {
        return _identityLinks;
    }


    public string getScopeId() {
        return this._scopeId;
    }


    public string getScopeType() {
        return this._scopeType;
    }

}
