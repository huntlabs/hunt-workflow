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
module flow.event.registry.EventManagementServiceImpl;

import hunt.collection;
import hunt.collection.Map;

import flow.common.service.CommonEngineServiceImpl;
import flow.event.registry.api.EventManagementService;
import flow.event.registry.cmd.GetTableCountsCmd;
import flow.event.registry.cmd.GetTableNamesCmd;
import flow.event.registry.EventRegistryEngineConfiguration;

/**
 * @author Tijs Rademakers
 */
class EventManagementServiceImpl : CommonEngineServiceImpl!EventRegistryEngineConfiguration , EventManagementService {

    this(EventRegistryEngineConfiguration engineConfiguration) {
        super(engineConfiguration);
    }

    public Map!(string, long) getTableCounts() {
        return commandExecutor.execute(new GetTableCountsCmd());
    }

    public Collection!string getTableNames() {
        return commandExecutor.execute(new GetTableNamesCmd());
    }

    public void executeEventRegistryChangeDetection() {
        configuration.getEventRegistryChangeDetectionManager().detectChanges();
    }

}
