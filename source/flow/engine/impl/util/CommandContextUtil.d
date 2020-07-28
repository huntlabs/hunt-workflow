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

module flow.engine.impl.util.CommandContextUtil;


import flow.common.persistence.cache.EntityCache;
import hunt.Exceptions;
import hunt.collection.HashMap;
import hunt.collection.Map;

import flow.batch.service.api.BatchService;
import flow.batch.service.BatchServiceConfiguration;
import flow.common.api.deleg.event.FlowableEventDispatcher;
import flow.common.context.Context;
//import flow.common.db.DbSqlSession;
import flow.common.interceptor.CommandContext;
import flow.common.interceptor.EngineConfigurationConstants;
//import flow.common.persistence.cache.EntityCache;
import flow.common.persistence.entity.PropertyEntityManager;
//import org.flowable.content.api.ContentEngineConfigurationApi;
//import org.flowable.content.api.ContentService;
//import org.flowable.dmn.api.DmnEngineConfigurationApi;
//import org.flowable.dmn.api.DmnManagementService;
//import org.flowable.dmn.api.DmnRepositoryService;
//import org.flowable.dmn.api.DmnRuleService;
import flow.engine.FlowableEngineAgenda;
import flow.engine.impl.cfg.ProcessEngineConfigurationImpl;
import flow.engine.impl.history.HistoryManager;
import flow.engine.impl.persistence.entity.ActivityInstanceEntityManager;
import flow.engine.impl.persistence.entity.AttachmentEntityManager;
import flow.engine.impl.persistence.entity.ByteArrayEntityManager;
import flow.engine.impl.persistence.entity.CommentEntityManager;
import flow.engine.impl.persistence.entity.DeploymentEntityManager;
import flow.engine.impl.persistence.entity.EventLogEntryEntityManager;
import flow.engine.impl.persistence.entity.ExecutionEntity;
import flow.engine.impl.persistence.entity.ExecutionEntityManager;
import flow.engine.impl.persistence.entity.HistoricActivityInstanceEntityManager;
import flow.engine.impl.persistence.entity.HistoricDetailEntityManager;
import flow.engine.impl.persistence.entity.HistoricProcessInstanceEntityManager;
import flow.engine.impl.persistence.entity.ModelEntityManager;
import flow.engine.impl.persistence.entity.ProcessDefinitionEntityManager;
import flow.engine.impl.persistence.entity.ProcessDefinitionInfoEntityManager;
import flow.engine.impl.persistence.entity.ResourceEntityManager;
import flow.engine.impl.persistence.entity.TableDataManager;
import flow.entitylink.service.api.EntityLinkService;
import flow.entitylink.service.api.history.HistoricEntityLinkService;
//import flow.entitylink.service.EntityLinkServiceConfiguration;
import flow.event.registry.api.EventRegistry;
import flow.event.registry.api.EventRepositoryService;
import flow.event.registry.EventRegistryEngineConfiguration;
import flow.eventsubscription.service.EventSubscriptionService;
import flow.eventsubscription.service.EventSubscriptionServiceConfiguration;
import flow.form.api.FormEngineConfigurationApi;
import flow.form.api.FormManagementService;
import flow.form.api.FormRepositoryService;
import flow.form.api.FormService;
import flow.identitylink.service.HistoricIdentityLinkService;
import flow.identitylink.service.IdentityLinkService;
import flow.identitylink.service.IdentityLinkServiceConfiguration;
import flow.idm.api.IdmEngineConfigurationApi;
import flow.idm.api.IdmIdentityService;
import flow.job.service.HistoryJobService;
import flow.job.service.JobService;
import flow.job.service.JobServiceConfiguration;
import flow.job.service.TimerJobService;
import flow.job.service.impl.asyncexecutor.FailedJobCommandFactory;
import flow.task.service.HistoricTaskService;
import flow.task.service.InternalTaskAssignmentManager;
import flow.task.service.TaskService;
import flow.task.service.TaskServiceConfiguration;
import flow.variable.service.HistoricVariableService;
import flow.variable.service.VariableService;
import flow.variable.service.VariableServiceConfiguration;
import flow.engine.impl.util.ProcessInstanceHelper;

class CommandContextUtil {

    public static string ATTRIBUTE_INVOLVED_EXECUTIONS = "ctx.attribute.involvedExecutions";

    public static ProcessEngineConfigurationImpl getProcessEngineConfiguration() {
        return getProcessEngineConfiguration(getCommandContext());
    }

    public static ProcessEngineConfigurationImpl getProcessEngineConfiguration(CommandContext commandContext) {
        if (commandContext !is null) {
            return cast(ProcessEngineConfigurationImpl) commandContext.getEngineConfigurations().get(EngineConfigurationConstants.KEY_PROCESS_ENGINE_CONFIG);
        }
        return null;
    }

    // VARIABLE SERVICE
    public static VariableServiceConfiguration getVariableServiceConfiguration() {
        return getVariableServiceConfiguration(getCommandContext());
    }

    public static VariableServiceConfiguration getVariableServiceConfiguration(CommandContext commandContext) {
        return cast(VariableServiceConfiguration) getProcessEngineConfiguration(commandContext).getServiceConfigurations()
            .get(EngineConfigurationConstants.KEY_VARIABLE_SERVICE_CONFIG);
    }

    public static VariableService getVariableService() {
        return getVariableService(getCommandContext());
    }

    public static VariableService getVariableService(CommandContext commandContext) {
        VariableService variableService = null;
        VariableServiceConfiguration variableServiceConfiguration = getVariableServiceConfiguration();
        if (variableServiceConfiguration !is null) {
            variableService = variableServiceConfiguration.getVariableService();
        }

        return variableService;
    }

    public static HistoricVariableService getHistoricVariableService() {
        HistoricVariableService historicVariableService = null;
        VariableServiceConfiguration variableServiceConfiguration = getVariableServiceConfiguration();
        if (variableServiceConfiguration !is null) {
            historicVariableService = variableServiceConfiguration.getHistoricVariableService();
        }

        return historicVariableService;
    }

    // IDENTITY LINK SERVICE
    public static IdentityLinkServiceConfiguration getIdentityLinkServiceConfiguration() {
        return getIdentityLinkServiceConfiguration(getCommandContext());
    }

    public static IdentityLinkServiceConfiguration getIdentityLinkServiceConfiguration(CommandContext commandContext) {
        return cast(IdentityLinkServiceConfiguration) getProcessEngineConfiguration(commandContext).getServiceConfigurations()
            .get(EngineConfigurationConstants.KEY_IDENTITY_LINK_SERVICE_CONFIG);
    }

    public static IdentityLinkService getIdentityLinkService() {
        return getIdentityLinkService(getCommandContext());
    }

    public static IdentityLinkService getIdentityLinkService(CommandContext commandContext) {
        IdentityLinkService identityLinkService = null;
        IdentityLinkServiceConfiguration identityLinkServiceConfiguration = getIdentityLinkServiceConfiguration(commandContext);
        if (identityLinkServiceConfiguration !is null) {
            identityLinkService = identityLinkServiceConfiguration.getIdentityLinkService();
        }

        return identityLinkService;
    }

    public static HistoricIdentityLinkService getHistoricIdentityLinkService() {
        HistoricIdentityLinkService historicIdentityLinkService = null;
        IdentityLinkServiceConfiguration identityLinkServiceConfiguration = getIdentityLinkServiceConfiguration();
        if (identityLinkServiceConfiguration !is null) {
            historicIdentityLinkService = identityLinkServiceConfiguration.getHistoricIdentityLinkService();
        }

        return historicIdentityLinkService;
    }

    // ENTITY LINK SERVICE
    //public static EntityLinkServiceConfiguration getEntityLinkServiceConfiguration() {
    //    return getEntityLinkServiceConfiguration(getCommandContext());
    //}
    //
    //public static EntityLinkServiceConfiguration getEntityLinkServiceConfiguration(CommandContext commandContext) {
    //    return cast(EntityLinkServiceConfiguration) getProcessEngineConfiguration(commandContext).getServiceConfigurations()
    //        .get(EngineConfigurationConstants.KEY_ENTITY_LINK_SERVICE_CONFIG);
    //}

    public static EntityLinkService getEntityLinkService() {
        implementationMissing(false);
        return null;
        //return getEntityLinkService(getCommandContext());
    }

    //public static EntityLinkService getEntityLinkService(CommandContext commandContext) {
    //    EntityLinkService entityLinkService = null;
    //    EntityLinkServiceConfiguration entityLinkServiceConfiguration = getEntityLinkServiceConfiguration(commandContext);
    //    if (entityLinkServiceConfiguration !is null) {
    //        entityLinkService = entityLinkServiceConfiguration.getEntityLinkService();
    //    }
    //
    //    return entityLinkService;
    //}
    //
    //public static HistoricEntityLinkService getHistoricEntityLinkService() {
    //    HistoricEntityLinkService historicEntityLinkService = null;
    //    EntityLinkServiceConfiguration entityLinkServiceConfiguration = getEntityLinkServiceConfiguration();
    //    if (entityLinkServiceConfiguration !is null) {
    //        historicEntityLinkService = entityLinkServiceConfiguration.getHistoricEntityLinkService();
    //    }
    //
    //    return historicEntityLinkService;
    //}

    // EVENT SUBSCRIPTION SERVICE
    public static EventSubscriptionServiceConfiguration getEventSubscriptionServiceConfiguration() {
        return getEventSubscriptionServiceConfiguration(getCommandContext());
    }

    public static EventSubscriptionServiceConfiguration getEventSubscriptionServiceConfiguration(CommandContext commandContext) {
        return cast(EventSubscriptionServiceConfiguration) getProcessEngineConfiguration(commandContext).getServiceConfigurations()
                        .get(EngineConfigurationConstants.KEY_EVENT_SUBSCRIPTION_SERVICE_CONFIG);
    }

    public static EventSubscriptionService getEventSubscriptionService() {
        return getEventSubscriptionService(getCommandContext());
    }

    public static EventSubscriptionService getEventSubscriptionService(CommandContext commandContext) {
        EventSubscriptionService eventSubscriptionService = null;
        EventSubscriptionServiceConfiguration eventSubscriptionServiceConfiguration = getEventSubscriptionServiceConfiguration(commandContext);
        if (eventSubscriptionServiceConfiguration !is null) {
            eventSubscriptionService = eventSubscriptionServiceConfiguration.getEventSubscriptionService();
        }

        return eventSubscriptionService;
    }

    // TASK SERVICE
    public static TaskServiceConfiguration getTaskServiceConfiguration() {
        return getTaskServiceConfiguration(getCommandContext());
    }

    public static TaskServiceConfiguration getTaskServiceConfiguration(CommandContext commandContext) {
        return cast(TaskServiceConfiguration) getProcessEngineConfiguration(commandContext).getServiceConfigurations()
            .get(EngineConfigurationConstants.KEY_TASK_SERVICE_CONFIG);
    }

    public static TaskService getTaskService() {
        return getTaskService(getCommandContext());
    }

    public static TaskService getTaskService(CommandContext commandContext) {
        TaskService taskService = null;
        TaskServiceConfiguration taskServiceConfiguration = getTaskServiceConfiguration(commandContext);
        if (taskServiceConfiguration !is null) {
            taskService = taskServiceConfiguration.getTaskService();
        }
        return taskService;
    }

    public static HistoricTaskService getHistoricTaskService() {
        return getHistoricTaskService(getCommandContext());
    }

    public static HistoricTaskService getHistoricTaskService(CommandContext commandContext) {
        HistoricTaskService historicTaskService = null;
        TaskServiceConfiguration taskServiceConfiguration = getTaskServiceConfiguration(commandContext);
        if (taskServiceConfiguration !is null) {
            historicTaskService = taskServiceConfiguration.getHistoricTaskService();
        }

        return historicTaskService;
    }

    // JOB SERVICE
    public static JobServiceConfiguration getJobServiceConfiguration() {
        return getJobServiceConfiguration(getCommandContext());
    }

    public static JobServiceConfiguration getJobServiceConfiguration(CommandContext commandContext) {
        return cast(JobServiceConfiguration) getProcessEngineConfiguration(commandContext).getServiceConfigurations()
            .get(EngineConfigurationConstants.KEY_JOB_SERVICE_CONFIG);
    }

    public static JobService getJobService() {
        return getJobService(getCommandContext());
    }

    public static JobService getJobService(CommandContext commandContext) {
        JobService jobService = null;
        JobServiceConfiguration jobServiceConfiguration = getJobServiceConfiguration(commandContext);
        if (jobServiceConfiguration !is null) {
            jobService = jobServiceConfiguration.getJobService();
        }

        return jobService;
    }

    public static TimerJobService getTimerJobService() {
        return getTimerJobService(getCommandContext());
    }

    public static TimerJobService getTimerJobService(CommandContext commandContext) {
        TimerJobService timerJobService = null;
        JobServiceConfiguration jobServiceConfiguration = getJobServiceConfiguration(commandContext);
        if (jobServiceConfiguration !is null) {
            timerJobService = jobServiceConfiguration.getTimerJobService();
        }

        return timerJobService;
    }

    public static HistoryJobService getHistoryJobService() {
        return getHistoryJobService(getCommandContext());
    }

    public static HistoryJobService getHistoryJobService(CommandContext commandContext) {
        HistoryJobService historyJobService = null;
        JobServiceConfiguration jobServiceConfiguration = getJobServiceConfiguration(commandContext);
        if (jobServiceConfiguration !is null) {
            historyJobService = jobServiceConfiguration.getHistoryJobService();
        }

        return historyJobService;
    }

    // BATCH SERVICE
    public static BatchServiceConfiguration getBatchServiceConfiguration() {
        return getBatchServiceConfiguration(getCommandContext());
    }

    public static BatchServiceConfiguration getBatchServiceConfiguration(CommandContext commandContext) {
        return cast(BatchServiceConfiguration) getProcessEngineConfiguration(commandContext).getServiceConfigurations()
            .get(EngineConfigurationConstants.KEY_BATCH_SERVICE_CONFIG);
    }

    public static BatchService getBatchService() {
        return getBatchService(getCommandContext());
    }

    public static BatchService getBatchService(CommandContext commandContext) {
        BatchService batchService = null;
        BatchServiceConfiguration batchServiceConfiguration = getBatchServiceConfiguration(commandContext);
        if (batchServiceConfiguration !is null) {
            batchService = batchServiceConfiguration.getBatchService();
        }

        return batchService;
    }

    // IDM ENGINE

    public static IdmEngineConfigurationApi getIdmEngineConfiguration() {
        return getIdmEngineConfiguration(getCommandContext());
    }

    public static IdmEngineConfigurationApi getIdmEngineConfiguration(CommandContext commandContext) {
        return cast(IdmEngineConfigurationApi) commandContext.getEngineConfigurations().get(EngineConfigurationConstants.KEY_IDM_ENGINE_CONFIG);
    }

    public static IdmIdentityService getIdmIdentityService() {
        IdmIdentityService idmIdentityService = null;
        IdmEngineConfigurationApi idmEngineConfiguration = getIdmEngineConfiguration();
        if (idmEngineConfiguration !is null) {
            idmIdentityService = idmEngineConfiguration.getIdmIdentityService();
        }

        return idmIdentityService;
    }

    // EVENT REGISTRY

    public static EventRegistryEngineConfiguration getEventRegistryEngineConfiguration() {
        return getEventRegistryEngineConfiguration(getCommandContext());
    }

    public static EventRegistryEngineConfiguration getEventRegistryEngineConfiguration(CommandContext commandContext) {
        return cast(EventRegistryEngineConfiguration) commandContext.getEngineConfigurations().get(EngineConfigurationConstants.KEY_EVENT_REGISTRY_CONFIG);
    }

    public static EventRegistry getEventRegistry() {
        return getEventRegistry(getCommandContext());
    }

    public static EventRegistry getEventRegistry(CommandContext commandContext) {
        EventRegistry eventRegistry = null;
        EventRegistryEngineConfiguration eventRegistryEngineConfiguration = getEventRegistryEngineConfiguration(commandContext);
        if (eventRegistryEngineConfiguration !is null) {
            eventRegistry = eventRegistryEngineConfiguration.getEventRegistry();
        }

        return eventRegistry;
    }

    public static EventRepositoryService getEventRepositoryService() {
        return getEventRepositoryService(getCommandContext());
    }

    public static EventRepositoryService getEventRepositoryService(CommandContext commandContext) {
        EventRepositoryService eventRepositoryService = null;
        EventRegistryEngineConfiguration eventRegistryEngineConfiguration = getEventRegistryEngineConfiguration(commandContext);
        if (eventRegistryEngineConfiguration !is null) {
            eventRepositoryService = eventRegistryEngineConfiguration.getEventRepositoryService();
        }

        return eventRepositoryService;
    }

    // DMN ENGINE

    //public static DmnEngineConfigurationApi getDmnEngineConfiguration() {
    //    return getDmnEngineConfiguration(getCommandContext());
    //}
    //
    //public static DmnEngineConfigurationApi getDmnEngineConfiguration(CommandContext commandContext) {
    //    return (DmnEngineConfigurationApi) commandContext.getEngineConfigurations().get(EngineConfigurationConstants.KEY_DMN_ENGINE_CONFIG);
    //}
    //
    //public static DmnRepositoryService getDmnRepositoryService() {
    //    DmnRepositoryService dmnRepositoryService = null;
    //    DmnEngineConfigurationApi dmnEngineConfiguration = getDmnEngineConfiguration();
    //    if (dmnEngineConfiguration !is null) {
    //        dmnRepositoryService = dmnEngineConfiguration.getDmnRepositoryService();
    //    }
    //
    //    return dmnRepositoryService;
    //}
    //
    //public static DmnRuleService getDmnRuleService() {
    //    DmnRuleService dmnRuleService = null;
    //    DmnEngineConfigurationApi dmnEngineConfiguration = getDmnEngineConfiguration();
    //    if (dmnEngineConfiguration !is null) {
    //        dmnRuleService = dmnEngineConfiguration.getDmnRuleService();
    //    }
    //
    //    return dmnRuleService;
    //}
    //
    //public static DmnManagementService getDmnManagementService() {
    //    DmnManagementService dmnManagementService = null;
    //    DmnEngineConfigurationApi dmnEngineConfiguration = getDmnEngineConfiguration();
    //    if (dmnEngineConfiguration !is null) {
    //        dmnManagementService = dmnEngineConfiguration.getDmnManagementService();
    //    }
    //
    //    return dmnManagementService;
    //}

    // FORM ENGINE

    public static FormEngineConfigurationApi getFormEngineConfiguration() {
        return getFormEngineConfiguration(getCommandContext());
    }

    public static FormEngineConfigurationApi getFormEngineConfiguration(CommandContext commandContext) {
        return cast(FormEngineConfigurationApi) commandContext.getEngineConfigurations().get(EngineConfigurationConstants.KEY_FORM_ENGINE_CONFIG);
    }

    public static FormRepositoryService getFormRepositoryService() {
        return getFormRepositoryService(getCommandContext());
    }

    public static FormRepositoryService getFormRepositoryService(CommandContext commandContext) {
        FormRepositoryService formRepositoryService = null;
        FormEngineConfigurationApi formEngineConfiguration = getFormEngineConfiguration(commandContext);
        if (formEngineConfiguration !is null) {
            formRepositoryService = formEngineConfiguration.getFormRepositoryService();
        }

        return formRepositoryService;
    }

    public static FormService getFormService() {
        return getFormService(getCommandContext());
    }

    public static FormService getFormService(CommandContext commandContext) {
        FormService formService = null;
        FormEngineConfigurationApi formEngineConfiguration = getFormEngineConfiguration(commandContext);
        if (formEngineConfiguration !is null) {
            formService = formEngineConfiguration.getFormService();
        }

        return formService;
    }

    public static FormManagementService getFormManagementService() {
        return getFormManagementService(getCommandContext());
    }

    public static FormManagementService getFormManagementService(CommandContext commandContext) {
        FormManagementService formManagementService = null;
        FormEngineConfigurationApi formEngineConfiguration = getFormEngineConfiguration(commandContext);
        if (formEngineConfiguration !is null) {
            formManagementService = formEngineConfiguration.getFormManagementService();
        }

        return formManagementService;
    }

    // CONTENT ENGINE
    //
    //public static ContentEngineConfigurationApi getContentEngineConfiguration() {
    //    return getContentEngineConfiguration(getCommandContext());
    //}
    //
    //public static ContentEngineConfigurationApi getContentEngineConfiguration(CommandContext commandContext) {
    //    return (ContentEngineConfigurationApi) commandContext.getEngineConfigurations().get(EngineConfigurationConstants.KEY_CONTENT_ENGINE_CONFIG);
    //}
    //
    //public static ContentService getContentService() {
    //    return getContentService(getCommandContext());
    //}
    //
    //public static ContentService getContentService(CommandContext commandContext) {
    //    ContentService contentService = null;
    //    ContentEngineConfigurationApi contentEngineConfiguration = getContentEngineConfiguration(commandContext);
    //    if (contentEngineConfiguration !is null) {
    //        contentService = contentEngineConfiguration.getContentService();
    //    }
    //
    //    return contentService;
    //}

    public static FlowableEngineAgenda getAgenda() {
        return getAgenda(getCommandContext());
    }

    public static FlowableEngineAgenda getAgenda(CommandContext commandContext) {
        return cast(FlowableEngineAgenda)(commandContext.getSession(typeid(FlowableEngineAgenda)));
    }

    //public static DbSqlSession getDbSqlSession() {
    //    return getDbSqlSession(getCommandContext());
    //}
    //
    //public static DbSqlSession getDbSqlSession(CommandContext commandContext) {
    //    return commandContext.getSession(DbSqlSession.class);
    //}
    //
    //public static EntityCache getEntityCache() {
    //    return getEntityCache(getCommandContext());
    //}
    //
    //public static EntityCache getEntityCache(CommandContext commandContext) {
    //    return commandContext.getSession(EntityCache.class);
    //}

  public static EntityCache getEntityCache()
  {
    return getEntityCache(getCommandContext());
  }

  public static EntityCache getEntityCache(CommandContext commandContext)
  {
    return commandContext.getSession();
  }

    public static void addInvolvedExecution(CommandContext commandContext, ExecutionEntity executionEntity) {
        if (executionEntity.getId() !is null && executionEntity.getId().length != 0) {
            Map!(string, ExecutionEntity) involvedExecutions = null;
            Object obj = commandContext.getAttribute(ATTRIBUTE_INVOLVED_EXECUTIONS);
            if (obj !is null) {
                involvedExecutions = cast(Map!(string, ExecutionEntity)) obj;
            } else {
                involvedExecutions = new HashMap!(string, ExecutionEntity)();
                commandContext.addAttribute(ATTRIBUTE_INVOLVED_EXECUTIONS, cast(Object)involvedExecutions);
            }
            involvedExecutions.put(executionEntity.getId(), executionEntity);
        }
    }

    public static Map!(string, ExecutionEntity) getInvolvedExecutions(CommandContext commandContext) {
        Object obj = commandContext.getAttribute(ATTRIBUTE_INVOLVED_EXECUTIONS);
        if (obj !is null) {
            return cast(Map!(string, ExecutionEntity)) obj;
        }
        return null;
    }

    public static bool hasInvolvedExecutions(CommandContext commandContext) {
        return getInvolvedExecutions(commandContext) !is null;
    }

    public static TableDataManager getTableDataManager() {
        return getTableDataManager(getCommandContext());
    }

    public static TableDataManager getTableDataManager(CommandContext commandContext) {
        return getProcessEngineConfiguration(commandContext).getTableDataManager();
    }

    public static ByteArrayEntityManager getByteArrayEntityManager() {
        return getByteArrayEntityManager(getCommandContext());
    }

    public static ByteArrayEntityManager getByteArrayEntityManager(CommandContext commandContext) {
        return getProcessEngineConfiguration(commandContext).getByteArrayEntityManager();
    }

    public static ResourceEntityManager getResourceEntityManager() {
        return getResourceEntityManager(getCommandContext());
    }

    public static ResourceEntityManager getResourceEntityManager(CommandContext commandContext) {
        return getProcessEngineConfiguration(commandContext).getResourceEntityManager();
    }

    public static DeploymentEntityManager getDeploymentEntityManager() {
        return getDeploymentEntityManager(getCommandContext());
    }

    public static DeploymentEntityManager getDeploymentEntityManager(CommandContext commandContext) {
        return getProcessEngineConfiguration(commandContext).getDeploymentEntityManager();
    }

    public static PropertyEntityManager getPropertyEntityManager() {
        return getPropertyEntityManager(getCommandContext());
    }

    public static PropertyEntityManager getPropertyEntityManager(CommandContext commandContext) {
        return getProcessEngineConfiguration(commandContext).getPropertyEntityManager();
    }

    public static ProcessDefinitionEntityManager getProcessDefinitionEntityManager() {
        return getProcessDefinitionEntityManager(getCommandContext());
    }

    public static ProcessDefinitionEntityManager getProcessDefinitionEntityManager(CommandContext commandContext) {
        return getProcessEngineConfiguration(commandContext).getProcessDefinitionEntityManager();
    }

    public static ProcessDefinitionInfoEntityManager getProcessDefinitionInfoEntityManager() {
        return getProcessDefinitionInfoEntityManager(getCommandContext());
    }

    public static ProcessDefinitionInfoEntityManager getProcessDefinitionInfoEntityManager(CommandContext commandContext) {
        return getProcessEngineConfiguration(commandContext).getProcessDefinitionInfoEntityManager();
    }

    public static ExecutionEntityManager getExecutionEntityManager() {
        return getExecutionEntityManager(getCommandContext());
    }

    public static ExecutionEntityManager getExecutionEntityManager(CommandContext commandContext) {
        return getProcessEngineConfiguration(commandContext).getExecutionEntityManager();
    }

    public static CommentEntityManager getCommentEntityManager() {
        return getCommentEntityManager(getCommandContext());
    }

    public static CommentEntityManager getCommentEntityManager(CommandContext commandContext) {
        return getProcessEngineConfiguration(commandContext).getCommentEntityManager();
    }

    public static ModelEntityManager getModelEntityManager() {
        return getModelEntityManager(getCommandContext());
    }

    public static ModelEntityManager getModelEntityManager(CommandContext commandContext) {
        return getProcessEngineConfiguration(commandContext).getModelEntityManager();
    }

    public static HistoryManager getHistoryManager() {
        return getHistoryManager(getCommandContext());
    }

    public static HistoricProcessInstanceEntityManager getHistoricProcessInstanceEntityManager() {
        return getHistoricProcessInstanceEntityManager(getCommandContext());
    }

    public static HistoricProcessInstanceEntityManager getHistoricProcessInstanceEntityManager(CommandContext commandContext) {
        return getProcessEngineConfiguration(commandContext).getHistoricProcessInstanceEntityManager();
    }

    public static ActivityInstanceEntityManager getActivityInstanceEntityManager() {
        return getActivityInstanceEntityManager(getCommandContext());
    }

    public static ActivityInstanceEntityManager getActivityInstanceEntityManager(CommandContext commandContext) {
        return getProcessEngineConfiguration(commandContext).getActivityInstanceEntityManager();
    }

    public static HistoricActivityInstanceEntityManager getHistoricActivityInstanceEntityManager() {
        return getHistoricActivityInstanceEntityManager(getCommandContext());
    }

    public static HistoricActivityInstanceEntityManager getHistoricActivityInstanceEntityManager(CommandContext commandContext) {
        return getProcessEngineConfiguration(commandContext).getHistoricActivityInstanceEntityManager();
    }

    public static HistoryManager getHistoryManager(CommandContext commandContext) {
        return getProcessEngineConfiguration(commandContext).getHistoryManager();
    }

    public static HistoricDetailEntityManager getHistoricDetailEntityManager() {
        return getHistoricDetailEntityManager(getCommandContext());
    }

    public static HistoricDetailEntityManager getHistoricDetailEntityManager(CommandContext commandContext) {
        return getProcessEngineConfiguration(commandContext).getHistoricDetailEntityManager();
    }

    public static AttachmentEntityManager getAttachmentEntityManager() {
        return getAttachmentEntityManager(getCommandContext());
    }

    public static AttachmentEntityManager getAttachmentEntityManager(CommandContext commandContext) {
        return getProcessEngineConfiguration(commandContext).getAttachmentEntityManager();
    }

    public static EventLogEntryEntityManager getEventLogEntryEntityManager() {
        return getEventLogEntryEntityManager(getCommandContext());
    }

    public static EventLogEntryEntityManager getEventLogEntryEntityManager(CommandContext commandContext) {
        return getProcessEngineConfiguration(commandContext).getEventLogEntryEntityManager();
    }

    public static FlowableEventDispatcher getEventDispatcher() {
        return getEventDispatcher(getCommandContext());
    }

    public static FlowableEventDispatcher getEventDispatcher(CommandContext commandContext) {
        return getProcessEngineConfiguration(commandContext).getEventDispatcher();
    }

    public static FailedJobCommandFactory getFailedJobCommandFactory() {
        return getFailedJobCommandFactory(getCommandContext());
    }

    public static FailedJobCommandFactory getFailedJobCommandFactory(CommandContext commandContext) {
        return getProcessEngineConfiguration(commandContext).getFailedJobCommandFactory();
    }

    public static ProcessInstanceHelper getProcessInstanceHelper() {
        return getProcessInstanceHelper(getCommandContext());
    }

    public static ProcessInstanceHelper getProcessInstanceHelper(CommandContext commandContext) {
        return getProcessEngineConfiguration(commandContext).getProcessInstanceHelper();
    }

    public static CommandContext getCommandContext() {
        return Context.getCommandContext();
    }

    public static InternalTaskAssignmentManager getInternalTaskAssignmentManager(CommandContext commandContext) {
        return getTaskServiceConfiguration(commandContext).getInternalTaskAssignmentManager();
    }

    public static InternalTaskAssignmentManager getInternalTaskAssignmentManager() {
        return getInternalTaskAssignmentManager(getCommandContext());
    }
}
