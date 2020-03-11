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

module flow.event.registry.EventRegistryEngineImpl;

import hunt.collection.List;

import flow.common.api.engine.EngineLifecycleListener;
import flow.event.registry.api.ChannelDefinition;
import flow.event.registry.api.EventManagementService;
import flow.event.registry.api.EventRegistry;
import flow.event.registry.api.EventRepositoryService;
import flow.event.registry.model.ChannelModel;
import flow.event.registry.EventRegistryEngine;
import flow.event.registry.EventRegistryEngineConfiguration;

import hunt.logging;

/**
 * @author Tijs Rademakers
 */
class EventRegistryEngineImpl : EventRegistryEngine {

   // private static final Logger LOGGER = LoggerFactory.getLogger(EventRegistryEngineImpl.class);

    protected string name;
    protected EventRepositoryService repositoryService;
    protected EventManagementService managementService;
    protected EventRegistry eventRegistry;
    protected EventRegistryEngineConfiguration engineConfiguration;

    this(EventRegistryEngineConfiguration engineConfiguration) {
        this.engineConfiguration = engineConfiguration;
        this.name = engineConfiguration.getEngineName();
        this.repositoryService = engineConfiguration.getEventRepositoryService();
        this.managementService = engineConfiguration.getEventManagementService();
        this.eventRegistry = engineConfiguration.getEventRegistry();

        if (engineConfiguration.getSchemaManagementCmd() !is null) {
            engineConfiguration.getCommandExecutor().execute(engineConfiguration.getSchemaCommandConfig(), engineConfiguration.getSchemaManagementCmd());
        }

        if (name is null) {
            logInfo("default flowable EventRegistryEngine created");
        } else {
            logInfo("EventRegistryEngine %s created", name);
        }

        EventRegistryEngines.registerEventRegistryEngine(this);

        if (engineConfiguration.getEngineLifecycleListeners() !is null) {
            foreach (EngineLifecycleListener engineLifecycleListener ; engineConfiguration.getEngineLifecycleListeners()) {
                engineLifecycleListener.onEngineBuilt(this);
            }
        }
    }


    public void handleDeployedChannelDefinitions() {
        // Fetching and deploying all existing channel definitions at bootup
        List!ChannelDefinition channelDefinitions = repositoryService.createChannelDefinitionQuery().latestVersion().list();
        foreach (ChannelDefinition channelDefinition ; channelDefinitions) {
            // Getting the channel model will trigger a deployment and set up the channel and associated adapters
            ChannelModel channelModel = repositoryService.getChannelModelById(channelDefinition.getId());
            logInfo("Booted up channel {%s} ", channelModel.getKey().value);
        }
    }


    public void close() {
        EventRegistryEngines.unregister(this);
        engineConfiguration.close();

        if (engineConfiguration.getEngineLifecycleListeners() !is null) {
            foreach (EngineLifecycleListener engineLifecycleListener ; engineConfiguration.getEngineLifecycleListeners()) {
                engineLifecycleListener.onEngineClosed(this);
            }
        }
    }

    // getters and setters
    // //////////////////////////////////////////////////////


    public string getName() {
        return name;
    }


    public EventRepositoryService getEventRepositoryService() {
        return repositoryService;
    }


    public EventManagementService getEventManagementService() {
        return managementService;
    }


    public EventRegistry getEventRegistry() {
        return eventRegistry;
    }


    public EventRegistryEngineConfiguration getEventRegistryEngineConfiguration() {
        return engineConfiguration;
    }
}
