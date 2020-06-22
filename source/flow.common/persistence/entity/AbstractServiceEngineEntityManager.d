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

module flow.common.persistence.entity.AbstractServiceEngineEntityManager;

import flow.common.api.deleg.event.FlowableEventDispatcher;
import flow.common.AbstractServiceConfiguration;
import flow.common.persistence.entity.data.DataManager;
import flow.common.runtime.Clockm;
import flow.common.persistence.entity.AbstractEntityManager;

/**
 * @author Joram Barrez
 * @author Filip Hrisafov
 */
abstract class AbstractServiceEngineEntityManager(T, EntityImpl, DM): AbstractEntityManager!(EntityImpl, DM) {

    protected T serviceConfiguration;

    this(T serviceConfiguration, DM dataManager) {
        super(dataManager);
        this.serviceConfiguration = serviceConfiguration;
    }

    protected T getServiceConfiguration() {
        return serviceConfiguration;
    }

    override
    protected FlowableEventDispatcher getEventDispatcher() {
        return serviceConfiguration.getEventDispatcher();
    }

    protected Clockm getClock() {
        return serviceConfiguration.getClock();
    }
}
