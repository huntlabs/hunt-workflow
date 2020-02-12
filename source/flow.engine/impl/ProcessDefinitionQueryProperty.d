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



import java.util.HashMap;
import java.util.Map;

import flow.common.api.query.QueryProperty;
import flow.engine.repository.ProcessDefinitionQuery;

/**
 * Contains the possible properties that can be used in a {@link ProcessDefinitionQuery}.
 * 
 * @author Joram Barrez
 */
class ProcessDefinitionQueryProperty implements QueryProperty {

    private static final long serialVersionUID = 1L;

    private static final Map<string, ProcessDefinitionQueryProperty> properties = new HashMap<>();

    public static final ProcessDefinitionQueryProperty PROCESS_DEFINITION_KEY = new ProcessDefinitionQueryProperty("RES.KEY_");
    public static final ProcessDefinitionQueryProperty PROCESS_DEFINITION_CATEGORY = new ProcessDefinitionQueryProperty("RES.CATEGORY_");
    public static final ProcessDefinitionQueryProperty PROCESS_DEFINITION_ID = new ProcessDefinitionQueryProperty("RES.ID_");
    public static final ProcessDefinitionQueryProperty PROCESS_DEFINITION_VERSION = new ProcessDefinitionQueryProperty("RES.VERSION_");
    public static final ProcessDefinitionQueryProperty PROCESS_DEFINITION_NAME = new ProcessDefinitionQueryProperty("RES.NAME_");
    public static final ProcessDefinitionQueryProperty DEPLOYMENT_ID = new ProcessDefinitionQueryProperty("RES.DEPLOYMENT_ID_");
    public static final ProcessDefinitionQueryProperty PROCESS_DEFINITION_TENANT_ID = new ProcessDefinitionQueryProperty("RES.TENANT_ID_");

    private string name;

    public ProcessDefinitionQueryProperty(string name) {
        this.name = name;
        properties.put(name, this);
    }

    @Override
    public string getName() {
        return name;
    }

    public static ProcessDefinitionQueryProperty findByName(string propertyName) {
        return properties.get(propertyName);
    }

}
