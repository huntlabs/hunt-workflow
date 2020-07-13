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

module flow.event.registry.ChannelDefinitionQueryProperty;

import hunt.collection.HashMap;
import hunt.collection.Map;

import flow.common.api.query.QueryProperty;
import flow.event.registry.api.ChannelDefinitionQuery;
import std.concurrency : initOnce;

/**
 * Contains the possible properties that can be used in a {@link ChannelDefinitionQuery}.
 */
class ChannelDefinitionQueryProperty : QueryProperty {

    static Map!(string,ChannelDefinitionQueryProperty) properties() {
      __gshared Map!(string,ChannelDefinitionQueryProperty) inst;
      return initOnce!inst(new HashMap!(string,ChannelDefinitionQueryProperty));
    }

  static ChannelDefinitionQueryProperty KEY() {
    __gshared ChannelDefinitionQueryProperty inst;
    return initOnce!inst(new ChannelDefinitionQueryProperty("RES.KEY_"));
  }

  static ChannelDefinitionQueryProperty CATEGORY() {
    __gshared ChannelDefinitionQueryProperty inst;
    return initOnce!inst(new ChannelDefinitionQueryProperty("RES.CATEGORY_"));
  }
  static ChannelDefinitionQueryProperty ID() {
    __gshared ChannelDefinitionQueryProperty inst;
    return initOnce!inst(new ChannelDefinitionQueryProperty("RES.ID_"));
  }
  static ChannelDefinitionQueryProperty NAME() {
    __gshared ChannelDefinitionQueryProperty inst;
    return initOnce!inst(new ChannelDefinitionQueryProperty("RES.NAME_"));
  }

  static ChannelDefinitionQueryProperty DEPLOYMENT_ID() {
    __gshared ChannelDefinitionQueryProperty inst;
    return initOnce!inst(new ChannelDefinitionQueryProperty("RES.DEPLOYMENT_ID_"));
  }

  static ChannelDefinitionQueryProperty CREATE_TIME() {
    __gshared ChannelDefinitionQueryProperty inst;
    return initOnce!inst(new ChannelDefinitionQueryProperty("RES.CREATE_TIME_"));
  }

  static ChannelDefinitionQueryProperty TENANT_ID() {
    __gshared ChannelDefinitionQueryProperty inst;
    return initOnce!inst(new ChannelDefinitionQueryProperty("RES.TENANT_ID_"));
  }
    //private static final Map<string, ChannelDefinitionQueryProperty> properties = new HashMap<>();

    //public static final ChannelDefinitionQueryProperty KEY = new ChannelDefinitionQueryProperty("RES.KEY_");
   // public static final ChannelDefinitionQueryProperty CATEGORY = new ChannelDefinitionQueryProperty("RES.CATEGORY_");
    //public static final ChannelDefinitionQueryProperty ID = new ChannelDefinitionQueryProperty("RES.ID_");
    //public static final ChannelDefinitionQueryProperty NAME = new ChannelDefinitionQueryProperty("RES.NAME_");
   // public static final ChannelDefinitionQueryProperty DEPLOYMENT_ID = new ChannelDefinitionQueryProperty("RES.DEPLOYMENT_ID_");
    //public static final ChannelDefinitionQueryProperty CREATE_TIME = new ChannelDefinitionQueryProperty("RES.CREATE_TIME_");
  //  public static final ChannelDefinitionQueryProperty TENANT_ID = new ChannelDefinitionQueryProperty("RES.TENANT_ID_");

    private string name;

    this(string name) {
        this.name = name;
        properties.put(name, this);
    }

    public string getName() {
        return name;
    }

    public static ChannelDefinitionQueryProperty findByName(string propertyName) {
        return properties.get(propertyName);
    }

}
