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


import java.io.InputStream;
import hunt.collection.ArrayList;
import hunt.collection;
import hunt.time.LocalDateTime;
import hunt.collection.HashMap;
import hunt.collection.List;
import hunt.collection.Map;
import hunt.collection.Set;

import flow.common.api.FlowableIllegalArgumentException;
import flow.common.service.CommonEngineServiceImpl;
import flow.engine.TaskService;
import flow.engine.impl.cfg.ProcessEngineConfigurationImpl;
import flow.engine.impl.cmd.AddCommentCmd;
import flow.engine.impl.cmd.AddIdentityLinkCmd;
import flow.engine.impl.cmd.ClaimTaskCmd;
import flow.engine.impl.cmd.CompleteTaskCmd;
import flow.engine.impl.cmd.CompleteTaskWithFormCmd;
import flow.engine.impl.cmd.CreateAttachmentCmd;
import flow.engine.impl.cmd.DelegateTaskCmd;
import flow.engine.impl.cmd.DeleteAttachmentCmd;
import flow.engine.impl.cmd.DeleteCommentCmd;
import flow.engine.impl.cmd.DeleteIdentityLinkCmd;
import flow.engine.impl.cmd.DeleteTaskCmd;
import flow.engine.impl.cmd.GetAttachmentCmd;
import flow.engine.impl.cmd.GetAttachmentContentCmd;
import flow.engine.impl.cmd.GetCommentCmd;
import flow.engine.impl.cmd.GetIdentityLinksForTaskCmd;
import flow.engine.impl.cmd.GetProcessInstanceAttachmentsCmd;
import flow.engine.impl.cmd.GetProcessInstanceCommentsCmd;
import flow.engine.impl.cmd.GetSubTasksCmd;
import flow.engine.impl.cmd.GetTaskAttachmentsCmd;
import flow.engine.impl.cmd.GetTaskCommentsByTypeCmd;
import flow.engine.impl.cmd.GetTaskCommentsCmd;
import flow.engine.impl.cmd.GetTaskDataObjectCmd;
import flow.engine.impl.cmd.GetTaskDataObjectsCmd;
import flow.engine.impl.cmd.GetTaskEventCmd;
import flow.engine.impl.cmd.GetTaskEventsCmd;
import flow.engine.impl.cmd.GetTaskFormModelCmd;
import flow.engine.impl.cmd.GetTaskVariableCmd;
import flow.engine.impl.cmd.GetTaskVariableInstanceCmd;
import flow.engine.impl.cmd.GetTaskVariableInstancesCmd;
import flow.engine.impl.cmd.GetTaskVariablesCmd;
import flow.engine.impl.cmd.GetTasksLocalVariablesCmd;
import flow.engine.impl.cmd.GetTypeCommentsCmd;
import flow.engine.impl.cmd.HasTaskVariableCmd;
import flow.engine.impl.cmd.NewTaskCmd;
import flow.engine.impl.cmd.RemoveTaskVariablesCmd;
import flow.engine.impl.cmd.ResolveTaskCmd;
import flow.engine.impl.cmd.SaveAttachmentCmd;
import flow.engine.impl.cmd.SaveCommentCmd;
import flow.engine.impl.cmd.SaveTaskCmd;
import flow.engine.impl.cmd.SetTaskDueDateCmd;
import flow.engine.impl.cmd.SetTaskPriorityCmd;
import flow.engine.impl.cmd.SetTaskVariablesCmd;
import flow.engine.impl.persistence.entity.CommentEntity;
import flow.engine.runtime.DataObject;
import flow.engine.task.Attachment;
import flow.engine.task.Comment;
import flow.engine.task.Event;
import flow.form.api.FormInfo;
import flow.identitylink.api.IdentityLink;
import flow.identitylink.api.IdentityLinkType;
import flow.task.api.NativeTaskQuery;
import flow.task.api.Task;
import flow.task.api.TaskBuilder;
import flow.task.api.TaskQuery;
import flow.task.service.impl.NativeTaskQueryImpl;
import flow.task.service.impl.TaskQueryImpl;
import flow.variable.service.api.persistence.entity.VariableInstance;

/**
 * @author Tom Baeyens
 * @author Joram Barrez
 */
class TaskServiceImpl extends CommonEngineServiceImpl<ProcessEngineConfigurationImpl> implements TaskService {

    public TaskServiceImpl(ProcessEngineConfigurationImpl processEngineConfiguration) {
        super(processEngineConfiguration);
    }

    @Override
    public Task newTask() {
        return newTask(null);
    }

    @Override
    public Task newTask(string taskId) {
        return commandExecutor.execute(new NewTaskCmd(taskId));
    }

    @Override
    public void saveTask(Task task) {
        commandExecutor.execute(new SaveTaskCmd(task));
    }

    @Override
    public void deleteTask(string taskId) {
        commandExecutor.execute(new DeleteTaskCmd(taskId, null, false));
    }

    @Override
    public void deleteTasks(Collection!string taskIds) {
        commandExecutor.execute(new DeleteTaskCmd(taskIds, null, false));
    }

    @Override
    public void deleteTask(string taskId, bool cascade) {
        commandExecutor.execute(new DeleteTaskCmd(taskId, null, cascade));
    }

    @Override
    public void deleteTasks(Collection!string taskIds, bool cascade) {
        commandExecutor.execute(new DeleteTaskCmd(taskIds, null, cascade));
    }

    @Override
    public void deleteTask(string taskId, string deleteReason) {
        commandExecutor.execute(new DeleteTaskCmd(taskId, deleteReason, false));
    }

    @Override
    public void deleteTasks(Collection!string taskIds, string deleteReason) {
        commandExecutor.execute(new DeleteTaskCmd(taskIds, deleteReason, false));
    }

    @Override
    public void setAssignee(string taskId, string userId) {
        commandExecutor.execute(new AddIdentityLinkCmd(taskId, userId, AddIdentityLinkCmd.IDENTITY_USER, IdentityLinkType.ASSIGNEE));
    }

    @Override
    public void setOwner(string taskId, string userId) {
        commandExecutor.execute(new AddIdentityLinkCmd(taskId, userId, AddIdentityLinkCmd.IDENTITY_USER, IdentityLinkType.OWNER));
    }

    @Override
    public void addCandidateUser(string taskId, string userId) {
        commandExecutor.execute(new AddIdentityLinkCmd(taskId, userId, AddIdentityLinkCmd.IDENTITY_USER, IdentityLinkType.CANDIDATE));
    }

    @Override
    public void addCandidateGroup(string taskId, string groupId) {
        commandExecutor.execute(new AddIdentityLinkCmd(taskId, groupId, AddIdentityLinkCmd.IDENTITY_GROUP, IdentityLinkType.CANDIDATE));
    }

    @Override
    public void addUserIdentityLink(string taskId, string userId, string identityLinkType) {
        commandExecutor.execute(new AddIdentityLinkCmd(taskId, userId, AddIdentityLinkCmd.IDENTITY_USER, identityLinkType));
    }

    @Override
    public void addGroupIdentityLink(string taskId, string groupId, string identityLinkType) {
        commandExecutor.execute(new AddIdentityLinkCmd(taskId, groupId, AddIdentityLinkCmd.IDENTITY_GROUP, identityLinkType));
    }

    @Override
    public void deleteCandidateGroup(string taskId, string groupId) {
        commandExecutor.execute(new DeleteIdentityLinkCmd(taskId, null, groupId, IdentityLinkType.CANDIDATE));
    }

    @Override
    public void deleteCandidateUser(string taskId, string userId) {
        commandExecutor.execute(new DeleteIdentityLinkCmd(taskId, userId, null, IdentityLinkType.CANDIDATE));
    }

    @Override
    public void deleteGroupIdentityLink(string taskId, string groupId, string identityLinkType) {
        commandExecutor.execute(new DeleteIdentityLinkCmd(taskId, null, groupId, identityLinkType));
    }

    @Override
    public void deleteUserIdentityLink(string taskId, string userId, string identityLinkType) {
        commandExecutor.execute(new DeleteIdentityLinkCmd(taskId, userId, null, identityLinkType));
    }

    @Override
    public List!IdentityLink getIdentityLinksForTask(string taskId) {
        return commandExecutor.execute(new GetIdentityLinksForTaskCmd(taskId));
    }

    @Override
    public void claim(string taskId, string userId) {
        commandExecutor.execute(new ClaimTaskCmd(taskId, userId));
    }

    @Override
    public void unclaim(string taskId) {
        commandExecutor.execute(new ClaimTaskCmd(taskId, null));
    }

    @Override
    public void complete(string taskId) {
        commandExecutor.execute(new CompleteTaskCmd(taskId, null));
    }

    @Override
    public void complete(string taskId, Map!(string, Object) variables) {
        commandExecutor.execute(new CompleteTaskCmd(taskId, variables));
    }

    @Override
    public void complete(string taskId, Map!(string, Object) variables, Map!(string, Object) transientVariables) {
        commandExecutor.execute(new CompleteTaskCmd(taskId, variables, transientVariables));
    }

    @Override
    public void complete(string taskId, Map!(string, Object) variables, bool localScope) {
        commandExecutor.execute(new CompleteTaskCmd(taskId, variables, localScope));
    }

    @Override
    public void completeTaskWithForm(string taskId, string formDefinitionId, string outcome, Map!(string, Object) variables) {
        commandExecutor.execute(new CompleteTaskWithFormCmd(taskId, formDefinitionId, outcome, variables));
    }

    @Override
    public void completeTaskWithForm(string taskId, string formDefinitionId, string outcome,
            Map!(string, Object) variables, Map!(string, Object) transientVariables) {

        commandExecutor.execute(new CompleteTaskWithFormCmd(taskId, formDefinitionId, outcome, variables, transientVariables));
    }

    @Override
    public void completeTaskWithForm(string taskId, string formDefinitionId, string outcome,
            Map!(string, Object) variables, bool localScope) {

        commandExecutor.execute(new CompleteTaskWithFormCmd(taskId, formDefinitionId, outcome, variables, localScope));
    }

    @Override
    public FormInfo getTaskFormModel(string taskId) {
        return commandExecutor.execute(new GetTaskFormModelCmd(taskId, false));
    }

    @Override
    public FormInfo getTaskFormModel(string taskId, bool ignoreVariables) {
        return commandExecutor.execute(new GetTaskFormModelCmd(taskId, ignoreVariables));
    }

    @Override
    public void delegateTask(string taskId, string userId) {
        commandExecutor.execute(new DelegateTaskCmd(taskId, userId));
    }

    @Override
    public void resolveTask(string taskId) {
        commandExecutor.execute(new ResolveTaskCmd(taskId, null));
    }

    @Override
    public void resolveTask(string taskId, Map!(string, Object) variables) {
        commandExecutor.execute(new ResolveTaskCmd(taskId, variables));
    }

    @Override
    public void resolveTask(string taskId, Map!(string, Object) variables, Map!(string, Object) transientVariables) {
        commandExecutor.execute(new ResolveTaskCmd(taskId, variables, transientVariables));
    }

    @Override
    public void setPriority(string taskId, int priority) {
        commandExecutor.execute(new SetTaskPriorityCmd(taskId, priority));
    }

    @Override
    public void setDueDate(string taskId, Date dueDate) {
        commandExecutor.execute(new SetTaskDueDateCmd(taskId, dueDate));
    }

    @Override
    public TaskQuery createTaskQuery() {
        return new TaskQueryImpl(commandExecutor, configuration.getDatabaseType());
    }

    @Override
    public NativeTaskQuery createNativeTaskQuery() {
        return new NativeTaskQueryImpl(commandExecutor);
    }

    @Override
    public Map!(string, Object) getVariables(string taskId) {
        return commandExecutor.execute(new GetTaskVariablesCmd(taskId, null, false));
    }

    @Override
    public Map!(string, Object) getVariablesLocal(string taskId) {
        return commandExecutor.execute(new GetTaskVariablesCmd(taskId, null, true));
    }

    @Override
    public Map!(string, Object) getVariables(string taskId, Collection!string variableNames) {
        return commandExecutor.execute(new GetTaskVariablesCmd(taskId, variableNames, false));
    }

    @Override
    public Map!(string, Object) getVariablesLocal(string taskId, Collection!string variableNames) {
        return commandExecutor.execute(new GetTaskVariablesCmd(taskId, variableNames, true));
    }

    @Override
    public Object getVariable(string taskId, string variableName) {
        return commandExecutor.execute(new GetTaskVariableCmd(taskId, variableName, false));
    }

    @Override
    public <T> T getVariable(string taskId, string variableName, Class<T> variableClass) {
        return variableClass.cast(getVariable(taskId, variableName));
    }

    @Override
    public bool hasVariable(string taskId, string variableName) {
        return commandExecutor.execute(new HasTaskVariableCmd(taskId, variableName, false));
    }

    @Override
    public Object getVariableLocal(string taskId, string variableName) {
        return commandExecutor.execute(new GetTaskVariableCmd(taskId, variableName, true));
    }

    @Override
    public <T> T getVariableLocal(string taskId, string variableName, Class<T> variableClass) {
        return variableClass.cast(getVariableLocal(taskId, variableName));
    }

    @Override
    public List<VariableInstance> getVariableInstancesLocalByTaskIds(Set!string taskIds) {
        return commandExecutor.execute(new GetTasksLocalVariablesCmd(taskIds));
    }

    @Override
    public bool hasVariableLocal(string taskId, string variableName) {
        return commandExecutor.execute(new HasTaskVariableCmd(taskId, variableName, true));
    }

    @Override
    public void setVariable(string taskId, string variableName, Object value) {
        if (variableName is null) {
            throw new FlowableIllegalArgumentException("variableName is null");
        }
        Map!(string, Object) variables = new HashMap<>();
        variables.put(variableName, value);
        commandExecutor.execute(new SetTaskVariablesCmd(taskId, variables, false));
    }

    @Override
    public void setVariableLocal(string taskId, string variableName, Object value) {
        if (variableName is null) {
            throw new FlowableIllegalArgumentException("variableName is null");
        }
        Map!(string, Object) variables = new HashMap<>();
        variables.put(variableName, value);
        commandExecutor.execute(new SetTaskVariablesCmd(taskId, variables, true));
    }

    @Override
    public void setVariables(string taskId, Map<string, ? extends Object> variables) {
        commandExecutor.execute(new SetTaskVariablesCmd(taskId, variables, false));
    }

    @Override
    public void setVariablesLocal(string taskId, Map<string, ? extends Object> variables) {
        commandExecutor.execute(new SetTaskVariablesCmd(taskId, variables, true));
    }

    @Override
    public void removeVariable(string taskId, string variableName) {
        Collection!string variableNames = new ArrayList<>();
        variableNames.add(variableName);
        commandExecutor.execute(new RemoveTaskVariablesCmd(taskId, variableNames, false));
    }

    @Override
    public void removeVariableLocal(string taskId, string variableName) {
        Collection!string variableNames = new ArrayList<>(1);
        variableNames.add(variableName);
        commandExecutor.execute(new RemoveTaskVariablesCmd(taskId, variableNames, true));
    }

    @Override
    public void removeVariables(string taskId, Collection!string variableNames) {
        commandExecutor.execute(new RemoveTaskVariablesCmd(taskId, variableNames, false));
    }

    @Override
    public void removeVariablesLocal(string taskId, Collection!string variableNames) {
        commandExecutor.execute(new RemoveTaskVariablesCmd(taskId, variableNames, true));
    }

    @Override
    public Comment addComment(string taskId, string processInstance, string message) {
        return commandExecutor.execute(new AddCommentCmd(taskId, processInstance, message));
    }

    @Override
    public Comment addComment(string taskId, string processInstance, string type, string message) {
        return commandExecutor.execute(new AddCommentCmd(taskId, processInstance, type, message));
    }

    @Override
    public void saveComment(Comment comment) {
        commandExecutor.execute(new SaveCommentCmd((CommentEntity) comment));
    }

    @Override
    public Comment getComment(string commentId) {
        return commandExecutor.execute(new GetCommentCmd(commentId));
    }

    @Override
    public Event getEvent(string eventId) {
        return commandExecutor.execute(new GetTaskEventCmd(eventId));
    }

    @Override
    public List<Comment> getTaskComments(string taskId) {
        return commandExecutor.execute(new GetTaskCommentsCmd(taskId));
    }

    @Override
    public List<Comment> getTaskComments(string taskId, string type) {
        return commandExecutor.execute(new GetTaskCommentsByTypeCmd(taskId, type));
    }

    @Override
    public List<Comment> getCommentsByType(string type) {
        return commandExecutor.execute(new GetTypeCommentsCmd(type));
    }

    @Override
    public List<Event> getTaskEvents(string taskId) {
        return commandExecutor.execute(new GetTaskEventsCmd(taskId));
    }

    @Override
    public List<Comment> getProcessInstanceComments(string processInstanceId) {
        return commandExecutor.execute(new GetProcessInstanceCommentsCmd(processInstanceId));
    }

    @Override
    public List<Comment> getProcessInstanceComments(string processInstanceId, string type) {
        return commandExecutor.execute(new GetProcessInstanceCommentsCmd(processInstanceId, type));
    }

    @Override
    public Attachment createAttachment(string attachmentType, string taskId, string processInstanceId, string attachmentName, string attachmentDescription, InputStream content) {
        return commandExecutor.execute(new CreateAttachmentCmd(attachmentType, taskId, processInstanceId, attachmentName, attachmentDescription, content, null));
    }

    @Override
    public Attachment createAttachment(string attachmentType, string taskId, string processInstanceId, string attachmentName, string attachmentDescription, string url) {
        return commandExecutor.execute(new CreateAttachmentCmd(attachmentType, taskId, processInstanceId, attachmentName, attachmentDescription, null, url));
    }

    @Override
    public InputStream getAttachmentContent(string attachmentId) {
        return commandExecutor.execute(new GetAttachmentContentCmd(attachmentId));
    }

    @Override
    public void deleteAttachment(string attachmentId) {
        commandExecutor.execute(new DeleteAttachmentCmd(attachmentId));
    }

    @Override
    public void deleteComments(string taskId, string processInstanceId) {
        commandExecutor.execute(new DeleteCommentCmd(taskId, processInstanceId, null));
    }

    @Override
    public void deleteComment(string commentId) {
        commandExecutor.execute(new DeleteCommentCmd(null, null, commentId));
    }

    @Override
    public Attachment getAttachment(string attachmentId) {
        return commandExecutor.execute(new GetAttachmentCmd(attachmentId));
    }

    @Override
    @SuppressWarnings("unchecked")
    public List<Attachment> getTaskAttachments(string taskId) {
        return (List<Attachment>) commandExecutor.execute(new GetTaskAttachmentsCmd(taskId));
    }

    @Override
    @SuppressWarnings("unchecked")
    public List<Attachment> getProcessInstanceAttachments(string processInstanceId) {
        return (List<Attachment>) commandExecutor.execute(new GetProcessInstanceAttachmentsCmd(processInstanceId));
    }

    @Override
    public void saveAttachment(Attachment attachment) {
        commandExecutor.execute(new SaveAttachmentCmd(attachment));
    }

    @Override
    public List<Task> getSubTasks(string parentTaskId) {
        return commandExecutor.execute(new GetSubTasksCmd(parentTaskId));
    }

    @Override
    public VariableInstance getVariableInstance(string taskId, string variableName) {
        return commandExecutor.execute(new GetTaskVariableInstanceCmd(taskId, variableName, false));
    }

    @Override
    public VariableInstance getVariableInstanceLocal(string taskId, string variableName) {
        return commandExecutor.execute(new GetTaskVariableInstanceCmd(taskId, variableName, true));
    }

    @Override
    public Map<string, VariableInstance> getVariableInstances(string taskId) {
        return commandExecutor.execute(new GetTaskVariableInstancesCmd(taskId, null, false));
    }

    @Override
    public Map<string, VariableInstance> getVariableInstances(string taskId, Collection!string variableNames) {
        return commandExecutor.execute(new GetTaskVariableInstancesCmd(taskId, variableNames, false));
    }

    @Override
    public Map<string, VariableInstance> getVariableInstancesLocal(string taskId) {
        return commandExecutor.execute(new GetTaskVariableInstancesCmd(taskId, null, true));
    }

    @Override
    public Map<string, VariableInstance> getVariableInstancesLocal(string taskId, Collection!string variableNames) {
        return commandExecutor.execute(new GetTaskVariableInstancesCmd(taskId, variableNames, true));
    }

    @Override
    public Map<string, DataObject> getDataObjects(string taskId) {
        return commandExecutor.execute(new GetTaskDataObjectsCmd(taskId, null));
    }

    @Override
    public Map<string, DataObject> getDataObjects(string taskId, string locale, bool withLocalizationFallback) {
        return commandExecutor.execute(new GetTaskDataObjectsCmd(taskId, null, locale, withLocalizationFallback));
    }

    @Override
    public Map<string, DataObject> getDataObjects(string taskId, Collection!string dataObjectNames) {
        return commandExecutor.execute(new GetTaskDataObjectsCmd(taskId, dataObjectNames));
    }

    @Override
    public Map<string, DataObject> getDataObjects(string taskId, Collection!string dataObjectNames, string locale, bool withLocalizationFallback) {
        return commandExecutor.execute(new GetTaskDataObjectsCmd(taskId, dataObjectNames, locale, withLocalizationFallback));
    }

    @Override
    public DataObject getDataObject(string taskId, string dataObject) {
        return commandExecutor.execute(new GetTaskDataObjectCmd(taskId, dataObject));
    }

    @Override
    public DataObject getDataObject(string taskId, string dataObjectName, string locale, bool withLocalizationFallback) {
        return commandExecutor.execute(new GetTaskDataObjectCmd(taskId, dataObjectName, locale, withLocalizationFallback));
    }

    @Override
    public TaskBuilder createTaskBuilder() {
        return new TaskBuilderImpl(commandExecutor);
    }
}
