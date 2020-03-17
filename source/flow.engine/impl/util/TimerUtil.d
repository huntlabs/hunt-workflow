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


import java.time.Duration;
import java.time.Instant;
import hunt.time.LocalDateTime;

import org.apache.commons.lang3.StringUtils;
import flow.bpmn.model.BoundaryEvent;
import flow.bpmn.model.BpmnModel;
import flow.bpmn.model.Event;
import flow.bpmn.model.FlowElement;
import flow.bpmn.model.IntermediateCatchEvent;
import flow.bpmn.model.TimerEventDefinition;
import flow.common.api.FlowableException;
import flow.common.api.deleg.Expression;
import flow.common.api.deleg.event.FlowableEngineEventType;
import flow.common.api.deleg.event.FlowableEventDispatcher;
import flow.common.calendar.BusinessCalendar;
import flow.common.calendar.CycleBusinessCalendar;
import flow.common.calendar.DueDateBusinessCalendar;
import flow.common.calendar.DurationBusinessCalendar;
import flow.common.el.ExpressionManager;
import flow.common.runtime.Clock;
import flow.engine.deleg.event.impl.FlowableEventBuilder;
import flow.engine.impl.cfg.ProcessEngineConfigurationImpl;
import flow.engine.impl.jobexecutor.TimerEventHandler;
import flow.engine.impl.persistence.entity.ExecutionEntity;
import flow.job.service.TimerJobService;
import flow.job.service.event.impl.FlowableJobEventBuilder;
import flow.job.service.impl.persistence.entity.JobEntity;
import flow.job.service.impl.persistence.entity.TimerJobEntity;
import flow.variable.service.api.deleg.VariableScope;
import flow.variable.service.impl.el.NoExecutionVariableScope;
import org.joda.time.DateTime;
import org.joda.time.DateTimeZone;
import org.joda.time.format.DateTimeFormatter;
import org.joda.time.format.ISODateTimeFormat;

/**
 * @author Joram Barrez
 */
class TimerUtil {

    /**
     * The event definition on which the timer is based.
     *
     * Takes in an optional execution, if missing the {@link NoExecutionVariableScope} will be used (eg Timer start event)
     */
    public static TimerJobEntity createTimerEntityForTimerEventDefinition(TimerEventDefinition timerEventDefinition, bool isInterruptingTimer,
            ExecutionEntity executionEntity, string jobHandlerType, string jobHandlerConfig) {

        ProcessEngineConfigurationImpl processEngineConfiguration = CommandContextUtil.getProcessEngineConfiguration();

        string businessCalendarRef = null;
        Expression expression = null;
        ExpressionManager expressionManager = processEngineConfiguration.getExpressionManager();

        // ACT-1415: timer-declaration on start-event may contain expressions NOT
        // evaluating variables but other context, evaluating should happen nevertheless
        VariableScope scopeForExpression = executionEntity;
        if (scopeForExpression is null) {
            scopeForExpression = NoExecutionVariableScope.getSharedInstance();
        }

        if (StringUtils.isNotEmpty(timerEventDefinition.getTimeDate())) {

            businessCalendarRef = DueDateBusinessCalendar.NAME;
            expression = expressionManager.createExpression(timerEventDefinition.getTimeDate());

        } else if (StringUtils.isNotEmpty(timerEventDefinition.getTimeCycle())) {

            businessCalendarRef = CycleBusinessCalendar.NAME;
            expression = expressionManager.createExpression(timerEventDefinition.getTimeCycle());

        } else if (StringUtils.isNotEmpty(timerEventDefinition.getTimeDuration())) {

            businessCalendarRef = DurationBusinessCalendar.NAME;
            expression = expressionManager.createExpression(timerEventDefinition.getTimeDuration());
        }

        if (StringUtils.isNotEmpty(timerEventDefinition.getCalendarName())) {
            businessCalendarRef = timerEventDefinition.getCalendarName();
            Expression businessCalendarExpression = expressionManager.createExpression(businessCalendarRef);
            businessCalendarRef = businessCalendarExpression.getValue(scopeForExpression).toString();
        }

        if (expression is null) {
            throw new FlowableException("Timer needs configuration (either timeDate, timeCycle or timeDuration is needed) (" + timerEventDefinition.getId() + ")");
        }

        BusinessCalendar businessCalendar = processEngineConfiguration.getBusinessCalendarManager().getBusinessCalendar(businessCalendarRef);

        string dueDateString = null;
        Date duedate = null;

        Object dueDateValue = expression.getValue(scopeForExpression);
        if (dueDateValue instanceof string) {
            dueDateString = (string) dueDateValue;

        } else if (dueDateValue instanceof Date) {
            duedate = (Date) dueDateValue;

        } else if (dueDateValue instanceof DateTime) {
            // JodaTime support
            duedate = ((DateTime) dueDateValue).toDate();

        } else if (dueDateValue instanceof Duration) {
        	dueDateString = ((Duration) dueDateValue).toString();
        } else if (dueDateValue instanceof Instant) {
            duedate = Date.from((Instant) dueDateValue);

        } else if (dueDateValue !is null) {
            throw new FlowableException("Timer '" + executionEntity.getActivityId()
                    + "' was not configured with a valid duration/time, either hand in a java.util.Date or a java.time.Instant or a org.joda.time.DateTime or a string in format 'yyyy-MM-dd'T'hh:mm:ss'");
        }

        if (duedate is null && dueDateString !is null) {
            duedate = businessCalendar.resolveDuedate(dueDateString);
        }

        TimerJobEntity timer = null;
        if (duedate !is null) {
            timer = CommandContextUtil.getTimerJobService().createTimerJob();
            timer.setJobType(JobEntity.JOB_TYPE_TIMER);
            timer.setRevision(1);
            timer.setJobHandlerType(jobHandlerType);
            timer.setJobHandlerConfiguration(jobHandlerConfig);
            timer.setExclusive(true);
            timer.setRetries(processEngineConfiguration.getAsyncExecutorNumberOfRetries());
            timer.setDuedate(duedate);
            if (executionEntity !is null) {
                timer.setExecutionId(executionEntity.getId());
                timer.setProcessDefinitionId(executionEntity.getProcessDefinitionId());
                timer.setProcessInstanceId(executionEntity.getProcessInstanceId());

                // Inherit tenant identifier (if applicable)
                if (executionEntity.getTenantId() !is null) {
                    timer.setTenantId(executionEntity.getTenantId());
                }
            }

        } else {
            throw new FlowableException("Due date could not be determined for timer job " + dueDateString);
        }

        if (StringUtils.isNotEmpty(timerEventDefinition.getTimeCycle())) {
            // See ACT-1427: A boundary timer with a cancelActivity='true', doesn't need to repeat itself
            bool repeat = !isInterruptingTimer;

            // ACT-1951: intermediate catching timer events shouldn't repeat according to spec
            if (executionEntity !is null) {
                FlowElement currentElement = executionEntity.getCurrentFlowElement();
                if (currentElement instanceof IntermediateCatchEvent) {
                    repeat = false;
                }
            }

            if (repeat) {
                string prepared = prepareRepeat(dueDateString);
                timer.setRepeat(prepared);
            }
        }

        if (timer !is null && executionEntity !is null) {
            timer.setExecutionId(executionEntity.getId());
            timer.setProcessDefinitionId(executionEntity.getProcessDefinitionId());
            timer.setProcessInstanceId(executionEntity.getProcessInstanceId());
            timer.setElementId(executionEntity.getCurrentFlowElement().getId());
            timer.setElementName(executionEntity.getCurrentFlowElement().getName());

            // Inherit tenant identifier (if applicable)
            if (executionEntity.getTenantId() !is null) {
                timer.setTenantId(executionEntity.getTenantId());
            }
        }

        return timer;
    }

    public static TimerJobEntity rescheduleTimerJob(string timerJobId, TimerEventDefinition timerEventDefinition) {
        TimerJobService timerJobService = CommandContextUtil.getTimerJobService();
        TimerJobEntity timerJob = timerJobService.findTimerJobById(timerJobId);
        if (timerJob !is null) {
            BpmnModel bpmnModel = ProcessDefinitionUtil.getBpmnModel(timerJob.getProcessDefinitionId());
            Event eventElement = (Event) bpmnModel.getFlowElement(TimerEventHandler.getActivityIdFromConfiguration(timerJob.getJobHandlerConfiguration()));
            bool isInterruptingTimer = false;
            if (eventElement instanceof BoundaryEvent) {
                isInterruptingTimer = ((BoundaryEvent) eventElement).isCancelActivity();
            }

            ExecutionEntity execution = CommandContextUtil.getExecutionEntityManager().findById(timerJob.getExecutionId());
            TimerJobEntity rescheduledTimerJob = TimerUtil.createTimerEntityForTimerEventDefinition(timerEventDefinition, isInterruptingTimer, execution,
                    timerJob.getJobHandlerType(), timerJob.getJobHandlerConfiguration());

            timerJobService.deleteTimerJob(timerJob);
            timerJobService.insertTimerJob(rescheduledTimerJob);

            FlowableEventDispatcher eventDispatcher = CommandContextUtil.getProcessEngineConfiguration().getEventDispatcher();
            if (eventDispatcher !is null && eventDispatcher.isEnabled()) {
                eventDispatcher.dispatchEvent(
                        FlowableEventBuilder.createJobRescheduledEvent(FlowableEngineEventType.JOB_RESCHEDULED, rescheduledTimerJob, timerJob.getId()));

             // job rescheduled event should occur before new timer scheduled event
                eventDispatcher.dispatchEvent(
                                FlowableJobEventBuilder.createEntityEvent(FlowableEngineEventType.TIMER_SCHEDULED, rescheduledTimerJob));
            }

            return rescheduledTimerJob;
        }
        return null;
    }

    public static string prepareRepeat(string dueDate) {
        if (dueDate.startsWith("R") && dueDate.split("/").length == 2) {
            DateTimeFormatter fmt = ISODateTimeFormat.dateTime();
            Clock clock = CommandContextUtil.getProcessEngineConfiguration().getClock();
            Date now = clock.getCurrentTime();
            return dueDate.replace("/", "/" + fmt.print(new DateTime(now,
                    DateTimeZone.forTimeZone(clock.getCurrentTimeZone()))) + "/");
        }
        return dueDate;
    }

}
