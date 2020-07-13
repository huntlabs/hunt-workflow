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
module flow.task.service.impl.HistoricTaskLogEntryQueryProperty;

import hunt.collection.HashMap;
import hunt.collection.Map;

import flow.common.api.query.QueryProperty;
import flow.task.api.history.HistoricTaskLogEntryQuery;
import std.concurrency : initOnce;
/**
 * Contains the possible properties that can be used in a {@link HistoricTaskLogEntryQuery}.
 *
 * @author martin.grofcik
 */
class HistoricTaskLogEntryQueryProperty : QueryProperty {


    //private static final Map<string, HistoricTaskLogEntryQueryProperty> properties = new HashMap<>();
    //
    //public static final HistoricTaskLogEntryQueryProperty LOG_NUMBER = new HistoricTaskLogEntryQueryProperty("RES.ID_");
    //public static final HistoricTaskLogEntryQueryProperty TYPE = new HistoricTaskLogEntryQueryProperty("RES.TYPE_");
    //public static final HistoricTaskLogEntryQueryProperty TASK_ID_ = new HistoricTaskLogEntryQueryProperty("RES.TASK_ID_");
    //public static final HistoricTaskLogEntryQueryProperty TIME_STAMP = new HistoricTaskLogEntryQueryProperty("RES.TIME_STAMP_");
    //public static final HistoricTaskLogEntryQueryProperty USER_ID = new HistoricTaskLogEntryQueryProperty("RES.USER_ID");
    //public static final HistoricTaskLogEntryQueryProperty DATA = new HistoricTaskLogEntryQueryProperty("RES.DATA_");
    //public static final HistoricTaskLogEntryQueryProperty EXECUTION_ID = new HistoricTaskLogEntryQueryProperty("RES.EXECUTION_ID_");
    //public static final HistoricTaskLogEntryQueryProperty PROCESS_INSTANCE_ID = new HistoricTaskLogEntryQueryProperty("RES.PROC_INST_ID_");
    //public static final HistoricTaskLogEntryQueryProperty PROCESS_DEFINITION_ID = new HistoricTaskLogEntryQueryProperty("RES.PROC_DEF_ID_");
    //public static final HistoricTaskLogEntryQueryProperty SCOPE_ID = new HistoricTaskLogEntryQueryProperty("RES.SCOPE_ID_");
    //public static final HistoricTaskLogEntryQueryProperty SCOPE_DEFINITION_ID = new HistoricTaskLogEntryQueryProperty("RES.SCOPE_DEFINITION_ID_");
    //public static final HistoricTaskLogEntryQueryProperty SUB_SCOPE_ID = new HistoricTaskLogEntryQueryProperty("RES.SUB_SCOPE_ID_");
    //public static final HistoricTaskLogEntryQueryProperty SCOPE_TYPE = new HistoricTaskLogEntryQueryProperty("RES.SCOPE_TYPE_");
    //public static final HistoricTaskLogEntryQueryProperty TENANT_ID = new HistoricTaskLogEntryQueryProperty("RES.TENANT_ID_");

    private string name;

    static Map!(string,HistoricTaskLogEntryQueryProperty) properties() {
      __gshared Map!(string,HistoricTaskLogEntryQueryProperty) inst;
      return initOnce!inst(new HashMap!(string,HistoricTaskLogEntryQueryProperty));
    }

     static HistoricTaskLogEntryQueryProperty LOG_NUMBER() {
       __gshared HistoricTaskLogEntryQueryProperty inst;
       return initOnce!inst(new HistoricTaskLogEntryQueryProperty("RES.ID_"));
     }
  static HistoricTaskLogEntryQueryProperty TYPE() {
    __gshared HistoricTaskLogEntryQueryProperty inst;
    return initOnce!inst(new HistoricTaskLogEntryQueryProperty("RES.TYPE_"));
  }
    static HistoricTaskLogEntryQueryProperty TASK_ID_() {
      __gshared HistoricTaskLogEntryQueryProperty inst;
      return initOnce!inst(new HistoricTaskLogEntryQueryProperty("RES.TASK_ID_"));
    }
      static HistoricTaskLogEntryQueryProperty TIME_STAMP() {
        __gshared HistoricTaskLogEntryQueryProperty inst;
        return initOnce!inst(new HistoricTaskLogEntryQueryProperty("RES.TIME_STAMP_"));
      }
     static HistoricTaskLogEntryQueryProperty USER_ID() {
       __gshared HistoricTaskLogEntryQueryProperty inst;
       return initOnce!inst(new HistoricTaskLogEntryQueryProperty("RES.USER_ID"));
     }

  static HistoricTaskLogEntryQueryProperty DATA() {
    __gshared HistoricTaskLogEntryQueryProperty inst;
    return initOnce!inst(new HistoricTaskLogEntryQueryProperty("RES.DATA_"));
  }

    static HistoricTaskLogEntryQueryProperty EXECUTION_ID() {
      __gshared HistoricTaskLogEntryQueryProperty inst;
      return initOnce!inst(new HistoricTaskLogEntryQueryProperty("RES.EXECUTION_ID_"));
    }
  static HistoricTaskLogEntryQueryProperty PROCESS_INSTANCE_ID() {
    __gshared HistoricTaskLogEntryQueryProperty inst;
    return initOnce!inst(new HistoricTaskLogEntryQueryProperty("RES.PROC_INST_ID_"));
  }

    static HistoricTaskLogEntryQueryProperty PROCESS_DEFINITION_ID() {
      __gshared HistoricTaskLogEntryQueryProperty inst;
      return initOnce!inst(new HistoricTaskLogEntryQueryProperty("RES.PROC_DEF_ID_"));
    }

    static HistoricTaskLogEntryQueryProperty SCOPE_ID() {
      __gshared HistoricTaskLogEntryQueryProperty inst;
      return initOnce!inst(new HistoricTaskLogEntryQueryProperty("RES.SCOPE_ID_"));
    }
    static HistoricTaskLogEntryQueryProperty SCOPE_DEFINITION_ID() {
      __gshared HistoricTaskLogEntryQueryProperty inst;
      return initOnce!inst(new HistoricTaskLogEntryQueryProperty("RES.SCOPE_DEFINITION_ID_"));
    }
  static HistoricTaskLogEntryQueryProperty SUB_SCOPE_ID() {
    __gshared HistoricTaskLogEntryQueryProperty inst;
    return initOnce!inst(new HistoricTaskLogEntryQueryProperty("RES.SUB_SCOPE_ID_"));
  }
   static HistoricTaskLogEntryQueryProperty SCOPE_TYPE() {
     __gshared HistoricTaskLogEntryQueryProperty inst;
     return initOnce!inst(new HistoricTaskLogEntryQueryProperty("RES.SCOPE_TYPE_"));
   }
     static HistoricTaskLogEntryQueryProperty TENANT_ID() {
       __gshared HistoricTaskLogEntryQueryProperty inst;
       return initOnce!inst(new HistoricTaskLogEntryQueryProperty("RES.TENANT_ID_"));
     }

    this(string name) {
        this.name = name;
        properties.put(name, this);
    }

    public string getName() {
        return name;
    }

    public static HistoricTaskLogEntryQueryProperty findByName(string propertyName) {
        return properties.get(propertyName);
    }

}
