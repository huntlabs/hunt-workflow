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
    protected string id;
    protected string name;
    protected string description;
    protected int priority = Task.DEFAULT_PRIORITY;
    protected string ownerId;
    protected string assigneeId;
    protected Date dueDate;
    protected string category;
    protected string parentTaskId;
    protected string tenantId;
    protected string formKey;
    protected string taskDefinitionId;
    protected string taskDefinitionKey;
    protected string scopeId;
    protected string scopeType;
    protected Set!IdentityLinkInfo identityLinks  ;//= Collections.EMPTY_SET;

    this(CommandExecutor commandExecutor) {
        this.commandExecutor = commandExecutor;
        identityLinks  = Collections.emptySet!IdentityLinkInfo;
    }


    abstract Task create();


    public TaskBuilder id(string id) {
        this.id = id;
        return this;
    }


    public TaskBuilder name(string name) {
        this.name = name;
        return this;
    }


    public TaskBuilder description(string description) {
        this.description = description;
        return this;
    }


    public TaskBuilder priority(int priority) {
        this.priority = priority;
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
        this.dueDate = dueDate;
        return this;
    }


    public TaskBuilder category(string category) {
        this.category = category;
        return this;
    }


    public TaskBuilder parentTaskId(string parentTaskId) {
        this.parentTaskId = parentTaskId;
        return this;
    }


    public TaskBuilder tenantId(string tenantId) {
        this.tenantId = tenantId;
        return this;
    }


    public TaskBuilder formKey(string formKey) {
        this.formKey = formKey;
        return this;
    }


    public TaskBuilder taskDefinitionId(string taskDefinitionId) {
        this.taskDefinitionId = taskDefinitionId;
        return this;
    }


    public TaskBuilder taskDefinitionKey(string taskDefinitionKey) {
        this.taskDefinitionKey = taskDefinitionKey;
        return this;
    }


    public TaskBuilder identityLinks(Set!IdentityLinkInfo identityLinks) {
        this.identityLinks = identityLinks;
        return this;
    }


    public TaskBuilder scopeId(string scopeId) {
        this.scopeId = scopeId;
        return this;
    }


    public TaskBuilder scopeType(string scopeType) {
        this.scopeType = scopeType;
        return this;
    }


    public string getId() {
        return id;
    }


    public string getName() {
        return name;
    }


    public string getDescription() {
        return description;
    }


    public int getPriority() {
        return priority;
    }


    public string getOwner() {
        return ownerId;
    }


    public string getAssignee() {
        return assigneeId;
    }


    public string getTaskDefinitionId() {
        return taskDefinitionId;
    }


    public string getTaskDefinitionKey() {
        return taskDefinitionKey;
    }


    public Date getDueDate() {
        return dueDate;
    }


    public string getCategory() {
        return category;
    }


    public string getParentTaskId() {
        return parentTaskId;
    }


    public string getTenantId() {
        return tenantId;
    }


    public string getFormKey() {
        return formKey;
    }



    public Set!IdentityLinkInfo getIdentityLinks() {
        return identityLinks;
    }


    public string getScopeId() {
        return this.scopeId;
    }


    public string getScopeType() {
        return this.scopeType;
    }

}
