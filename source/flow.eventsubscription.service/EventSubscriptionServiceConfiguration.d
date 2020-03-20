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
module flow.eventsubscription.service.EventSubscriptionServiceConfiguration;

import flow.common.AbstractServiceConfiguration;
import flow.eventsubscription.service.impl.EventSubscriptionServiceImpl;
import flow.eventsubscription.service.impl.persistence.entity.EventSubscriptionEntityManager;
import flow.eventsubscription.service.impl.persistence.entity.EventSubscriptionEntityManagerImpl;
import flow.eventsubscription.service.impl.persistence.entity.data.EventSubscriptionDataManager;
import flow.eventsubscription.service.impl.persistence.entity.data.impl.MybatisEventSubscriptionDataManager;
import flow.eventsubscription.service.EventSubscriptionService;

//import com.fasterxml.jackson.databind.ObjectMapper;

/**
 * @author Tijs Rademakers
 */
class EventSubscriptionServiceConfiguration : AbstractServiceConfiguration {

    // SERVICES
    // /////////////////////////////////////////////////////////////////

    protected EventSubscriptionService eventSubscriptionService  ;//= new EventSubscriptionServiceImpl(this);

    // DATA MANAGERS ///////////////////////////////////////////////////

    protected EventSubscriptionDataManager eventSubscriptionDataManager;

    // ENTITY MANAGERS /////////////////////////////////////////////////

    protected EventSubscriptionEntityManager eventSubscriptionEntityManager;

    //protected ObjectMapper objectMapper;

    this(string engineName) {
        super(engineName);
        eventSubscriptionService = new EventSubscriptionServiceImpl(this);
    }

    // init
    // /////////////////////////////////////////////////////////////////////

    public void init() {
        initDataManagers();
        initEntityManagers();
    }

    // Data managers
    ///////////////////////////////////////////////////////////

    public void initDataManagers() {
        if (eventSubscriptionDataManager is null) {
            eventSubscriptionDataManager = new MybatisEventSubscriptionDataManager(this);
        }
    }

    public void initEntityManagers() {
        if (eventSubscriptionEntityManager is null) {
            eventSubscriptionEntityManager = new EventSubscriptionEntityManagerImpl(this, eventSubscriptionDataManager);
        }
    }

    // getters and setters
    // //////////////////////////////////////////////////////

    public EventSubscriptionServiceConfiguration getIdentityLinkServiceConfiguration() {
        return this;
    }

    public EventSubscriptionService getEventSubscriptionService() {
        return eventSubscriptionService;
    }

    public EventSubscriptionServiceConfiguration setEventSubscriptionService(EventSubscriptionService eventSubscriptionService) {
        this.eventSubscriptionService = eventSubscriptionService;
        return this;
    }

    public EventSubscriptionDataManager getEventSubscriptionDataManager() {
        return eventSubscriptionDataManager;
    }

    public EventSubscriptionServiceConfiguration setEventSubscriptionDataManager(EventSubscriptionDataManager eventSubscriptionDataManager) {
        this.eventSubscriptionDataManager = eventSubscriptionDataManager;
        return this;
    }

    public EventSubscriptionEntityManager getEventSubscriptionEntityManager() {
        return eventSubscriptionEntityManager;
    }

    public EventSubscriptionServiceConfiguration setEventSubscriptionEntityManager(EventSubscriptionEntityManager eventSubscriptionEntityManager) {
        this.eventSubscriptionEntityManager = eventSubscriptionEntityManager;
        return this;
    }

    //@Override
    //public ObjectMapper getObjectMapper() {
    //    return objectMapper;
    //}
    //
    //@Override
    //public EventSubscriptionServiceConfiguration setObjectMapper(ObjectMapper objectMapper) {
    //    this.objectMapper = objectMapper;
    //    return this;
    //}
}
