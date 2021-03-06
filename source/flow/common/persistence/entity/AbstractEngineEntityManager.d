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

module flow.common.persistence.entity.AbstractEngineEntityManager;

import flow.common.api.deleg.event.FlowableEventDispatcher;
import flow.common.AbstractEngineConfiguration;
import flow.common.interceptor.CommandExecutor;
import flow.common.persistence.entity.data.DataManager;
import flow.common.runtime.Clockm;
import flow.common.persistence.entity.AbstractEntityManager;

/**
 * @author Joram Barrez
 * @author Filip Hrisafov
 */
abstract class AbstractEngineEntityManager(T, EntityImpl, DM)
    : AbstractEntityManager!(EntityImpl, DM) {

    protected T engineConfiguration;

    this(T engineConfiguration, DM dataManager) {
        super(dataManager);
        this.engineConfiguration = engineConfiguration;
    }

    protected T getEngineConfiguration() {
        return engineConfiguration;
    }

    override
    protected FlowableEventDispatcher getEventDispatcher() {
        return engineConfiguration.getEventDispatcher();
    }

    protected Clockm getClock() {
        return engineConfiguration.getClock();
    }

    protected CommandExecutor getCommandExecutor() {
        return engineConfiguration.getCommandExecutor();
    }

}
