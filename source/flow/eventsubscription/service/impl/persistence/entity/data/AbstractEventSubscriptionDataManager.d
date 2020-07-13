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
module flow.eventsubscription.service.impl.persistence.entity.data.AbstractEventSubscriptionDataManager;

import flow.common.db.AbstractDataManager;
import flow.common.persistence.entity.Entity;
import flow.eventsubscription.service.EventSubscriptionServiceConfiguration;

/**
 * @author Joram Barrez
 */
abstract class AbstractEventSubscriptionDataManager(EntityImpl) : AbstractDataManager!EntityImpl {

    protected EventSubscriptionServiceConfiguration eventSubscriptionServiceConfiguration;

    this(EventSubscriptionServiceConfiguration eventSubscriptionServiceConfiguration) {
        this.eventSubscriptionServiceConfiguration = eventSubscriptionServiceConfiguration;
    }

    public EventSubscriptionServiceConfiguration getEventSubscriptionServiceConfiguration() {
        return eventSubscriptionServiceConfiguration;
    }

    public void setEventSubscriptionServiceConfiguration(EventSubscriptionServiceConfiguration eventSubscriptionServiceConfiguration) {
        this.eventSubscriptionServiceConfiguration = eventSubscriptionServiceConfiguration;
    }
}
