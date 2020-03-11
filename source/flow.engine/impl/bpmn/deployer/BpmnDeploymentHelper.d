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


import hunt.collection;
import java.util.Iterator;
import hunt.collection.LinkedHashSet;
import hunt.collection.List;
import hunt.collection.Set;

import org.apache.commons.lang3.StringUtils;
import flow.bpmn.model.BpmnModel;
import flow.bpmn.model.Process;
import flow.common.api.FlowableException;
import flow.common.context.Context;
import flow.common.interceptor.CommandContext;
import flow.engine.ProcessEngineConfiguration;
import flow.engine.impl.persistence.entity.DeploymentEntity;
import flow.engine.impl.persistence.entity.ProcessDefinitionEntity;
import flow.engine.impl.persistence.entity.ProcessDefinitionEntityManager;
import flow.engine.impl.util.CommandContextUtil;
import flow.identitylink.api.IdentityLinkType;
import org.flowable.identitylink.service.IdentityLinkService;
import org.flowable.identitylink.service.impl.persistence.entity.IdentityLinkEntity;

/**
 * Methods for working with deployments. Much of the actual work of {@link BpmnDeployer} is done by orchestrating the different pieces of work this class does; by having them here, we allow other
 * deployers to make use of them.
 */
class BpmnDeploymentHelper {

    protected TimerManager timerManager;
    protected EventSubscriptionManager eventSubscriptionManager;

    /**
     * Verifies that no two process definitions share the same key, to prevent database unique index violation.
     *
     * @throws FlowableException
     *             if any two processes have the same key
     */
    public void verifyProcessDefinitionsDoNotShareKeys(
            Collection<ProcessDefinitionEntity> processDefinitions) {
        Set!string keySet = new LinkedHashSet<>();
        for (ProcessDefinitionEntity processDefinition : processDefinitions) {
            if (keySet.contains(processDefinition.getKey())) {
                throw new FlowableException(
                        "The deployment contains process definitions with the same key (process id attribute), this is not allowed");
            }
            keySet.add(processDefinition.getKey());
        }
    }

    /**
     * Updates all the process definition entities to match the deployment's values for tenant, engine version, and deployment id.
     */
    public void copyDeploymentValuesToProcessDefinitions(DeploymentEntity deployment,
            List<ProcessDefinitionEntity> processDefinitions) {
        string engineVersion = deployment.getEngineVersion();
        string tenantId = deployment.getTenantId();
        string deploymentId = deployment.getId();

        for (ProcessDefinitionEntity processDefinition : processDefinitions) {

            // Backwards compatibility
            if (engineVersion !is null) {
                processDefinition.setEngineVersion(engineVersion);
            }

            // process definition inherits the tenant id
            if (tenantId !is null) {
                processDefinition.setTenantId(tenantId);
            }

            processDefinition.setDeploymentId(deploymentId);
        }
    }

    /**
     * Updates all the process definition entities to have the correct resource names.
     */
    public void setResourceNamesOnProcessDefinitions(ParsedDeployment parsedDeployment) {
        for (ProcessDefinitionEntity processDefinition : parsedDeployment.getAllProcessDefinitions()) {
            string resourceName = parsedDeployment.getResourceForProcessDefinition(processDefinition).getName();
            processDefinition.setResourceName(resourceName);
        }
    }

    /**
     * Gets the most recent persisted process definition that matches this one for tenant and key. If none is found, returns null. This method assumes that the tenant and key are properly set on the
     * process definition entity.
     */
    public ProcessDefinitionEntity getMostRecentVersionOfProcessDefinition(ProcessDefinitionEntity processDefinition) {
        string key = processDefinition.getKey();
        string tenantId = processDefinition.getTenantId();
        ProcessDefinitionEntityManager processDefinitionManager = CommandContextUtil.getProcessEngineConfiguration().getProcessDefinitionEntityManager();

        ProcessDefinitionEntity existingDefinition = null;

        if (tenantId !is null && !tenantId.equals(ProcessEngineConfiguration.NO_TENANT_ID)) {
            existingDefinition = processDefinitionManager.findLatestProcessDefinitionByKeyAndTenantId(key, tenantId);
        } else {
            existingDefinition = processDefinitionManager.findLatestProcessDefinitionByKey(key);
        }

        return existingDefinition;
    }

    /**
     * Gets the most recent persisted derived process definition that matches this one for tenant and key. If none is found, returns null. This method assumes that the tenant and key are properly set on the
     * process definition entity.
     */
    public ProcessDefinitionEntity getMostRecentDerivedVersionOfProcessDefinition(ProcessDefinitionEntity processDefinition) {
        string key = processDefinition.getKey();
        string tenantId = processDefinition.getTenantId();
        ProcessDefinitionEntityManager processDefinitionManager = CommandContextUtil.getProcessEngineConfiguration().getProcessDefinitionEntityManager();

        ProcessDefinitionEntity existingDefinition = null;

        if (tenantId !is null && !tenantId.equals(ProcessEngineConfiguration.NO_TENANT_ID)) {
            existingDefinition = processDefinitionManager.findLatestDerivedProcessDefinitionByKeyAndTenantId(key, tenantId);
        } else {
            existingDefinition = processDefinitionManager.findLatestDerivedProcessDefinitionByKey(key);
        }

        return existingDefinition;
    }

    /**
     * Gets the persisted version of the already-deployed process definition. Note that this is different from {@link #getMostRecentVersionOfProcessDefinition} as it looks specifically for a process
     * definition that is already persisted and attached to a particular deployment, rather than the latest version across all deployments.
     */
    public ProcessDefinitionEntity getPersistedInstanceOfProcessDefinition(ProcessDefinitionEntity processDefinition) {
        string deploymentId = processDefinition.getDeploymentId();
        if (StringUtils.isEmpty(processDefinition.getDeploymentId())) {
            throw new IllegalStateException("Provided process definition must have a deployment id.");
        }

        ProcessDefinitionEntityManager processDefinitionManager = CommandContextUtil.getProcessEngineConfiguration().getProcessDefinitionEntityManager();
        ProcessDefinitionEntity persistedProcessDefinition = null;
        if (processDefinition.getTenantId() is null || ProcessEngineConfiguration.NO_TENANT_ID.equals(processDefinition.getTenantId())) {
            persistedProcessDefinition = processDefinitionManager.findProcessDefinitionByDeploymentAndKey(deploymentId, processDefinition.getKey());
        } else {
            persistedProcessDefinition = processDefinitionManager.findProcessDefinitionByDeploymentAndKeyAndTenantId(deploymentId, processDefinition.getKey(), processDefinition.getTenantId());
        }

        return persistedProcessDefinition;
    }

    /**
     * Updates all timers and events for the process definition. This removes obsolete message and signal subscriptions and timers, and adds new ones.
     */
    public void updateTimersAndEvents(ProcessDefinitionEntity processDefinition,
            ProcessDefinitionEntity previousProcessDefinition, ParsedDeployment parsedDeployment) {

        Process process = parsedDeployment.getProcessModelForProcessDefinition(processDefinition);
        BpmnModel bpmnModel = parsedDeployment.getBpmnModelForProcessDefinition(processDefinition);

        eventSubscriptionManager.removeObsoleteMessageEventSubscriptions(previousProcessDefinition);
        eventSubscriptionManager.removeObsoleteSignalEventSubScription(previousProcessDefinition);
        eventSubscriptionManager.removeObsoleteEventRegistryEventSubScription(previousProcessDefinition);
        eventSubscriptionManager.addEventSubscriptions(Context.getCommandContext(), processDefinition, process, bpmnModel);

        timerManager.removeObsoleteTimers(processDefinition);
        timerManager.scheduleTimers(processDefinition, process);
    }

    enum ExpressionType {
        USER, GROUP
    }

    /**
     * @param processDefinition
     */
    public void addAuthorizationsForNewProcessDefinition(Process process, ProcessDefinitionEntity processDefinition) {
        CommandContext commandContext = Context.getCommandContext();

        addAuthorizationsFromIterator(commandContext, process.getCandidateStarterUsers(), processDefinition, ExpressionType.USER);
        addAuthorizationsFromIterator(commandContext, process.getCandidateStarterGroups(), processDefinition, ExpressionType.GROUP);
    }

    protected void addAuthorizationsFromIterator(CommandContext commandContext, List!string expressions,
            ProcessDefinitionEntity processDefinition, ExpressionType expressionType) {

        if (expressions !is null) {
            IdentityLinkService identityLinkService = CommandContextUtil.getIdentityLinkService();
            Iterator!string iterator = expressions.iterator();
            while (iterator.hasNext()) {
                @SuppressWarnings("cast")
                string expression = iterator.next();
                IdentityLinkEntity identityLink = identityLinkService.createIdentityLink();
                identityLink.setProcessDefId(processDefinition.getId());
                if (expressionType == ExpressionType.USER) {
                    identityLink.setUserId(expression);
                } else if (expressionType == ExpressionType.GROUP) {
                    identityLink.setGroupId(expression);
                }
                identityLink.setType(IdentityLinkType.CANDIDATE);
                identityLinkService.insertIdentityLink(identityLink);
            }
        }

    }

    public TimerManager getTimerManager() {
        return timerManager;
    }

    public void setTimerManager(TimerManager timerManager) {
        this.timerManager = timerManager;
    }

    public EventSubscriptionManager getEventSubscriptionManager() {
        return eventSubscriptionManager;
    }

    public void setEventSubscriptionManager(EventSubscriptionManager eventSubscriptionManager) {
        this.eventSubscriptionManager = eventSubscriptionManager;
    }
}
