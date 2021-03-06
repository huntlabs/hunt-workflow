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

module flow.event.registry.persistence.entity.data.AbstractEventDataManager;


import flow.common.db.AbstractDataManager;
import flow.common.persistence.entity.Entity;
import flow.event.registry.EventRegistryEngineConfiguration;

/**
 * @author Joram Barrez
 * @author Tijs Rademakers
 */
abstract class AbstractEventDataManager(T) : AbstractDataManager!T {

    protected EventRegistryEngineConfiguration eventRegistryConfiguration;

    this(EventRegistryEngineConfiguration eventRegistryConfiguration) {
        this.eventRegistryConfiguration = eventRegistryConfiguration;
    }

}
