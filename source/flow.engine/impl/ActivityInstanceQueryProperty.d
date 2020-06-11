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

module flow.engine.impl.ActivityInstanceQueryProperty;

import hunt.collection.HashMap;
import hunt.collection.Map;

import flow.common.api.query.QueryProperty;
import flow.engine.runtime.ActivityInstanceQuery;
import std.concurrency : initOnce;
/**
 * Contains the possible properties which can be used in a {@link ActivityInstanceQuery}.
 *
 * @author martin.grofcik
 */
class ActivityInstanceQueryProperty : QueryProperty {

    //private static final Map!(string, ActivityInstanceQueryProperty) properties = new HashMap<>();
    //
    //public static final ActivityInstanceQueryProperty ACTIVITY_INSTANCE_ID = new ActivityInstanceQueryProperty("ID_");
    //public static final ActivityInstanceQueryProperty PROCESS_INSTANCE_ID = new ActivityInstanceQueryProperty("PROC_INST_ID_");
    //public static final ActivityInstanceQueryProperty EXECUTION_ID = new ActivityInstanceQueryProperty("EXECUTION_ID_");
    //public static final ActivityInstanceQueryProperty ACTIVITY_ID = new ActivityInstanceQueryProperty("ACT_ID_");
    //public static final ActivityInstanceQueryProperty ACTIVITY_NAME = new ActivityInstanceQueryProperty("ACT_NAME_");
    //public static final ActivityInstanceQueryProperty ACTIVITY_TYPE = new ActivityInstanceQueryProperty("ACT_TYPE_");
    //public static final ActivityInstanceQueryProperty PROCESS_DEFINITION_ID = new ActivityInstanceQueryProperty("PROC_DEF_ID_");
    //public static final ActivityInstanceQueryProperty START = new ActivityInstanceQueryProperty("START_TIME_");
    //public static final ActivityInstanceQueryProperty END = new ActivityInstanceQueryProperty("END_TIME_");
    //public static final ActivityInstanceQueryProperty DURATION = new ActivityInstanceQueryProperty("DURATION_");
    //public static final ActivityInstanceQueryProperty TENANT_ID = new ActivityInstanceQueryProperty("TENANT_ID_");


    static Map!(string,ActivityInstanceQueryProperty) properties() {
      __gshared Map!(string,ActivityInstanceQueryProperty) inst;
      return initOnce!inst(new HashMap!(string,ActivityInstanceQueryProperty));
    }

    static ActivityInstanceQueryProperty ACTIVITY_INSTANCE_ID() {
      __gshared ActivityInstanceQueryProperty inst;
      return initOnce!inst(new ActivityInstanceQueryProperty("ID_"));
    }

    static ActivityInstanceQueryProperty PROCESS_INSTANCE_ID() {
      __gshared ActivityInstanceQueryProperty inst;
      return initOnce!inst(new ActivityInstanceQueryProperty("PROC_INST_ID_"));
    }

   static ActivityInstanceQueryProperty EXECUTION_ID() {
     __gshared ActivityInstanceQueryProperty inst;
     return initOnce!inst(new ActivityInstanceQueryProperty("EXECUTION_ID_"));
   }

   static ActivityInstanceQueryProperty ACTIVITY_ID() {
     __gshared ActivityInstanceQueryProperty inst;
     return initOnce!inst(new ActivityInstanceQueryProperty("ACT_ID_"));
   }

    static ActivityInstanceQueryProperty ACTIVITY_NAME() {
      __gshared ActivityInstanceQueryProperty inst;
      return initOnce!inst(new ActivityInstanceQueryProperty("ACT_NAME_"));
    }

    static ActivityInstanceQueryProperty ACTIVITY_TYPE() {
      __gshared ActivityInstanceQueryProperty inst;
      return initOnce!inst(new ActivityInstanceQueryProperty("ACT_TYPE_"));
    }

    static ActivityInstanceQueryProperty PROCESS_DEFINITION_ID() {
      __gshared ActivityInstanceQueryProperty inst;
      return initOnce!inst(new ActivityInstanceQueryProperty("PROC_DEF_ID_"));
    }


    static ActivityInstanceQueryProperty START() {
      __gshared ActivityInstanceQueryProperty inst;
      return initOnce!inst(new ActivityInstanceQueryProperty("START_TIME_"));
    }

    static ActivityInstanceQueryProperty END() {
      __gshared ActivityInstanceQueryProperty inst;
      return initOnce!inst(new ActivityInstanceQueryProperty("END_TIME_"));
    }

    static ActivityInstanceQueryProperty DURATION() {
      __gshared ActivityInstanceQueryProperty inst;
      return initOnce!inst(new ActivityInstanceQueryProperty("DURATION_"));
    }

    static ActivityInstanceQueryProperty TENANT_ID() {
      __gshared ActivityInstanceQueryProperty inst;
      return initOnce!inst(new ActivityInstanceQueryProperty("TENANT_ID_"));
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

    public static ActivityInstanceQueryProperty findByName(string propertyName) {
        return properties.get(propertyName);
    }
}
