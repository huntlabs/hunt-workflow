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
module flow.event.registry.EventDefinitionQueryProperty;


import hunt.collection.HashMap;
import hunt.collection.Map;

import flow.common.api.query.QueryProperty;
import flow.event.registry.api.EventDefinitionQuery;
import std.concurrency : initOnce;
/**
 * Contains the possible properties that can be used in a {@link EventDefinitionQuery}.
 *
 * @author Joram Barrez
 */
class EventDefinitionQueryProperty : QueryProperty {


   static Map!(string,EventDefinitionQueryProperty) properties() {
     __gshared Map!(string,EventDefinitionQueryProperty) inst;
     return initOnce!inst(new HashMap!(string,EventDefinitionQueryProperty));
   }

  static EventDefinitionQueryProperty KEY() {
    __gshared EventDefinitionQueryProperty inst;
    return initOnce!inst(new EventDefinitionQueryProperty("RES.KEY_"));
  }

    static EventDefinitionQueryProperty CATEGORY() {
      __gshared EventDefinitionQueryProperty inst;
      return initOnce!inst(new EventDefinitionQueryProperty("RES.CATEGORY_"));
    }

    static EventDefinitionQueryProperty ID() {
      __gshared EventDefinitionQueryProperty inst;
      return initOnce!inst(new EventDefinitionQueryProperty("RES.ID_"));
    }

     static EventDefinitionQueryProperty NAME() {
       __gshared EventDefinitionQueryProperty inst;
       return initOnce!inst(new EventDefinitionQueryProperty("RES.NAME_"));
     }

     static EventDefinitionQueryProperty DEPLOYMENT_ID() {
       __gshared EventDefinitionQueryProperty inst;
       return initOnce!inst(new EventDefinitionQueryProperty("RES.DEPLOYMENT_ID_"));
     }

      static EventDefinitionQueryProperty TENANT_ID() {
        __gshared EventDefinitionQueryProperty inst;
        return initOnce!inst(new EventDefinitionQueryProperty("RES.TENANT_ID_"));
      }
    //private static final Map<string, EventDefinitionQueryProperty> properties = new HashMap<>();

    //public static final EventDefinitionQueryProperty KEY = new EventDefinitionQueryProperty("RES.KEY_");
    //public static final EventDefinitionQueryProperty CATEGORY = new EventDefinitionQueryProperty("RES.CATEGORY_");
    //public static final EventDefinitionQueryProperty ID = new EventDefinitionQueryProperty("RES.ID_");
    //public static final EventDefinitionQueryProperty NAME = new EventDefinitionQueryProperty("RES.NAME_");
    //public static final EventDefinitionQueryProperty DEPLOYMENT_ID = new EventDefinitionQueryProperty("RES.DEPLOYMENT_ID_");
    //public static final EventDefinitionQueryProperty TENANT_ID = new EventDefinitionQueryProperty("RES.TENANT_ID_");

    private string name;

    this(string name) {
        this.name = name;
        properties.put(name, this);
    }

    public string getName() {
        return name;
    }

    public static EventDefinitionQueryProperty findByName(string propertyName) {
        return properties.get(propertyName);
    }

}
