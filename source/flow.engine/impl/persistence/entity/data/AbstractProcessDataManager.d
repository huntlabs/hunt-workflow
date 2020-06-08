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
module flow.engine.impl.persistence.entity.data.AbstractProcessDataManager;

import flow.common.db.AbstractDataManager;
import flow.common.persistence.entity.Entity;
import flow.common.runtime.Clock;
import flow.engine.impl.cfg.ProcessEngineConfigurationImpl;

/**
 * @author Joram Barrez
 */
abstract class AbstractProcessDataManager(EntityImpl) : AbstractDataManager!EntityImpl {

    protected ProcessEngineConfigurationImpl processEngineConfiguration;

    this(ProcessEngineConfigurationImpl processEngineConfiguration) {
        this.processEngineConfiguration = processEngineConfiguration;
    }

    protected ProcessEngineConfigurationImpl getProcessEngineConfiguration() {
        return processEngineConfiguration;
    }

    protected Clock getClock() {
        return processEngineConfiguration.getClock();
    }

}
