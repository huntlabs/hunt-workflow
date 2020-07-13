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

module flow.engine.impl.cfg.DefaultInternalJobManager;

import hunt.time.LocalDateTime;
import hunt.collection.List;

import flow.bpmn.model.Event;
import flow.bpmn.model.EventDefinition;
import flow.bpmn.model.FlowElement;
import flow.bpmn.model.TimerEventDefinition;
import flow.common.api.FlowableException;
import flow.common.api.deleg.Expression;
//import flow.common.calendar.BusinessCalendar;
//import flow.common.calendar.CycleBusinessCalendar;
//import flow.common.logging.LoggingSessionConstants;
//import flow.engine.impl.jobexecutor.TimerEventHandler;
//import flow.engine.impl.jobexecutor.TimerStartEventJobHandler;
import flow.engine.impl.jobexecutor.TriggerTimerEventJobHandler;
import flow.engine.impl.persistence.CountingExecutionEntity;
import flow.engine.impl.persistence.entity.ExecutionEntity;
import flow.engine.impl.persistence.entity.ExecutionEntityManager;
//import flow.engine.impl.util.BpmnLoggingSessionUtil;
import flow.engine.impl.util.CommandContextUtil;
import flow.engine.impl.util.CountingEntityUtil;
import flow.engine.impl.util.ProcessDefinitionUtil;
import flow.job.service.api.Job;
import flow.job.service.InternalJobManager;
import flow.job.service.impl.persistence.entity.AbstractRuntimeJobEntity;
import flow.job.service.impl.persistence.entity.DeadLetterJobEntity;
import flow.job.service.impl.persistence.entity.JobEntity;
import flow.job.service.impl.persistence.entity.SuspendedJobEntity;
import flow.job.service.impl.persistence.entity.TimerJobEntity;
import flow.variable.service.api.deleg.VariableScope;
import flow.engine.impl.cfg.ProcessEngineConfigurationImpl;
import  std.uni;
import hunt.Exceptions;
import flow.bpmn.model.Process;
import hunt.String;
/**
 * @author Tijs Rademakers
 */
class DefaultInternalJobManager : InternalJobManager {

    protected ProcessEngineConfigurationImpl processEngineConfiguration;

    this(ProcessEngineConfigurationImpl processEngineConfiguration) {
        this.processEngineConfiguration = processEngineConfiguration;
    }

    public VariableScope resolveVariableScope(Job job) {
        if (job.getExecutionId() !is null) {
            return getExecutionEntityManager().findById(job.getExecutionId());
        }
        return null;
    }


    public bool handleJobInsert(Job job) {
        // add link to execution
        if (job.getExecutionId() !is null) {
            ExecutionEntity execution = getExecutionEntityManager().findById(job.getExecutionId());
            if (execution !is null) {

                // Inherit tenant if (if applicable)
                if (execution.getTenantId() !is null && execution.getTenantId().length != 0) {
                    (cast(AbstractRuntimeJobEntity) job).setTenantId(execution.getTenantId());
                }

                CountingExecutionEntity countingExecutionEntity = cast(CountingExecutionEntity) execution;

                if (cast(TimerJobEntity)job !is null) {
                    TimerJobEntity timerJobEntity = cast(TimerJobEntity) job;
                    execution.getTimerJobs().add(timerJobEntity);

                    if (CountingEntityUtil.isExecutionRelatedEntityCountEnabled(execution)) {
                        countingExecutionEntity.setTimerJobCount(countingExecutionEntity.getTimerJobCount() + 1);
                    }

                } else if (cast(JobEntity)job !is null) {
                    JobEntity jobEntity = cast(JobEntity) job;
                    execution.getJobs().add(jobEntity);

                    if (CountingEntityUtil.isExecutionRelatedEntityCountEnabled(execution)) {
                        countingExecutionEntity.setJobCount(countingExecutionEntity.getJobCount() + 1);
                    }

                } else {
                    if (CountingEntityUtil.isExecutionRelatedEntityCountEnabled(execution)) {
                        if (cast(SuspendedJobEntity)job !is null) {
                            countingExecutionEntity.setSuspendedJobCount(countingExecutionEntity.getSuspendedJobCount() + 1);
                        } else if (cast(DeadLetterJobEntity)job !is null) {
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


    public void handleJobDelete(Job job) {
        if (job.getExecutionId() !is null && CountingEntityUtil.isExecutionRelatedEntityCountEnabledGlobally()) {
            ExecutionEntity executionEntity = getExecutionEntityManager().findById(job.getExecutionId());
            if (CountingEntityUtil.isExecutionRelatedEntityCountEnabled(executionEntity)) {
                CountingExecutionEntity countingExecutionEntity = cast(CountingExecutionEntity) executionEntity;
                if (cast(JobEntity)job !is null) {
                    executionEntity.getJobs().remove(cast(JobEntity)job);
                    countingExecutionEntity.setJobCount(countingExecutionEntity.getJobCount() - 1);

                } else if (cast(TimerJobEntity)job !is null) {
                    executionEntity.getTimerJobs().remove(cast(TimerJobEntity)job);
                    countingExecutionEntity.setTimerJobCount(countingExecutionEntity.getTimerJobCount() - 1);

                } else if (cast(SuspendedJobEntity)job !is null) {
                    countingExecutionEntity.setSuspendedJobCount(countingExecutionEntity.getSuspendedJobCount() - 1);

                } else if (cast(DeadLetterJobEntity)job !is null) {
                    countingExecutionEntity.setDeadLetterJobCount(countingExecutionEntity.getDeadLetterJobCount() - 1);
                }
            }
        }
    }


    public void lockJobScope(Job job) {
        ExecutionEntityManager executionEntityManager = getExecutionEntityManager();
        ExecutionEntity execution = executionEntityManager.findById(job.getExecutionId());
        if (execution !is null) {
            executionEntityManager.updateProcessInstanceLockTime(execution.getProcessInstanceId());
        }

        //if (processEngineConfiguration.isLoggingSessionEnabled()) {
            //FlowElement flowElement = execution.getCurrentFlowElement();
            //BpmnLoggingSessionUtil.addAsyncActivityLoggingData("Locking job for " + flowElement.getId() + ", with job id " + job.getId(),
            //                LoggingSessionConstants.TYPE_SERVICE_TASK_LOCK_JOB, (JobEntity) job, flowElement, execution);
        //}
    }


    public void clearJobScopeLock(Job job) {
        ExecutionEntityManager executionEntityManager = getExecutionEntityManager();
        ExecutionEntity execution = executionEntityManager.findById(job.getProcessInstanceId());
        if (execution !is null) {
            executionEntityManager.clearProcessInstanceLockTime(execution.getId());
        }

       // if (processEngineConfiguration.isLoggingSessionEnabled()) {
            //ExecutionEntity localExecution = executionEntityManager.findById(job.getExecutionId());
            //FlowElement flowElement = localExecution.getCurrentFlowElement();
            //BpmnLoggingSessionUtil.addAsyncActivityLoggingData("Unlocking job for " + flowElement.getId() + ", with job id " + job.getId(),
            //                LoggingSessionConstants.TYPE_SERVICE_TASK_UNLOCK_JOB, (JobEntity) job, flowElement, localExecution);
        //}
    }


    public void preTimerJobDelete(JobEntity jobEntity, VariableScope variableScope) {
        implementationMissing(false);
        //string activityId = jobEntity.getJobHandlerConfiguration();
        //
        //if (sicmp(jobEntity.getJobHandlerType(),(TimerStartEventJobHandler.TYPE)) == 0 ||
        //                sicmp(jobEntity.getJobHandlerType(),(TriggerTimerEventJobHandler.TYPE)) == 0) {
        //
        //    activityId = TimerEventHandler.getActivityIdFromConfiguration(jobEntity.getJobHandlerConfiguration());
        //    string endDateExpressionString = TimerEventHandler.getEndDateFromConfiguration(jobEntity.getJobHandlerConfiguration());
        //
        //    if (endDateExpressionString !is null) {
        //        Expression endDateExpression = processEngineConfiguration.getExpressionManager().createExpression(endDateExpressionString);
        //
        //        string endDateString = null;
        //
        //        BusinessCalendar businessCalendar = processEngineConfiguration.getBusinessCalendarManager().getBusinessCalendar(
        //                getBusinessCalendarName(TimerEventHandler.getCalendarNameFromConfiguration(jobEntity.getJobHandlerConfiguration()), variableScope));
        //
        //        if (endDateExpression !is null) {
        //            Object endDateValue = endDateExpression.getValue(variableScope);
        //            if (endDateValue instanceof string) {
        //                endDateString = (string) endDateValue;
        //            } else if (endDateValue instanceof Date) {
        //                jobEntity.setEndDate((Date) endDateValue);
        //            } else {
        //                throw new FlowableException("Timer '" + ((ExecutionEntity) variableScope).getActivityId()
        //                        + "' was not configured with a valid duration/time, either hand in a java.util.Date or a string in format 'yyyy-MM-dd'T'hh:mm:ss'");
        //            }
        //
        //            if (jobEntity.getEndDate() is null) {
        //                jobEntity.setEndDate(businessCalendar.resolveEndDate(endDateString));
        //            }
        //        }
        //    }
        //}
        //
        //int maxIterations = 1;
        //if (jobEntity.getProcessDefinitionId() !is null) {
        //    flow.bpmn.model.Process process = ProcessDefinitionUtil.getProcess(jobEntity.getProcessDefinitionId());
        //    maxIterations = getMaxIterations(process, activityId);
        //    if (maxIterations <= 1) {
        //        maxIterations = getMaxIterations(process, activityId);
        //    }
        //}
        //jobEntity.setMaxIterations(maxIterations);
    }


    public void preRepeatedTimerSchedule(TimerJobEntity ti, VariableScope variableScope) {
        // Nothing to do
    }

    protected int getMaxIterations(flow.bpmn.model.Process.Process process, string activityId) {
        FlowElement flowElement = process.getFlowElement(activityId, true);
        if (flowElement !is null) {
            if (cast(Event)flowElement !is null) {

                Event event = cast(Event) flowElement;
                List!EventDefinition eventDefinitions = event.getEventDefinitions();

                if (eventDefinitions !is null) {

                    foreach (EventDefinition eventDefinition ; eventDefinitions) {
                        if (cast(TimerEventDefinition)eventDefinition !is null) {
                            TimerEventDefinition timerEventDefinition = cast(TimerEventDefinition) eventDefinition;
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
        implementationMissing(false);
        return 0;
        //int times = Integer.MAX_VALUE;
        //List!string expression = Arrays.asList(originalExpression.split("/"));
        //if (expression.size() > 1 && expression.get(0).startsWith("R")) {
        //    times = Integer.MAX_VALUE;
        //    if (expression.get(0).length() > 1) {
        //        times = Integer.parseInt(expression.get(0).substring(1));
        //    }
        //}
        //
        //return times;
    }

    protected string getBusinessCalendarName(string calendarName, VariableScope variableScope) {
        implementationMissing(false);
        return "";
        //string businessCalendarName = CycleBusinessCalendar.NAME;
        //if (StringUtils.isNotEmpty(calendarName)) {
        //    businessCalendarName = cast(String) CommandContextUtil.getProcessEngineConfiguration().getExpressionManager()
        //            .createExpression(calendarName).getValue(variableScope);
        //}
        //return businessCalendarName;
    }

    protected ExecutionEntityManager getExecutionEntityManager() {
        return processEngineConfiguration.getExecutionEntityManager();
    }
}
