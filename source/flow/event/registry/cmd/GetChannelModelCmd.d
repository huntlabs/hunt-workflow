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
import flow.event.registry.persistence.deploy.ChannelDefinitionCacheEntry;
import flow.event.registry.persistence.deploy.EventDeploymentManager;
import flow.event.registry.persistence.entity.ChannelDefinitionEntity;
import flow.event.registry.persistence.entity.ChannelDefinitionEntityManager;
import flow.event.registry.util.CommandContextUtil;
import flow.event.registry.model.ChannelModel;

/**
 * @author Tijs Rademakers
 */
class GetChannelModelCmd implements Command<ChannelModel>, Serializable {

    private static final long serialVersionUID = 1L;

    protected String channelDefinitionKey;
    protected String channelDefinitionId;
    protected String tenantId;
    protected String parentDeploymentId;

    public GetChannelModelCmd(String channelDefinitionKey, String channelDefinitionId) {
        this.channelDefinitionKey = channelDefinitionKey;
        this.channelDefinitionId = channelDefinitionId;
    }

    public GetChannelModelCmd(String channelDefinitionKey, String tenantId, String parentDeploymentId) {
        this(channelDefinitionKey, null);
        this.tenantId = tenantId;
        this.parentDeploymentId = parentDeploymentId;
    }

    @Override
    public ChannelModel execute(CommandContext commandContext) {
        EventRegistryEngineConfiguration eventEngineConfiguration = CommandContextUtil.getEventRegistryConfiguration(commandContext);
        EventDeploymentManager deploymentManager = eventEngineConfiguration.getDeploymentManager();
        ChannelDefinitionEntityManager channelDefinitionEntityManager = eventEngineConfiguration.getChannelDefinitionEntityManager();

        // Find the channel definition
        ChannelDefinitionEntity channelDefinitionEntity = null;
        if (channelDefinitionId !is null) {

            channelDefinitionEntity = deploymentManager.findDeployedChannelDefinitionById(channelDefinitionId);
            if (channelDefinitionEntity is null) {
                throw new FlowableObjectNotFoundException("No channel definition found for id = '" + channelDefinitionId + "'", ChannelDefinitionEntity.class);
            }

        } else if (channelDefinitionKey !is null && (tenantId is null || EventRegistryEngineConfiguration.NO_TENANT_ID.equals(tenantId)) &&
                        (parentDeploymentId is null || eventEngineConfiguration.isAlwaysLookupLatestDefinitionVersion())) {

            channelDefinitionEntity = deploymentManager.findDeployedLatestChannelDefinitionByKey(channelDefinitionKey);
            if (channelDefinitionEntity is null) {
                throw new FlowableObjectNotFoundException("No channel definition found for key '" + channelDefinitionKey + "'", ChannelDefinitionEntity.class);
            }

        } else if (channelDefinitionKey !is null && tenantId !is null && !EventRegistryEngineConfiguration.NO_TENANT_ID.equals(tenantId) &&
                        (parentDeploymentId is null || eventEngineConfiguration.isAlwaysLookupLatestDefinitionVersion())) {

            channelDefinitionEntity = channelDefinitionEntityManager.findLatestChannelDefinitionByKeyAndTenantId(channelDefinitionKey, tenantId);

            if (channelDefinitionEntity is null && eventEngineConfiguration.isFallbackToDefaultTenant()) {
                String defaultTenant = eventEngineConfiguration.getDefaultTenantProvider().getDefaultTenant(tenantId, ScopeTypes.EVENT_REGISTRY, channelDefinitionKey);
                if (StringUtils.isNotEmpty(defaultTenant)) {
                    channelDefinitionEntity = channelDefinitionEntityManager.findLatestChannelDefinitionByKeyAndTenantId(channelDefinitionKey, defaultTenant);
                } else {
                    channelDefinitionEntity = channelDefinitionEntityManager.findLatestChannelDefinitionByKey(channelDefinitionKey);
                }
            }

            if (channelDefinitionEntity is null) {
                throw new FlowableObjectNotFoundException("No channel definition found for key '" + channelDefinitionKey + "' for tenant identifier " + tenantId, ChannelDefinitionEntity.class);
            }

        } else if (channelDefinitionKey !is null && (tenantId is null || EventRegistryEngineConfiguration.NO_TENANT_ID.equals(tenantId)) && parentDeploymentId !is null) {

            List<EventDeployment> eventDeployments = deploymentManager.getDeploymentEntityManager().findDeploymentsByQueryCriteria(
                            new EventDeploymentQueryImpl().parentDeploymentId(parentDeploymentId));

            if (eventDeployments !is null && eventDeployments.size() > 0) {
                channelDefinitionEntity = channelDefinitionEntityManager.findChannelDefinitionByDeploymentAndKey(eventDeployments.get(0).getId(), channelDefinitionKey);
            }

            if (channelDefinitionEntity is null) {
                channelDefinitionEntity = channelDefinitionEntityManager.findLatestChannelDefinitionByKey(channelDefinitionKey);
            }

            if (channelDefinitionEntity is null) {
                throw new FlowableObjectNotFoundException("No channel definition found for key '" + channelDefinitionKey +
                        "' for parent deployment id " + parentDeploymentId, ChannelDefinitionEntity.class);
            }

        } else if (channelDefinitionKey !is null && tenantId !is null && !EventRegistryEngineConfiguration.NO_TENANT_ID.equals(tenantId) && parentDeploymentId !is null) {

            List<EventDeployment> eventDeployments = deploymentManager.getDeploymentEntityManager().findDeploymentsByQueryCriteria(
                            new EventDeploymentQueryImpl().parentDeploymentId(parentDeploymentId).deploymentTenantId(tenantId));

            if (eventDeployments !is null && eventDeployments.size() > 0) {
                channelDefinitionEntity = channelDefinitionEntityManager.findChannelDefinitionByDeploymentAndKeyAndTenantId(
                                eventDeployments.get(0).getId(), channelDefinitionKey, tenantId);
            }

            if (channelDefinitionEntity is null) {
                channelDefinitionEntity = channelDefinitionEntityManager.findLatestChannelDefinitionByKeyAndTenantId(channelDefinitionKey, tenantId);
            }

            if (channelDefinitionEntity is null && eventEngineConfiguration.isFallbackToDefaultTenant()) {
                String defaultTenant = eventEngineConfiguration.getDefaultTenantProvider().getDefaultTenant(tenantId, ScopeTypes.EVENT_REGISTRY, channelDefinitionKey);
                if (StringUtils.isNotEmpty(defaultTenant)) {
                    channelDefinitionEntity = channelDefinitionEntityManager.findLatestChannelDefinitionByKeyAndTenantId(channelDefinitionKey, defaultTenant);
                } else {
                    channelDefinitionEntity = channelDefinitionEntityManager.findLatestChannelDefinitionByKey(channelDefinitionKey);
                }
            }

            if (channelDefinitionEntity is null) {
                throw new FlowableObjectNotFoundException("No channel definition found for key '" + channelDefinitionKey +
                        " for parent deployment id '" + parentDeploymentId + "' and for tenant identifier " + tenantId, ChannelDefinitionEntity.class);
            }

        } else {
            throw new FlowableObjectNotFoundException("channelDefinitionKey and channelDefinitionId are null");
        }

        ChannelDefinitionCacheEntry channelDefinitionCacheEntry = deploymentManager.resolveChannelDefinition(channelDefinitionEntity);
        return channelDefinitionCacheEntry.getChannelModel();
    }
}
