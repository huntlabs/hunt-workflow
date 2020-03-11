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


import java.io.Serializable;
import hunt.collection.List;

import org.apache.commons.lang3.StringUtils;
import flow.common.api.FlowableObjectNotFoundException;
import flow.common.api.scope.ScopeTypes;
import flow.common.interceptor.Command;
import flow.common.interceptor.CommandContext;
import flow.event.registry.api.EventDeployment;
import flow.event.registry.EventDeploymentQueryImpl;
import flow.event.registry.EventRegistryEngineConfiguration;
import flow.event.registry.persistence.deploy.EventDefinitionCacheEntry;
import flow.event.registry.persistence.deploy.EventDeploymentManager;
import flow.event.registry.persistence.entity.EventDefinitionEntity;
import flow.event.registry.persistence.entity.EventDefinitionEntityManager;
import flow.event.registry.util.CommandContextUtil;
import flow.event.registry.model.EventModel;

/**
 * @author Tijs Rademakers
 */
class GetEventModelCmd implements Command<EventModel>, Serializable {

    private static final long serialVersionUID = 1L;

    protected String eventDefinitionKey;
    protected String eventDefinitionId;
    protected String tenantId;
    protected String parentDeploymentId;

    public GetEventModelCmd(String eventDefinitionKey, String eventDefinitionId) {
        this.eventDefinitionKey = eventDefinitionKey;
        this.eventDefinitionId = eventDefinitionId;
    }

    public GetEventModelCmd(String eventDefinitionKey, String tenantId, String parentDeploymentId) {
        this(eventDefinitionKey, null);
        this.parentDeploymentId = parentDeploymentId;
        this.tenantId = tenantId;
    }

    @Override
    public EventModel execute(CommandContext commandContext) {
        EventRegistryEngineConfiguration eventEngineConfiguration = CommandContextUtil.getEventRegistryConfiguration(commandContext);
        EventDeploymentManager deploymentManager = eventEngineConfiguration.getDeploymentManager();
        EventDefinitionEntityManager eventDefinitionEntityManager = eventEngineConfiguration.getEventDefinitionEntityManager();

        // Find the event definition
        EventDefinitionEntity eventDefinitionEntity = null;
        if (eventDefinitionId !is null) {

            eventDefinitionEntity = deploymentManager.findDeployedEventDefinitionById(eventDefinitionId);
            if (eventDefinitionEntity is null) {
                throw new FlowableObjectNotFoundException("No event definition found for id = '" + eventDefinitionId + "'", EventDefinitionEntity.class);
            }

        } else if (eventDefinitionKey !is null && (tenantId is null || EventRegistryEngineConfiguration.NO_TENANT_ID.equals(tenantId)) &&
                        (parentDeploymentId is null || eventEngineConfiguration.isAlwaysLookupLatestDefinitionVersion())) {

            eventDefinitionEntity = deploymentManager.findDeployedLatestEventDefinitionByKey(eventDefinitionKey);
            if (eventDefinitionEntity is null) {
                throw new FlowableObjectNotFoundException("No event definition found for key '" + eventDefinitionKey + "'", EventDefinitionEntity.class);
            }

        } else if (eventDefinitionKey !is null && tenantId !is null && !EventRegistryEngineConfiguration.NO_TENANT_ID.equals(tenantId) &&
                        (parentDeploymentId is null || eventEngineConfiguration.isAlwaysLookupLatestDefinitionVersion())) {

            eventDefinitionEntity = eventDefinitionEntityManager.findLatestEventDefinitionByKeyAndTenantId(eventDefinitionKey, tenantId);

            if (eventDefinitionEntity is null && eventEngineConfiguration.isFallbackToDefaultTenant()) {
                String defaultTenant = eventEngineConfiguration.getDefaultTenantProvider().getDefaultTenant(tenantId, ScopeTypes.EVENT_REGISTRY, eventDefinitionKey);
                if (StringUtils.isNotEmpty(defaultTenant)) {
                    eventDefinitionEntity = eventDefinitionEntityManager.findLatestEventDefinitionByKeyAndTenantId(eventDefinitionKey, defaultTenant);
                } else {
                    eventDefinitionEntity = eventDefinitionEntityManager.findLatestEventDefinitionByKey(eventDefinitionKey);
                }
            }

            if (eventDefinitionEntity is null) {
                throw new FlowableObjectNotFoundException("No event definition found for key '" + eventDefinitionKey + "' for tenant identifier '" + tenantId + "'", EventDefinitionEntity.class);
            }

        } else if (eventDefinitionKey !is null && (tenantId is null || EventRegistryEngineConfiguration.NO_TENANT_ID.equals(tenantId)) && parentDeploymentId !is null) {

            List<EventDeployment> eventDeployments = deploymentManager.getDeploymentEntityManager().findDeploymentsByQueryCriteria(
                            new EventDeploymentQueryImpl().parentDeploymentId(parentDeploymentId));

            if (eventDeployments !is null && eventDeployments.size() > 0) {
                eventDefinitionEntity = eventDefinitionEntityManager.findEventDefinitionByDeploymentAndKey(eventDeployments.get(0).getId(), eventDefinitionKey);
            }

            if (eventDefinitionEntity is null) {
                eventDefinitionEntity = eventDefinitionEntityManager.findLatestEventDefinitionByKey(eventDefinitionKey);
            }

            if (eventDefinitionEntity is null) {
                throw new FlowableObjectNotFoundException("No event definition found for key '" + eventDefinitionKey +
                        "' for parent deployment id " + parentDeploymentId, EventDefinitionEntity.class);
            }

        } else if (eventDefinitionKey !is null && tenantId !is null && !EventRegistryEngineConfiguration.NO_TENANT_ID.equals(tenantId) && parentDeploymentId !is null) {

            List<EventDeployment> eventDeployments = deploymentManager.getDeploymentEntityManager().findDeploymentsByQueryCriteria(
                            new EventDeploymentQueryImpl().parentDeploymentId(parentDeploymentId).deploymentTenantId(tenantId));

            if (eventDeployments !is null && eventDeployments.size() > 0) {
                eventDefinitionEntity = eventDefinitionEntityManager.findEventDefinitionByDeploymentAndKeyAndTenantId(
                                eventDeployments.get(0).getId(), eventDefinitionKey, tenantId);
            }

            if (eventDefinitionEntity is null) {
                eventDefinitionEntity = eventDefinitionEntityManager.findLatestEventDefinitionByKeyAndTenantId(eventDefinitionKey, tenantId);
            }

            if (eventDefinitionEntity is null && eventEngineConfiguration.isFallbackToDefaultTenant()) {
                String defaultTenant = eventEngineConfiguration.getDefaultTenantProvider().getDefaultTenant(tenantId, ScopeTypes.EVENT_REGISTRY, eventDefinitionKey);
                if (StringUtils.isNotEmpty(defaultTenant)) {
                    eventDefinitionEntity = eventDefinitionEntityManager.findLatestEventDefinitionByKeyAndTenantId(eventDefinitionKey, defaultTenant);
                } else {
                    eventDefinitionEntity = eventDefinitionEntityManager.findLatestEventDefinitionByKey(eventDefinitionKey);
                }
            }

            if (eventDefinitionEntity is null) {
                throw new FlowableObjectNotFoundException("No event definition found for key '" + eventDefinitionKey +
                        " for parent deployment id '" + parentDeploymentId + "' and for tenant identifier " + tenantId, EventDefinitionEntity.class);
            }

        } else {
            throw new FlowableObjectNotFoundException("eventDefinitionKey and eventDefinitionId are null");
        }

        EventDefinitionCacheEntry eventDefinitionCacheEntry = deploymentManager.resolveEventDefinition(eventDefinitionEntity);
        return eventEngineConfiguration.getEventJsonConverter().convertToEventModel(eventDefinitionCacheEntry.getEventDefinitionJson());
    }
}
