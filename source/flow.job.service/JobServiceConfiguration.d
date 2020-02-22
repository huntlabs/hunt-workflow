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
//          Copyright linse 2020. 
// Distributed under the Boost Software License, Version 1.0. 
//    (See accompanying file LICENSE_1_0.txt or copy at 
//          http://www.boost.org/LICENSE_1_0.txt)} 
 
module flow.job.service.JobServiceConfiguration;
 
 
 


import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import flow.common.AbstractServiceConfiguration;
import flow.common.calendar.BusinessCalendarManager;
import flow.common.el.ExpressionManager;
import flow.common.history.HistoryLevel;
import flow.common.interceptor.CommandExecutor;
import org.flowable.job.service.impl.HistoryJobServiceImpl;
import org.flowable.job.service.impl.JobServiceImpl;
import org.flowable.job.service.impl.TimerJobServiceImpl;
import org.flowable.job.service.impl.asyncexecutor.AsyncExecutor;
import org.flowable.job.service.impl.asyncexecutor.AsyncRunnableExecutionExceptionHandler;
import org.flowable.job.service.impl.asyncexecutor.DefaultJobManager;
import org.flowable.job.service.impl.asyncexecutor.FailedJobCommandFactory;
import org.flowable.job.service.impl.asyncexecutor.JobManager;
import org.flowable.job.service.impl.history.async.AsyncHistoryJobHandler;
import org.flowable.job.service.impl.history.async.transformer.HistoryJsonTransformer;
import org.flowable.job.service.impl.persistence.entity.DeadLetterJobEntityManager;
import org.flowable.job.service.impl.persistence.entity.DeadLetterJobEntityManagerImpl;
import org.flowable.job.service.impl.persistence.entity.HistoryJobEntityManager;
import org.flowable.job.service.impl.persistence.entity.HistoryJobEntityManagerImpl;
import org.flowable.job.service.impl.persistence.entity.JobByteArrayEntityManager;
import org.flowable.job.service.impl.persistence.entity.JobByteArrayEntityManagerImpl;
import org.flowable.job.service.impl.persistence.entity.JobEntityManager;
import org.flowable.job.service.impl.persistence.entity.JobEntityManagerImpl;
import org.flowable.job.service.impl.persistence.entity.SuspendedJobEntityManager;
import org.flowable.job.service.impl.persistence.entity.SuspendedJobEntityManagerImpl;
import org.flowable.job.service.impl.persistence.entity.TimerJobEntityManager;
import org.flowable.job.service.impl.persistence.entity.TimerJobEntityManagerImpl;
import org.flowable.job.service.impl.persistence.entity.data.DeadLetterJobDataManager;
import org.flowable.job.service.impl.persistence.entity.data.HistoryJobDataManager;
import org.flowable.job.service.impl.persistence.entity.data.JobByteArrayDataManager;
import org.flowable.job.service.impl.persistence.entity.data.JobDataManager;
import org.flowable.job.service.impl.persistence.entity.data.SuspendedJobDataManager;
import org.flowable.job.service.impl.persistence.entity.data.TimerJobDataManager;
import org.flowable.job.service.impl.persistence.entity.data.impl.MybatisDeadLetterJobDataManager;
import org.flowable.job.service.impl.persistence.entity.data.impl.MybatisHistoryJobDataManager;
import org.flowable.job.service.impl.persistence.entity.data.impl.MybatisJobByteArrayDataManager;
import org.flowable.job.service.impl.persistence.entity.data.impl.MybatisJobDataManager;
import org.flowable.job.service.impl.persistence.entity.data.impl.MybatisSuspendedJobDataManager;
import org.flowable.job.service.impl.persistence.entity.data.impl.MybatisTimerJobDataManager;

import com.fasterxml.jackson.databind.ObjectMapper;

/**
 * This service configuration contains all settings and instances around job execution and management.
 * Note that a {@link JobServiceConfiguration} is not shared between engines and instantiated for each engine.
 * 
 * @author Tijs Rademakers
 */
class JobServiceConfiguration : AbstractServiceConfiguration {

    public static  string JOB_EXECUTION_SCOPE_ALL = "all";
    public static  string JOB_EXECUTION_SCOPE_CMMN = "cmmn";

    // SERVICES
    // /////////////////////////////////////////////////////////////////

    protected JobService jobService = new JobServiceImpl(this);
    protected TimerJobService timerJobService = new TimerJobServiceImpl(this);
    protected HistoryJobService historyJobService = new HistoryJobServiceImpl(this);

    protected JobManager jobManager;

    // DATA MANAGERS ///////////////////////////////////////////////////

    protected JobDataManager jobDataManager;
    protected DeadLetterJobDataManager deadLetterJobDataManager;
    protected SuspendedJobDataManager suspendedJobDataManager;
    protected TimerJobDataManager timerJobDataManager;
    protected HistoryJobDataManager historyJobDataManager;
    protected JobByteArrayDataManager jobByteArrayDataManager;

    // ENTITY MANAGERS /////////////////////////////////////////////////

    protected JobEntityManager jobEntityManager;
    protected DeadLetterJobEntityManager deadLetterJobEntityManager;
    protected SuspendedJobEntityManager suspendedJobEntityManager;
    protected TimerJobEntityManager timerJobEntityManager;
    protected HistoryJobEntityManager historyJobEntityManager;
    protected JobByteArrayEntityManager jobByteArrayEntityManager;

    protected CommandExecutor commandExecutor;

    protected ExpressionManager expressionManager;
    protected BusinessCalendarManager businessCalendarManager;

    protected InternalJobManager internalJobManager;
    protected InternalJobCompatibilityManager internalJobCompatibilityManager;
    protected InternalJobParentStateResolver jobParentStateResolver;

    protected AsyncExecutor asyncExecutor;
    protected int asyncExecutorNumberOfRetries;
    protected int asyncExecutorResetExpiredJobsMaxTimeout;
    
    protected string jobExecutionScope;
    protected Map<string, JobHandler> jobHandlers;
    protected FailedJobCommandFactory failedJobCommandFactory;
    protected List<AsyncRunnableExecutionExceptionHandler> asyncRunnableExecutionExceptionHandlers;
    protected List<JobProcessor> jobProcessors;
    
    protected AsyncExecutor asyncHistoryExecutor;
    protected int asyncHistoryExecutorNumberOfRetries;
    protected string historyJobExecutionScope;
    
    protected Map<string, HistoryJobHandler> historyJobHandlers;
    protected List<HistoryJobProcessor> historyJobProcessors;
    
    protected string jobTypeAsyncHistory;
    protected string jobTypeAsyncHistoryZipped;
    
    protected bool asyncHistoryJsonGzipCompressionEnabled;
    protected bool asyncHistoryJsonGroupingEnabled;
    protected bool asyncHistoryExecutorMessageQueueMode;
    protected int asyncHistoryJsonGroupingThreshold = 10;
    
    public JobServiceConfiguration(string engineName) {
        super(engineName);
    }

    // init
    // /////////////////////////////////////////////////////////////////////

    public void init() {
        initJobManager();
        initDataManagers();
        initEntityManagers();
    }

    @Override
    public bool isHistoryLevelAtLeast(HistoryLevel level) {
        if (logger.isDebugEnabled()) {
            logger.debug("Current history level: {}, level required: {}", historyLevel, level);
        }
        // Comparing enums actually compares the location of values declared in the enum
        return historyLevel.isAtLeast(level);
    }

    @Override
    public bool isHistoryEnabled() {
        if (logger.isDebugEnabled()) {
            logger.debug("Current history level: {}", historyLevel);
        }
        return historyLevel != HistoryLevel.NONE;
    }

    // Job manager ///////////////////////////////////////////////////////////

    public void initJobManager() {
        if (jobManager is null) {
            jobManager = new DefaultJobManager(this);
        }

        jobManager.setJobServiceConfiguration(this);
    }

    // Data managers
    ///////////////////////////////////////////////////////////

    public void initDataManagers() {
        if (jobDataManager is null) {
            jobDataManager = new MybatisJobDataManager(this);
        }
        if (deadLetterJobDataManager is null) {
            deadLetterJobDataManager = new MybatisDeadLetterJobDataManager();
        }
        if (suspendedJobDataManager is null) {
            suspendedJobDataManager = new MybatisSuspendedJobDataManager();
        }
        if (timerJobDataManager is null) {
            timerJobDataManager = new MybatisTimerJobDataManager(this);
        }
        if (historyJobDataManager is null) {
            historyJobDataManager = new MybatisHistoryJobDataManager(this);
        }
        if (jobByteArrayDataManager is null) {
            jobByteArrayDataManager = new MybatisJobByteArrayDataManager();
        }
    }

    public void initEntityManagers() {
        if (jobEntityManager is null) {
            jobEntityManager = new JobEntityManagerImpl(this, jobDataManager);
        }
        if (deadLetterJobEntityManager is null) {
            deadLetterJobEntityManager = new DeadLetterJobEntityManagerImpl(this, deadLetterJobDataManager);
        }
        if (suspendedJobEntityManager is null) {
            suspendedJobEntityManager = new SuspendedJobEntityManagerImpl(this, suspendedJobDataManager);
        }
        if (timerJobEntityManager is null) {
            timerJobEntityManager = new TimerJobEntityManagerImpl(this, timerJobDataManager);
        }
        if (historyJobEntityManager is null) {
            historyJobEntityManager = new HistoryJobEntityManagerImpl(this, historyJobDataManager);
        }
        if (jobByteArrayEntityManager is null) {
            jobByteArrayEntityManager = new JobByteArrayEntityManagerImpl(this, jobByteArrayDataManager);
        }
    }

    // getters and setters
    // //////////////////////////////////////////////////////

    public JobServiceConfiguration getIdentityLinkServiceConfiguration() {
        return this;
    }

    public JobService getJobService() {
        return jobService;
    }

    public JobServiceConfiguration setJobService(JobService jobService) {
        this.jobService = jobService;
        return this;
    }

    public TimerJobService getTimerJobService() {
        return timerJobService;
    }

    public JobServiceConfiguration setTimerJobService(TimerJobService timerJobService) {
        this.timerJobService = timerJobService;
        return this;
    }

    public HistoryJobService getHistoryJobService() {
        return historyJobService;
    }

    public JobServiceConfiguration setHistoryJobService(HistoryJobService historyJobService) {
        this.historyJobService = historyJobService;
        return this;
    }

    public JobManager getJobManager() {
        return jobManager;
    }

    public void setJobManager(JobManager jobManager) {
        this.jobManager = jobManager;
    }

    public JobDataManager getJobDataManager() {
        return jobDataManager;
    }

    public JobServiceConfiguration setJobDataManager(JobDataManager jobDataManager) {
        this.jobDataManager = jobDataManager;
        return this;
    }

    public DeadLetterJobDataManager getDeadLetterJobDataManager() {
        return deadLetterJobDataManager;
    }

    public JobServiceConfiguration setDeadLetterJobDataManager(DeadLetterJobDataManager deadLetterJobDataManager) {
        this.deadLetterJobDataManager = deadLetterJobDataManager;
        return this;
    }

    public SuspendedJobDataManager getSuspendedJobDataManager() {
        return suspendedJobDataManager;
    }

    public JobServiceConfiguration setSuspendedJobDataManager(SuspendedJobDataManager suspendedJobDataManager) {
        this.suspendedJobDataManager = suspendedJobDataManager;
        return this;
    }

    public TimerJobDataManager getTimerJobDataManager() {
        return timerJobDataManager;
    }

    public JobServiceConfiguration setTimerJobDataManager(TimerJobDataManager timerJobDataManager) {
        this.timerJobDataManager = timerJobDataManager;
        return this;
    }

    public HistoryJobDataManager getHistoryJobDataManager() {
        return historyJobDataManager;
    }

    public JobServiceConfiguration setHistoryJobDataManager(HistoryJobDataManager historyJobDataManager) {
        this.historyJobDataManager = historyJobDataManager;
        return this;
    }

    public JobByteArrayDataManager getJobByteArrayDataManager() {
        return jobByteArrayDataManager;
    }

    public JobServiceConfiguration setJobByteArrayDataManager(JobByteArrayDataManager jobByteArrayDataManager) {
        this.jobByteArrayDataManager = jobByteArrayDataManager;
        return this;
    }

    public JobEntityManager getJobEntityManager() {
        return jobEntityManager;
    }

    public JobServiceConfiguration setJobEntityManager(JobEntityManager jobEntityManager) {
        this.jobEntityManager = jobEntityManager;
        return this;
    }

    public DeadLetterJobEntityManager getDeadLetterJobEntityManager() {
        return deadLetterJobEntityManager;
    }

    public JobServiceConfiguration setDeadLetterJobEntityManager(DeadLetterJobEntityManager deadLetterJobEntityManager) {
        this.deadLetterJobEntityManager = deadLetterJobEntityManager;
        return this;
    }

    public SuspendedJobEntityManager getSuspendedJobEntityManager() {
        return suspendedJobEntityManager;
    }

    public JobServiceConfiguration setSuspendedJobEntityManager(SuspendedJobEntityManager suspendedJobEntityManager) {
        this.suspendedJobEntityManager = suspendedJobEntityManager;
        return this;
    }

    public TimerJobEntityManager getTimerJobEntityManager() {
        return timerJobEntityManager;
    }

    public JobServiceConfiguration setTimerJobEntityManager(TimerJobEntityManager timerJobEntityManager) {
        this.timerJobEntityManager = timerJobEntityManager;
        return this;
    }

    public HistoryJobEntityManager getHistoryJobEntityManager() {
        return historyJobEntityManager;
    }

    public JobServiceConfiguration setHistoryJobEntityManager(HistoryJobEntityManager historyJobEntityManager) {
        this.historyJobEntityManager = historyJobEntityManager;
        return this;
    }

    public JobByteArrayEntityManager getJobByteArrayEntityManager() {
        return jobByteArrayEntityManager;
    }

    public JobServiceConfiguration setJobByteArrayEntityManager(JobByteArrayEntityManager jobByteArrayEntityManager) {
        this.jobByteArrayEntityManager = jobByteArrayEntityManager;
        return this;
    }

    public CommandExecutor getCommandExecutor() {
        return commandExecutor;
    }

    public void setCommandExecutor(CommandExecutor commandExecutor) {
        this.commandExecutor = commandExecutor;
    }

    public InternalJobManager getInternalJobManager() {
        return internalJobManager;
    }

    public void setInternalJobManager(InternalJobManager internalJobManager) {
        this.internalJobManager = internalJobManager;
    }
    
    public InternalJobCompatibilityManager getInternalJobCompatibilityManager() {
        return internalJobCompatibilityManager;
    }

    public void setInternalJobCompatibilityManager(InternalJobCompatibilityManager internalJobCompatibilityManager) {
        this.internalJobCompatibilityManager = internalJobCompatibilityManager;
    }

    public AsyncExecutor getAsyncExecutor() {
        return asyncExecutor;
    }

    public JobServiceConfiguration setAsyncExecutor(AsyncExecutor asyncExecutor) {
        this.asyncExecutor = asyncExecutor;
        return this;
    }
    
    public AsyncExecutor getAsyncHistoryExecutor() {
        return asyncHistoryExecutor;
    }

    public JobServiceConfiguration setAsyncHistoryExecutor(AsyncExecutor asyncHistoryExecutor) {
        this.asyncHistoryExecutor = asyncHistoryExecutor;
        return this;
    }
    
    public int getAsyncHistoryExecutorNumberOfRetries() {
        return asyncHistoryExecutorNumberOfRetries;
    }

    public JobServiceConfiguration setAsyncHistoryExecutorNumberOfRetries(int asyncHistoryExecutorNumberOfRetries) {
        this.asyncHistoryExecutorNumberOfRetries = asyncHistoryExecutorNumberOfRetries;
        return this;
    }

    public string getJobExecutionScope() {
        return jobExecutionScope;
    }

    public JobServiceConfiguration setJobExecutionScope(string jobExecutionScope) {
        this.jobExecutionScope = jobExecutionScope;
        return this;
    }
    
    public string getHistoryJobExecutionScope() {
        return historyJobExecutionScope;
    }

    public JobServiceConfiguration setHistoryJobExecutionScope(string historyJobExecutionScope) {
        this.historyJobExecutionScope = historyJobExecutionScope;
        return this;
    }

    public ExpressionManager getExpressionManager() {
        return expressionManager;
    }

    public JobServiceConfiguration setExpressionManager(ExpressionManager expressionManager) {
        this.expressionManager = expressionManager;
        return this;
    }

    public BusinessCalendarManager getBusinessCalendarManager() {
        return businessCalendarManager;
    }

    public JobServiceConfiguration setBusinessCalendarManager(BusinessCalendarManager businessCalendarManager) {
        this.businessCalendarManager = businessCalendarManager;
        return this;
    }

    public Map<string, JobHandler> getJobHandlers() {
        return jobHandlers;
    }

    public JobServiceConfiguration setJobHandlers(Map<string, JobHandler> jobHandlers) {
        this.jobHandlers = jobHandlers;
        return this;
    }
    
    public JobServiceConfiguration addJobHandler(string type, JobHandler jobHandler) {
        if (this.jobHandlers is null) {
            this.jobHandlers = new HashMap<>();
        }
        this.jobHandlers.put(type, jobHandler);
        return this;
    }

    public FailedJobCommandFactory getFailedJobCommandFactory() {
        return failedJobCommandFactory;
    }

    public JobServiceConfiguration setFailedJobCommandFactory(FailedJobCommandFactory failedJobCommandFactory) {
        this.failedJobCommandFactory = failedJobCommandFactory;
        return this;
    }

    public List<AsyncRunnableExecutionExceptionHandler> getAsyncRunnableExecutionExceptionHandlers() {
        return asyncRunnableExecutionExceptionHandlers;
    }

    public JobServiceConfiguration setAsyncRunnableExecutionExceptionHandlers(List<AsyncRunnableExecutionExceptionHandler> asyncRunnableExecutionExceptionHandlers) {
        this.asyncRunnableExecutionExceptionHandlers = asyncRunnableExecutionExceptionHandlers;
        return this;
    }

    public Map<string, HistoryJobHandler> getHistoryJobHandlers() {
        return historyJobHandlers;
    }

    public JobServiceConfiguration setHistoryJobHandlers(Map<string, HistoryJobHandler> historyJobHandlers) {
        this.historyJobHandlers = historyJobHandlers;
        return this;
    }
    
    public JobServiceConfiguration addHistoryJobHandler(string type, HistoryJobHandler historyJobHandler) {
        if (this.historyJobHandlers is null) {
            this.historyJobHandlers = new HashMap<>();
        }
        this.historyJobHandlers.put(type, historyJobHandler);
        return this;
    }
    
    /**
     * Registers the given {@link HistoryJobHandler} under the provided type and checks for 
     * existing <b>default and internal</b> {@link HistoryJobHandler} instances to be of the same class.
     * 
     * If no such instances are found, a {@link #addHistoryJobHandler(string, HistoryJobHandler)} is done.
     * 
     * If such instances are found, they are merged, meaning the {@link HistoryJsonTransformer} instances of the provided {@link HistoryJobHandler} 
     * are copied into the already registered {@link HistoryJobHandler} and vice versa.
     * 
     * If a type is already registered, the provided history job handler is simply ignored.
     * 
     * This is especially useful when multiple engines (e.g. bpmn and cmmn) share an async history executor.
     * In this case, both {@link AsyncHistoryJobHandler} instances should be able to handle history jobs from any engine.
     */
    public JobServiceConfiguration mergeHistoryJobHandler(HistoryJobHandler historyJobHandler) {
        if (historyJobHandlers !is null
                && historyJobHandler instanceof AsyncHistoryJobHandler
                && !historyJobHandlers.containsKey(historyJobHandler.getType())) {
            for (HistoryJobHandler existingHistoryJobHandler : historyJobHandlers.values()) {
                if (existingHistoryJobHandler.getClass().equals(historyJobHandler.getClass())) {
                    copyHistoryJsonTransformers((AsyncHistoryJobHandler) historyJobHandler, (AsyncHistoryJobHandler) existingHistoryJobHandler);
                    copyHistoryJsonTransformers((AsyncHistoryJobHandler) existingHistoryJobHandler, (AsyncHistoryJobHandler) historyJobHandler);
                }
            }
        }
        addHistoryJobHandler(historyJobHandler.getType(), historyJobHandler);
        return this;
    }

    protected void copyHistoryJsonTransformers(AsyncHistoryJobHandler source, AsyncHistoryJobHandler target) {
        source.getHistoryJsonTransformers().forEach((transformerType, transformersList) -> {
            for (HistoryJsonTransformer historyJsonTransformer : transformersList) {
                if (!target.getHistoryJsonTransformers().containsKey(transformerType)) {
                    target.addHistoryJsonTransformer(historyJsonTransformer);
                }
            }
        });
    }

    public int getAsyncExecutorNumberOfRetries() {
        return asyncExecutorNumberOfRetries;
    }

    public JobServiceConfiguration setAsyncExecutorNumberOfRetries(int asyncExecutorNumberOfRetries) {
        this.asyncExecutorNumberOfRetries = asyncExecutorNumberOfRetries;
        return this;
    }

    public int getAsyncExecutorResetExpiredJobsMaxTimeout() {
        return asyncExecutorResetExpiredJobsMaxTimeout;
    }

    public JobServiceConfiguration setAsyncExecutorResetExpiredJobsMaxTimeout(int asyncExecutorResetExpiredJobsMaxTimeout) {
        this.asyncExecutorResetExpiredJobsMaxTimeout = asyncExecutorResetExpiredJobsMaxTimeout;
        return this;
    }

    @Override
    public ObjectMapper getObjectMapper() {
        return objectMapper;
    }

    @Override
    public JobServiceConfiguration setObjectMapper(ObjectMapper objectMapper) {
        this.objectMapper = objectMapper;
        return this;
    }

    public List<JobProcessor> getJobProcessors() {
        return jobProcessors;
    }

    public JobServiceConfiguration setJobProcessors(List<JobProcessor> jobProcessors) {
        this.jobProcessors = Collections.unmodifiableList(jobProcessors);
        return this;
    }

    public List<HistoryJobProcessor> getHistoryJobProcessors() {
        return historyJobProcessors;
    }

    public JobServiceConfiguration setHistoryJobProcessors(List<HistoryJobProcessor> historyJobProcessors) {
        this.historyJobProcessors = Collections.unmodifiableList(historyJobProcessors);
        return this;
    }

    public void setJobParentStateResolver(InternalJobParentStateResolver jobParentStateResolver) {
        this.jobParentStateResolver = jobParentStateResolver;
    }

    public InternalJobParentStateResolver getJobParentStateResolver() {
        return jobParentStateResolver;
    }
    
    public string getJobTypeAsyncHistory() {
        return jobTypeAsyncHistory;
    }

    public void setJobTypeAsyncHistory(string jobTypeAsyncHistory) {
        this.jobTypeAsyncHistory = jobTypeAsyncHistory;
    }

    public string getJobTypeAsyncHistoryZipped() {
        return jobTypeAsyncHistoryZipped;
    }

    public void setJobTypeAsyncHistoryZipped(string jobTypeAsyncHistoryZipped) {
        this.jobTypeAsyncHistoryZipped = jobTypeAsyncHistoryZipped;
    }

    public bool isAsyncHistoryJsonGzipCompressionEnabled() {
        return asyncHistoryJsonGzipCompressionEnabled;
    }

    public void setAsyncHistoryJsonGzipCompressionEnabled(bool asyncHistoryJsonGzipCompressionEnabled) {
        this.asyncHistoryJsonGzipCompressionEnabled = asyncHistoryJsonGzipCompressionEnabled;
    }

    public bool isAsyncHistoryJsonGroupingEnabled() {
        return asyncHistoryJsonGroupingEnabled;
    }

    public void setAsyncHistoryJsonGroupingEnabled(bool asyncHistoryJsonGroupingEnabled) {
        this.asyncHistoryJsonGroupingEnabled = asyncHistoryJsonGroupingEnabled;
    }

    public bool isAsyncHistoryExecutorMessageQueueMode() {
        return asyncHistoryExecutorMessageQueueMode;
    }

    public void setAsyncHistoryExecutorMessageQueueMode(bool asyncHistoryExecutorMessageQueueMode) {
        this.asyncHistoryExecutorMessageQueueMode = asyncHistoryExecutorMessageQueueMode;
    }

    public int getAsyncHistoryJsonGroupingThreshold() {
        return asyncHistoryJsonGroupingThreshold;
    }

    public void setAsyncHistoryJsonGroupingThreshold(int asyncHistoryJsonGroupingThreshold) {
        this.asyncHistoryJsonGroupingThreshold = asyncHistoryJsonGroupingThreshold;
    }
    
}