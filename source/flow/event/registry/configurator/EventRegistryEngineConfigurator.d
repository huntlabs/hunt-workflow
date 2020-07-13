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
//
////          Copyright linse 2020.
//// Distributed under the Boost Software License, Version 1.0.
////    (See accompanying file LICENSE_1_0.txt or copy at
////          http://www.boost.org/LICENSE_1_0.txt)}
//
//module flow.event.registry.configurator.EventRegistryEngineConfigurator;
//
//
//
//
//
//import hunt.collection.ArrayList;
//import hunt.collection.List;
//
//import flow.common.api.FlowableException;
//import flow.common.AbstractEngineConfiguration;
//import flow.common.AbstractEngineConfigurator;
//import flow.common.EngineDeployer;
//import flow.common.interceptor.EngineConfigurationConstants;
//import flow.common.persistence.entity.Entity;
//import flow.event.registry.EventRegistryEngine;
//import flow.event.registry.EventRegistryEngineConfiguration;
//import flow.event.registry.cfg.StandaloneEventRegistryEngineConfiguration;
//import flow.event.registry.configurator.deployer.EventDeployer;
//import flow.event.registry.db.EntityDependencyOrder;
//
///**
// * @author Tijs Rademakers
// * @author Joram Barrez
// */
//class EventRegistryEngineConfigurator : AbstractEngineConfigurator {
//
//    protected EventRegistryEngine eventRegistryEngine;
//    protected EventRegistryEngineConfiguration eventEngineConfiguration;
//
//    @Override
//    public int getPriority() {
//        return EngineConfigurationConstants.PRIORITY_ENGINE_EVENT_REGISTRY;
//    }
//
//    @Override
//    protected List<EngineDeployer> getCustomDeployers() {
//        List<EngineDeployer> deployers = new ArrayList<>();
//        deployers.add(new EventDeployer());
//        return deployers;
//    }
//
//    @Override
//    protected String getMybatisCfgPath() {
//        return EventRegistryEngineConfiguration.DEFAULT_MYBATIS_MAPPING_FILE;
//    }
//
//    @Override
//    public void configure(AbstractEngineConfiguration engineConfiguration) {
//        if (eventEngineConfiguration is null) {
//            eventEngineConfiguration = new StandaloneEventRegistryEngineConfiguration();
//        }
//
//        initialiseEventRegistryEngineConfiguration(eventEngineConfiguration);
//        initialiseCommonProperties(engineConfiguration, eventEngineConfiguration);
//        this.eventRegistryEngine = initEventRegistryEngine();
//        initServiceConfigurations(engineConfiguration, eventEngineConfiguration);
//    }
//
//    protected void initialiseEventRegistryEngineConfiguration(EventRegistryEngineConfiguration eventRegistryEngineConfiguration) {
//        // meant to be overridden
//    }
//
//    @Override
//    protected List<Class<? extends Entity>> getEntityInsertionOrder() {
//        return EntityDependencyOrder.INSERT_ORDER;
//    }
//
//    @Override
//    protected List<Class<? extends Entity>> getEntityDeletionOrder() {
//        return EntityDependencyOrder.DELETE_ORDER;
//    }
//
//    protected synchronized EventRegistryEngine initEventRegistryEngine() {
//        if (eventEngineConfiguration is null) {
//            throw new FlowableException("EventRegistryEngineConfiguration is required");
//        }
//
//        return eventEngineConfiguration.buildEventRegistryEngine();
//    }
//
//    public EventRegistryEngineConfiguration getEventEngineConfiguration() {
//        return eventEngineConfiguration;
//    }
//
//    public EventRegistryEngineConfigurator setEventEngineConfiguration(EventRegistryEngineConfiguration eventEngineConfiguration) {
//        this.eventEngineConfiguration = eventEngineConfiguration;
//        return this;
//    }
//
//    public EventRegistryEngine getEventRegistryEngine() {
//        return eventRegistryEngine;
//    }
//
//    public void setEventRegistryEngine(EventRegistryEngine eventRegistryEngine) {
//        this.eventRegistryEngine = eventRegistryEngine;
//    }
//}
