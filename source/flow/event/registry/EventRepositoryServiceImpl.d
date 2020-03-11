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


import java.io.InputStream;
import hunt.collection.List;

import flow.common.interceptor.Command;
import flow.common.interceptor.CommandContext;
import flow.common.service.CommonEngineServiceImpl;
import flow.event.registry.api.ChannelDefinition;
import flow.event.registry.api.ChannelDefinitionQuery;
import flow.event.registry.api.EventDefinition;
import flow.event.registry.api.EventDefinitionQuery;
import flow.event.registry.api.EventDeployment;
import flow.event.registry.api.EventDeploymentBuilder;
import flow.event.registry.api.EventDeploymentQuery;
import flow.event.registry.api.EventRepositoryService;
import flow.event.registry.api.model.EventModelBuilder;
import flow.event.registry.api.model.InboundChannelModelBuilder;
import flow.event.registry.api.model.OutboundChannelModelBuilder;
import flow.event.registry.cmd.DeleteDeploymentCmd;
import flow.event.registry.cmd.DeployCmd;
import flow.event.registry.cmd.GetChannelDefinitionCmd;
import flow.event.registry.cmd.GetChannelDefinitionResourceCmd;
import flow.event.registry.cmd.GetChannelModelCmd;
import flow.event.registry.cmd.GetDeploymentResourceCmd;
import flow.event.registry.cmd.GetDeploymentResourceNamesCmd;
import flow.event.registry.cmd.GetEventDefinitionCmd;
import flow.event.registry.cmd.GetEventDefinitionResourceCmd;
import flow.event.registry.cmd.GetEventModelCmd;
import flow.event.registry.cmd.SetChannelDefinitionCategoryCmd;
import flow.event.registry.cmd.SetDeploymentCategoryCmd;
import flow.event.registry.cmd.SetDeploymentParentDeploymentIdCmd;
import flow.event.registry.cmd.SetDeploymentTenantIdCmd;
import flow.event.registry.cmd.SetEventDefinitionCategoryCmd;
import flow.event.registry.model.EventModelBuilderImpl;
import flow.event.registry.model.InboundChannelDefinitionBuilderImpl;
import flow.event.registry.model.OutboundChannelDefinitionBuilderImpl;
import flow.event.registry.repository.EventDeploymentBuilderImpl;
import flow.event.registry.model.ChannelModel;
import flow.event.registry.model.EventModel;

/**
 * @author Tijs Rademakers
 */
class EventRepositoryServiceImpl extends CommonEngineServiceImpl<EventRegistryEngineConfiguration> implements EventRepositoryService {

    protected EventRegistryEngineConfiguration eventRegistryEngineConfiguration;

    public EventRepositoryServiceImpl(EventRegistryEngineConfiguration engineConfiguration) {
        super(engineConfiguration);

        this.eventRegistryEngineConfiguration = engineConfiguration;
    }

    @Override
    public EventDeploymentBuilder createDeployment() {
        return commandExecutor.execute(new Command<EventDeploymentBuilder>() {
            @Override
            public EventDeploymentBuilder execute(CommandContext commandContext) {
                return new EventDeploymentBuilderImpl();
            }
        });
    }

    public EventDeployment deploy(EventDeploymentBuilderImpl deploymentBuilder) {
        return commandExecutor.execute(new DeployCmd<EventDeployment>(deploymentBuilder));
    }

    @Override
    public void deleteDeployment(String deploymentId) {
        commandExecutor.execute(new DeleteDeploymentCmd(deploymentId));
    }

    @Override
    public EventDefinitionQuery createEventDefinitionQuery() {
        return new EventDefinitionQueryImpl(commandExecutor);
    }

    @Override
    public ChannelDefinitionQuery createChannelDefinitionQuery() {
        return new ChannelDefinitionQueryImpl(commandExecutor);
    }

    @Override
    public List!String getDeploymentResourceNames(String deploymentId) {
        return commandExecutor.execute(new GetDeploymentResourceNamesCmd(deploymentId));
    }

    @Override
    public InputStream getResourceAsStream(String deploymentId, String resourceName) {
        return commandExecutor.execute(new GetDeploymentResourceCmd(deploymentId, resourceName));
    }

    @Override
    public void setDeploymentCategory(String deploymentId, String category) {
        commandExecutor.execute(new SetDeploymentCategoryCmd(deploymentId, category));
    }

    @Override
    public void setDeploymentTenantId(String deploymentId, String newTenantId) {
        commandExecutor.execute(new SetDeploymentTenantIdCmd(deploymentId, newTenantId));
    }

    @Override
    public void changeDeploymentParentDeploymentId(String deploymentId, String newParentDeploymentId) {
        commandExecutor.execute(new SetDeploymentParentDeploymentIdCmd(deploymentId, newParentDeploymentId));
    }

    @Override
    public EventDeploymentQuery createDeploymentQuery() {
        return new EventDeploymentQueryImpl(commandExecutor);
    }

    @Override
    public EventDefinition getEventDefinition(String eventDefinitionId) {
        return commandExecutor.execute(new GetEventDefinitionCmd(eventDefinitionId));
    }

    @Override
    public InputStream getEventDefinitionResource(String eventDefinitionId) {
        return commandExecutor.execute(new GetEventDefinitionResourceCmd(eventDefinitionId));
    }

    @Override
    public void setEventDefinitionCategory(String eventDefinitionId, String category) {
        commandExecutor.execute(new SetEventDefinitionCategoryCmd(eventDefinitionId, category));
    }

    @Override
    public ChannelDefinition getChannelDefinition(String channelDefinitionId) {
        return commandExecutor.execute(new GetChannelDefinitionCmd(channelDefinitionId));
    }

    @Override
    public InputStream getChannelDefinitionResource(String channelDefinitionId) {
        return commandExecutor.execute(new GetChannelDefinitionResourceCmd(channelDefinitionId));
    }

    @Override
    public void setChannelDefinitionCategory(String channelDefinitionId, String category) {
        commandExecutor.execute(new SetChannelDefinitionCategoryCmd(channelDefinitionId, category));
    }

    @Override
    public EventModel getEventModelById(String eventDefinitionId) {
        return commandExecutor.execute(new GetEventModelCmd(null, eventDefinitionId));
    }

    @Override
    public EventModel getEventModelByKey(String eventDefinitionKey) {
        return commandExecutor.execute(new GetEventModelCmd(eventDefinitionKey, null));
    }

    @Override
    public EventModel getEventModelByKey(String eventDefinitionKey, String tenantId) {
        return commandExecutor.execute(new GetEventModelCmd(eventDefinitionKey, tenantId, null));
    }

    @Override
    public EventModel getEventModelByKeyAndParentDeploymentId(String eventDefinitionKey, String parentDeploymentId) {
        return commandExecutor.execute(new GetEventModelCmd(eventDefinitionKey, null, parentDeploymentId));
    }

    @Override
    public EventModel getEventModelByKeyAndParentDeploymentId(String eventDefinitionKey, String parentDeploymentId, String tenantId) {
        return commandExecutor.execute(new GetEventModelCmd(eventDefinitionKey, tenantId, parentDeploymentId));
    }

    @Override
    public ChannelModel getChannelModelById(String channelDefinitionId) {
        return commandExecutor.execute(new GetChannelModelCmd(null, channelDefinitionId));
    }

    @Override
    public ChannelModel getChannelModelByKey(String channelDefinitionKey) {
        return commandExecutor.execute(new GetChannelModelCmd(channelDefinitionKey, null));
    }

    @Override
    public ChannelModel getChannelModelByKey(String channelDefinitionKey, String tenantId) {
        return commandExecutor.execute(new GetChannelModelCmd(channelDefinitionKey, tenantId, null));
    }

    @Override
    public ChannelModel getChannelModelByKeyAndParentDeploymentId(String channelDefinitionKey, String parentDeploymentId) {
        return commandExecutor.execute(new GetChannelModelCmd(channelDefinitionKey, null, parentDeploymentId));
    }

    @Override
    public ChannelModel getChannelModelByKeyAndParentDeploymentId(String channelDefinitionKey, String parentDeploymentId, String tenantId) {
        return commandExecutor.execute(new GetChannelModelCmd(channelDefinitionKey, tenantId, parentDeploymentId));
    }

    @Override
    public EventModelBuilder createEventModelBuilder() {
        return new EventModelBuilderImpl(this);
    }


    @Override
    public InboundChannelModelBuilder createInboundChannelModelBuilder() {
        return new InboundChannelDefinitionBuilderImpl(eventRegistryEngineConfiguration.getEventRepositoryService());
    }

    @Override
    public OutboundChannelModelBuilder createOutboundChannelModelBuilder() {
        return new OutboundChannelDefinitionBuilderImpl(eventRegistryEngineConfiguration.getEventRepositoryService());
    }

    public void registerEventModel(EventModel eventModel) {

    }
}
