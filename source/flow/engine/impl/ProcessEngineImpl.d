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

module flow.engine.impl.ProcessEngineImpl;





import hunt.collection.Map;

import flow.common.api.deleg.event.FlowableEngineEventType;
import flow.common.api.engine.EngineLifecycleListener;
import flow.common.cfg.TransactionContextFactory;
import flow.common.interceptor.CommandExecutor;
import flow.common.interceptor.SessionFactory;
//import flow.engine.DynamicBpmnService;
import flow.engine.FormService;
import flow.engine.HistoryService;
import flow.engine.IdentityService;
import flow.engine.ManagementService;
import flow.engine.ProcessEngine;
import flow.engine.ProcessEngines;
//import flow.engine.ProcessMigrationService;
import flow.engine.RepositoryService;
import flow.engine.RuntimeService;
import flow.engine.TaskService;
import flow.engine.deleg.event.impl.FlowableEventBuilder;
import flow.engine.impl.cfg.ProcessEngineConfigurationImpl;
import flow.job.service.impl.asyncexecutor.AsyncExecutor;
import hunt.logging;
import hunt.util.Runnable;
/**
 * @author Tom Baeyens
 */
class ProcessEngineImpl : ProcessEngine {
    protected string name;
    protected RepositoryService repositoryService;
    protected RuntimeService runtimeService;
    protected HistoryService historicDataService;
    protected IdentityService identityService;
    protected TaskService taskService;
    protected FormService formService;
    protected ManagementService managementService;
    //protected DynamicBpmnService dynamicBpmnService;
   // protected ProcessMigrationService processInstanceMigrationService;
    protected AsyncExecutor asyncExecutor;
    protected AsyncExecutor asyncHistoryExecutor;
    protected CommandExecutor commandExecutor;
    //protected Map<Class<?>, SessionFactory> sessionFactories;
    protected TransactionContextFactory transactionContextFactory;
    protected ProcessEngineConfigurationImpl processEngineConfiguration;

    this(ProcessEngineConfigurationImpl processEngineConfiguration) {
        this.processEngineConfiguration = processEngineConfiguration;
        this.name = processEngineConfiguration.getEngineName();
        this.repositoryService = processEngineConfiguration.getRepositoryService();
        this.runtimeService = processEngineConfiguration.getRuntimeService();
        this.historicDataService = processEngineConfiguration.getHistoryService();
        this.identityService = processEngineConfiguration.getIdentityService();
        this.taskService = processEngineConfiguration.getTaskService();
        this.formService = processEngineConfiguration.getFormService();
        this.managementService = processEngineConfiguration.getManagementService();
        //this.dynamicBpmnService = processEngineConfiguration.getDynamicBpmnService();
        //this.processInstanceMigrationService = processEngineConfiguration.getProcessMigrationService();
        this.asyncExecutor = processEngineConfiguration.getAsyncExecutor();
        this.asyncHistoryExecutor = processEngineConfiguration.getAsyncHistoryExecutor();
        this.commandExecutor = processEngineConfiguration.getCommandExecutor();
        //this.sessionFactories = processEngineConfiguration.getSessionFactories();
        this.transactionContextFactory = processEngineConfiguration.getTransactionContextFactory();

        //if (processEngineConfiguration.getSchemaManagementCmd() !is null) {
        //    commandExecutor.execute(processEngineConfiguration.getSchemaCommandConfig(), processEngineConfiguration.getSchemaManagementCmd());
        //}

        if (name is null) {
            logInfo("default ProcessEngine created");
        } else {
            logInfof("ProcessEngine {} created %s",name);
        }

        ProcessEngines.registerProcessEngine(this);
        //if (processEngineConfiguration.getProcessEngineLifecycleListener() !is null) {
        //    processEngineConfiguration.getProcessEngineLifecycleListener().onProcessEngineBuilt(this);
        //}
        //
        //processEngineConfiguration.getEventDispatcher().dispatchEvent(FlowableEventBuilder.createGlobalEvent(FlowableEngineEventType.ENGINE_CREATED));
        //
        //if (asyncExecutor !is null && asyncExecutor.isAutoActivate()) {
        //    asyncExecutor.start();
        //}
        //if (asyncHistoryExecutor !is null && asyncHistoryExecutor.isAutoActivate()) {
        //    asyncHistoryExecutor.start();
        //}
        if (processEngineConfiguration.getEngineLifecycleListeners() !is null) {
            foreach (EngineLifecycleListener engineLifecycleListener ; processEngineConfiguration.getEngineLifecycleListeners()) {
                engineLifecycleListener.onEngineBuilt(this);
            }
        }

        processEngineConfiguration.getEventDispatcher().dispatchEvent(FlowableEventBuilder.createGlobalEvent(FlowableEngineEventType.ENGINE_CREATED));
    }

    override
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

    override
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
            foreach (EngineLifecycleListener engineLifecycleListener ; processEngineConfiguration.getEngineLifecycleListeners()) {
                engineLifecycleListener.onEngineClosed(this);
            }
        }

        processEngineConfiguration.getEventDispatcher().dispatchEvent(FlowableEventBuilder.createGlobalEvent(FlowableEngineEventType.ENGINE_CLOSED));
    }

    // getters and setters
    // //////////////////////////////////////////////////////

    override
    public string getName() {
        return name;
    }

    override
    public IdentityService getIdentityService() {
        return identityService;
    }

    override
    public ManagementService getManagementService() {
        return managementService;
    }

    override
    public TaskService getTaskService() {
        return taskService;
    }

    override
    public HistoryService getHistoryService() {
        return historicDataService;
    }

    override
    public RuntimeService getRuntimeService() {
        return runtimeService;
    }

    override
    public RepositoryService getRepositoryService() {
        return repositoryService;
    }

    override
    public FormService getFormService() {
        return formService;
    }

    //override
    //public DynamicBpmnService getDynamicBpmnService() {
    //    return dynamicBpmnService;
    //}
    //
    //override
    //public ProcessMigrationService getProcessMigrationService() {
    //    return processInstanceMigrationService;
    //}

    override
    public ProcessEngineConfigurationImpl getProcessEngineConfiguration() {
        return processEngineConfiguration;
    }
}
