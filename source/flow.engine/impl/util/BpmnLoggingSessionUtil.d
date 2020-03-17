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


import hunt.time.LocalDateTime;
import hunt.collection.List;

import org.apache.commons.lang3.StringUtils;
import flow.bpmn.model.BoundaryEvent;
import flow.bpmn.model.CancelEventDefinition;
import flow.bpmn.model.CompensateEventDefinition;
import flow.bpmn.model.ConditionalEventDefinition;
import flow.bpmn.model.EscalationEventDefinition;
import flow.bpmn.model.Event;
import flow.bpmn.model.EventDefinition;
import flow.bpmn.model.FlowElement;
import flow.bpmn.model.FlowNode;
import flow.bpmn.model.MessageEventDefinition;
import flow.bpmn.model.SequenceFlow;
import flow.bpmn.model.ServiceTask;
import flow.bpmn.model.SignalEventDefinition;
import flow.bpmn.model.TimerEventDefinition;
import flow.common.api.scop.ScopeTypes;
import flow.common.logging.LoggingSessionConstants;
import flow.common.logging.LoggingSessionUtil;
import flow.engine.deleg.DelegateExecution;
import flow.engine.impl.bpmn.behavior.ServiceTaskDelegateExpressionActivityBehavior;
import flow.engine.impl.bpmn.behavior.ServiceTaskExpressionActivityBehavior;
import flow.engine.impl.bpmn.helper.ClassDelegate;
import flow.engine.impl.deleg.ActivityBehavior;
import flow.engine.impl.persistence.entity.ExecutionEntity;
import flow.engine.repository.ProcessDefinition;
import flow.identitylink.service.impl.persistence.entity.IdentityLinkEntity;
import flow.job.service.impl.persistence.entity.JobEntity;
import flow.task.service.impl.persistence.entity.TaskEntity;

import com.fasterxml.jackson.databind.node.ArrayNode;
import com.fasterxml.jackson.databind.node.ObjectNode;

class BpmnLoggingSessionUtil {

    public static void addLoggingData(string type, string message, DelegateExecution execution) {
        FlowElement flowElement = execution.getCurrentFlowElement();
        string activityId = null;
        string activityName = null;
        string activityType = null;
        string activitySubType = null;
        if (flowElement !is null) {
            activityId = flowElement.getId();
            activityName = flowElement.getName();
            activityType = flowElement.getClass().getSimpleName();
            activitySubType = getActivitySubType(flowElement);
        }

        ObjectNode loggingNode = LoggingSessionUtil.fillLoggingData(message, execution.getProcessInstanceId(), execution.getId(),
                        ScopeTypes.BPMN, execution.getProcessDefinitionId(), activityId, activityName, activityType, activitySubType);
        fillScopeDefinitionInfo(execution.getProcessDefinitionId(), loggingNode);
        LoggingSessionUtil.addLoggingData(type, loggingNode);
    }

    public static void addLoggingData(string type, string message, TaskEntity task, DelegateExecution execution) {
        ObjectNode loggingNode = LoggingSessionUtil.fillLoggingData(message, task.getProcessInstanceId(), task.getExecutionId(), ScopeTypes.BPMN);
        loggingNode.put("scopeDefinitionId", execution.getProcessDefinitionId());
        loggingNode.put("taskId", task.getId());
        putIfNotNull("taskName", task.getName(), loggingNode);
        putIfNotNull("taskCategory", task.getCategory(), loggingNode);
        putIfNotNull("taskFormKey", task.getFormKey(), loggingNode);
        putIfNotNull("taskDescription", task.getDescription(), loggingNode);
        putIfNotNull("taskDueDate", task.getDueDate(), loggingNode);
        putIfNotNull("taskPriority", task.getPriority(), loggingNode);

        fillScopeDefinitionInfo(execution.getProcessDefinitionId(), loggingNode);
        fillFlowElementInfo(loggingNode, execution);

        LoggingSessionUtil.addLoggingData(type, loggingNode);
    }

    public static void addExecuteActivityBehaviorLoggingData(string type, ActivityBehavior activityBehavior, FlowNode flowNode, ExecutionEntity execution) {
        string message = "In " + flowNode.getClass().getSimpleName() + ", executing " + activityBehavior.getClass().getSimpleName();

        ObjectNode loggingNode = LoggingSessionUtil.fillLoggingData(message, execution.getProcessInstanceId(), execution.getId(), ScopeTypes.BPMN);
        loggingNode.put("scopeDefinitionId", execution.getProcessDefinitionId());
        loggingNode.put("elementId", flowNode.getId());
        putIfNotNull("elementName", flowNode.getName(), loggingNode);
        loggingNode.put("elementType", flowNode.getClass().getSimpleName());
        putIfNotNull("elementSubType", getActivitySubType(flowNode), loggingNode);
        loggingNode.put("activityBehavior", activityBehavior.getClass().getSimpleName());

        fillScopeDefinitionInfo(execution.getProcessDefinitionId(), loggingNode);

        LoggingSessionUtil.addLoggingData(type, loggingNode);
    }

    public static void addAsyncActivityLoggingData(string message, string type, JobEntity jobEntity, FlowElement flowElement, ExecutionEntity execution) {
        ObjectNode loggingNode = LoggingSessionUtil.fillLoggingData(message, execution.getProcessInstanceId(), execution.getId(), ScopeTypes.BPMN);
        loggingNode.put("scopeDefinitionId", execution.getProcessDefinitionId());
        loggingNode.put("elementId", flowElement.getId());
        putIfNotNull("elementName", flowElement.getName(), loggingNode);
        loggingNode.put("elementType", flowElement.getClass().getSimpleName());
        putIfNotNull("elementSubType", getActivitySubType(flowElement), loggingNode);
        loggingNode.put("jobId", jobEntity.getId());

        fillScopeDefinitionInfo(execution.getProcessDefinitionId(), loggingNode);

        LoggingSessionUtil.addLoggingData(type, loggingNode);
    }

    public static void addSequenceFlowLoggingData(string type, ExecutionEntity execution) {
        string message = null;
        FlowElement flowElement = execution.getCurrentFlowElement();
        SequenceFlow sequenceFlow = null;
        if (flowElement !is null && flowElement instanceof SequenceFlow) {
            sequenceFlow = (SequenceFlow) flowElement;
            string sequenceFlowId = "";
            if (sequenceFlow.getId() !is null) {
                sequenceFlowId = sequenceFlow.getId() + ", ";
            }
            message = "Sequence flow will be taken for " + sequenceFlowId + sequenceFlow.getSourceRef() + " --> " + sequenceFlow.getTargetRef();
        } else {
            message = "Sequence flow will be taken";
        }

        ObjectNode loggingNode = LoggingSessionUtil.fillLoggingData(message, execution.getProcessInstanceId(), execution.getId(), ScopeTypes.BPMN);
        loggingNode.put("scopeDefinitionId", execution.getProcessDefinitionId());
        if (sequenceFlow !is null) {
            putIfNotNull("elementId", sequenceFlow.getId(), loggingNode);
            putIfNotNull("elementName", sequenceFlow.getName(), loggingNode);
            loggingNode.put("elementType", sequenceFlow.getClass().getSimpleName());
            putIfNotNull("sourceRef", sequenceFlow.getSourceRef(), loggingNode);
            putIfNotNull("targetRef", sequenceFlow.getTargetRef(), loggingNode);
        }

        fillScopeDefinitionInfo(execution.getProcessDefinitionId(), loggingNode);

        LoggingSessionUtil.addLoggingData(type, loggingNode);
    }

    public static ObjectNode fillBasicTaskLoggingData(string message, TaskEntity task, DelegateExecution execution) {
        ObjectNode loggingNode = LoggingSessionUtil.fillLoggingData(message, task.getProcessInstanceId(), task.getExecutionId(), ScopeTypes.BPMN);
        loggingNode.put("scopeDefinitionId", execution.getProcessDefinitionId());
        loggingNode.put("taskId", task.getId());
        putIfNotNull("taskName", task.getName(), loggingNode);

        fillScopeDefinitionInfo(execution.getProcessDefinitionId(), loggingNode);
        fillFlowElementInfo(loggingNode, execution);

        return loggingNode;
    }

    public static void addErrorLoggingData(string type, string message, Throwable t, DelegateExecution execution) {
        FlowElement flowElement = execution.getCurrentFlowElement();
        string activityId = null;
        string activityName = null;
        string activityType = null;
        string activitySubType = null;
        if (flowElement !is null) {
            activityId = flowElement.getId();
            activityName = flowElement.getName();
            activityType = flowElement.getClass().getSimpleName();
            activitySubType = getActivitySubType(flowElement);
        }

        ObjectNode loggingNode = LoggingSessionUtil.fillLoggingData(message, execution.getProcessInstanceId(), execution.getId(),
                        ScopeTypes.BPMN, execution.getProcessDefinitionId(), activityId, activityName, activityType, activitySubType);
        fillScopeDefinitionInfo(execution.getProcessDefinitionId(), loggingNode);
        LoggingSessionUtil.addErrorLoggingData(type, loggingNode, t);
    }

    public static void fillLoggingData(ObjectNode loggingNode, ExecutionEntity executionEntity) {
        loggingNode.put("scopeDefinitionId", executionEntity.getProcessDefinitionId());

        fillScopeDefinitionInfo(executionEntity.getProcessDefinitionId(), loggingNode);

        FlowElement flowElement = executionEntity.getCurrentFlowElement();
        if (flowElement is null) {
            flowElement = executionEntity.getOriginatingCurrentFlowElement();
        }

        if (flowElement !is null) {
            loggingNode.put("elementId", flowElement.getId());
            putIfNotNull("elementName", flowElement.getName(), loggingNode);
            loggingNode.put("elementType", flowElement.getClass().getSimpleName());
        }
    }

    public static void addTaskIdentityLinkData(string type, string message, bool isUser, List<IdentityLinkEntity> identityLinkEntities,
                    TaskEntity task, DelegateExecution execution) {

        ObjectNode loggingNode = fillBasicTaskLoggingData(message, task, execution);
        ArrayNode identityLinkArray = null;
        if (isUser) {
            identityLinkArray = loggingNode.putArray("taskUserIdentityLinks");
        } else {
            identityLinkArray = loggingNode.putArray("taskGroupIdentityLinks");
        }

        for (IdentityLinkEntity identityLink : identityLinkEntities) {
            ObjectNode identityLinkNode = identityLinkArray.addObject();
            identityLinkNode.put("id", identityLink.getId());
            identityLinkNode.put("type", identityLink.getType());
            if (isUser) {
                identityLinkNode.put("userId", identityLink.getUserId());
            } else {
                identityLinkNode.put("groupId", identityLink.getGroupId());
            }
        }

        LoggingSessionUtil.addLoggingData(type, loggingNode);
    }

    public static string getBoundaryCreateEventType(BoundaryEvent boundaryEvent) {
        List<EventDefinition> eventDefinitions = boundaryEvent.getEventDefinitions();
        if (eventDefinitions !is null && !eventDefinitions.isEmpty()) {
            EventDefinition eventDefinition = eventDefinitions.get(0);
            if (eventDefinition instanceof TimerEventDefinition) {
                return LoggingSessionConstants.TYPE_BOUNDARY_TIMER_EVENT_CREATE;
            } else if (eventDefinition instanceof MessageEventDefinition) {
                return LoggingSessionConstants.TYPE_BOUNDARY_MESSAGE_EVENT_CREATE;
            } else if (eventDefinition instanceof SignalEventDefinition) {
                return LoggingSessionConstants.TYPE_BOUNDARY_SIGNAL_EVENT_CREATE;
            } else if (eventDefinition instanceof CancelEventDefinition) {
                return LoggingSessionConstants.TYPE_BOUNDARY_CANCEL_EVENT_CREATE;
            } else if (eventDefinition instanceof CompensateEventDefinition) {
                return LoggingSessionConstants.TYPE_BOUNDARY_COMPENSATE_EVENT_CREATE;
            } else if (eventDefinition instanceof ConditionalEventDefinition) {
                return LoggingSessionConstants.TYPE_BOUNDARY_CONDITIONAL_EVENT_CREATE;
            } else if (eventDefinition instanceof EscalationEventDefinition) {
                return LoggingSessionConstants.TYPE_BOUNDARY_ESCALATION_EVENT_CREATE;
            }
        }

        return LoggingSessionConstants.TYPE_BOUNDARY_EVENT_CREATE;
    }

    public static string getBoundaryEventType(BoundaryEvent boundaryEvent) {
        List<EventDefinition> eventDefinitions = boundaryEvent.getEventDefinitions();
        if (eventDefinitions !is null && !eventDefinitions.isEmpty()) {
            EventDefinition eventDefinition = eventDefinitions.get(0);
            return eventDefinition.getClass().getSimpleName();
        }

        return "unknown";
    }

    protected static string getActivitySubType(FlowElement flowElement) {
        string activitySubType = null;
        if (flowElement instanceof Event) {
            Event event = (Event) flowElement;
            List<EventDefinition> eventDefinitions = event.getEventDefinitions();
            if (eventDefinitions !is null && !eventDefinitions.isEmpty()) {
                EventDefinition eventDefinition = eventDefinitions.get(0);
                activitySubType = eventDefinition.getClass().getSimpleName();
            }

        } else if (flowElement instanceof ServiceTask) {
            ServiceTask serviceTask = (ServiceTask) flowElement;
            if (serviceTask.getBehavior() !is null && serviceTask.getBehavior() instanceof ClassDelegate) {
                ClassDelegate classDelegate = (ClassDelegate) serviceTask.getBehavior();
                activitySubType = classDelegate.getClassName();

            } else if (serviceTask.getBehavior() !is null && serviceTask.getBehavior() instanceof ServiceTaskExpressionActivityBehavior) {
                activitySubType = serviceTask.getImplementation();

            } else if (serviceTask.getBehavior() !is null && serviceTask.getBehavior() instanceof ServiceTaskDelegateExpressionActivityBehavior) {
                activitySubType = serviceTask.getImplementation();
            }
        }

        return activitySubType;
    }

    protected static void fillScopeDefinitionInfo(string processDefinitionId, ObjectNode loggingNode) {
        ProcessDefinition processDefinition = ProcessDefinitionUtil.getProcessDefinition(processDefinitionId);
        loggingNode.put("scopeDefinitionKey", processDefinition.getKey());
        loggingNode.put("scopeDefinitionName", processDefinition.getName());
    }

    protected static void fillFlowElementInfo(ObjectNode loggingNode, DelegateExecution execution) {
        FlowElement flowElement = execution.getCurrentFlowElement();

        if (flowElement !is null) {
            loggingNode.put("elementId", flowElement.getId());
            putIfNotNull("elementName", flowElement.getName(), loggingNode);
            loggingNode.put("elementType", flowElement.getClass().getSimpleName());
        }
    }

    protected static void putIfNotNull(string name, string value, ObjectNode loggingNode) {
        if (StringUtils.isNotEmpty(value)) {
            loggingNode.put(name, value);
        }
    }

    protected static void putIfNotNull(string name, Integer value, ObjectNode loggingNode) {
        if (value !is null) {
            loggingNode.put(name, value);
        }
    }

    protected static void putIfNotNull(string name, Date value, ObjectNode loggingNode) {
        if (value !is null) {
            loggingNode.put(name, LoggingSessionUtil.formatDate(value));
        }
    }
}
