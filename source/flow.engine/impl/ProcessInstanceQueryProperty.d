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



import hunt.collection.HashMap;
import hunt.collection.Map;

import flow.common.api.query.QueryProperty;
import flow.engine.runtime.ProcessInstanceQuery;

/**
 * Contains the possible properties that can be used in a {@link ProcessInstanceQuery}.
 *
 * @author Joram Barrez
 */
class ProcessInstanceQueryProperty implements QueryProperty {

    private static final long serialVersionUID = 1L;

    private static final Map!(string, ProcessInstanceQueryProperty) properties = new HashMap<>();

    public static final ProcessInstanceQueryProperty PROCESS_INSTANCE_ID = new ProcessInstanceQueryProperty("RES.ID_");
    public static final ProcessInstanceQueryProperty PROCESS_DEFINITION_KEY = new ProcessInstanceQueryProperty("ProcessDefinitionKey");
    public static final ProcessInstanceQueryProperty PROCESS_DEFINITION_ID = new ProcessInstanceQueryProperty("ProcessDefinitionId");
    public static final ProcessInstanceQueryProperty PROCESS_START_TIME = new ProcessInstanceQueryProperty("RES.START_TIME_");
    public static final ProcessInstanceQueryProperty TENANT_ID = new ProcessInstanceQueryProperty("RES.TENANT_ID_");

    private string name;

    public ProcessInstanceQueryProperty(string name) {
        this.name = name;
        properties.put(name, this);
    }

    override
    public string getName() {
        return name;
    }

    public static ProcessInstanceQueryProperty findByName(string propertyName) {
        return properties.get(propertyName);
    }

}
