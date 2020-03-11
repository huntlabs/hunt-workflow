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
module flow.event.registry.persistence.deploy.EventDeploymentManager;

//import hunt.collection.List;
//
//import flow.common.api.FlowableException;
//import flow.common.api.FlowableObjectNotFoundException;
//import flow.common.persistence.deploy.DeploymentCache;
//import flow.event.registry.api.ChannelDefinition;
//import flow.event.registry.api.ChannelModelProcessor;
//import flow.event.registry.api.EventDefinition;
//import flow.event.registry.ChannelDefinitionQueryImpl;
//import flow.event.registry.EventDefinitionQueryImpl;
//import flow.event.registry.EventRegistryEngineConfiguration;
//import flow.event.registry.persistence.entity.ChannelDefinitionEntity;
//import flow.event.registry.persistence.entity.ChannelDefinitionEntityManager;
//import flow.event.registry.persistence.entity.EventDefinitionEntity;
//import flow.event.registry.persistence.entity.EventDefinitionEntityManager;
//import flow.event.registry.persistence.entity.EventDeploymentEntity;
//import flow.event.registry.persistence.entity.EventDeploymentEntityManager;
//import flow.event.registry.persistence.entity.EventResourceEntity;
//import flow.event.registry.model.ChannelModel;
//
///**
// * @author Tijs Rademakers
// * @author Joram Barrez
// */
//class EventDeploymentManager {
//
//    protected EventRegistryEngineConfiguration engineConfig;
//    protected DeploymentCache<EventDefinitionCacheEntry> eventDefinitionCache;
//    protected DeploymentCache<ChannelDefinitionCacheEntry> channelDefinitionCache;
//
//    protected List<Deployer> deployers;
//    protected EventDefinitionEntityManager eventDefinitionEntityManager;
//    protected ChannelDefinitionEntityManager channelDefinitionEntityManager;
//    protected EventDeploymentEntityManager deploymentEntityManager;
//
//    public EventDeploymentManager(DeploymentCache<EventDefinitionCacheEntry> eventDefinitionCache,
//                    DeploymentCache<ChannelDefinitionCacheEntry> channelDefinitionCache, EventRegistryEngineConfiguration engineConfig) {
//
//        this.eventDefinitionCache = eventDefinitionCache;
//        this.channelDefinitionCache = channelDefinitionCache;
//        this.engineConfig = engineConfig;
//    }
//
//    public void deploy(EventDeploymentEntity deployment) {
//        for (Deployer deployer : deployers) {
//            deployer.deploy(deployment);
//        }
//    }
//
//    public EventDefinitionEntity findDeployedEventDefinitionById(String eventDefinitionId) {
//        if (eventDefinitionId is null) {
//            throw new FlowableException("Invalid event definition id : null");
//        }
//
//        // first try the cache
//        EventDefinitionCacheEntry cacheEntry = eventDefinitionCache.get(eventDefinitionId);
//        EventDefinitionEntity eventDefinition = cacheEntry !is null ? cacheEntry.getEventDefinitionEntity() : null;
//
//        if (eventDefinition is null) {
//            eventDefinition = engineConfig.getEventDefinitionEntityManager().findById(eventDefinitionId);
//            if (eventDefinition is null) {
//                throw new FlowableObjectNotFoundException("no deployed event definition found with id '" + eventDefinitionId + "'");
//            }
//            eventDefinition = resolveEventDefinition(eventDefinition).getEventDefinitionEntity();
//        }
//        return eventDefinition;
//    }
//
//    public ChannelDefinitionEntity findDeployedChannelDefinitionById(String channelDefinitionId) {
//        if (channelDefinitionId is null) {
//            throw new FlowableException("Invalid channel definition id : null");
//        }
//
//        // first try the cache
//        ChannelDefinitionCacheEntry cacheEntry = channelDefinitionCache.get(channelDefinitionId);
//        ChannelDefinitionEntity channelDefinition = cacheEntry !is null ? cacheEntry.getChannelDefinitionEntity() : null;
//
//        if (channelDefinition is null) {
//            channelDefinition = engineConfig.getChannelDefinitionEntityManager().findById(channelDefinitionId);
//            if (channelDefinition is null) {
//                throw new FlowableObjectNotFoundException("no deployed channel definition found with id '" + channelDefinitionId + "'");
//            }
//            channelDefinition = resolveChannelDefinition(channelDefinition).getChannelDefinitionEntity();
//        }
//        return channelDefinition;
//    }
//
//    public EventDefinitionEntity findDeployedLatestEventDefinitionByKey(String eventDefinitionKey) {
//        EventDefinitionEntity eventDefinition = eventDefinitionEntityManager.findLatestEventDefinitionByKey(eventDefinitionKey);
//
//        if (eventDefinition is null) {
//            throw new FlowableObjectNotFoundException("no event definitions deployed with key '" + eventDefinitionKey + "'");
//        }
//        eventDefinition = resolveEventDefinition(eventDefinition).getEventDefinitionEntity();
//        return eventDefinition;
//    }
//
//    public ChannelDefinitionEntity findDeployedLatestChannelDefinitionByKey(String channelDefinitionKey) {
//        ChannelDefinitionEntity channelDefinition = channelDefinitionEntityManager.findLatestChannelDefinitionByKey(channelDefinitionKey);
//
//        if (channelDefinition is null) {
//            throw new FlowableObjectNotFoundException("no channel definitions deployed with key '" + channelDefinitionKey + "'");
//        }
//        channelDefinition = resolveChannelDefinition(channelDefinition).getChannelDefinitionEntity();
//        return channelDefinition;
//    }
//
//    public EventDefinitionEntity findDeployedLatestEventDefinitionByKeyAndTenantId(String eventDefinitionKey, String tenantId) {
//        EventDefinitionEntity eventDefinition = eventDefinitionEntityManager.findLatestEventDefinitionByKeyAndTenantId(eventDefinitionKey, tenantId);
//
//        if (eventDefinition is null) {
//            throw new FlowableObjectNotFoundException("no event definitions deployed with key '" + eventDefinitionKey + "' for tenant identifier '" + tenantId + "'");
//        }
//        eventDefinition = resolveEventDefinition(eventDefinition).getEventDefinitionEntity();
//        return eventDefinition;
//    }
//
//    public EventDefinitionEntity findDeployedLatestEventDefinitionByKeyAndDeploymentId(String eventDefinitionKey, String deploymentId) {
//        EventDefinitionEntity eventDefinition = eventDefinitionEntityManager.findEventDefinitionByDeploymentAndKey(deploymentId, eventDefinitionKey);
//
//        if (eventDefinition is null) {
//            throw new FlowableObjectNotFoundException("no event definitions deployed with key '" + eventDefinitionKey +
//                    "' for deployment id '" + deploymentId + "'");
//        }
//        eventDefinition = resolveEventDefinition(eventDefinition).getEventDefinitionEntity();
//        return eventDefinition;
//    }
//
//    public EventDefinitionEntity findDeployedLatestEventDefinitionByKeyDeploymentIdAndTenantId(String eventDefinitionKey, String deploymentId, String tenantId) {
//        EventDefinitionEntity eventDefinition = eventDefinitionEntityManager.findEventDefinitionByDeploymentAndKeyAndTenantId(deploymentId, eventDefinitionKey, tenantId);
//
//        if (eventDefinition is null) {
//            throw new FlowableObjectNotFoundException("no event definitions deployed with key '" + eventDefinitionKey +
//                    "' for deployment id '" + deploymentId + "' and tenant identifier '" + tenantId + "'");
//        }
//        eventDefinition = resolveEventDefinition(eventDefinition).getEventDefinitionEntity();
//        return eventDefinition;
//    }
//
//    public EventDefinitionEntity findDeployedEventDefinitionByKeyAndVersionAndTenantId(String eventDefinitionKey, int eventVersion, String tenantId) {
//        EventDefinitionEntity eventDefinition = eventDefinitionEntityManager.findEventDefinitionByKeyAndVersionAndTenantId(eventDefinitionKey, eventVersion, tenantId);
//
//        if (eventDefinition is null) {
//            throw new FlowableObjectNotFoundException("no event definitions deployed with key = '" + eventDefinitionKey + "'");
//        }
//
//        eventDefinition = resolveEventDefinition(eventDefinition).getEventDefinitionEntity();
//        return eventDefinition;
//    }
//
//    /**
//     * Resolving the event will fetch the event definition, parse it and store the {@link EventDefinition} in memory.
//     */
//    public EventDefinitionCacheEntry resolveEventDefinition(EventDefinition eventDefinition) {
//        String eventDefinitionId = eventDefinition.getId();
//        String deploymentId = eventDefinition.getDeploymentId();
//
//        EventDefinitionCacheEntry cachedEventDefinition = eventDefinitionCache.get(eventDefinitionId);
//
//        if (cachedEventDefinition is null) {
//            EventDeploymentEntity deployment = engineConfig.getDeploymentEntityManager().findById(deploymentId);
//            List<EventResourceEntity> resources = engineConfig.getResourceEntityManager().findResourcesByDeploymentId(deploymentId);
//            for (EventResourceEntity resource : resources) {
//                deployment.addResource(resource);
//            }
//
//            deployment.setNew(false);
//            deploy(deployment);
//            cachedEventDefinition = eventDefinitionCache.get(eventDefinitionId);
//
//            if (cachedEventDefinition is null) {
//                throw new FlowableException("deployment '" + deploymentId + "' didn't put event definition '" + eventDefinitionId + "' in the cache");
//            }
//        }
//        return cachedEventDefinition;
//    }
//
//    /**
//     * Resolving the channel will fetch the channel definition, parse it and store the {@link ChannelDefinition} in memory.
//     */
//    public ChannelDefinitionCacheEntry resolveChannelDefinition(ChannelDefinition channelDefinition) {
//        String channelDefinitionId = channelDefinition.getId();
//        String deploymentId = channelDefinition.getDeploymentId();
//
//        ChannelDefinitionCacheEntry cachedChannelDefinition = channelDefinitionCache.get(channelDefinitionId);
//
//        if (cachedChannelDefinition is null) {
//            EventDeploymentEntity deployment = engineConfig.getDeploymentEntityManager().findById(deploymentId);
//            List<EventResourceEntity> resources = engineConfig.getResourceEntityManager().findResourcesByDeploymentId(deploymentId);
//            for (EventResourceEntity resource : resources) {
//                deployment.addResource(resource);
//            }
//
//            deployment.setNew(false);
//            deploy(deployment);
//            cachedChannelDefinition = channelDefinitionCache.get(channelDefinitionId);
//
//            if (cachedChannelDefinition is null) {
//                throw new FlowableException("deployment '" + deploymentId + "' didn't put channel definition '" + channelDefinitionId + "' in the cache");
//            }
//        }
//        return cachedChannelDefinition;
//    }
//
//    public void removeDeployment(String deploymentId) {
//        EventDeploymentEntity deployment = deploymentEntityManager.findById(deploymentId);
//        if (deployment is null) {
//            throw new FlowableObjectNotFoundException("Could not find a deployment with id '" + deploymentId + "'.");
//        }
//
//        // Remove any event and channel definition from the cache
//        List<EventDefinition> eventDefinitions = new EventDefinitionQueryImpl().deploymentId(deploymentId).list();
//        List<ChannelDefinition> channelDefinitions = new ChannelDefinitionQueryImpl().deploymentId(deploymentId).list();
//
//        // Delete data
//        deploymentEntityManager.deleteDeployment(deploymentId);
//
//        for (EventDefinition eventDefinition : eventDefinitions) {
//            eventDefinitionCache.remove(eventDefinition.getId());
//        }
//
//        for (ChannelDefinition channelDefinition : channelDefinitions) {
//            removeChannelDefinitionFromCache(channelDefinition);
//        }
//    }
//
//    public void removeChannelDefinitionFromCache(ChannelDefinition channelDefinition) {
//        ChannelDefinitionCacheEntry cacheEntry = channelDefinitionCache.get(channelDefinition.getId());
//
//        if (cacheEntry !is null) {
//            ChannelModel channelModel = cacheEntry.getChannelModel();
//            for (ChannelModelProcessor channelModelProcessor : engineConfig.getChannelModelProcessors()) {
//                if (channelModelProcessor.canProcess(channelModel)) {
//                    channelModelProcessor.unregisterChannelModel(channelModel, channelDefinition.getTenantId(), engineConfig.getEventRepositoryService());
//                }
//            }
//        }
//
//        channelDefinitionCache.remove(channelDefinition.getId());
//    }
//
//    public List<Deployer> getDeployers() {
//        return deployers;
//    }
//
//    public void setDeployers(List<Deployer> deployers) {
//        this.deployers = deployers;
//    }
//
//    public DeploymentCache<EventDefinitionCacheEntry> getEventDefinitionCache() {
//        return eventDefinitionCache;
//    }
//
//    public void setEventDefinitionCache(DeploymentCache<EventDefinitionCacheEntry> eventDefinitionCache) {
//        this.eventDefinitionCache = eventDefinitionCache;
//    }
//
//    public DeploymentCache<ChannelDefinitionCacheEntry> getChannelDefinitionCache() {
//        return channelDefinitionCache;
//    }
//
//    public void setChannelDefinitionCache(DeploymentCache<ChannelDefinitionCacheEntry> channelDefinitionCache) {
//        this.channelDefinitionCache = channelDefinitionCache;
//    }
//
//    public EventDefinitionEntityManager getEventDefinitionEntityManager() {
//        return eventDefinitionEntityManager;
//    }
//
//    public void setEventDefinitionEntityManager(EventDefinitionEntityManager eventDefinitionEntityManager) {
//        this.eventDefinitionEntityManager = eventDefinitionEntityManager;
//    }
//
//    public ChannelDefinitionEntityManager getChannelDefinitionEntityManager() {
//        return channelDefinitionEntityManager;
//    }
//
//    public void setChannelDefinitionEntityManager(ChannelDefinitionEntityManager channelDefinitionEntityManager) {
//        this.channelDefinitionEntityManager = channelDefinitionEntityManager;
//    }
//
//    public EventDeploymentEntityManager getDeploymentEntityManager() {
//        return deploymentEntityManager;
//    }
//
//    public void setDeploymentEntityManager(EventDeploymentEntityManager deploymentEntityManager) {
//        this.deploymentEntityManager = deploymentEntityManager;
//    }
//}
