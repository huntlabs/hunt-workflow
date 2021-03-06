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
module flow.engine.impl.cmd.SaveTaskCmd;


import flow.common.api.FlowableIllegalArgumentException;
import flow.common.api.deleg.event.FlowableEngineEventType;
import flow.common.api.deleg.event.FlowableEventDispatcher;
import flow.common.history.HistoryLevel;
import flow.common.interceptor.Command;
import flow.common.interceptor.CommandContext;
import flow.engine.compatibility.Flowable5CompatibilityHandler;
import flow.engine.deleg.TaskListener;
import flow.engine.impl.cfg.ProcessEngineConfigurationImpl;
import flow.engine.impl.util.CommandContextUtil;
//import flow.engine.impl.util.CountingEntityUtil;
//import flow.engine.impl.util.Flowable5Util;
//import flow.engine.impl.util.TaskHelper;
import flow.task.api.Task;
import flow.task.api.TaskInfo;
import flow.task.service.TaskService;
import flow.task.service.event.impl.FlowableTaskEventBuilder;
import flow.task.service.impl.persistence.CountingTaskEntity;
import flow.task.service.impl.persistence.entity.TaskEntity;
import hunt.Object;
import hunt.Exceptions;
/**
 * @author Joram Barrez
 */
class SaveTaskCmd : Command!Void {


    protected TaskEntity task;

    this(Task task) {
        this.task = cast(TaskEntity) task;
    }

    public Void execute(CommandContext commandContext) {
        implementationMissing(false);
        //if (task is null) {
        //    throw new FlowableIllegalArgumentException("task is null");
        //}
        //
        //if (task.getProcessDefinitionId() !is null && Flowable5Util.isFlowable5ProcessDefinitionId(commandContext, task.getProcessDefinitionId())) {
        //    Flowable5CompatibilityHandler compatibilityHandler = Flowable5Util.getFlowable5CompatibilityHandler();
        //    compatibilityHandler.saveTask(task);
        //    return null;
        //}
        //
        //TaskService taskService = CommandContextUtil.getTaskService(commandContext);
        //
        //if (task.getRevision() == 0) {
        //    TaskHelper.insertTask(task, null, true, false);
        //
        //    FlowableEventDispatcher eventDispatcher = CommandContextUtil.getEventDispatcher(commandContext);
        //    if (eventDispatcher !is null && eventDispatcher.isEnabled()) {
        //        CommandContextUtil.getEventDispatcher().dispatchEvent(FlowableTaskEventBuilder.createEntityEvent(FlowableEngineEventType.TASK_CREATED, task));
        //    }
        //
        //    handleSubTaskCount(taskService, null);
        //
        //} else {
        //
        //    ProcessEngineConfigurationImpl processEngineConfiguration = CommandContextUtil.getProcessEngineConfiguration(commandContext);
        //
        //    TaskInfo originalTaskEntity = taskService.getTask(task.getId());
        //
        //    if (originalTaskEntity is null && processEngineConfiguration.getHistoryLevel().isAtLeast(HistoryLevel.AUDIT)) {
        //        originalTaskEntity = CommandContextUtil.getHistoricTaskService().getHistoricTask(task.getId());
        //    }
        //
        //    CommandContextUtil.getActivityInstanceEntityManager(commandContext)
        //        .recordTaskInfoChange(task, processEngineConfiguration.getClock().getCurrentTime());
        //    taskService.updateTask(task, true);
        //
        //    // Special care needed to detect the assignee task has changed
        //    if (!StringUtils.equals(originalTaskEntity.getAssignee(), task.getAssignee())) {
        //        handleAssigneeChange(commandContext, processEngineConfiguration);
        //    }
        //
        //    // Special care needed to detect the parent task has changed
        //    if (!StringUtils.equals(originalTaskEntity.getParentTaskId(), task.getParentTaskId())) {
        //        handleSubTaskCount(taskService, originalTaskEntity);
        //    }
        //
        //}

        return null;
    }

    protected void handleAssigneeChange(CommandContext commandContext,
            ProcessEngineConfigurationImpl processEngineConfiguration) {
        implementationMissing(false);
        //processEngineConfiguration.getListenerNotificationHelper().executeTaskListeners(task, TaskListener.EVENTNAME_ASSIGNMENT);
        //
        //FlowableEventDispatcher eventDispatcher = CommandContextUtil.getEventDispatcher(commandContext);
        //if (eventDispatcher !is null && eventDispatcher.isEnabled()) {
        //    CommandContextUtil.getEventDispatcher().dispatchEvent(FlowableTaskEventBuilder.createEntityEvent(FlowableEngineEventType.TASK_ASSIGNED, task));
        //}
    }

    protected void handleSubTaskCount(TaskService taskService, TaskInfo originalTaskEntity) {
        implementationMissing(false);
        //if (CountingEntityUtil.isTaskRelatedEntityCountEnabled(task)) {
        //
        //    // Parent task is set, none was set before or it's a new subtask
        //    if (task.getParentTaskId() !is null && (originalTaskEntity is null || originalTaskEntity.getParentTaskId() is null)) {
        //        TaskEntity parentTaskEntity = taskService.getTask(task.getParentTaskId());
        //        if (CountingEntityUtil.isTaskRelatedEntityCountEnabled(parentTaskEntity)) {
        //            CountingTaskEntity countingParentTaskEntity = (CountingTaskEntity) parentTaskEntity;
        //            countingParentTaskEntity.setSubTaskCount(countingParentTaskEntity.getSubTaskCount() + 1);
        //            parentTaskEntity.forceUpdate();
        //        }
        //
        //    // Parent task removed and was set before
        //    } else if (task.getParentTaskId() is null && originalTaskEntity !is null && originalTaskEntity.getParentTaskId() !is null) {
        //        TaskEntity parentTaskEntity = taskService.getTask(originalTaskEntity.getParentTaskId());
        //        if (CountingEntityUtil.isTaskRelatedEntityCountEnabled(parentTaskEntity)) {
        //            CountingTaskEntity countingParentTaskEntity = (CountingTaskEntity) parentTaskEntity;
        //            countingParentTaskEntity.setSubTaskCount(countingParentTaskEntity.getSubTaskCount() - 1);
        //            parentTaskEntity.forceUpdate();
        //        }
        //
        //    // Parent task was changed
        //    } else if (task.getParentTaskId() !is null && originalTaskEntity.getParentTaskId() !is null
        //            && !task.getParentTaskId().equals(originalTaskEntity.getParentTaskId())) {
        //
        //        TaskEntity originalParentTaskEntity = taskService.getTask(originalTaskEntity.getParentTaskId());
        //        if (CountingEntityUtil.isTaskRelatedEntityCountEnabled(originalParentTaskEntity)) {
        //            CountingTaskEntity countingOriginalParentTaskEntity = (CountingTaskEntity) originalParentTaskEntity;
        //            countingOriginalParentTaskEntity.setSubTaskCount(countingOriginalParentTaskEntity.getSubTaskCount() - 1);
        //            originalParentTaskEntity.forceUpdate();
        //        }
        //
        //        TaskEntity parentTaskEntity = taskService.getTask(task.getParentTaskId());
        //        if (CountingEntityUtil.isTaskRelatedEntityCountEnabled(parentTaskEntity)) {
        //            CountingTaskEntity countingParentTaskEntity = (CountingTaskEntity) parentTaskEntity;
        //            countingParentTaskEntity.setSubTaskCount(countingParentTaskEntity.getSubTaskCount() + 1);
        //            parentTaskEntity.forceUpdate();
        //        }
        //
        //    }

        //}
    }

}
