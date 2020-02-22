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



import java.util.List;
import java.util.Map;

import org.flowable.bpmn.model.BpmnModel;
import org.flowable.bpmn.model.EventDefinition;
import org.flowable.bpmn.model.Message;
import org.flowable.bpmn.model.MessageEventDefinition;
import org.flowable.bpmn.model.Signal;
import org.flowable.bpmn.model.SignalEventDefinition;
import org.flowable.bpmn.model.StartEvent;
import org.flowable.bpmn.model.TimerEventDefinition;
import flow.common.api.deleg.event.FlowableEngineEventType;
import flow.common.api.repository.EngineResource;
import flow.common.util.CollectionUtil;
import flow.engine.ProcessEngineConfiguration;
import flow.engine.deleg.event.impl.FlowableEventBuilder;
import flow.engine.impl.DeploymentQueryImpl;
import flow.engine.impl.ModelQueryImpl;
import flow.engine.impl.ProcessDefinitionQueryImpl;
import flow.engine.impl.cfg.ProcessEngineConfigurationImpl;
import flow.engine.impl.jobexecutor.TimerEventHandler;
import flow.engine.impl.jobexecutor.TimerStartEventJobHandler;
import flow.engine.impl.persistence.entity.data.DeploymentDataManager;
import flow.engine.impl.util.CommandContextUtil;
import flow.engine.impl.util.CountingEntityUtil;
import flow.engine.impl.util.ProcessDefinitionUtil;
import flow.engine.impl.util.TimerUtil;
import flow.engine.repository.Deployment;
import flow.engine.repository.Model;
import flow.engine.repository.ProcessDefinition;
import org.flowable.eventsubscription.service.impl.persistence.entity.MessageEventSubscriptionEntity;
import org.flowable.eventsubscription.service.impl.persistence.entity.SignalEventSubscriptionEntity;
import org.flowable.job.service.TimerJobService;
import org.flowable.job.service.impl.persistence.entity.TimerJobEntity;

/**
 * @author Tom Baeyens
 * @author Joram Barrez
 */
class DeploymentEntityManagerImpl
    extends AbstractProcessEngineEntityManager<DeploymentEntity, DeploymentDataManager>
    implements DeploymentEntityManager {

    public DeploymentEntityManagerImpl(ProcessEngineConfigurationImpl processEngineConfiguration, DeploymentDataManager deploymentDataManager) {
        super(processEngineConfiguration, deploymentDataManager);
    }

    @Override
    public void insert(DeploymentEntity deployment) {
        insert(deployment, false);

        for (EngineResource resource : deployment.getResources().values()) {
            resource.setDeploymentId(deployment.getId());
            getResourceEntityManager().insert((ResourceEntity) resource);
        }
    }

    @Override
    public void deleteDeployment(string deploymentId, bool cascade) {
        List<ProcessDefinition> processDefinitions = new ProcessDefinitionQueryImpl().deploymentId(deploymentId).list();

        updateRelatedModels(deploymentId);

        if (cascade) {
            deleteProcessInstancesForProcessDefinitions(processDefinitions);
            deleteHistoricTaskEventLogEntriesForProcessDefinitions(processDefinitions);
        }

        for (ProcessDefinition processDefinition : processDefinitions) {
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
        delete(findById(deploymentId), false);
    }

    protected void updateRelatedModels(string deploymentId) {
        // Remove the deployment link from any model.
        // The model will still exists, as a model is a source for a deployment model and has a different lifecycle
        List<Model> models = new ModelQueryImpl().deploymentId(deploymentId).list();
        for (Model model : models) {
            ModelEntity modelEntity = (ModelEntity) model;
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

    protected void deleteProcessInstancesForProcessDefinitions(List<ProcessDefinition> processDefinitions) {
        for (ProcessDefinition processDefinition : processDefinitions) {
            getExecutionEntityManager().deleteProcessInstancesByProcessDefinition(processDefinition.getId(), "deleted deployment", true);
        }
    }

    protected void deleteHistoricTaskEventLogEntriesForProcessDefinitions(List<ProcessDefinition> processDefinitions) {
        for (ProcessDefinition processDefinition : processDefinitions) {
            CommandContextUtil.getHistoricTaskService().deleteHistoricTaskLogEntriesForProcessDefinition(processDefinition.getId());
        }
    }

    protected void removeTimerStartJobs(ProcessDefinition processDefinition) {
        TimerJobService timerJobService = CommandContextUtil.getTimerJobService();
        List<TimerJobEntity> timerStartJobs = timerJobService.findJobsByTypeAndProcessDefinitionId(TimerStartEventJobHandler.TYPE, processDefinition.getId());
        if (timerStartJobs !is null && timerStartJobs.size() > 0) {
            for (TimerJobEntity timerStartJob : timerStartJobs) {
                if (getEventDispatcher() !is null && getEventDispatcher().isEnabled()) {
                    getEventDispatcher().dispatchEvent(FlowableEventBuilder.createEntityEvent(FlowableEngineEventType.JOB_CANCELED, timerStartJob, null, null, processDefinition.getId()));
                }

                timerJobService.deleteTimerJob(timerStartJob);
            }
        }
    }

    protected void restorePreviousStartEventsIfNeeded(ProcessDefinition processDefinition) {
        ProcessDefinitionEntity latestProcessDefinition = findLatestProcessDefinition(processDefinition);
        if (latestProcessDefinition !is null && processDefinition.getId().equals(latestProcessDefinition.getId())) {

            // Try to find a previous version (it could be some versions are missing due to deletions)
            ProcessDefinition previousProcessDefinition = findNewLatestProcessDefinitionAfterRemovalOf(processDefinition);
            if (previousProcessDefinition !is null) {

                BpmnModel bpmnModel = ProcessDefinitionUtil.getBpmnModel(previousProcessDefinition.getId());
                org.flowable.bpmn.model.Process previousProcess = ProcessDefinitionUtil.getProcess(previousProcessDefinition.getId());
                if (CollectionUtil.isNotEmpty(previousProcess.getFlowElements())) {

                    List<StartEvent> startEvents = previousProcess.findFlowElementsOfType(StartEvent.class);

                    if (CollectionUtil.isNotEmpty(startEvents)) {
                        for (StartEvent startEvent : startEvents) {

                            if (CollectionUtil.isNotEmpty(startEvent.getEventDefinitions())) {
                                EventDefinition eventDefinition = startEvent.getEventDefinitions().get(0);
                                if (eventDefinition instanceof TimerEventDefinition) {
                                    restoreTimerStartEvent(previousProcessDefinition, startEvent, eventDefinition);
                                } else if (eventDefinition instanceof SignalEventDefinition) {
                                    restoreSignalStartEvent(previousProcessDefinition, bpmnModel, startEvent, eventDefinition);
                                } else if (eventDefinition instanceof MessageEventDefinition) {
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
        TimerEventDefinition timerEventDefinition = (TimerEventDefinition) eventDefinition;
        TimerJobEntity timer = TimerUtil.createTimerEntityForTimerEventDefinition((TimerEventDefinition) eventDefinition, false, null, TimerStartEventJobHandler.TYPE,
                TimerEventHandler.createConfiguration(startEvent.getId(), timerEventDefinition.getEndDate(), timerEventDefinition.getCalendarName()));

        if (timer !is null) {
            TimerJobEntity timerJob = TimerUtil.createTimerEntityForTimerEventDefinition(timerEventDefinition, false, null, TimerStartEventJobHandler.TYPE, 
                            TimerEventHandler.createConfiguration(startEvent.getId(), timerEventDefinition.getEndDate(), timerEventDefinition.getCalendarName()));
            
            timerJob.setProcessDefinitionId(previousProcessDefinition.getId());

            if (previousProcessDefinition.getTenantId() !is null) {
                timerJob.setTenantId(previousProcessDefinition.getTenantId());
            }

            CommandContextUtil.getTimerJobService().scheduleTimerJob(timerJob);
        }
    }

    protected void restoreSignalStartEvent(ProcessDefinition previousProcessDefinition, BpmnModel bpmnModel, StartEvent startEvent, EventDefinition eventDefinition) {
        SignalEventDefinition signalEventDefinition = (SignalEventDefinition) eventDefinition;
        SignalEventSubscriptionEntity subscriptionEntity = CommandContextUtil.getEventSubscriptionService().createSignalEventSubscription();
        Signal signal = bpmnModel.getSignal(signalEventDefinition.getSignalRef());
        if (signal !is null) {
            subscriptionEntity.setEventName(signal.getName());
        } else {
            subscriptionEntity.setEventName(signalEventDefinition.getSignalRef());
        }
        subscriptionEntity.setActivityId(startEvent.getId());
        subscriptionEntity.setProcessDefinitionId(previousProcessDefinition.getId());
        if (previousProcessDefinition.getTenantId() !is null) {
            subscriptionEntity.setTenantId(previousProcessDefinition.getTenantId());
        }

        CommandContextUtil.getEventSubscriptionService().insertEventSubscription(subscriptionEntity);
        CountingEntityUtil.handleInsertEventSubscriptionEntityCount(subscriptionEntity);
    }

    protected void restoreMessageStartEvent(ProcessDefinition previousProcessDefinition, BpmnModel bpmnModel, StartEvent startEvent, EventDefinition eventDefinition) {
        MessageEventDefinition messageEventDefinition = (MessageEventDefinition) eventDefinition;
        if (bpmnModel.containsMessageId(messageEventDefinition.getMessageRef())) {
            Message message = bpmnModel.getMessage(messageEventDefinition.getMessageRef());
            messageEventDefinition.setMessageRef(message.getName());
        }

        MessageEventSubscriptionEntity newSubscription = CommandContextUtil.getEventSubscriptionService().createMessageEventSubscription();
        newSubscription.setEventName(messageEventDefinition.getMessageRef());
        newSubscription.setActivityId(startEvent.getId());
        newSubscription.setConfiguration(previousProcessDefinition.getId());
        newSubscription.setProcessDefinitionId(previousProcessDefinition.getId());

        if (previousProcessDefinition.getTenantId() !is null) {
            newSubscription.setTenantId(previousProcessDefinition.getTenantId());
        }

        CommandContextUtil.getEventSubscriptionService().insertEventSubscription(newSubscription);
        CountingEntityUtil.handleInsertEventSubscriptionEntityCount(newSubscription);
    }

    protected ProcessDefinitionEntity findLatestProcessDefinition(ProcessDefinition processDefinition) {
        ProcessDefinitionEntity latestProcessDefinition = null;
        if (processDefinition.getTenantId() !is null && !ProcessEngineConfiguration.NO_TENANT_ID.equals(processDefinition.getTenantId())) {
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

        if (processDefinitionToBeRemoved.getTenantId() !is null
                && !ProcessEngineConfiguration.NO_TENANT_ID.equals(processDefinitionToBeRemoved.getTenantId())) {
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
        List<ProcessDefinition> processDefinitions = getProcessDefinitionEntityManager().findProcessDefinitionsByQueryCriteria(query);
        if (processDefinitions !is null && processDefinitions.size() > 0) {
            return processDefinitions.get(0);
        }
        return null;
    }

    @Override
    public long findDeploymentCountByQueryCriteria(DeploymentQueryImpl deploymentQuery) {
        return dataManager.findDeploymentCountByQueryCriteria(deploymentQuery);
    }

    @Override
    public List<Deployment> findDeploymentsByQueryCriteria(DeploymentQueryImpl deploymentQuery) {
        return dataManager.findDeploymentsByQueryCriteria(deploymentQuery);
    }

    @Override
    public List<string> getDeploymentResourceNames(string deploymentId) {
        return dataManager.getDeploymentResourceNames(deploymentId);
    }

    @Override
    public List<Deployment> findDeploymentsByNativeQuery(Map<string, Object> parameterMap) {
        return dataManager.findDeploymentsByNativeQuery(parameterMap);
    }

    @Override
    public long findDeploymentCountByNativeQuery(Map<string, Object> parameterMap) {
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