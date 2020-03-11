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


import flow.common.interceptor.CommandExecutor;
import flow.identitylink.api.IdentityLinkInfo;
import flow.task.api.Task;
import flow.task.api.TaskBuilder;

import hunt.collections;
import java.util.Date;
import hunt.collection.Set;

/**
 * Base implementation of the {@link TaskBuilder} interface
 *
 * @author martin.grofcik
 */
abstract class BaseTaskBuilderImpl implements TaskBuilder {
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
    protected Set<? extends IdentityLinkInfo> identityLinks = Collections.EMPTY_SET;

    public BaseTaskBuilderImpl(CommandExecutor commandExecutor) {
        this.commandExecutor = commandExecutor;
    }

    @Override
    abstract Task create();

    @Override
    public TaskBuilder id(string id) {
        this.id = id;
        return this;
    }

    @Override
    public TaskBuilder name(string name) {
        this.name = name;
        return this;
    }

    @Override
    public TaskBuilder description(string description) {
        this.description = description;
        return this;
    }

    @Override
    public TaskBuilder priority(int priority) {
        this.priority = priority;
        return this;
    }

    @Override
    public TaskBuilder owner(string ownerId) {
        this.ownerId = ownerId;
        return this;
    }

    @Override
    public TaskBuilder assignee(string assigneId) {
        this.assigneeId = assigneId;
        return this;
    }

    @Override
    public TaskBuilder dueDate(Date dueDate) {
        this.dueDate = dueDate;
        return this;
    }

    @Override
    public TaskBuilder category(string category) {
        this.category = category;
        return this;
    }

    @Override
    public TaskBuilder parentTaskId(string parentTaskId) {
        this.parentTaskId = parentTaskId;
        return this;
    }

    @Override
    public TaskBuilder tenantId(string tenantId) {
        this.tenantId = tenantId;
        return this;
    }

    @Override
    public TaskBuilder formKey(string formKey) {
        this.formKey = formKey;
        return this;
    }

    @Override
    public TaskBuilder taskDefinitionId(string taskDefinitionId) {
        this.taskDefinitionId = taskDefinitionId;
        return this;
    }

    @Override
    public TaskBuilder taskDefinitionKey(string taskDefinitionKey) {
        this.taskDefinitionKey = taskDefinitionKey;
        return this;
    }

    @Override
    public TaskBuilder identityLinks(Set<? extends IdentityLinkInfo> identityLinks) {
        this.identityLinks = identityLinks;
        return this;
    }

    @Override
    public TaskBuilder scopeId(string scopeId) {
        this.scopeId = scopeId;
        return this;
    }

    @Override
    public TaskBuilder scopeType(string scopeType) {
        this.scopeType = scopeType;
        return this;
    }

    @Override
    public string getId() {
        return id;
    }

    @Override
    public string getName() {
        return name;
    }

    @Override
    public string getDescription() {
        return description;
    }

    @Override
    public int getPriority() {
        return priority;
    }

    @Override
    public string getOwner() {
        return ownerId;
    }

    @Override
    public string getAssignee() {
        return assigneeId;
    }

    @Override
    public string getTaskDefinitionId() {
        return taskDefinitionId;
    }

    @Override
    public string getTaskDefinitionKey() {
        return taskDefinitionKey;
    }

    @Override
    public Date getDueDate() {
        return dueDate;
    }

    @Override
    public string getCategory() {
        return category;
    }

    @Override
    public string getParentTaskId() {
        return parentTaskId;
    }

    @Override
    public string getTenantId() {
        return tenantId;
    }

    @Override
    public string getFormKey() {
        return formKey;
    }


    @Override
    public Set<? extends IdentityLinkInfo> getIdentityLinks() {
        return identityLinks;
    }

    @Override
    public string getScopeId() {
        return this.scopeId;
    }

    @Override
    public string getScopeType() {
        return this.scopeType;
    }

}
