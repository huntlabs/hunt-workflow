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

module flow.engine.impl.ProcessDefinitionQueryProperty;

import hunt.collection.HashMap;
import hunt.collection.Map;

import flow.common.api.query.QueryProperty;
import flow.engine.repository.ProcessDefinitionQuery;
import std.concurrency : initOnce;
/**
 * Contains the possible properties that can be used in a {@link ProcessDefinitionQuery}.
 *
 * @author Joram Barrez
 */
class ProcessDefinitionQueryProperty : QueryProperty {

    //private static final Map!(string, ProcessDefinitionQueryProperty) properties = new HashMap<>();
    //
    //public static final ProcessDefinitionQueryProperty PROCESS_DEFINITION_KEY = new ProcessDefinitionQueryProperty("RES.KEY_");
    //public static final ProcessDefinitionQueryProperty PROCESS_DEFINITION_CATEGORY = new ProcessDefinitionQueryProperty("RES.CATEGORY_");
    //public static final ProcessDefinitionQueryProperty PROCESS_DEFINITION_ID = new ProcessDefinitionQueryProperty("RES.ID_");
    //public static final ProcessDefinitionQueryProperty PROCESS_DEFINITION_VERSION = new ProcessDefinitionQueryProperty("RES.VERSION_");
    //public static final ProcessDefinitionQueryProperty PROCESS_DEFINITION_NAME = new ProcessDefinitionQueryProperty("RES.NAME_");
    //public static final ProcessDefinitionQueryProperty DEPLOYMENT_ID = new ProcessDefinitionQueryProperty("RES.DEPLOYMENT_ID_");
    //public static final ProcessDefinitionQueryProperty PROCESS_DEFINITION_TENANT_ID = new ProcessDefinitionQueryProperty("RES.TENANT_ID_");

     static Map!(string,ProcessDefinitionQueryProperty) properties() {
       __gshared Map!(string,ProcessDefinitionQueryProperty) inst;
       return initOnce!inst(new HashMap!(string,ProcessDefinitionQueryProperty));
     }

    static ProcessDefinitionQueryProperty PROCESS_DEFINITION_KEY() {
      __gshared ProcessDefinitionQueryProperty inst;
      return initOnce!inst(new ProcessDefinitionQueryProperty("RES.KEY_"));
    }

   static ProcessDefinitionQueryProperty PROCESS_DEFINITION_CATEGORY() {
     __gshared ProcessDefinitionQueryProperty inst;
     return initOnce!inst(new ProcessDefinitionQueryProperty("RES.CATEGORY_"));
   }

   static ProcessDefinitionQueryProperty PROCESS_DEFINITION_ID() {
     __gshared ProcessDefinitionQueryProperty inst;
     return initOnce!inst(new ProcessDefinitionQueryProperty("RES.ID_"));
   }

    static ProcessDefinitionQueryProperty PROCESS_DEFINITION_VERSION() {
      __gshared ProcessDefinitionQueryProperty inst;
      return initOnce!inst(new ProcessDefinitionQueryProperty("RES.VERSION_"));
    }

    static ProcessDefinitionQueryProperty PROCESS_DEFINITION_NAME() {
      __gshared ProcessDefinitionQueryProperty inst;
      return initOnce!inst(new ProcessDefinitionQueryProperty("RES.NAME_"));
    }

    static ProcessDefinitionQueryProperty DEPLOYMENT_ID() {
      __gshared ProcessDefinitionQueryProperty inst;
      return initOnce!inst(new ProcessDefinitionQueryProperty("RES.DEPLOYMENT_ID_"));
    }

    static ProcessDefinitionQueryProperty PROCESS_DEFINITION_TENANT_ID() {
      __gshared ProcessDefinitionQueryProperty inst;
      return initOnce!inst(new ProcessDefinitionQueryProperty("RES.TENANT_ID_"));
    }

    private string name;

    this(string name) {
        this.name = name;
        properties.put(name, this);
    }

    override
    public string getName() {
        return name;
    }

    public static ProcessDefinitionQueryProperty findByName(string propertyName) {
        return properties.get(propertyName);
    }

}
