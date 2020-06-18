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
module flow.event.registry.api.EventRepositoryService;

import hunt.stream.Common;
import hunt.collection.List;
import flow.event.registry.api.model.EventModelBuilder;
import flow.event.registry.api.model.InboundChannelModelBuilder;
import flow.event.registry.api.model.OutboundChannelModelBuilder;
import flow.event.registry.model.ChannelModel;
import flow.event.registry.model.EventModel;
import flow.event.registry.api.EventDeploymentBuilder;
import flow.event.registry.api.EventDefinitionQuery;
import flow.event.registry.api.ChannelDefinitionQuery;
import flow.event.registry.api.EventDeploymentQuery;
import flow.event.registry.api.EventDefinition;
import flow.event.registry.api.ChannelDefinition;

/**
 * Service providing access to the repository of forms.
 *
 * @author Tijs Rademakers
 */
interface EventRepositoryService {

    EventDeploymentBuilder createDeployment();

    void deleteDeployment(string deploymentId);

    EventDefinitionQuery createEventDefinitionQuery();

    ChannelDefinitionQuery createChannelDefinitionQuery();

    /**
     * Changes the category of a deployment.
     *
     * @param deploymentId
     *              The id of the deployment of which the category will be changed.
     * @param category
     *              The new category.
     */
    void setDeploymentCategory(string deploymentId, string category);

    /**
     * Changes the tenant id of a deployment.
     *
     * @param deploymentId
     *              The id of the deployment of which the tenant identifier will be changed.
     * @param newTenantId
     *              The new tenant identifier.
     */
    void setDeploymentTenantId(string deploymentId, string newTenantId);

    /**
     * Changes the parent deployment id of a deployment. This is used to move deployments to a different app deployment parent.
     *
     * @param deploymentId
     *              The id of the deployment of which the parent deployment identifier will be changed.
     * @param newParentDeploymentId
     *              The new parent deployment identifier.
     */
    void changeDeploymentParentDeploymentId(string deploymentId, string newParentDeploymentId);

    List!string getDeploymentResourceNames(string deploymentId);

    InputStream getResourceAsStream(string deploymentId, string resourceName);

    EventDeploymentQuery createDeploymentQuery();

    EventDefinition getEventDefinition(string eventDefinitionId);

    InputStream getEventDefinitionResource(string eventDefinitionId);

    void setEventDefinitionCategory(string eventDefinitionId, string category);

    ChannelDefinition getChannelDefinition(string channelDefinitionId);

    InputStream getChannelDefinitionResource(string channelDefinitionId);

    void setChannelDefinitionCategory(string channelDefinitionId, string category);

    EventModel getEventModelById(string eventDefinitionId);

    EventModel getEventModelByKey(string eventDefinitionKey);

    EventModel getEventModelByKey(string eventDefinitionKey, string tenantId);

    EventModel getEventModelByKeyAndParentDeploymentId(string eventDefinitionKey, string parentDeploymentId);

    EventModel getEventModelByKeyAndParentDeploymentId(string eventDefinitionKey, string parentDeploymentId, string tenantId);

    ChannelModel getChannelModelById(string channelDefinitionId);

    ChannelModel getChannelModelByKey(string channelDefinitionKey);

    ChannelModel getChannelModelByKey(string channelDefinitionKey, string tenantId);

    ChannelModel getChannelModelByKeyAndParentDeploymentId(string channelDefinitionKey, string parentDeploymentId);

    ChannelModel getChannelModelByKeyAndParentDeploymentId(string channelDefinitionKey, string parentDeploymentId, string tenantId);

    /**
     * Programmatically build and register a new {@link EventModel}.
     */
    EventModelBuilder createEventModelBuilder();

    InboundChannelModelBuilder createInboundChannelModelBuilder();

    OutboundChannelModelBuilder createOutboundChannelModelBuilder();
}
