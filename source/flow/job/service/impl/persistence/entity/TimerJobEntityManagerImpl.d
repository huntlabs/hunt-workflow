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
module flow.job.service.impl.persistence.entity.TimerJobEntityManagerImpl;
import hunt.util.StringBuilder;
import hunt.time.LocalDateTime;
import hunt.collection.List;
import hunt.collection.ArrayList;
import flow.common.api.deleg.event.FlowableEngineEventType;
import flow.common.api.deleg.event.FlowableEventDispatcher;
import flow.common.Page;
import std.algorithm;
import std.conv;
//import flow.common.calendar.BusinessCalendar;
import flow.job.service.api.Job;
import flow.job.service.JobServiceConfiguration;
import flow.job.service.event.impl.FlowableJobEventBuilder;
import flow.job.service.impl.TimerJobQueryImpl;
import flow.job.service.impl.persistence.entity.data.TimerJobDataManager;
import flow.variable.service.api.deleg.VariableScope;
import flow.job.service.impl.persistence.entity.AbstractJobServiceEngineEntityManager;
import flow.job.service.impl.persistence.entity.TimerJobEntityManager;
import flow.job.service.impl.persistence.entity.TimerJobEntity;
import flow.job.service.impl.persistence.entity.JobEntity;
import std.array;
import hunt.Exceptions;

/**
 * @author Tijs Rademakers
 */
class TimerJobEntityManagerImpl
    : AbstractJobServiceEngineEntityManager!(TimerJobEntity, TimerJobDataManager)
    , TimerJobEntityManager {


    this(JobServiceConfiguration jobServiceConfiguration, TimerJobDataManager jobDataManager) {
        super(jobServiceConfiguration, jobDataManager);
    }


    public TimerJobEntity createAndCalculateNextTimer(JobEntity timerEntity, VariableScope variableScope) {
        int repeatValue = calculateRepeatValue(timerEntity);
        if (repeatValue != 0) {
            if (repeatValue > 0) {
                setNewRepeat(timerEntity, repeatValue);
            }
            Date newTimer = calculateNextTimer(timerEntity, variableScope);
            if (newTimer !is null && isValidTime(timerEntity, newTimer, variableScope)) {
                TimerJobEntity te = createTimer(timerEntity);
                te.setDuedate(newTimer);
                return te;
            }
        }
        return null;
    }


    public List!TimerJobEntity findTimerJobsToExecute(Page page) {
        return dataManager.findTimerJobsToExecute(page);
    }


    public List!TimerJobEntity findJobsByTypeAndProcessDefinitionId(string jobHandlerType, string processDefinitionId) {
        return dataManager.findJobsByTypeAndProcessDefinitionId(jobHandlerType, processDefinitionId);
    }


    public List!TimerJobEntity findJobsByTypeAndProcessDefinitionKeyNoTenantId(string jobHandlerType, string processDefinitionKey) {
        return dataManager.findJobsByTypeAndProcessDefinitionKeyNoTenantId(jobHandlerType, processDefinitionKey);
    }


    public List!TimerJobEntity findJobsByTypeAndProcessDefinitionKeyAndTenantId(string jobHandlerType, string processDefinitionKey, string tenantId) {
        return dataManager.findJobsByTypeAndProcessDefinitionKeyAndTenantId(jobHandlerType, processDefinitionKey, tenantId);
    }


    public List!TimerJobEntity findJobsByExecutionId(string id) {
        return dataManager.findJobsByExecutionId(id);
    }


    public List!TimerJobEntity findJobsByProcessInstanceId(string id) {
        return dataManager.findJobsByProcessInstanceId(id);
    }


    public List!TimerJobEntity findJobsByScopeIdAndSubScopeId(string scopeId, string subScopeId) {
        return dataManager.findJobsByScopeIdAndSubScopeId(scopeId, subScopeId);
    }


    public List!Job findJobsByQueryCriteria(TimerJobQueryImpl jobQuery) {
        return dataManager.findJobsByQueryCriteria(jobQuery);
    }


    public long findJobCountByQueryCriteria(TimerJobQueryImpl jobQuery) {
        return dataManager.findJobCountByQueryCriteria(jobQuery);
    }


    public void updateJobTenantIdForDeployment(string deploymentId, string newTenantId) {
        dataManager.updateJobTenantIdForDeployment(deploymentId, newTenantId);
    }


    public bool insertTimerJobEntity(TimerJobEntity timerJobEntity) {
        return doInsert(timerJobEntity, true);
    }

    override
    public void insert(TimerJobEntity jobEntity) {
        insert(jobEntity, true);
    }

    override
    public void insert(TimerJobEntity jobEntity, bool fireCreateEvent) {
        doInsert(jobEntity, fireCreateEvent);
    }

    protected bool doInsert(TimerJobEntity jobEntity, bool fireCreateEvent) {
        if (serviceConfiguration.getInternalJobManager() !is null) {
            bool handledJob = serviceConfiguration.getInternalJobManager().handleJobInsert(jobEntity);
            if (!handledJob) {
                return false;
            }
        }

        jobEntity.setCreateTime(getClock().getCurrentTime());
        super.insert(jobEntity, fireCreateEvent);
        return true;
    }

    override
    public void dele(TimerJobEntity jobEntity) {
        super.dele(jobEntity, false);

        deleteByteArrayRef(jobEntity.getExceptionByteArrayRef());
        deleteByteArrayRef(jobEntity.getCustomValuesByteArrayRef());

        if (serviceConfiguration.getInternalJobManager() !is null) {
            serviceConfiguration.getInternalJobManager().handleJobDelete(jobEntity);
        }

        // Send event
        FlowableEventDispatcher eventDispatcher = getEventDispatcher();
        if (eventDispatcher !is null && eventDispatcher.isEnabled()) {
            eventDispatcher.dispatchEvent(FlowableJobEventBuilder.createEntityEvent(FlowableEngineEventType.ENTITY_DELETED, cast(Object)jobEntity));
        }
    }

    protected TimerJobEntity createTimer(JobEntity te) {
        TimerJobEntity newTimerEntity = create();
        newTimerEntity.setJobHandlerConfiguration(te.getJobHandlerConfiguration());
        newTimerEntity.setCustomValues(te.getCustomValues());
        newTimerEntity.setJobHandlerType(te.getJobHandlerType());
        newTimerEntity.setExclusive(te.isExclusive());
        newTimerEntity.setRepeat(te.getRepeat());
        newTimerEntity.setRetries(te.getRetries());
        newTimerEntity.setEndDate(te.getEndDate());
        newTimerEntity.setExecutionId(te.getExecutionId());
        newTimerEntity.setProcessInstanceId(te.getProcessInstanceId());
        newTimerEntity.setProcessDefinitionId(te.getProcessDefinitionId());
        newTimerEntity.setScopeId(te.getScopeId());
        newTimerEntity.setSubScopeId(te.getSubScopeId());
        newTimerEntity.setScopeDefinitionId(te.getScopeDefinitionId());
        newTimerEntity.setScopeType(te.getScopeType());

        // Inherit tenant
        newTimerEntity.setTenantId(te.getTenantId());
        newTimerEntity.setJobType(JobEntity.JOB_TYPE_TIMER);
        return newTimerEntity;
    }

    protected void setNewRepeat(JobEntity timerEntity, int newRepeatValue) {
        List!string expression = new ArrayList!string(timerEntity.getRepeat().split("/"));
        expression.removeAt(0);
        //expression = expression.subList(1, expression.size());
        StringBuilder repeatBuilder = new StringBuilder("R");
        repeatBuilder.append(newRepeatValue);
        foreach (string value ; expression) {
            repeatBuilder.append("/");
            repeatBuilder.append(value);
        }
        timerEntity.setRepeat(repeatBuilder.toString());
    }

    protected bool isValidTime(JobEntity timerEntity, Date newTimerDate, VariableScope variableScope) {
        implementationMissing(false);
        return true;
        //BusinessCalendar businessCalendar = serviceConfiguration.getBusinessCalendarManager().getBusinessCalendar(
        //                serviceConfiguration.getJobManager().getBusinessCalendarName(timerEntity, variableScope));
        //return businessCalendar.validateDuedate(timerEntity.getRepeat(), timerEntity.getMaxIterations(), timerEntity.getEndDate(), newTimerDate);
    }

    protected Date calculateNextTimer(JobEntity timerEntity, VariableScope variableScope) {
        implementationMissing(false);
        return null;
        //BusinessCalendar businessCalendar = serviceConfiguration.getBusinessCalendarManager().getBusinessCalendar(
        //                serviceConfiguration.getJobManager().getBusinessCalendarName(timerEntity, variableScope));
        //return businessCalendar.resolveDuedate(timerEntity.getRepeat(), timerEntity.getMaxIterations());
    }

    protected int calculateRepeatValue(JobEntity timerEntity) {
        int times = -1;
        List!string expression = new ArrayList!string(timerEntity.getRepeat().split("/"));
        if (expression.size() > 1 && startsWith(expression.get(0),"R") && expression.get(0).length > 1) {
            string t = expression.get(0)[ 1 .. $];
            times = to!int(t);
           // times = Integer.parseInt(expression.get(0).substring(1));
            if (times > 0) {
                times--;
            }
        }
        return times;
    }
}
