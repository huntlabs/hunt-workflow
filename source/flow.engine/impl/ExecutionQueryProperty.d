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

module flow.engine.impl.ExecutionQueryProperty;

import hunt.collection.HashMap;
import hunt.collection.Map;

import flow.common.api.query.QueryProperty;
import flow.engine.runtime.ExecutionQuery;
import std.concurrency : initOnce;
/**
 * Contains the possible properties that can be used in a {@link ExecutionQuery} .
 *
 * @author Joram Barrez
 */
class ExecutionQueryProperty : QueryProperty {

    //private static final Map!(string, ExecutionQueryProperty) properties = new HashMap<>();

    //public static final ExecutionQueryProperty PROCESS_INSTANCE_ID = new ExecutionQueryProperty("RES.ID_");
    //public static final ExecutionQueryProperty PROCESS_DEFINITION_KEY = new ExecutionQueryProperty("ProcessDefinitionKey");
    //public static final ExecutionQueryProperty PROCESS_DEFINITION_ID = new ExecutionQueryProperty("ProcessDefinitionId");
    //public static final ExecutionQueryProperty TENANT_ID = new ExecutionQueryProperty("RES.TENANT_ID_");

    static Map!(string, ExecutionQueryProperty) properties() {
      __gshared Map!(string, ExecutionQueryProperty) inst;
      return initOnce!inst(new HashMap!(string, ExecutionQueryProperty));
    }

    static ExecutionQueryProperty PROCESS_INSTANCE_ID() {
      __gshared ExecutionQueryProperty inst;
      return initOnce!inst(new ExecutionQueryProperty("RES.ID_"));
    }

    static ExecutionQueryProperty PROCESS_DEFINITION_KEY() {
      __gshared ExecutionQueryProperty inst;
      return initOnce!inst(new ExecutionQueryProperty("ProcessDefinitionKey"));
    }

    static ExecutionQueryProperty PROCESS_DEFINITION_ID() {
      __gshared ExecutionQueryProperty inst;
      return initOnce!inst(new ExecutionQueryProperty("ProcessDefinitionId"));
    }

    static ExecutionQueryProperty TENANT_ID() {
      __gshared ExecutionQueryProperty inst;
      return initOnce!inst(new ExecutionQueryProperty("RES.TENANT_ID_"));
    }

    private string name;

    this(string name) {
        this.name = name;
        properties.put(name, this);
    }

    public string getName() {
        return name;
    }

    public static ExecutionQueryProperty findByName(string propertyName) {
        return properties.get(propertyName);
    }

}
