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


import java.util.Map;

import flow.common.api.deleg.event.FlowableEngineEventType;
import flow.common.api.engine.EngineLifecycleListener;
import flow.common.cfg.TransactionContextFactory;
import flow.common.interceptor.CommandExecutor;
import flow.common.interceptor.SessionFactory;
import flow.engine.DynamicBpmnService;
import flow.engine.FormService;
import flow.engine.HistoryService;
import flow.engine.IdentityService;
import flow.engine.ManagementService;
import flow.engine.ProcessEngine;
import flow.engine.ProcessEngines;
import flow.engine.ProcessMigrationService;
import flow.engine.RepositoryService;
import flow.engine.RuntimeService;
import flow.engine.TaskService;
import flow.engine.delegate.event.impl.FlowableEventBuilder;
import flow.engine.impl.cfg.ProcessEngineConfigurationImpl;
import org.flowable.job.service.impl.asyncexecutor.AsyncExecutor;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

/**
 * @author Tom Baeyens
 */
class ProcessEngineImpl implements ProcessEngine {

    private static final Logger LOGGER = LoggerFactory.getLogger(ProcessEngineImpl.class);

    protected string name;
    protected RepositoryService repositoryService;
    protected RuntimeService runtimeService;
    protected HistoryService historicDataService;
    protected IdentityService identityService;
    protected TaskService taskService;
    protected FormService formService;
    protected ManagementService managementService;
    protected DynamicBpmnService dynamicBpmnService;
    protected ProcessMigrationService processInstanceMigrationService;
    protected AsyncExecutor asyncExecutor;
    protected AsyncExecutor asyncHistoryExecutor;
    protected CommandExecutor commandExecutor;
    protected Map<Class<?>, SessionFactory> sessionFactories;
    protected TransactionContextFactory transactionContextFactory;
    protected ProcessEngineConfigurationImpl processEngineConfiguration;

    public ProcessEngineImpl(ProcessEngineConfigurationImpl processEngineConfiguration) {
        this.processEngineConfiguration = processEngineConfiguration;
        this.name = processEngineConfiguration.getEngineName();
        this.repositoryService = processEngineConfiguration.getRepositoryService();
        this.runtimeService = processEngineConfiguration.getRuntimeService();
        this.historicDataService = processEngineConfiguration.getHistoryService();
        this.identityService = processEngineConfiguration.getIdentityService();
        this.taskService = processEngineConfiguration.getTaskService();
        this.formService = processEngineConfiguration.getFormService();
        this.managementService = processEngineConfiguration.getManagementService();
        this.dynamicBpmnService = processEngineConfiguration.getDynamicBpmnService();
        this.processInstanceMigrationService = processEngineConfiguration.getProcessMigrationService();
        this.asyncExecutor = processEngineConfiguration.getAsyncExecutor();
        this.asyncHistoryExecutor = processEngineConfiguration.getAsyncHistoryExecutor();
        this.commandExecutor = processEngineConfiguration.getCommandExecutor();
        this.sessionFactories = processEngineConfiguration.getSessionFactories();
        this.transactionContextFactory = processEngineConfiguration.getTransactionContextFactory();

        if (processEngineConfiguration.getSchemaManagementCmd() !is null) {
            commandExecutor.execute(processEngineConfiguration.getSchemaCommandConfig(), processEngineConfiguration.getSchemaManagementCmd());
        }

        if (name is null) {
            LOGGER.info("default ProcessEngine created");
        } else {
            LOGGER.info("ProcessEngine {} created", name);
        }

        ProcessEngines.registerProcessEngine(this);

        if (processEngineConfiguration.getEngineLifecycleListeners() !is null) {
            for (EngineLifecycleListener engineLifecycleListener : processEngineConfiguration.getEngineLifecycleListeners()) {
                engineLifecycleListener.onEngineBuilt(this);
            }
        }

        processEngineConfiguration.getEventDispatcher().dispatchEvent(FlowableEventBuilder.createGlobalEvent(FlowableEngineEventType.ENGINE_CREATED));
    }

    @Override
    public void startExecutors() {
        if (asyncExecutor !is null && asyncExecutor.isAutoActivate()) {
            asyncExecutor.start();
        }
        
        if (asyncHistoryExecutor !is null && asyncHistoryExecutor.isAutoActivate()) {
            asyncHistoryExecutor.start();
        }
        
        if (processEngineConfiguration.isEnableHistoryCleaning()) {
            managementService.handleHistoryCleanupTimerJob();
        }
    }

    @Override
    public void close() {
        ProcessEngines.unregister(this);
        if (asyncExecutor !is null && asyncExecutor.isActive()) {
            asyncExecutor.shutdown();
        }
        if (asyncHistoryExecutor !is null && asyncHistoryExecutor.isActive()) {
            asyncHistoryExecutor.shutdown();
        }

        Runnable closeRunnable = processEngineConfiguration.getProcessEngineCloseRunnable();
        if (closeRunnable !is null) {
            closeRunnable.run();
        }

        processEngineConfiguration.close();

        if (processEngineConfiguration.getEngineLifecycleListeners() !is null) {
            for (EngineLifecycleListener engineLifecycleListener : processEngineConfiguration.getEngineLifecycleListeners()) {
                engineLifecycleListener.onEngineClosed(this);
            }
        }

        processEngineConfiguration.getEventDispatcher().dispatchEvent(FlowableEventBuilder.createGlobalEvent(FlowableEngineEventType.ENGINE_CLOSED));
    }

    // getters and setters
    // //////////////////////////////////////////////////////

    @Override
    public string getName() {
        return name;
    }

    @Override
    public IdentityService getIdentityService() {
        return identityService;
    }

    @Override
    public ManagementService getManagementService() {
        return managementService;
    }

    @Override
    public TaskService getTaskService() {
        return taskService;
    }

    @Override
    public HistoryService getHistoryService() {
        return historicDataService;
    }

    @Override
    public RuntimeService getRuntimeService() {
        return runtimeService;
    }

    @Override
    public RepositoryService getRepositoryService() {
        return repositoryService;
    }

    @Override
    public FormService getFormService() {
        return formService;
    }

    @Override
    public DynamicBpmnService getDynamicBpmnService() {
        return dynamicBpmnService;
    }

    @Override
    public ProcessMigrationService getProcessMigrationService() {
        return processInstanceMigrationService;
    }

    @Override
    public ProcessEngineConfigurationImpl getProcessEngineConfiguration() {
        return processEngineConfiguration;
    }
}
