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
module flow.event.registry.api.EventManagementService;

import hunt.collection;
import hunt.collection.Map;
interface EventManagementService {

    /**
     * Returns a map containing {tableName, rowCount} values.
     */
    Map!(string, long) getTableCounts();

    /**
     * Returns all relational database tables of the engine.
     */
    Collection!string getTableNames();

    /**
     * Programmatically execute the house keeping functionality: any new channel definitions
     * deployed on other engine nodes (using the same datasource) will be deployed.
     * Any removed channel definitions on other engine nodes will be removed.
     */
    void executeEventRegistryChangeDetection();

}
