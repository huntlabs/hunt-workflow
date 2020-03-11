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



import java.util.Arrays;
import java.util.Date;
import hunt.collection.List;

import org.apache.commons.lang3.StringUtils;
import flow.bpmn.model.Event;
import flow.bpmn.model.EventDefinition;
import flow.bpmn.model.FlowElement;
import flow.bpmn.model.TimerEventDefinition;
import flow.common.api.FlowableException;
import flow.common.api.deleg.Expression;
import flow.common.calendar.BusinessCalendar;
import flow.common.calendar.CycleBusinessCalendar;
import flow.common.logging.LoggingSessionConstants;
import flow.engine.impl.jobexecutor.TimerEventHandler;
import flow.engine.impl.jobexecutor.TimerStartEventJobHandler;
import flow.engine.impl.jobexecutor.TriggerTimerEventJobHandler;
import flow.engine.impl.persistence.CountingExecutionEntity;
import flow.engine.impl.persistence.entity.ExecutionEntity;
import flow.engine.impl.persistence.entity.ExecutionEntityManager;
import flow.engine.impl.util.BpmnLoggingSessionUtil;
import flow.engine.impl.util.CommandContextUtil;
import flow.engine.impl.util.CountingEntityUtil;
import flow.engine.impl.util.ProcessDefinitionUtil;
import org.flowable.job.api.Job;
import org.flowable.job.service.InternalJobManager;
import org.flowable.job.service.impl.persistence.entity.AbstractRuntimeJobEntity;
import org.flowable.job.service.impl.persistence.entity.DeadLetterJobEntity;
import org.flowable.job.service.impl.persistence.entity.JobEntity;
import org.flowable.job.service.impl.persistence.entity.SuspendedJobEntity;
import org.flowable.job.service.impl.persistence.entity.TimerJobEntity;
import org.flowable.variable.api.delegate.VariableScope;

/**
 * @author Tijs Rademakers
 */
class DefaultInternalJobManager implements InternalJobManager {

    protected ProcessEngineConfigurationImpl processEngineConfiguration;

    public DefaultInternalJobManager(ProcessEngineConfigurationImpl processEngineConfiguration) {
        this.processEngineConfiguration = processEngineConfiguration;
    }

    @Override
    public VariableScope resolveVariableScope(Job job) {
        if (job.getExecutionId() !is null) {
            return getExecutionEntityManager().findById(job.getExecutionId());
        }
        return null;
    }

    @Override
    public bool handleJobInsert(Job job) {
        // add link to execution
        if (job.getExecutionId() !is null) {
            ExecutionEntity execution = getExecutionEntityManager().findById(job.getExecutionId());
            if (execution !is null) {

                // Inherit tenant if (if applicable)
                if (execution.getTenantId() !is null) {
                    ((AbstractRuntimeJobEntity) job).setTenantId(execution.getTenantId());
                }

                CountingExecutionEntity countingExecutionEntity = (CountingExecutionEntity) execution;

                if (job instanceof TimerJobEntity) {
                    TimerJobEntity timerJobEntity = (TimerJobEntity) job;
                    execution.getTimerJobs().add(timerJobEntity);

                    if (CountingEntityUtil.isExecutionRelatedEntityCountEnabled(execution)) {
                        countingExecutionEntity.setTimerJobCount(countingExecutionEntity.getTimerJobCount() + 1);
                    }

                } else if (job instanceof JobEntity) {
                    JobEntity jobEntity = (JobEntity) job;
                    execution.getJobs().add(jobEntity);

                    if (CountingEntityUtil.isExecutionRelatedEntityCountEnabled(execution)) {
                        countingExecutionEntity.setJobCount(countingExecutionEntity.getJobCount() + 1);
                    }

                } else {
                    if (CountingEntityUtil.isExecutionRelatedEntityCountEnabled(execution)) {
                        if (job instanceof SuspendedJobEntity) {
                            countingExecutionEntity.setSuspendedJobCount(countingExecutionEntity.getSuspendedJobCount() + 1);
                        } else if (job instanceof DeadLetterJobEntity) {
                            countingExecutionEntity.setDeadLetterJobCount(countingExecutionEntity.getDeadLetterJobCount() + 1);
                        }
                    }
                }

            } else {
                // In case the job has an executionId, but the Execution was not found,
                // it means that for example for a boundary timer event on a user task,
                // the task has been completed and the Execution and job have been removed.
                return false;
            }
        }

        return true;
    }

    @Override
    public void handleJobDelete(Job job) {
        if (job.getExecutionId() !is null && CountingEntityUtil.isExecutionRelatedEntityCountEnabledGlobally()) {
            ExecutionEntity executionEntity = getExecutionEntityManager().findById(job.getExecutionId());
            if (CountingEntityUtil.isExecutionRelatedEntityCountEnabled(executionEntity)) {
                CountingExecutionEntity countingExecutionEntity = (CountingExecutionEntity) executionEntity;
                if (job instanceof JobEntity) {
                    executionEntity.getJobs().remove(job);
                    countingExecutionEntity.setJobCount(countingExecutionEntity.getJobCount() - 1);

                } else if (job instanceof TimerJobEntity) {
                    executionEntity.getTimerJobs().remove(job);
                    countingExecutionEntity.setTimerJobCount(countingExecutionEntity.getTimerJobCount() - 1);

                } else if (job instanceof SuspendedJobEntity) {
                    countingExecutionEntity.setSuspendedJobCount(countingExecutionEntity.getSuspendedJobCount() - 1);

                } else if (job instanceof DeadLetterJobEntity) {
                    countingExecutionEntity.setDeadLetterJobCount(countingExecutionEntity.getDeadLetterJobCount() - 1);
                }
            }
        }
    }

    @Override
    public void lockJobScope(Job job) {
        ExecutionEntityManager executionEntityManager = getExecutionEntityManager();
        ExecutionEntity execution = executionEntityManager.findById(job.getExecutionId());
        if (execution !is null) {
            executionEntityManager.updateProcessInstanceLockTime(execution.getProcessInstanceId());
        }

        if (processEngineConfiguration.isLoggingSessionEnabled()) {
            FlowElement flowElement = execution.getCurrentFlowElement();
            BpmnLoggingSessionUtil.addAsyncActivityLoggingData("Locking job for " + flowElement.getId() + ", with job id " + job.getId(),
                            LoggingSessionConstants.TYPE_SERVICE_TASK_LOCK_JOB, (JobEntity) job, flowElement, execution);
        }
    }

    @Override
    public void clearJobScopeLock(Job job) {
        ExecutionEntityManager executionEntityManager = getExecutionEntityManager();
        ExecutionEntity execution = executionEntityManager.findById(job.getProcessInstanceId());
        if (execution !is null) {
            executionEntityManager.clearProcessInstanceLockTime(execution.getId());
        }

        if (processEngineConfiguration.isLoggingSessionEnabled()) {
            ExecutionEntity localExecution = executionEntityManager.findById(job.getExecutionId());
            FlowElement flowElement = localExecution.getCurrentFlowElement();
            BpmnLoggingSessionUtil.addAsyncActivityLoggingData("Unlocking job for " + flowElement.getId() + ", with job id " + job.getId(),
                            LoggingSessionConstants.TYPE_SERVICE_TASK_UNLOCK_JOB, (JobEntity) job, flowElement, localExecution);
        }
    }

    @Override
    public void preTimerJobDelete(JobEntity jobEntity, VariableScope variableScope) {
        string activityId = jobEntity.getJobHandlerConfiguration();

        if (jobEntity.getJobHandlerType().equalsIgnoreCase(TimerStartEventJobHandler.TYPE) ||
                        jobEntity.getJobHandlerType().equalsIgnoreCase(TriggerTimerEventJobHandler.TYPE)) {

            activityId = TimerEventHandler.getActivityIdFromConfiguration(jobEntity.getJobHandlerConfiguration());
            string endDateExpressionString = TimerEventHandler.getEndDateFromConfiguration(jobEntity.getJobHandlerConfiguration());

            if (endDateExpressionString !is null) {
                Expression endDateExpression = processEngineConfiguration.getExpressionManager().createExpression(endDateExpressionString);

                string endDateString = null;

                BusinessCalendar businessCalendar = processEngineConfiguration.getBusinessCalendarManager().getBusinessCalendar(
                        getBusinessCalendarName(TimerEventHandler.getCalendarNameFromConfiguration(jobEntity.getJobHandlerConfiguration()), variableScope));

                if (endDateExpression !is null) {
                    Object endDateValue = endDateExpression.getValue(variableScope);
                    if (endDateValue instanceof string) {
                        endDateString = (string) endDateValue;
                    } else if (endDateValue instanceof Date) {
                        jobEntity.setEndDate((Date) endDateValue);
                    } else {
                        throw new FlowableException("Timer '" + ((ExecutionEntity) variableScope).getActivityId()
                                + "' was not configured with a valid duration/time, either hand in a java.util.Date or a string in format 'yyyy-MM-dd'T'hh:mm:ss'");
                    }

                    if (jobEntity.getEndDate() is null) {
                        jobEntity.setEndDate(businessCalendar.resolveEndDate(endDateString));
                    }
                }
            }
        }

        int maxIterations = 1;
        if (jobEntity.getProcessDefinitionId() !is null) {
            flow.bpmn.model.Process process = ProcessDefinitionUtil.getProcess(jobEntity.getProcessDefinitionId());
            maxIterations = getMaxIterations(process, activityId);
            if (maxIterations <= 1) {
                maxIterations = getMaxIterations(process, activityId);
            }
        }
        jobEntity.setMaxIterations(maxIterations);
    }

    @Override
    public void preRepeatedTimerSchedule(TimerJobEntity ti, VariableScope variableScope) {
        // Nothing to do
    }

    protected int getMaxIterations(flow.bpmn.model.Process process, string activityId) {
        FlowElement flowElement = process.getFlowElement(activityId, true);
        if (flowElement !is null) {
            if (flowElement instanceof Event) {

                Event event = (Event) flowElement;
                List<EventDefinition> eventDefinitions = event.getEventDefinitions();

                if (eventDefinitions !is null) {

                    for (EventDefinition eventDefinition : eventDefinitions) {
                        if (eventDefinition instanceof TimerEventDefinition) {
                            TimerEventDefinition timerEventDefinition = (TimerEventDefinition) eventDefinition;
                            if (timerEventDefinition.getTimeCycle() !is null) {
                                return calculateMaxIterationsValue(timerEventDefinition.getTimeCycle());
                            }
                        }
                    }

                }

            }
        }
        return -1;
    }

    protected int calculateMaxIterationsValue(string originalExpression) {
        int times = Integer.MAX_VALUE;
        List!string expression = Arrays.asList(originalExpression.split("/"));
        if (expression.size() > 1 && expression.get(0).startsWith("R")) {
            times = Integer.MAX_VALUE;
            if (expression.get(0).length() > 1) {
                times = Integer.parseInt(expression.get(0).substring(1));
            }
        }

        return times;
    }

    protected string getBusinessCalendarName(string calendarName, VariableScope variableScope) {
        string businessCalendarName = CycleBusinessCalendar.NAME;
        if (StringUtils.isNotEmpty(calendarName)) {
            businessCalendarName = (string) CommandContextUtil.getProcessEngineConfiguration().getExpressionManager()
                    .createExpression(calendarName).getValue(variableScope);
        }
        return businessCalendarName;
    }

    protected ExecutionEntityManager getExecutionEntityManager() {
        return processEngineConfiguration.getExecutionEntityManager();
    }
}
