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
module flow.task.service.TaskServiceConfiguration;

import hunt.collection.List;
import hunt.collection.Map;
import hunt.Exceptions;
import flow.common.api.deleg.event.FlowableEventDispatcher;
import flow.common.api.deleg.event.FlowableEventListener;
import flow.common.AbstractServiceConfiguration;
import flow.idm.api.IdmIdentityService;
import flow.task.api.TaskQueryInterceptor;
import flow.task.api.history.HistoricTaskQueryInterceptor;
import flow.task.service.history.InternalHistoryTaskManager;
import flow.task.service.impl.HistoricTaskServiceImpl;
import flow.task.service.impl.TaskServiceImpl;
import flow.task.service.impl.persistence.entity.HistoricTaskInstanceEntityManager;
import flow.task.service.impl.persistence.entity.HistoricTaskInstanceEntityManagerImpl;
import flow.task.service.impl.persistence.entity.HistoricTaskLogEntryEntityManager;
import flow.task.service.impl.persistence.entity.HistoricTaskLogEntryEntityManagerImpl;
import flow.task.service.impl.persistence.entity.TaskEntityManager;
import flow.task.service.impl.persistence.entity.TaskEntityManagerImpl;
import flow.task.service.impl.persistence.entity.data.HistoricTaskInstanceDataManager;
import flow.task.service.impl.persistence.entity.data.HistoricTaskLogEntryDataManager;
import flow.task.service.impl.persistence.entity.data.TaskDataManager;
import flow.task.service.impl.persistence.entity.data.impl.MyBatisHistoricTaskLogEntryDataManager;
import flow.task.service.impl.persistence.entity.data.impl.MybatisHistoricTaskInstanceDataManager;
import flow.task.service.impl.persistence.entity.data.impl.MybatisTaskDataManager;
import flow.task.service.TaskService;
import flow.task.service.HistoricTaskService;
import flow.task.service.InternalTaskVariableScopeResolver;
import flow.task.service.InternalTaskLocalizationManager;
import flow.task.service.InternalTaskAssignmentManager;
import flow.task.service.TaskPostProcessor;

class TaskServiceConfiguration : AbstractServiceConfiguration {

    public static  string DEFAULT_MYBATIS_MAPPING_FILE = "org/flowable/task/service/db/mapping/mappings.xml";

    // SERVICES
    // /////////////////////////////////////////////////////////////////

    protected TaskService taskService  ;//= new TaskServiceImpl(this);
    protected HistoricTaskService historicTaskService ;// = new HistoricTaskServiceImpl(this);

    protected IdmIdentityService idmIdentityService;

    // DATA MANAGERS ///////////////////////////////////////////////////

    protected TaskDataManager taskDataManager;
    protected HistoricTaskInstanceDataManager historicTaskInstanceDataManager;
    protected HistoricTaskLogEntryDataManager historicTaskLogDataManager;

    // ENTITY MANAGERS /////////////////////////////////////////////////
    protected TaskEntityManager taskEntityManager;
    protected HistoricTaskInstanceEntityManager historicTaskInstanceEntityManager;
    protected HistoricTaskLogEntryEntityManager historicTaskLogEntryEntityManager;

    protected InternalTaskVariableScopeResolver internalTaskVariableScopeResolver;
    protected InternalHistoryTaskManager internalHistoryTaskManager;
    protected InternalTaskLocalizationManager internalTaskLocalizationManager;
    protected InternalTaskAssignmentManager internalTaskAssignmentManager;

    protected bool enableTaskRelationshipCounts;
    protected bool enableLocalization;

    protected TaskQueryInterceptor taskQueryInterceptor;
    protected HistoricTaskQueryInterceptor historicTaskQueryInterceptor;
    protected int taskQueryLimit;
    protected int historicTaskQueryLimit;

    protected TaskPostProcessor taskPostProcessor;

    // Events
    protected bool enableHistoricTaskLogging;

    this(string engineName) {
        super(engineName);
        taskService = new TaskServiceImpl(this);
        historicTaskService = new HistoricTaskServiceImpl(this);
    }

    // init
    // /////////////////////////////////////////////////////////////////////

    public void init() {
        initDataManagers();
        initEntityManagers();
        initTaskPostProcessor();
    }

    // Data managers
    ///////////////////////////////////////////////////////////

    public void initDataManagers() {
        if (taskDataManager is null) {
            taskDataManager = new MybatisTaskDataManager();
        }
        if (historicTaskInstanceDataManager is null) {
            historicTaskInstanceDataManager = new MybatisHistoricTaskInstanceDataManager();
        }
        if (historicTaskLogDataManager is null) {
            historicTaskLogDataManager = new MyBatisHistoricTaskLogEntryDataManager();
        }
    }

    public void initEntityManagers() {
        if (taskEntityManager is null) {
            taskEntityManager = new TaskEntityManagerImpl(this, taskDataManager);
        }
        if (historicTaskInstanceEntityManager is null) {
            historicTaskInstanceEntityManager = new HistoricTaskInstanceEntityManagerImpl(this, historicTaskInstanceDataManager);
        }
        if (historicTaskLogEntryEntityManager is null) {
            historicTaskLogEntryEntityManager = new HistoricTaskLogEntryEntityManagerImpl(this, historicTaskLogDataManager);
        }
    }

    public void initTaskPostProcessor() {
        if (taskPostProcessor is null) {
            implementationMissing(false);
            //taskPostProcessor = taskBuilder -> taskBuilder;
        }
    }

    public TaskService getTaskService() {
        return taskService;
    }

    public TaskServiceConfiguration setTaskService(TaskService taskService) {
        this.taskService = taskService;
        return this;
    }

    public HistoricTaskService getHistoricTaskService() {
        return historicTaskService;
    }

    public TaskServiceConfiguration setHistoricTaskService(HistoricTaskService historicTaskService) {
        this.historicTaskService = historicTaskService;
        return this;
    }

    public IdmIdentityService getIdmIdentityService() {
        return idmIdentityService;
    }

    public void setIdmIdentityService(IdmIdentityService idmIdentityService) {
        this.idmIdentityService = idmIdentityService;
    }

    public TaskServiceConfiguration getTaskServiceConfiguration() {
        return this;
    }

    public TaskDataManager getTaskDataManager() {
        return taskDataManager;
    }

    public TaskServiceConfiguration setTaskDataManager(TaskDataManager taskDataManager) {
        this.taskDataManager = taskDataManager;
        return this;
    }

    public HistoricTaskInstanceDataManager getHistoricTaskInstanceDataManager() {
        return historicTaskInstanceDataManager;
    }

    public TaskServiceConfiguration setHistoricTaskInstanceDataManager(HistoricTaskInstanceDataManager historicTaskInstanceDataManager) {
        this.historicTaskInstanceDataManager = historicTaskInstanceDataManager;
        return this;
    }

    public TaskEntityManager getTaskEntityManager() {
        return taskEntityManager;
    }

    public TaskServiceConfiguration setTaskEntityManager(TaskEntityManager taskEntityManager) {
        this.taskEntityManager = taskEntityManager;
        return this;
    }

    public HistoricTaskInstanceEntityManager getHistoricTaskInstanceEntityManager() {
        return historicTaskInstanceEntityManager;
    }

    public TaskServiceConfiguration setHistoricTaskInstanceEntityManager(HistoricTaskInstanceEntityManager historicTaskInstanceEntityManager) {
        this.historicTaskInstanceEntityManager = historicTaskInstanceEntityManager;
        return this;
    }

    public HistoricTaskLogEntryEntityManager getHistoricTaskLogEntryEntityManager() {
        return historicTaskLogEntryEntityManager;
    }

    public TaskServiceConfiguration setHistoricTaskLogEntryEntityManager(HistoricTaskLogEntryEntityManager historicTaskLogEntryEntityManager) {
        this.historicTaskLogEntryEntityManager = historicTaskLogEntryEntityManager;
        return this;
    }

    public InternalTaskVariableScopeResolver getInternalTaskVariableScopeResolver() {
        return internalTaskVariableScopeResolver;
    }

    public void setInternalTaskVariableScopeResolver(InternalTaskVariableScopeResolver internalTaskVariableScopeResolver) {
        this.internalTaskVariableScopeResolver = internalTaskVariableScopeResolver;
    }

    public InternalHistoryTaskManager getInternalHistoryTaskManager() {
        return internalHistoryTaskManager;
    }

    public void setInternalHistoryTaskManager(InternalHistoryTaskManager internalHistoryTaskManager) {
        this.internalHistoryTaskManager = internalHistoryTaskManager;
    }

    public InternalTaskLocalizationManager getInternalTaskLocalizationManager() {
        return internalTaskLocalizationManager;
    }

    public void setInternalTaskLocalizationManager(InternalTaskLocalizationManager internalTaskLocalizationManager) {
        this.internalTaskLocalizationManager = internalTaskLocalizationManager;
    }

    public InternalTaskAssignmentManager getInternalTaskAssignmentManager() {
        return internalTaskAssignmentManager;
    }

    public void setInternalTaskAssignmentManager(InternalTaskAssignmentManager internalTaskAssignmentManager) {
        this.internalTaskAssignmentManager = internalTaskAssignmentManager;
    }

    public bool isEnableTaskRelationshipCounts() {
        return enableTaskRelationshipCounts;
    }

    public TaskServiceConfiguration setEnableTaskRelationshipCounts(bool enableTaskRelationshipCounts) {
        this.enableTaskRelationshipCounts = enableTaskRelationshipCounts;
        return this;
    }

    public bool isEnableLocalization() {
        return enableLocalization;
    }

    public TaskServiceConfiguration setEnableLocalization(bool enableLocalization) {
        this.enableLocalization = enableLocalization;
        return this;
    }

    public TaskQueryInterceptor getTaskQueryInterceptor() {
        return taskQueryInterceptor;
    }

    public TaskServiceConfiguration setTaskQueryInterceptor(TaskQueryInterceptor taskQueryInterceptor) {
        this.taskQueryInterceptor = taskQueryInterceptor;
        return this;
    }

    public HistoricTaskQueryInterceptor getHistoricTaskQueryInterceptor() {
        return historicTaskQueryInterceptor;
    }

    public TaskServiceConfiguration setHistoricTaskQueryInterceptor(HistoricTaskQueryInterceptor historicTaskQueryInterceptor) {
        this.historicTaskQueryInterceptor = historicTaskQueryInterceptor;
        return this;
    }

    public int getTaskQueryLimit() {
        return taskQueryLimit;
    }

    public TaskServiceConfiguration setTaskQueryLimit(int taskQueryLimit) {
        this.taskQueryLimit = taskQueryLimit;
        return this;
    }

    public int getHistoricTaskQueryLimit() {
        return historicTaskQueryLimit;
    }

    public TaskServiceConfiguration setHistoricTaskQueryLimit(int historicTaskQueryLimit) {
        this.historicTaskQueryLimit = historicTaskQueryLimit;
        return this;
    }

    public bool isEnableHistoricTaskLogging() {
        return enableHistoricTaskLogging;
    }

    public TaskServiceConfiguration setEnableHistoricTaskLogging(bool enableHistoricTaskLogging) {
        this.enableHistoricTaskLogging = enableHistoricTaskLogging;
        return this;
    }

    override
    public TaskServiceConfiguration setEnableEventDispatcher(bool enableEventDispatcher) {
        this.enableEventDispatcher = enableEventDispatcher;
        return this;
    }

    override
    public TaskServiceConfiguration setEventDispatcher(FlowableEventDispatcher eventDispatcher) {
        this.eventDispatcher = eventDispatcher;
        return this;
    }

    override
    public TaskServiceConfiguration setEventListeners(List!FlowableEventListener eventListeners) {
        this.eventListeners = eventListeners;
        return this;
    }

    override
    public TaskServiceConfiguration setTypedEventListeners(Map!(string, List!FlowableEventListener) typedEventListeners) {
        this.typedEventListeners = typedEventListeners;
        return this;
    }

    public TaskPostProcessor getTaskPostProcessor() {
        return taskPostProcessor;
    }

    public TaskServiceConfiguration setTaskPostProcessor(TaskPostProcessor processor) {
        this.taskPostProcessor = processor;
        return this;
    }
}
