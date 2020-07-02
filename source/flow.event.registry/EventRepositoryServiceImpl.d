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
module flow.event.registry.EventRepositoryServiceImpl;

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
//import flow.event.registry.cmd.DeleteDeploymentCmd;
//import flow.event.registry.cmd.DeployCmd;
//import flow.event.registry.cmd.GetChannelDefinitionCmd;
//import flow.event.registry.cmd.GetChannelDefinitionResourceCmd;
//import flow.event.registry.cmd.GetChannelModelCmd;
//import flow.event.registry.cmd.GetDeploymentResourceCmd;
//import flow.event.registry.cmd.GetDeploymentResourceNamesCmd;
//import flow.event.registry.cmd.GetEventDefinitionCmd;
//import flow.event.registry.cmd.GetEventDefinitionResourceCmd;
//import flow.event.registry.cmd.GetEventModelCmd;
//import flow.event.registry.cmd.SetChannelDefinitionCategoryCmd;
//import flow.event.registry.cmd.SetDeploymentCategoryCmd;
//import flow.event.registry.cmd.SetDeploymentParentDeploymentIdCmd;
//import flow.event.registry.cmd.SetDeploymentTenantIdCmd;
//import flow.event.registry.cmd.SetEventDefinitionCategoryCmd;
import flow.event.registry.model.EventModelBuilderImpl;
//import flow.event.registry.model.InboundChannelDefinitionBuilderImpl;
import flow.event.registry.model.OutboundChannelDefinitionBuilderImpl;
//import flow.event.registry.repository.EventDeploymentBuilderImpl;
import flow.event.registry.model.ChannelModel;
import flow.event.registry.model.EventModel;
import flow.event.registry.EventRegistryEngineConfiguration;
import hunt.Exceptions;
/**
 * @author Tijs Rademakers
 */
class EventRepositoryServiceImpl : CommonEngineServiceImpl!EventRegistryEngineConfiguration , EventRepositoryService {

    protected EventRegistryEngineConfiguration eventRegistryEngineConfiguration;

    this(EventRegistryEngineConfiguration engineConfiguration) {
        super(engineConfiguration);

        this.eventRegistryEngineConfiguration = engineConfiguration;
    }

    public EventDeploymentBuilder createDeployment() {
        implementationMissing(false);
        return null;
        //return commandExecutor.execute(new class Command!EventDeploymentBuilder {
        //    public EventDeploymentBuilder execute(CommandContext commandContext) {
        //        return new EventDeploymentBuilderImpl();
        //    }
        //});
    }

    //public EventDeployment deploy(EventDeploymentBuilderImpl deploymentBuilder) {
    //    return commandExecutor.execute(new DeployCmd<EventDeployment>(deploymentBuilder));
    //}

    public void deleteDeployment(string deploymentId) {
        implementationMissing(false);
       // commandExecutor.execute(new DeleteDeploymentCmd(deploymentId));
    }


    public EventDefinitionQuery createEventDefinitionQuery() {
        implementationMissing(false);
        return null;
       // return new EventDefinitionQueryImpl(commandExecutor);
    }


    public ChannelDefinitionQuery createChannelDefinitionQuery() {
        implementationMissing(false);
        return null;
       // return new ChannelDefinitionQueryImpl(commandExecutor);
    }


    public List!string getDeploymentResourceNames(string deploymentId) {
        implementationMissing(false);
        return null;
        //return commandExecutor.execute(new GetDeploymentResourceNamesCmd(deploymentId));
    }


    //public InputStream getResourceAsStream(string deploymentId, string resourceName) {
    //    return commandExecutor.execute(new GetDeploymentResourceCmd(deploymentId, resourceName));
    //}


    public void setDeploymentCategory(string deploymentId, string category) {
        implementationMissing(false);

        //commandExecutor.execute(new SetDeploymentCategoryCmd(deploymentId, category));
    }


    public void setDeploymentTenantId(string deploymentId, string newTenantId) {
        implementationMissing(false);
       // commandExecutor.execute(new SetDeploymentTenantIdCmd(deploymentId, newTenantId));
    }


    public void changeDeploymentParentDeploymentId(string deploymentId, string newParentDeploymentId) {
        implementationMissing(false);
        //commandExecutor.execute(new SetDeploymentParentDeploymentIdCmd(deploymentId, newParentDeploymentId));
    }


    public EventDeploymentQuery createDeploymentQuery() {
        implementationMissing(false);
        return null;
        //return new EventDeploymentQueryImpl(commandExecutor);
    }


    public EventDefinition getEventDefinition(string eventDefinitionId) {
        implementationMissing(false);
        return null;
       // return commandExecutor.execute(new GetEventDefinitionCmd(eventDefinitionId));
    }


    //public InputStream getEventDefinitionResource(string eventDefinitionId) {
    //    return commandExecutor.execute(new GetEventDefinitionResourceCmd(eventDefinitionId));
    //}


    public void setEventDefinitionCategory(string eventDefinitionId, string category) {
      implementationMissing(false);
        //commandExecutor.execute(new SetEventDefinitionCategoryCmd(eventDefinitionId, category));
    }


    public ChannelDefinition getChannelDefinition(string channelDefinitionId) {
      implementationMissing(false);
      return null;
      //  return commandExecutor.execute(new GetChannelDefinitionCmd(channelDefinitionId));
    }


    //public InputStream getChannelDefinitionResource(string channelDefinitionId) {
    //    return commandExecutor.execute(new GetChannelDefinitionResourceCmd(channelDefinitionId));
    //}


    public void setChannelDefinitionCategory(string channelDefinitionId, string category) {
      implementationMissing(false);
       // commandExecutor.execute(new SetChannelDefinitionCategoryCmd(channelDefinitionId, category));
    }


    public EventModel getEventModelById(string eventDefinitionId) {
      implementationMissing(false);
      return null;
      //  return commandExecutor.execute(new GetEventModelCmd(null, eventDefinitionId));
    }


    public EventModel getEventModelByKey(string eventDefinitionKey) {
      implementationMissing(false);
        return null;
       // return commandExecutor.execute(new GetEventModelCmd(eventDefinitionKey, null));
    }


    public EventModel getEventModelByKey(string eventDefinitionKey, string tenantId) {
      implementationMissing(false);
        return null;
       // return commandExecutor.execute(new GetEventModelCmd(eventDefinitionKey, tenantId, null));
    }


    public EventModel getEventModelByKeyAndParentDeploymentId(string eventDefinitionKey, string parentDeploymentId) {
      implementationMissing(false);
        return null;
        //return commandExecutor.execute(new GetEventModelCmd(eventDefinitionKey, null, parentDeploymentId));
    }


    public EventModel getEventModelByKeyAndParentDeploymentId(string eventDefinitionKey, string parentDeploymentId, string tenantId) {
      implementationMissing(false);
      return null;
        //return commandExecutor.execute(new GetEventModelCmd(eventDefinitionKey, tenantId, parentDeploymentId));
    }


    public ChannelModel getChannelModelById(string channelDefinitionId) {
      implementationMissing(false);
        return null;
       // return commandExecutor.execute(new GetChannelModelCmd(null, channelDefinitionId));
    }


    public ChannelModel getChannelModelByKey(string channelDefinitionKey) {
      implementationMissing(false);
        return null;
       // return commandExecutor.execute(new GetChannelModelCmd(channelDefinitionKey, null));
    }


    public ChannelModel getChannelModelByKey(string channelDefinitionKey, string tenantId) {
      implementationMissing(false);
        return null;
       // return commandExecutor.execute(new GetChannelModelCmd(channelDefinitionKey, tenantId, null));
    }


    public ChannelModel getChannelModelByKeyAndParentDeploymentId(string channelDefinitionKey, string parentDeploymentId) {
      implementationMissing(false);
        return null;
        //return commandExecutor.execute(new GetChannelModelCmd(channelDefinitionKey, null, parentDeploymentId));
    }


    public ChannelModel getChannelModelByKeyAndParentDeploymentId(string channelDefinitionKey, string parentDeploymentId, string tenantId) {
      implementationMissing(false);
      return null;
       // return commandExecutor.execute(new GetChannelModelCmd(channelDefinitionKey, tenantId, parentDeploymentId));
    }


    public EventModelBuilder createEventModelBuilder() {
        return new EventModelBuilderImpl(this);
    }



    public InboundChannelModelBuilder createInboundChannelModelBuilder() {
      implementationMissing(false);
      return null;
       // return new InboundChannelDefinitionBuilderImpl(eventRegistryEngineConfiguration.getEventRepositoryService());
    }


    public OutboundChannelModelBuilder createOutboundChannelModelBuilder() {
        implementationMissing(false);
        return null;
        //return new OutboundChannelDefinitionBuilderImpl(eventRegistryEngineConfiguration.getEventRepositoryService());
    }

    public void registerEventModel(EventModel eventModel) {

    }
}
