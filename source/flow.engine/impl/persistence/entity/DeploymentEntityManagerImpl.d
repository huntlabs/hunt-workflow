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

module flow.engine.impl.persistence.entity.DeploymentEntityManagerImpl;

import hunt.collection.List;
import hunt.collection.Map;

import flow.bpmn.model.BpmnModel;
import flow.bpmn.model.EventDefinition;
import flow.bpmn.model.Message;
import flow.bpmn.model.MessageEventDefinition;
import flow.bpmn.model.Signal;
import flow.bpmn.model.SignalEventDefinition;
import flow.bpmn.model.StartEvent;
import flow.bpmn.model.TimerEventDefinition;
import flow.common.api.deleg.event.FlowableEngineEventType;
import flow.common.api.repository.EngineResource;
//import flow.common.util.CollectionUtil;
import flow.engine.ProcessEngineConfiguration;
import flow.engine.deleg.event.impl.FlowableEventBuilder;
import flow.engine.impl.DeploymentQueryImpl;
import flow.engine.impl.ModelQueryImpl;
import flow.engine.impl.ProcessDefinitionQueryImpl;
import flow.engine.impl.cfg.ProcessEngineConfigurationImpl;
//import flow.engine.impl.jobexecutor.TimerEventHandler;
//import flow.engine.impl.jobexecutor.TimerStartEventJobHandler;
import flow.engine.impl.persistence.entity.data.DeploymentDataManager;
import flow.engine.impl.util.CommandContextUtil;
import flow.engine.impl.util.CountingEntityUtil;
import flow.engine.impl.util.ProcessDefinitionUtil;
//import flow.engine.impl.util.TimerUtil;
import flow.engine.repository.Deployment;
import flow.engine.repository.Model;
import flow.engine.repository.ProcessDefinition;
//import flow.eventsubscription.service.impl.persistence.entity.MessageEventSubscriptionEntity;
//import flow.eventsubscription.service.impl.persistence.entity.SignalEventSubscriptionEntity;
import flow.job.service.TimerJobService;
import flow.job.service.impl.persistence.entity.TimerJobEntity;
import flow.engine.impl.persistence.entity.AbstractProcessEngineEntityManager;
import flow.engine.impl.persistence.entity.DeploymentEntity;
import flow.engine.impl.persistence.entity.DeploymentEntityManager;
import flow.engine.impl.persistence.entity.ResourceEntity;
import flow.engine.impl.persistence.entity.ModelEntity;
import flow.engine.impl.persistence.entity.ProcessDefinitionEntity;
import flow.engine.impl.persistence.entity.ResourceEntityManager;
import flow.engine.impl.persistence.entity.ProcessDefinitionInfoEntityManager;
import flow.engine.impl.persistence.entity.ProcessDefinitionEntityManager;
import flow.engine.impl.persistence.entity.ModelEntityManager;
import flow.engine.impl.persistence.entity.ExecutionEntityManager;
import flow.bpmn.model.Process;
import hunt.Exceptions;
/**
 * @author Tom Baeyens
 * @author Joram Barrez
 */
class DeploymentEntityManagerImpl
    : AbstractProcessEngineEntityManager!(DeploymentEntity, DeploymentDataManager)
    , DeploymentEntityManager {

    this(ProcessEngineConfigurationImpl processEngineConfiguration, DeploymentDataManager deploymentDataManager) {
        super(processEngineConfiguration, deploymentDataManager);
    }

    override
    public void insert(DeploymentEntity deployment) {
        super.insert(deployment, false);

        foreach (EngineResource resource ; deployment.getResources().values()) {
            resource.setDeploymentId(deployment.getId());
            getResourceEntityManager().insert(cast(ResourceEntity) resource);
        }
    }

    public void deleteDeployment(string deploymentId, bool cascade) {
        List!ProcessDefinition processDefinitions = new ProcessDefinitionQueryImpl().deploymentId(deploymentId).list();

        updateRelatedModels(deploymentId);

        if (cascade) {
            deleteProcessInstancesForProcessDefinitions(processDefinitions);
            deleteHistoricTaskEventLogEntriesForProcessDefinitions(processDefinitions);
        }

        foreach (ProcessDefinition processDefinition ; processDefinitions) {
            deleteProcessDefinitionIdentityLinks(processDefinition);
            deleteEventSubscriptions(processDefinition);
            deleteProcessDefinitionInfo(processDefinition.getId());

            removeTimerStartJobs(processDefinition);

            // If previous process definition version has a timer/signal/message start event, it must be added
            // Only if the currently deleted process definition is the latest version,
            // we fall back to the previous timer/signal/message start event

            restorePreviousStartEventsIfNeeded(processDefinition);
        }

        deleteProcessDefinitionForDeployment(deploymentId);
        getResourceEntityManager().deleteResourcesByDeploymentId(deploymentId);
        dele(findById(deploymentId), false);
    }

    protected void updateRelatedModels(string deploymentId) {
        // Remove the deployment link from any model.
        // The model will still exists, as a model is a source for a deployment model and has a different lifecycle
        List!Model models = new ModelQueryImpl().deploymentId(deploymentId).list();
        foreach (Model model ; models) {
            ModelEntity modelEntity = cast(ModelEntity) model;
            modelEntity.setDeploymentId(null);
            getModelEntityManager().updateModel(modelEntity);
        }
    }

    protected void deleteProcessDefinitionIdentityLinks(ProcessDefinition processDefinition) {
        CommandContextUtil.getIdentityLinkService().deleteIdentityLinksByProcessDefinitionId(processDefinition.getId());
    }

    protected void deleteEventSubscriptions(ProcessDefinition processDefinition) {
        CommandContextUtil.getEventSubscriptionService().deleteEventSubscriptionsForProcessDefinition(processDefinition.getId());
    }

    protected void deleteProcessDefinitionInfo(string processDefinitionId) {
        getProcessDefinitionInfoEntityManager().deleteProcessDefinitionInfo(processDefinitionId);
    }

    protected void deleteProcessDefinitionForDeployment(string deploymentId) {
        getProcessDefinitionEntityManager().deleteProcessDefinitionsByDeploymentId(deploymentId);
    }

    protected void deleteProcessInstancesForProcessDefinitions(List!ProcessDefinition processDefinitions) {
        foreach (ProcessDefinition processDefinition ; processDefinitions) {
            getExecutionEntityManager().deleteProcessInstancesByProcessDefinition(processDefinition.getId(), "deleted deployment", true);
        }
    }

    protected void deleteHistoricTaskEventLogEntriesForProcessDefinitions(List!ProcessDefinition processDefinitions) {
        foreach (ProcessDefinition processDefinition ; processDefinitions) {
            CommandContextUtil.getHistoricTaskService().deleteHistoricTaskLogEntriesForProcessDefinition(processDefinition.getId());
        }
    }

    protected void removeTimerStartJobs(ProcessDefinition processDefinition) {
        implementationMissing(false);

        //TimerJobService timerJobService = CommandContextUtil.getTimerJobService();
        //List!TimerJobEntity timerStartJobs = timerJobService.findJobsByTypeAndProcessDefinitionId(TimerStartEventJobHandler.TYPE, processDefinition.getId());
        //if (timerStartJobs !is null && timerStartJobs.size() > 0) {
        //    foreach (TimerJobEntity timerStartJob ; timerStartJobs) {
        //        if (getEventDispatcher() !is null && getEventDispatcher().isEnabled()) {
        //            getEventDispatcher().dispatchEvent(FlowableEventBuilder.createEntityEvent(FlowableEngineEventType.JOB_CANCELED, timerStartJob, null, null, processDefinition.getId()));
        //        }
        //
        //        timerJobService.deleteTimerJob(timerStartJob);
        //    }
        //}
    }

    protected void restorePreviousStartEventsIfNeeded(ProcessDefinition processDefinition) {
        ProcessDefinitionEntity latestProcessDefinition = findLatestProcessDefinition(processDefinition);
        if (latestProcessDefinition !is null && processDefinition.getId() == (latestProcessDefinition.getId())) {

            // Try to find a previous version (it could be some versions are missing due to deletions)
            ProcessDefinition previousProcessDefinition = findNewLatestProcessDefinitionAfterRemovalOf(processDefinition);
            if (previousProcessDefinition !is null) {

                BpmnModel bpmnModel = ProcessDefinitionUtil.getBpmnModel(previousProcessDefinition.getId());
                flow.bpmn.model.Process.Process previousProcess = ProcessDefinitionUtil.getProcess(previousProcessDefinition.getId());
                if (!previousProcess.getFlowElements().isEmpty()) {

                    List!StartEvent startEvents = previousProcess.findFlowElementsOfType!StartEvent(typeid(StartEvent));

                    if (!startEvents.isEmpty()) {
                        foreach (StartEvent startEvent ; startEvents) {

                            if (!startEvent.getEventDefinitions().isEmpty()) {
                                EventDefinition eventDefinition = startEvent.getEventDefinitions().get(0);
                                if (cast(TimerEventDefinition)eventDefinition !is null) {
                                    restoreTimerStartEvent(previousProcessDefinition, startEvent, eventDefinition);
                                } else if (cast(SignalEventDefinition)eventDefinition !is null) {
                                    restoreSignalStartEvent(previousProcessDefinition, bpmnModel, startEvent, eventDefinition);
                                } else if (cast(MessageEventDefinition)eventDefinition !is null) {
                                    restoreMessageStartEvent(previousProcessDefinition, bpmnModel, startEvent, eventDefinition);
                                }

                            }

                        }
                    }

                }

            }
        }
    }

    protected void restoreTimerStartEvent(ProcessDefinition previousProcessDefinition, StartEvent startEvent, EventDefinition eventDefinition) {
        implementationMissing(false);
        //TimerEventDefinition timerEventDefinition = cast(TimerEventDefinition) eventDefinition;
        //TimerJobEntity timer = TimerUtil.createTimerEntityForTimerEventDefinition(cast(TimerEventDefinition) eventDefinition, false, null, TimerStartEventJobHandler.TYPE,
        //        TimerEventHandler.createConfiguration(startEvent.getId(), timerEventDefinition.getEndDate(), timerEventDefinition.getCalendarName()));
        //
        //if (timer !is null) {
        //    TimerJobEntity timerJob = TimerUtil.createTimerEntityForTimerEventDefinition(timerEventDefinition, false, null, TimerStartEventJobHandler.TYPE,
        //                    TimerEventHandler.createConfiguration(startEvent.getId(), timerEventDefinition.getEndDate(), timerEventDefinition.getCalendarName()));
        //
        //    timerJob.setProcessDefinitionId(previousProcessDefinition.getId());
        //
        //    if (previousProcessDefinition.getTenantId() !is null) {
        //        timerJob.setTenantId(previousProcessDefinition.getTenantId());
        //    }
        //
        //    CommandContextUtil.getTimerJobService().scheduleTimerJob(timerJob);
        //}
    }

    protected void restoreSignalStartEvent(ProcessDefinition previousProcessDefinition, BpmnModel bpmnModel, StartEvent startEvent, EventDefinition eventDefinition) {
         implementationMissing(false);
        //SignalEventDefinition signalEventDefinition = cast(SignalEventDefinition) eventDefinition;
        //SignalEventSubscriptionEntity subscriptionEntity = CommandContextUtil.getEventSubscriptionService().createSignalEventSubscription();
        //Signal signal = bpmnModel.getSignal(signalEventDefinition.getSignalRef());
        //if (signal !is null) {
        //    subscriptionEntity.setEventName(signal.getName());
        //} else {
        //    subscriptionEntity.setEventName(signalEventDefinition.getSignalRef());
        //}
        //subscriptionEntity.setActivityId(startEvent.getId());
        //subscriptionEntity.setProcessDefinitionId(previousProcessDefinition.getId());
        //if (previousProcessDefinition.getTenantId().length != 0) {
        //    subscriptionEntity.setTenantId(previousProcessDefinition.getTenantId());
        //}
        //
        //CommandContextUtil.getEventSubscriptionService().insertEventSubscription(subscriptionEntity);
        //CountingEntityUtil.handleInsertEventSubscriptionEntityCount(subscriptionEntity);
    }

    protected void restoreMessageStartEvent(ProcessDefinition previousProcessDefinition, BpmnModel bpmnModel, StartEvent startEvent, EventDefinition eventDefinition) {
        //MessageEventDefinition messageEventDefinition = cast(MessageEventDefinition) eventDefinition;
        //if (bpmnModel.containsMessageId(messageEventDefinition.getMessageRef())) {
        //    Message message = bpmnModel.getMessage(messageEventDefinition.getMessageRef());
        //    messageEventDefinition.setMessageRef(message.getName());
        //}
        //
        //MessageEventSubscriptionEntity newSubscription = CommandContextUtil.getEventSubscriptionService().createMessageEventSubscription();
        //newSubscription.setEventName(messageEventDefinition.getMessageRef());
        //newSubscription.setActivityId(startEvent.getId());
        //newSubscription.setConfiguration(previousProcessDefinition.getId());
        //newSubscription.setProcessDefinitionId(previousProcessDefinition.getId());
        //
        //if (previousProcessDefinition.getTenantId() !is null) {
        //    newSubscription.setTenantId(previousProcessDefinition.getTenantId());
        //}
        //
        //CommandContextUtil.getEventSubscriptionService().insertEventSubscription(newSubscription);
        //CountingEntityUtil.handleInsertEventSubscriptionEntityCount(newSubscription);
        implementationMissing(false);

    }

    protected ProcessDefinitionEntity findLatestProcessDefinition(ProcessDefinition processDefinition) {
        ProcessDefinitionEntity latestProcessDefinition = null;
        if (processDefinition.getTenantId().length != 0 && ProcessEngineConfiguration.NO_TENANT_ID != (processDefinition.getTenantId())) {
            latestProcessDefinition = getProcessDefinitionEntityManager()
                    .findLatestProcessDefinitionByKeyAndTenantId(processDefinition.getKey(), processDefinition.getTenantId());
        } else {
            latestProcessDefinition = getProcessDefinitionEntityManager()
                    .findLatestProcessDefinitionByKey(processDefinition.getKey());
        }
        return latestProcessDefinition;
    }

    protected ProcessDefinition findNewLatestProcessDefinitionAfterRemovalOf(ProcessDefinition processDefinitionToBeRemoved) {

        // The latest process definition is not necessarily the one with 'version -1' (some versions could have been deleted)
        // Hence, the following logic

        ProcessDefinitionQueryImpl query = new ProcessDefinitionQueryImpl();
        query.processDefinitionKey(processDefinitionToBeRemoved.getKey());

        if (processDefinitionToBeRemoved.getTenantId().length != 0
                && ProcessEngineConfiguration.NO_TENANT_ID != (processDefinitionToBeRemoved.getTenantId())) {
            query.processDefinitionTenantId(processDefinitionToBeRemoved.getTenantId());
        } else {
            query.processDefinitionWithoutTenantId();
        }

        if (processDefinitionToBeRemoved.getVersion() > 0) {
            query.processDefinitionVersionLowerThan(processDefinitionToBeRemoved.getVersion());
        }
        query.orderByProcessDefinitionVersion().desc();

        query.setFirstResult(0);
        query.setMaxResults(1);
        List!ProcessDefinition processDefinitions = getProcessDefinitionEntityManager().findProcessDefinitionsByQueryCriteria(query);
        if (processDefinitions !is null && processDefinitions.size() > 0) {
            return processDefinitions.get(0);
        }
        return null;
    }

    public long findDeploymentCountByQueryCriteria(DeploymentQueryImpl deploymentQuery) {
        return dataManager.findDeploymentCountByQueryCriteria(deploymentQuery);
    }

    public List!Deployment findDeploymentsByQueryCriteria(DeploymentQueryImpl deploymentQuery) {
        return dataManager.findDeploymentsByQueryCriteria(deploymentQuery);
    }

    public List!string getDeploymentResourceNames(string deploymentId) {
        return dataManager.getDeploymentResourceNames(deploymentId);
    }

    public List!Deployment findDeploymentsByNativeQuery(Map!(string, Object) parameterMap) {
        return dataManager.findDeploymentsByNativeQuery(parameterMap);
    }

    public long findDeploymentCountByNativeQuery(Map!(string, Object) parameterMap) {
        return dataManager.findDeploymentCountByNativeQuery(parameterMap);
    }

    protected ResourceEntityManager getResourceEntityManager() {
        return engineConfiguration.getResourceEntityManager();
    }

    protected ModelEntityManager getModelEntityManager() {
        return engineConfiguration.getModelEntityManager();
    }

    protected ProcessDefinitionEntityManager getProcessDefinitionEntityManager() {
        return engineConfiguration.getProcessDefinitionEntityManager();
    }

    protected ProcessDefinitionInfoEntityManager getProcessDefinitionInfoEntityManager() {
        return engineConfiguration.getProcessDefinitionInfoEntityManager();
    }

    protected ExecutionEntityManager getExecutionEntityManager() {
        return engineConfiguration.getExecutionEntityManager();
    }

}
