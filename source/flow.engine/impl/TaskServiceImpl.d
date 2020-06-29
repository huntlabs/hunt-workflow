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
module flow.engine.impl.TaskServiceImpl;

import hunt.stream.Common;
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
//import flow.task.service.impl.NativeTaskQueryImpl;
import flow.task.service.impl.TaskQueryImpl;
import flow.variable.service.api.persistence.entity.VariableInstance;
import hunt.Exceptions;
import hunt.Boolean;
import flow.engine.impl.TaskBuilderImpl;
/**
 * @author Tom Baeyens
 * @author Joram Barrez
 */
class TaskServiceImpl : CommonEngineServiceImpl!ProcessEngineConfigurationImpl , TaskService {

    this(ProcessEngineConfigurationImpl processEngineConfiguration) {
        super(processEngineConfiguration);
    }


    public Task newTask() {
        return newTask(null);
    }


    public Task newTask(string taskId) {
        return cast(Task)(commandExecutor.execute(new NewTaskCmd(taskId)));
    }


    public void saveTask(Task task) {
        commandExecutor.execute(new SaveTaskCmd(task));
    }


    public void deleteTask(string taskId) {
        commandExecutor.execute(new DeleteTaskCmd(taskId, null, false));
    }


    public void deleteTasks(Collection!string taskIds) {
        commandExecutor.execute(new DeleteTaskCmd(taskIds, null, false));
    }


    public void deleteTask(string taskId, bool cascade) {
        commandExecutor.execute(new DeleteTaskCmd(taskId, null, cascade));
    }


    public void deleteTasks(Collection!string taskIds, bool cascade) {
        commandExecutor.execute(new DeleteTaskCmd(taskIds, null, cascade));
    }


    public void deleteTask(string taskId, string deleteReason) {
        commandExecutor.execute(new DeleteTaskCmd(taskId, deleteReason, false));
    }


    public void deleteTasks(Collection!string taskIds, string deleteReason) {
        commandExecutor.execute(new DeleteTaskCmd(taskIds, deleteReason, false));
    }


    public void setAssignee(string taskId, string userId) {
        commandExecutor.execute(new AddIdentityLinkCmd(taskId, userId, AddIdentityLinkCmd.IDENTITY_USER, IdentityLinkType.ASSIGNEE));
    }


    public void setOwner(string taskId, string userId) {
        commandExecutor.execute(new AddIdentityLinkCmd(taskId, userId, AddIdentityLinkCmd.IDENTITY_USER, IdentityLinkType.OWNER));
    }


    public void addCandidateUser(string taskId, string userId) {
        commandExecutor.execute(new AddIdentityLinkCmd(taskId, userId, AddIdentityLinkCmd.IDENTITY_USER, IdentityLinkType.CANDIDATE));
    }


    public void addCandidateGroup(string taskId, string groupId) {
        commandExecutor.execute(new AddIdentityLinkCmd(taskId, groupId, AddIdentityLinkCmd.IDENTITY_GROUP, IdentityLinkType.CANDIDATE));
    }


    public void addUserIdentityLink(string taskId, string userId, string identityLinkType) {
        commandExecutor.execute(new AddIdentityLinkCmd(taskId, userId, AddIdentityLinkCmd.IDENTITY_USER, identityLinkType));
    }


    public void addGroupIdentityLink(string taskId, string groupId, string identityLinkType) {
        commandExecutor.execute(new AddIdentityLinkCmd(taskId, groupId, AddIdentityLinkCmd.IDENTITY_GROUP, identityLinkType));
    }


    public void deleteCandidateGroup(string taskId, string groupId) {
        commandExecutor.execute(new DeleteIdentityLinkCmd(taskId, null, groupId, IdentityLinkType.CANDIDATE));
    }


    public void deleteCandidateUser(string taskId, string userId) {
        commandExecutor.execute(new DeleteIdentityLinkCmd(taskId, userId, null, IdentityLinkType.CANDIDATE));
    }


    public void deleteGroupIdentityLink(string taskId, string groupId, string identityLinkType) {
        commandExecutor.execute(new DeleteIdentityLinkCmd(taskId, null, groupId, identityLinkType));
    }


    public void deleteUserIdentityLink(string taskId, string userId, string identityLinkType) {
        commandExecutor.execute(new DeleteIdentityLinkCmd(taskId, userId, null, identityLinkType));
    }


    public List!IdentityLink getIdentityLinksForTask(string taskId) {
        return cast(List!IdentityLink)(commandExecutor.execute(new GetIdentityLinksForTaskCmd(taskId)));
    }


    public void claim(string taskId, string userId) {
        commandExecutor.execute(new ClaimTaskCmd(taskId, userId));
    }


    public void unclaim(string taskId) {
        commandExecutor.execute(new ClaimTaskCmd(taskId, null));
    }


    public void complete(string taskId) {
        commandExecutor.execute(new CompleteTaskCmd(taskId, null));
    }


    public void complete(string taskId, Map!(string, Object) variables) {
        commandExecutor.execute(new CompleteTaskCmd(taskId, variables));
    }


    public void complete(string taskId, Map!(string, Object) variables, Map!(string, Object) transientVariables) {
        commandExecutor.execute(new CompleteTaskCmd(taskId, variables, transientVariables));
    }


    public void complete(string taskId, Map!(string, Object) variables, bool localScope) {
        commandExecutor.execute(new CompleteTaskCmd(taskId, variables, localScope));
    }


    public void completeTaskWithForm(string taskId, string formDefinitionId, string outcome, Map!(string, Object) variables) {
        commandExecutor.execute(new CompleteTaskWithFormCmd(taskId, formDefinitionId, outcome, variables));
    }


    public void completeTaskWithForm(string taskId, string formDefinitionId, string outcome,
            Map!(string, Object) variables, Map!(string, Object) transientVariables) {

        commandExecutor.execute(new CompleteTaskWithFormCmd(taskId, formDefinitionId, outcome, variables, transientVariables));
    }


    public void completeTaskWithForm(string taskId, string formDefinitionId, string outcome,
            Map!(string, Object) variables, bool localScope) {

        commandExecutor.execute(new CompleteTaskWithFormCmd(taskId, formDefinitionId, outcome, variables, localScope));
    }


    public FormInfo getTaskFormModel(string taskId) {
        return cast(FormInfo)(commandExecutor.execute(new GetTaskFormModelCmd(taskId, false)));
    }


    public FormInfo getTaskFormModel(string taskId, bool ignoreVariables) {
        return cast(FormInfo)(commandExecutor.execute(new GetTaskFormModelCmd(taskId, ignoreVariables)));
    }


    public void delegateTask(string taskId, string userId) {
        commandExecutor.execute(new DelegateTaskCmd(taskId, userId));
    }


    public void resolveTask(string taskId) {
        commandExecutor.execute(new ResolveTaskCmd(taskId, null));
    }


    public void resolveTask(string taskId, Map!(string, Object) variables) {
        commandExecutor.execute(new ResolveTaskCmd(taskId, variables));
    }


    public void resolveTask(string taskId, Map!(string, Object) variables, Map!(string, Object) transientVariables) {
        commandExecutor.execute(new ResolveTaskCmd(taskId, variables, transientVariables));
    }


    public void setPriority(string taskId, int priority) {
        commandExecutor.execute(new SetTaskPriorityCmd(taskId, priority));
    }


    public void setDueDate(string taskId, Date dueDate) {
        commandExecutor.execute(new SetTaskDueDateCmd(taskId, dueDate));
    }


    public TaskQuery createTaskQuery() {
        return new TaskQueryImpl(commandExecutor, configuration.getDatabaseType());
    }


    public NativeTaskQuery createNativeTaskQuery() {
        implementationMissing(false);
        return null;
      //  return new NativeTaskQueryImpl(commandExecutor);
    }


    public Map!(string, Object) getVariables(string taskId) {
        return cast(Map!(string, Object))(commandExecutor.execute(new GetTaskVariablesCmd(taskId, null, false)));
    }


    public Map!(string, Object) getVariablesLocal(string taskId) {
        return cast(Map!(string, Object))(commandExecutor.execute(new GetTaskVariablesCmd(taskId, null, true)));
    }


    public Map!(string, Object) getVariables(string taskId, Collection!string variableNames) {
        return cast(Map!(string, Object))(commandExecutor.execute(new GetTaskVariablesCmd(taskId, variableNames, false)));
    }


    public Map!(string, Object) getVariablesLocal(string taskId, Collection!string variableNames) {
        return cast(Map!(string, Object))(commandExecutor.execute(new GetTaskVariablesCmd(taskId, variableNames, true)));
    }


    public Object getVariable(string taskId, string variableName) {
        return commandExecutor.execute(new GetTaskVariableCmd(taskId, variableName, false));
    }


    //public <T> T getVariable(string taskId, string variableName, Class!T variableClass) {
    //    return variableClass.cast(getVariable(taskId, variableName));
    //}


    public bool hasVariable(string taskId, string variableName) {
        return (cast(Boolean)(commandExecutor.execute(new HasTaskVariableCmd(taskId, variableName, false)))).booleanValue();
    }


    public Object getVariableLocal(string taskId, string variableName) {
        return commandExecutor.execute(new GetTaskVariableCmd(taskId, variableName, true));
    }


    //public <T> T getVariableLocal(string taskId, string variableName, Class!T variableClass) {
    //    return variableClass.cast(getVariableLocal(taskId, variableName));
    //}


    public List!VariableInstance getVariableInstancesLocalByTaskIds(Set!string taskIds) {
        return cast(List!VariableInstance)(commandExecutor.execute(new GetTasksLocalVariablesCmd(taskIds)));
    }


    public bool hasVariableLocal(string taskId, string variableName) {
        return (cast(Boolean)(commandExecutor.execute(new HasTaskVariableCmd(taskId, variableName, true)))).booleanValue();
    }


    public void setVariable(string taskId, string variableName, Object value) {
        if (variableName is null) {
            throw new FlowableIllegalArgumentException("variableName is null");
        }
        Map!(string, Object) variables = new HashMap!(string, Object)();
        variables.put(variableName, value);
        commandExecutor.execute(new SetTaskVariablesCmd(taskId, variables, false));
    }


    public void setVariableLocal(string taskId, string variableName, Object value) {
        if (variableName is null) {
            throw new FlowableIllegalArgumentException("variableName is null");
        }
        Map!(string, Object) variables = new HashMap!(string, Object)();
        variables.put(variableName, value);
        commandExecutor.execute(new SetTaskVariablesCmd(taskId, variables, true));
    }


    public void setVariables(string taskId, Map!(string, Object) variables) {
        commandExecutor.execute(new SetTaskVariablesCmd(taskId, variables, false));
    }


    public void setVariablesLocal(string taskId, Map!(string,Object) variables) {
        commandExecutor.execute(new SetTaskVariablesCmd(taskId, variables, true));
    }


    public void removeVariable(string taskId, string variableName) {
        Collection!string variableNames = new ArrayList!string();
        variableNames.add(variableName);
        commandExecutor.execute(new RemoveTaskVariablesCmd(taskId, variableNames, false));
    }


    public void removeVariableLocal(string taskId, string variableName) {
        Collection!string variableNames = new ArrayList!string(1);
        variableNames.add(variableName);
        commandExecutor.execute(new RemoveTaskVariablesCmd(taskId, variableNames, true));
    }


    public void removeVariables(string taskId, Collection!string variableNames) {
        commandExecutor.execute(new RemoveTaskVariablesCmd(taskId, variableNames, false));
    }


    public void removeVariablesLocal(string taskId, Collection!string variableNames) {
        commandExecutor.execute(new RemoveTaskVariablesCmd(taskId, variableNames, true));
    }


    public Comment addComment(string taskId, string processInstance, string message) {
        return cast(Comment)(commandExecutor.execute(new AddCommentCmd(taskId, processInstance, message)));
    }


    public Comment addComment(string taskId, string processInstance, string type, string message) {
        return cast(Comment)(commandExecutor.execute(new AddCommentCmd(taskId, processInstance, type, message)));
    }


    public void saveComment(Comment comment) {
        commandExecutor.execute(new SaveCommentCmd(cast(CommentEntity) comment));
    }


    public Comment getComment(string commentId) {
        return cast(Comment)(commandExecutor.execute(new GetCommentCmd(commentId)));
    }


    public Event getEvent(string eventId) {
        return cast(Event)(commandExecutor.execute(new GetTaskEventCmd(eventId)));
    }


    public List!Comment getTaskComments(string taskId) {
        return cast(List!Comment)(commandExecutor.execute(new GetTaskCommentsCmd(taskId)));
    }


    public List!Comment getTaskComments(string taskId, string type) {
        return cast(List!Comment)(commandExecutor.execute(new GetTaskCommentsByTypeCmd(taskId, type)));
    }


    public List!Comment getCommentsByType(string type) {
        return cast(List!Comment)(commandExecutor.execute(new GetTypeCommentsCmd(type)));
    }


    public List!Event getTaskEvents(string taskId) {
        return cast(List!Event)(commandExecutor.execute(new GetTaskEventsCmd(taskId)));
    }


    public List!Comment getProcessInstanceComments(string processInstanceId) {
        return cast(List!Comment)(commandExecutor.execute(new GetProcessInstanceCommentsCmd(processInstanceId)));
    }


    public List!Comment getProcessInstanceComments(string processInstanceId, string type) {
        return cast(List!Comment)(commandExecutor.execute(new GetProcessInstanceCommentsCmd(processInstanceId, type)));
    }


    public Attachment createAttachment(string attachmentType, string taskId, string processInstanceId, string attachmentName, string attachmentDescription, InputStream content) {
        return cast(Attachment)(commandExecutor.execute(new CreateAttachmentCmd(attachmentType, taskId, processInstanceId, attachmentName, attachmentDescription, content, null)));
    }


    public Attachment createAttachment(string attachmentType, string taskId, string processInstanceId, string attachmentName, string attachmentDescription, string url) {
        return cast(Attachment)(commandExecutor.execute(new CreateAttachmentCmd(attachmentType, taskId, processInstanceId, attachmentName, attachmentDescription, null, url)));
    }


    public InputStream getAttachmentContent(string attachmentId) {
        return cast(InputStream)(commandExecutor.execute(new GetAttachmentContentCmd(attachmentId)));
    }


    public void deleteAttachment(string attachmentId) {
        commandExecutor.execute(new DeleteAttachmentCmd(attachmentId));
    }


    public void deleteComments(string taskId, string processInstanceId) {
        commandExecutor.execute(new DeleteCommentCmd(taskId, processInstanceId, null));
    }


    public void deleteComment(string commentId) {
        commandExecutor.execute(new DeleteCommentCmd(null, null, commentId));
    }


    public Attachment getAttachment(string attachmentId) {
        return cast(Attachment)(commandExecutor.execute(new GetAttachmentCmd(attachmentId)));
    }


    public List!Attachment getTaskAttachments(string taskId) {
        return cast(List!Attachment) commandExecutor.execute(new GetTaskAttachmentsCmd(taskId));
    }


    public List!Attachment getProcessInstanceAttachments(string processInstanceId) {
        return cast(List!Attachment) commandExecutor.execute(new GetProcessInstanceAttachmentsCmd(processInstanceId));
    }


    public void saveAttachment(Attachment attachment) {
        commandExecutor.execute(new SaveAttachmentCmd(attachment));
    }


    public List!Task getSubTasks(string parentTaskId) {
        return cast(List!Task)(commandExecutor.execute(new GetSubTasksCmd(parentTaskId)));
    }


    public VariableInstance getVariableInstance(string taskId, string variableName) {
        return cast(VariableInstance)(commandExecutor.execute(new GetTaskVariableInstanceCmd(taskId, variableName, false)));
    }


    public VariableInstance getVariableInstanceLocal(string taskId, string variableName) {
        return cast(VariableInstance)(commandExecutor.execute(new GetTaskVariableInstanceCmd(taskId, variableName, true)));
    }


    public Map!(string, VariableInstance) getVariableInstances(string taskId) {
        return cast(Map!(string, VariableInstance))(commandExecutor.execute(new GetTaskVariableInstancesCmd(taskId, null, false)));
    }


    public Map!(string, VariableInstance) getVariableInstances(string taskId, Collection!string variableNames) {
        return cast(Map!(string, VariableInstance))(commandExecutor.execute(new GetTaskVariableInstancesCmd(taskId, variableNames, false)));
    }


    public Map!(string, VariableInstance) getVariableInstancesLocal(string taskId) {
        return cast(Map!(string, VariableInstance))(commandExecutor.execute(new GetTaskVariableInstancesCmd(taskId, null, true)));
    }


    public Map!(string, VariableInstance) getVariableInstancesLocal(string taskId, Collection!string variableNames) {
        return cast(Map!(string, VariableInstance))(commandExecutor.execute(new GetTaskVariableInstancesCmd(taskId, variableNames, true)));
    }


    public Map!(string, DataObject) getDataObjects(string taskId) {
        return cast(Map!(string, DataObject))(commandExecutor.execute(new GetTaskDataObjectsCmd(taskId, null)));
    }


    public Map!(string, DataObject) getDataObjects(string taskId, string locale, bool withLocalizationFallback) {
        return cast( Map!(string, DataObject))(commandExecutor.execute(new GetTaskDataObjectsCmd(taskId, null, locale, withLocalizationFallback)));
    }


    public Map!(string, DataObject) getDataObjects(string taskId, Collection!string dataObjectNames) {
        return cast(Map!(string, DataObject))(commandExecutor.execute(new GetTaskDataObjectsCmd(taskId, dataObjectNames)));
    }


    public Map!(string, DataObject) getDataObjects(string taskId, Collection!string dataObjectNames, string locale, bool withLocalizationFallback) {
        return cast(Map!(string, DataObject))(commandExecutor.execute(new GetTaskDataObjectsCmd(taskId, dataObjectNames, locale, withLocalizationFallback)));
    }


    public DataObject getDataObject(string taskId, string dataObject) {
        return cast(DataObject)(commandExecutor.execute(new GetTaskDataObjectCmd(taskId, dataObject)));
    }


    public DataObject getDataObject(string taskId, string dataObjectName, string locale, bool withLocalizationFallback) {
        return cast(DataObject)(commandExecutor.execute(new GetTaskDataObjectCmd(taskId, dataObjectName, locale, withLocalizationFallback)));
    }


    public TaskBuilder createTaskBuilder() {
        return new TaskBuilderImpl(commandExecutor);
    }
}
