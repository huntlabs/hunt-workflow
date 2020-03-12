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


import hunt.collection.ArrayList;
import java.util.Arrays;
import hunt.collection;
import hunt.time.LocalDateTime;
import java.util.Iterator;
import hunt.collection.List;

import org.apache.commons.lang3.StringUtils;
import flow.bpmn.model.UserTask;
import flow.common.api.FlowableException;
import flow.common.api.FlowableIllegalArgumentException;
import flow.common.api.deleg.Expression;
import flow.common.api.deleg.event.FlowableEngineEventType;
import flow.common.api.deleg.event.FlowableEventDispatcher;
import flow.common.calendar.BusinessCalendar;
import flow.common.calendar.DueDateBusinessCalendar;
import flow.common.el.ExpressionManager;
import flow.common.interceptor.CommandContext;
import flow.common.logging.LoggingSessionConstants;
import flow.common.logging.LoggingSessionUtil;
import flow.engine.DynamicBpmnConstants;
import flow.engine.deleg.DelegateExecution;
import flow.engine.deleg.TaskListener;
import flow.engine.impl.bpmn.helper.DynamicPropertyUtil;
import flow.engine.impl.bpmn.helper.SkipExpressionUtil;
import flow.engine.impl.cfg.ProcessEngineConfigurationImpl;
import flow.engine.impl.context.BpmnOverrideContext;
import flow.engine.impl.persistence.entity.ExecutionEntity;
import flow.engine.impl.util.BpmnLoggingSessionUtil;
import flow.engine.impl.util.CommandContextUtil;
import flow.engine.impl.util.IdentityLinkUtil;
import flow.engine.impl.util.TaskHelper;
import flow.engine.interceptor.CreateUserTaskAfterContext;
import flow.engine.interceptor.CreateUserTaskBeforeContext;
import flow.identitylink.service.impl.persistence.entity.IdentityLinkEntity;
import org.flowable.task.service.TaskService;
import org.flowable.task.service.event.impl.FlowableTaskEventBuilder;
import org.flowable.task.service.impl.persistence.entity.TaskEntity;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.fasterxml.jackson.databind.node.ObjectNode;

/**
 * @author Joram Barrez
 */
class UserTaskActivityBehavior extends TaskActivityBehavior {

    private static final long serialVersionUID = 1L;

    private static final Logger LOGGER = LoggerFactory.getLogger(UserTaskActivityBehavior.class);

    protected UserTask userTask;

    public UserTaskActivityBehavior(UserTask userTask) {
        this.userTask = userTask;
    }

    @Override
    public void execute(DelegateExecution execution) {
        CommandContext commandContext = CommandContextUtil.getCommandContext();
        TaskService taskService = CommandContextUtil.getTaskService(commandContext);

        TaskEntity task = taskService.createTask();
        task.setExecutionId(execution.getId());
        task.setTaskDefinitionKey(userTask.getId());
        task.setPropagatedStageInstanceId(execution.getPropagatedStageInstanceId());

        string activeTaskName = null;
        string activeTaskDescription = null;
        string activeTaskDueDate = null;
        string activeTaskPriority = null;
        string activeTaskCategory = null;
        string activeTaskFormKey = null;
        string activeTaskSkipExpression = null;
        string activeTaskAssignee = null;
        string activeTaskOwner = null;
        List!string activeTaskCandidateUsers = null;
        List!string activeTaskCandidateGroups = null;

        ProcessEngineConfigurationImpl processEngineConfiguration = CommandContextUtil.getProcessEngineConfiguration(commandContext);
        ExpressionManager expressionManager = processEngineConfiguration.getExpressionManager();

        if (processEngineConfiguration.isEnableProcessDefinitionInfoCache()) {
            ObjectNode taskElementProperties = BpmnOverrideContext.getBpmnOverrideElementProperties(userTask.getId(), execution.getProcessDefinitionId());
            activeTaskName = DynamicPropertyUtil.getActiveValue(userTask.getName(), DynamicBpmnConstants.USER_TASK_NAME, taskElementProperties);
            activeTaskDescription = DynamicPropertyUtil.getActiveValue(userTask.getDocumentation(), DynamicBpmnConstants.USER_TASK_DESCRIPTION, taskElementProperties);
            activeTaskDueDate = DynamicPropertyUtil.getActiveValue(userTask.getDueDate(), DynamicBpmnConstants.USER_TASK_DUEDATE, taskElementProperties);
            activeTaskPriority = DynamicPropertyUtil.getActiveValue(userTask.getPriority(), DynamicBpmnConstants.USER_TASK_PRIORITY, taskElementProperties);
            activeTaskCategory = DynamicPropertyUtil.getActiveValue(userTask.getCategory(), DynamicBpmnConstants.USER_TASK_CATEGORY, taskElementProperties);
            activeTaskFormKey = DynamicPropertyUtil.getActiveValue(userTask.getFormKey(), DynamicBpmnConstants.USER_TASK_FORM_KEY, taskElementProperties);
            activeTaskSkipExpression = DynamicPropertyUtil.getActiveValue(userTask.getSkipExpression(), DynamicBpmnConstants.TASK_SKIP_EXPRESSION, taskElementProperties);
            activeTaskAssignee = DynamicPropertyUtil.getActiveValue(userTask.getAssignee(), DynamicBpmnConstants.USER_TASK_ASSIGNEE, taskElementProperties);
            activeTaskOwner = DynamicPropertyUtil.getActiveValue(userTask.getOwner(), DynamicBpmnConstants.USER_TASK_OWNER, taskElementProperties);
            activeTaskCandidateUsers = getActiveValueList(userTask.getCandidateUsers(), DynamicBpmnConstants.USER_TASK_CANDIDATE_USERS, taskElementProperties);
            activeTaskCandidateGroups = getActiveValueList(userTask.getCandidateGroups(), DynamicBpmnConstants.USER_TASK_CANDIDATE_GROUPS, taskElementProperties);

        } else {
            activeTaskName = userTask.getName();
            activeTaskDescription = userTask.getDocumentation();
            activeTaskDueDate = userTask.getDueDate();
            activeTaskPriority = userTask.getPriority();
            activeTaskCategory = userTask.getCategory();
            activeTaskFormKey = userTask.getFormKey();
            activeTaskSkipExpression = userTask.getSkipExpression();
            activeTaskAssignee = userTask.getAssignee();
            activeTaskOwner = userTask.getOwner();
            activeTaskCandidateUsers = userTask.getCandidateUsers();
            activeTaskCandidateGroups = userTask.getCandidateGroups();
        }

        CreateUserTaskBeforeContext beforeContext = new CreateUserTaskBeforeContext(userTask, execution, activeTaskName, activeTaskDescription, activeTaskDueDate,
                        activeTaskPriority, activeTaskCategory, activeTaskFormKey, activeTaskSkipExpression, activeTaskAssignee, activeTaskOwner,
                        activeTaskCandidateUsers, activeTaskCandidateGroups);

        if (processEngineConfiguration.getCreateUserTaskInterceptor() !is null) {
            processEngineConfiguration.getCreateUserTaskInterceptor().beforeCreateUserTask(beforeContext);
        }

        if (StringUtils.isNotEmpty(beforeContext.getName())) {
            string name = null;
            try {
                Object nameValue = expressionManager.createExpression(beforeContext.getName()).getValue(execution);
                if (nameValue !is null) {
                    name = nameValue.toString();
                }
            } catch (FlowableException e) {
                name = beforeContext.getName();
                LOGGER.warn("property not found in task name expression {}", e.getMessage());
            }
            task.setName(name);
        }

        if (StringUtils.isNotEmpty(beforeContext.getDescription())) {
            string description = null;
            try {
                Object descriptionValue = expressionManager.createExpression(beforeContext.getDescription()).getValue(execution);
                if (descriptionValue !is null) {
                    description = descriptionValue.toString();
                }
            } catch (FlowableException e) {
                description = beforeContext.getDescription();
                LOGGER.warn("property not found in task description expression {}", e.getMessage());
            }
            task.setDescription(description);
        }

        if (StringUtils.isNotEmpty(beforeContext.getDueDate())) {
            Object dueDate = expressionManager.createExpression(beforeContext.getDueDate()).getValue(execution);
            if (dueDate !is null) {
                if (dueDate instanceof Date) {
                    task.setDueDate((Date) dueDate);
                } else if (dueDate instanceof string) {
                    string businessCalendarName = null;
                    if (StringUtils.isNotEmpty(userTask.getBusinessCalendarName())) {
                        businessCalendarName = expressionManager.createExpression(userTask.getBusinessCalendarName()).getValue(execution).toString();
                    } else {
                        businessCalendarName = DueDateBusinessCalendar.NAME;
                    }

                    BusinessCalendar businessCalendar = CommandContextUtil.getProcessEngineConfiguration(commandContext).getBusinessCalendarManager()
                            .getBusinessCalendar(businessCalendarName);
                    task.setDueDate(businessCalendar.resolveDuedate((string) dueDate));

                } else {
                    throw new FlowableIllegalArgumentException("Due date expression does not resolve to a Date or Date string: " + activeTaskDueDate);
                }
            }
        }

        if (StringUtils.isNotEmpty(beforeContext.getPriority())) {
            final Object priority = expressionManager.createExpression(beforeContext.getPriority()).getValue(execution);
            if (priority !is null) {
                if (priority instanceof string) {
                    try {
                        task.setPriority(Integer.valueOf((string) priority));
                    } catch (NumberFormatException e) {
                        throw new FlowableIllegalArgumentException("Priority does not resolve to a number: " + priority, e);
                    }
                } else if (priority instanceof Number) {
                    task.setPriority(((Number) priority).intValue());
                } else {
                    throw new FlowableIllegalArgumentException("Priority expression does not resolve to a number: " + activeTaskPriority);
                }
            }
        }

        if (StringUtils.isNotEmpty(beforeContext.getCategory())) {
            string category = null;
            try {
                Object categoryValue = expressionManager.createExpression(beforeContext.getCategory()).getValue(execution);
                if (categoryValue !is null) {
                    category = categoryValue.toString();
                }
            }  catch (FlowableException e) {
                category = beforeContext.getCategory();
                LOGGER.warn("property not found in task category expression {}", e.getMessage());
            }
            task.setCategory(category);
        }

        if (StringUtils.isNotEmpty(beforeContext.getFormKey())) {
            string formKey = null;
            try {
                Object formKeyValue = expressionManager.createExpression(beforeContext.getFormKey()).getValue(execution);
                if (formKeyValue !is null) {
                    formKey = formKeyValue.toString();
                }
            } catch (FlowableException e) {
                formKey = beforeContext.getFormKey();
                LOGGER.warn("property not found in task formKey expression {}", e.getMessage());
            }
            task.setFormKey(formKey);
        }

        bool skipUserTask = SkipExpressionUtil.isSkipExpressionEnabled(beforeContext.getSkipExpression(), userTask.getId(), execution, commandContext)
                    && SkipExpressionUtil.shouldSkipFlowElement(beforeContext.getSkipExpression(), userTask.getId(), execution, commandContext);

        TaskHelper.insertTask(task, (ExecutionEntity) execution, !skipUserTask, (!skipUserTask && processEngineConfiguration.isEnableEntityLinks()));

        // Handling assignments need to be done after the task is inserted, to have an id
        if (!skipUserTask) {
            if (processEngineConfiguration.isLoggingSessionEnabled()) {
                BpmnLoggingSessionUtil.addLoggingData(LoggingSessionConstants.TYPE_USER_TASK_CREATE, "User task '" +
                                task.getName() + "' created", task, execution);
            }

            handleAssignments(taskService, beforeContext.getAssignee(), beforeContext.getOwner(), beforeContext.getCandidateUsers(),
                            beforeContext.getCandidateGroups(), task, expressionManager, execution, processEngineConfiguration);

            if (processEngineConfiguration.getCreateUserTaskInterceptor() !is null) {
                CreateUserTaskAfterContext afterContext = new CreateUserTaskAfterContext(userTask, task, execution);
                processEngineConfiguration.getCreateUserTaskInterceptor().afterCreateUserTask(afterContext);
            }

            processEngineConfiguration.getListenerNotificationHelper().executeTaskListeners(task, TaskListener.EVENTNAME_CREATE);

            // All properties set, now firing 'create' events
            FlowableEventDispatcher eventDispatcher = CommandContextUtil.getTaskServiceConfiguration(commandContext).getEventDispatcher();
            if (eventDispatcher !is null  && eventDispatcher.isEnabled()) {
                eventDispatcher.dispatchEvent(
                        FlowableTaskEventBuilder.createEntityEvent(FlowableEngineEventType.TASK_CREATED, task));
            }

        } else {
            TaskHelper.deleteTask(task, null, false, false, false); // false: no events fired for skipped user task
            leave(execution);
        }

    }

    @Override
    public void trigger(DelegateExecution execution, string signalName, Object signalData) {
        List<TaskEntity> taskEntities = CommandContextUtil.getTaskService().findTasksByExecutionId(execution.getId()); // Should be only one
        for (TaskEntity taskEntity : taskEntities) {
            if (!taskEntity.isDeleted()) {
                throw new FlowableException("UserTask should not be signalled before complete");
            }
        }

        leave(execution);
    }

    @SuppressWarnings({ "unchecked", "rawtypes" })
    protected void handleAssignments(TaskService taskService, string assignee, string owner, List!string candidateUsers,
            List!string candidateGroups, TaskEntity task, ExpressionManager expressionManager, DelegateExecution execution,
            ProcessEngineConfigurationImpl processEngineConfiguration) {

        if (StringUtils.isNotEmpty(assignee)) {
            Object assigneeExpressionValue = expressionManager.createExpression(assignee).getValue(execution);
            string assigneeValue = null;
            if (assigneeExpressionValue !is null) {
                assigneeValue = assigneeExpressionValue.toString();
            }

            if (StringUtils.isNotEmpty(assigneeValue)) {
                TaskHelper.changeTaskAssignee(task, assigneeValue);
                if (processEngineConfiguration.isLoggingSessionEnabled()) {
                    ObjectNode loggingNode = BpmnLoggingSessionUtil.fillBasicTaskLoggingData("Set task assignee value to " + assigneeValue, task, execution);
                    loggingNode.put("taskAssignee", assigneeValue);
                    LoggingSessionUtil.addLoggingData(LoggingSessionConstants.TYPE_USER_TASK_SET_ASSIGNEE, loggingNode);
                }
            }
        }

        if (StringUtils.isNotEmpty(owner)) {
            Object ownerExpressionValue = expressionManager.createExpression(owner).getValue(execution);
            string ownerValue = null;
            if (ownerExpressionValue !is null) {
                ownerValue = ownerExpressionValue.toString();
            }

            if (StringUtils.isNotEmpty(ownerValue)) {
                TaskHelper.changeTaskOwner(task, ownerValue);
                if (processEngineConfiguration.isLoggingSessionEnabled()) {
                    ObjectNode loggingNode = BpmnLoggingSessionUtil.fillBasicTaskLoggingData("Set task owner value to " + ownerValue, task, execution);
                    loggingNode.put("taskOwner", ownerValue);
                    LoggingSessionUtil.addLoggingData(LoggingSessionConstants.TYPE_USER_TASK_SET_OWNER, loggingNode);
                }
            }
        }

        if (candidateGroups !is null && !candidateGroups.isEmpty()) {
            List<IdentityLinkEntity> allIdentityLinkEntities = new ArrayList<>();
            for (string candidateGroup : candidateGroups) {
                Expression groupIdExpr = expressionManager.createExpression(candidateGroup);
                Object value = groupIdExpr.getValue(execution);
                if (value !is null) {
                    List<IdentityLinkEntity> identityLinkEntities = null;
                    if (value instanceof Collection) {
                        identityLinkEntities = CommandContextUtil.getIdentityLinkService().addCandidateGroups(task.getId(), (Collection) value);

                    } else {
                        string strValue = value.toString();
                        if (StringUtils.isNotEmpty(strValue)) {
                            List!string candidates = extractCandidates(strValue);
                            identityLinkEntities = CommandContextUtil.getIdentityLinkService().addCandidateGroups(task.getId(), candidates);
                        }
                    }

                    if (identityLinkEntities !is null && !identityLinkEntities.isEmpty()) {
                        IdentityLinkUtil.handleTaskIdentityLinkAdditions(task, identityLinkEntities);
                        allIdentityLinkEntities.addAll(identityLinkEntities);
                    }
                }
            }

            if (!allIdentityLinkEntities.isEmpty()) {
                if (processEngineConfiguration.isLoggingSessionEnabled()) {
                    BpmnLoggingSessionUtil.addTaskIdentityLinkData(LoggingSessionConstants.TYPE_USER_TASK_SET_GROUP_IDENTITY_LINKS,
                                    "Added " + allIdentityLinkEntities.size() + " candidate group identity links to task", false,
                                    allIdentityLinkEntities, task, execution);
                }
            }
        }

        if (candidateUsers !is null && !candidateUsers.isEmpty()) {
            List<IdentityLinkEntity> allIdentityLinkEntities = new ArrayList<>();
            for (string candidateUser : candidateUsers) {
                Expression userIdExpr = expressionManager.createExpression(candidateUser);
                Object value = userIdExpr.getValue(execution);
                if (value !is null) {
                    List<IdentityLinkEntity> identityLinkEntities = null;
                    if (value instanceof Collection) {
                        identityLinkEntities = CommandContextUtil.getIdentityLinkService().addCandidateUsers(task.getId(), (Collection) value);

                    } else {
                        string strValue = value.toString();
                        if (StringUtils.isNotEmpty(strValue)) {
                            List!string candidates = extractCandidates(strValue);
                            identityLinkEntities = CommandContextUtil.getIdentityLinkService().addCandidateUsers(task.getId(), candidates);
                        }
                    }

                    if (identityLinkEntities !is null && !identityLinkEntities.isEmpty()) {
                        IdentityLinkUtil.handleTaskIdentityLinkAdditions(task, identityLinkEntities);
                        allIdentityLinkEntities.addAll(identityLinkEntities);
                    }
                }
            }

            if (!allIdentityLinkEntities.isEmpty()) {
                if (processEngineConfiguration.isLoggingSessionEnabled()) {
                    BpmnLoggingSessionUtil.addTaskIdentityLinkData(LoggingSessionConstants.TYPE_USER_TASK_SET_USER_IDENTITY_LINKS,
                                    "Added " + allIdentityLinkEntities.size() + " candidate user identity links to task", true,
                                    allIdentityLinkEntities, task, execution);
                }
            }
        }

        if (userTask.getCustomUserIdentityLinks() !is null && !userTask.getCustomUserIdentityLinks().isEmpty()) {

            List<IdentityLinkEntity> customIdentityLinkEntities = new ArrayList<>();
            for (string customUserIdentityLinkType : userTask.getCustomUserIdentityLinks().keySet()) {
                for (string userIdentityLink : userTask.getCustomUserIdentityLinks().get(customUserIdentityLinkType)) {
                    Expression idExpression = expressionManager.createExpression(userIdentityLink);
                    Object value = idExpression.getValue(execution);

                    if (value instanceof Collection) {
                        Iterator userIdSet = ((Collection) value).iterator();
                        while (userIdSet.hasNext()) {
                            IdentityLinkEntity identityLinkEntity = CommandContextUtil.getIdentityLinkService().createTaskIdentityLink(
                                            task.getId(), userIdSet.next().toString(), null, customUserIdentityLinkType);
                            IdentityLinkUtil.handleTaskIdentityLinkAddition(task, identityLinkEntity);
                            customIdentityLinkEntities.add(identityLinkEntity);
                        }

                    } else {
                        List!string userIds = extractCandidates(value.toString());
                        for (string userId : userIds) {
                            IdentityLinkEntity identityLinkEntity = CommandContextUtil.getIdentityLinkService().createTaskIdentityLink(task.getId(), userId, null, customUserIdentityLinkType);
                            IdentityLinkUtil.handleTaskIdentityLinkAddition(task, identityLinkEntity);
                            customIdentityLinkEntities.add(identityLinkEntity);
                        }
                    }
                }
            }

            if (!customIdentityLinkEntities.isEmpty()) {
                if (processEngineConfiguration.isLoggingSessionEnabled()) {
                    BpmnLoggingSessionUtil.addTaskIdentityLinkData(LoggingSessionConstants.TYPE_USER_TASK_SET_USER_IDENTITY_LINKS,
                                    "Added " + customIdentityLinkEntities.size() + " custom user identity links to task", true,
                                    customIdentityLinkEntities, task, execution);
                }
            }
        }

        if (userTask.getCustomGroupIdentityLinks() !is null && !userTask.getCustomGroupIdentityLinks().isEmpty()) {

            List<IdentityLinkEntity> customIdentityLinkEntities = new ArrayList<>();
            for (string customGroupIdentityLinkType : userTask.getCustomGroupIdentityLinks().keySet()) {
                for (string groupIdentityLink : userTask.getCustomGroupIdentityLinks().get(customGroupIdentityLinkType)) {

                    Expression idExpression = expressionManager.createExpression(groupIdentityLink);
                    Object value = idExpression.getValue(execution);

                    if (value instanceof Collection) {
                        Iterator groupIdSet = ((Collection) value).iterator();
                        while (groupIdSet.hasNext()) {
                            IdentityLinkEntity identityLinkEntity = CommandContextUtil.getIdentityLinkService().createTaskIdentityLink(
                                            task.getId(), null, groupIdSet.next().toString(), customGroupIdentityLinkType);
                            IdentityLinkUtil.handleTaskIdentityLinkAddition(task, identityLinkEntity);
                            customIdentityLinkEntities.add(identityLinkEntity);
                        }

                    } else {
                        List!string groupIds = extractCandidates(value.toString());
                        for (string groupId : groupIds) {
                            IdentityLinkEntity identityLinkEntity = CommandContextUtil.getIdentityLinkService().createTaskIdentityLink(
                                            task.getId(), null, groupId, customGroupIdentityLinkType);
                            IdentityLinkUtil.handleTaskIdentityLinkAddition(task, identityLinkEntity);
                            customIdentityLinkEntities.add(identityLinkEntity);
                        }
                    }
                }
            }

            if (!customIdentityLinkEntities.isEmpty()) {
                if (processEngineConfiguration.isLoggingSessionEnabled()) {
                    BpmnLoggingSessionUtil.addTaskIdentityLinkData(LoggingSessionConstants.TYPE_USER_TASK_SET_GROUP_IDENTITY_LINKS,
                                    "Added " + customIdentityLinkEntities.size() + " custom group identity links to task", false,
                                    customIdentityLinkEntities, task, execution);
                }
            }
        }

    }

    /**
     * Extract a candidate list from a string.
     *
     * @param str
     * @return
     */
    protected List!string extractCandidates(string str) {
        return Arrays.asList(str.split("[\\s]*,[\\s]*"));
    }
}
