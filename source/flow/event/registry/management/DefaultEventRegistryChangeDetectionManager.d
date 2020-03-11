///* Licensed under the Apache License, Version 2.0 (the "License");
// * you may not use this file except in compliance with the License.
// * You may obtain a copy of the License at
// *
// *      http://www.apache.org/licenses/LICENSE-2.0
// *
// * Unless required by applicable law or agreed to in writing, software
// * distributed under the License is distributed on an "AS IS" BASIS,
// * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// * See the License for the specific language governing permissions and
// * limitations under the License.
// */
//module flow.event.registry.management.DefaultEventRegistryChangeDetectionManager;
//
//import hunt.collection.ArrayList;
//import hunt.collection.HashSet;
//import hunt.collection.List;
//import hunt.collection.Set;
//
//import flow.event.registry.api.ChannelDefinition;
//import flow.event.registry.api.management.EventRegistryChangeDetectionManager;
//import flow.event.registry.EventRegistryEngineConfiguration;
//import flow.event.registry.persistence.deploy.ChannelDefinitionCacheEntry;
//import flow.event.registry.persistence.deploy.EventDeploymentManager;
//import org.slf4j.Logger;
//import org.slf4j.LoggerFactory;
//
///**
// * @author Joram Barrez
// */
//class DefaultEventRegistryChangeDetectionManager implements EventRegistryChangeDetectionManager {
//
//    private static final Logger LOGGER = LoggerFactory.getLogger(DefaultEventRegistryChangeDetectionManager.class);
//
//    protected EventRegistryEngineConfiguration eventRegistryEngineConfiguration;
//
//    public DefaultEventRegistryChangeDetectionManager(EventRegistryEngineConfiguration eventRegistryEngineConfiguration) {
//        this.eventRegistryEngineConfiguration = eventRegistryEngineConfiguration;
//    }
//
//    @Override
//    public void detectChanges() {
//        // This query could be optimized in the future by keeping a timestamp of the last query
//        // and querying by createtime (but detecting deletes would need dedicated logic!).
//        // The amount of channel definitions however, should typically not be large.
//        List<ChannelDefinition> channelDefinitions = eventRegistryEngineConfiguration.getEventRepositoryService()
//            .createChannelDefinitionQuery()
//            .latestVersion()
//            .list();
//
//        Set!String channelDefinitionCacheIds = new HashSet<>();
//        EventDeploymentManager deploymentManager = eventRegistryEngineConfiguration.getDeploymentManager();
//        List<ChannelDefinitionCacheEntry> cacheEntries = new ArrayList<>(deploymentManager.getChannelDefinitionCache().getAll());
//        for (ChannelDefinitionCacheEntry channelDefinitionCacheEntry : cacheEntries) {
//            channelDefinitionCacheIds.add(channelDefinitionCacheEntry.getChannelDefinitionEntity().getId());
//        }
//
//        // Check for new deployments
//        for (ChannelDefinition channelDefinition : channelDefinitions) {
//
//            // When no instance is returned, the channel definition has not yet been deployed before (e.g. deployed on another node)
//            if (!channelDefinitionCacheIds.contains(channelDefinition.getId())) {
//                eventRegistryEngineConfiguration.getEventRepositoryService().getChannelModelById(channelDefinition.getId());
//                LOGGER.info("Deployed channel definition with key {}", channelDefinition.getKey());
//            }
//
//        }
//
//        // Check for removed deployments
//        Set!String latestChannelDefinitionIds = channelDefinitions.stream().map(ChannelDefinition::getId).collect(Collectors.toSet());
//        for (ChannelDefinitionCacheEntry channelDefinitionCacheEntry : cacheEntries) {
//            if (!latestChannelDefinitionIds.contains(channelDefinitionCacheEntry.getChannelDefinitionEntity().getId())) {
//                deploymentManager.removeChannelDefinitionFromCache(channelDefinitionCacheEntry.getChannelDefinitionEntity());
//            }
//        }
//    }
//
//}
