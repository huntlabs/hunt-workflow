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

module flow.task.service.impl.HistoricTaskInstanceQueryProperty;

import hunt.collection.HashMap;
import hunt.collection.Map;

import flow.common.api.query.QueryProperty;
import std.concurrency : initOnce;
/**
 * @author Tom Baeyens
 */
class HistoricTaskInstanceQueryProperty : QueryProperty {

    //private static final Map<string, HistoricTaskInstanceQueryProperty> properties = new HashMap<>();
    //
    //public static final HistoricTaskInstanceQueryProperty HISTORIC_TASK_INSTANCE_ID = new HistoricTaskInstanceQueryProperty("RES.ID_");
    //public static final HistoricTaskInstanceQueryProperty PROCESS_DEFINITION_ID = new HistoricTaskInstanceQueryProperty("RES.PROC_DEF_ID_");
    //public static final HistoricTaskInstanceQueryProperty PROCESS_INSTANCE_ID = new HistoricTaskInstanceQueryProperty("RES.PROC_INST_ID_");
    //public static final HistoricTaskInstanceQueryProperty EXECUTION_ID = new HistoricTaskInstanceQueryProperty("RES.EXECUTION_ID_");
    //public static final HistoricTaskInstanceQueryProperty TASK_NAME = new HistoricTaskInstanceQueryProperty("RES.NAME_");
    //public static final HistoricTaskInstanceQueryProperty TASK_DESCRIPTION = new HistoricTaskInstanceQueryProperty("RES.DESCRIPTION_");
    //public static final HistoricTaskInstanceQueryProperty TASK_ASSIGNEE = new HistoricTaskInstanceQueryProperty("RES.ASSIGNEE_");
    //public static final HistoricTaskInstanceQueryProperty TASK_OWNER = new HistoricTaskInstanceQueryProperty("RES.OWNER_");
    //public static final HistoricTaskInstanceQueryProperty TASK_DEFINITION_KEY = new HistoricTaskInstanceQueryProperty("RES.TASK_DEF_KEY_");
    //public static final HistoricTaskInstanceQueryProperty DELETE_REASON = new HistoricTaskInstanceQueryProperty("RES.DELETE_REASON_");
    //public static final HistoricTaskInstanceQueryProperty START = new HistoricTaskInstanceQueryProperty("RES.START_TIME_");
    //public static final HistoricTaskInstanceQueryProperty END = new HistoricTaskInstanceQueryProperty("RES.END_TIME_");
    //public static final HistoricTaskInstanceQueryProperty DURATION = new HistoricTaskInstanceQueryProperty("RES.DURATION_");
    //public static final HistoricTaskInstanceQueryProperty TASK_PRIORITY = new HistoricTaskInstanceQueryProperty("RES.PRIORITY_");
    //public static final HistoricTaskInstanceQueryProperty TASK_DUE_DATE = new HistoricTaskInstanceQueryProperty("RES.DUE_DATE_");
    //public static final HistoricTaskInstanceQueryProperty TENANT_ID_ = new HistoricTaskInstanceQueryProperty("RES.TENANT_ID_");
    //public static final HistoricTaskInstanceQueryProperty SCOPE_DEFINITION_ID = new HistoricTaskInstanceQueryProperty("RES.SCOPE_DEFINITION_ID_");
    //public static final HistoricTaskInstanceQueryProperty SCOPE_ID = new HistoricTaskInstanceQueryProperty("RES.SCOPE_ID_");
    //public static final HistoricTaskInstanceQueryProperty SCOPE_TYPE = new HistoricTaskInstanceQueryProperty("RES.SCOPE_TYPE_");
    //
    //public static final HistoricTaskInstanceQueryProperty INCLUDED_VARIABLE_TIME = new HistoricTaskInstanceQueryProperty("VAR.LAST_UPDATED_TIME_");


    static Map!(string,HistoricTaskInstanceQueryProperty) properties() {
      __gshared Map!(string,HistoricTaskInstanceQueryProperty) inst;
      return initOnce!inst(new HashMap!(string,HistoricTaskInstanceQueryProperty));
    }

   static HistoricTaskInstanceQueryProperty HISTORIC_TASK_INSTANCE_ID() {
     __gshared HistoricTaskInstanceQueryProperty inst;
     return initOnce!inst(new HistoricTaskInstanceQueryProperty("RES.ID_"));
   }

 static HistoricTaskInstanceQueryProperty PROCESS_DEFINITION_ID() {
   __gshared HistoricTaskInstanceQueryProperty inst;
   return initOnce!inst(new HistoricTaskInstanceQueryProperty("RES.PROC_DEF_ID_"));
 }

   static HistoricTaskInstanceQueryProperty PROCESS_INSTANCE_ID() {
     __gshared HistoricTaskInstanceQueryProperty inst;
     return initOnce!inst(new HistoricTaskInstanceQueryProperty("RES.PROC_INST_ID_"));
   }

   static HistoricTaskInstanceQueryProperty EXECUTION_ID() {
     __gshared HistoricTaskInstanceQueryProperty inst;
     return initOnce!inst(new HistoricTaskInstanceQueryProperty("RES.EXECUTION_ID_"));
   }

     static HistoricTaskInstanceQueryProperty TASK_NAME() {
       __gshared HistoricTaskInstanceQueryProperty inst;
       return initOnce!inst(new HistoricTaskInstanceQueryProperty("RES.NAME_"));
     }

     static HistoricTaskInstanceQueryProperty TASK_DESCRIPTION() {
       __gshared HistoricTaskInstanceQueryProperty inst;
       return initOnce!inst(new HistoricTaskInstanceQueryProperty("RES.DESCRIPTION_"));
     }

       static HistoricTaskInstanceQueryProperty TASK_ASSIGNEE() {
         __gshared HistoricTaskInstanceQueryProperty inst;
         return initOnce!inst(new HistoricTaskInstanceQueryProperty("RES.ASSIGNEE_"));
       }

       static HistoricTaskInstanceQueryProperty TASK_OWNER() {
         __gshared HistoricTaskInstanceQueryProperty inst;
         return initOnce!inst(new HistoricTaskInstanceQueryProperty("RES.OWNER_"));
       }

     static HistoricTaskInstanceQueryProperty TASK_DEFINITION_KEY() {
       __gshared HistoricTaskInstanceQueryProperty inst;
       return initOnce!inst(new HistoricTaskInstanceQueryProperty("RES.TASK_DEF_KEY_"));
     }

    static HistoricTaskInstanceQueryProperty DELETE_REASON() {
      __gshared HistoricTaskInstanceQueryProperty inst;
      return initOnce!inst(new HistoricTaskInstanceQueryProperty("RES.DELETE_REASON_"));
    }

    static HistoricTaskInstanceQueryProperty START() {
      __gshared HistoricTaskInstanceQueryProperty inst;
      return initOnce!inst(new HistoricTaskInstanceQueryProperty("RES.START_TIME_"));
    }
    static HistoricTaskInstanceQueryProperty END() {
      __gshared HistoricTaskInstanceQueryProperty inst;
      return initOnce!inst(new HistoricTaskInstanceQueryProperty("RES.END_TIME_"));
    }
    static HistoricTaskInstanceQueryProperty DURATION() {
      __gshared HistoricTaskInstanceQueryProperty inst;
      return initOnce!inst(new HistoricTaskInstanceQueryProperty("RES.DURATION_"));
    }
    static HistoricTaskInstanceQueryProperty TASK_PRIORITY() {
      __gshared HistoricTaskInstanceQueryProperty inst;
      return initOnce!inst(new HistoricTaskInstanceQueryProperty("RES.PRIORITY_"));
    }


      static HistoricTaskInstanceQueryProperty TASK_DUE_DATE() {
        __gshared HistoricTaskInstanceQueryProperty inst;
        return initOnce!inst(new HistoricTaskInstanceQueryProperty("RES.DUE_DATE_"));
      }
   static HistoricTaskInstanceQueryProperty TENANT_ID_() {
     __gshared HistoricTaskInstanceQueryProperty inst;
     return initOnce!inst(new HistoricTaskInstanceQueryProperty("RES.TENANT_ID_"));
   }

    static HistoricTaskInstanceQueryProperty SCOPE_DEFINITION_ID() {
      __gshared HistoricTaskInstanceQueryProperty inst;
      return initOnce!inst(new HistoricTaskInstanceQueryProperty("RES.SCOPE_DEFINITION_ID_"));
    }

     static HistoricTaskInstanceQueryProperty SCOPE_ID() {
       __gshared HistoricTaskInstanceQueryProperty inst;
       return initOnce!inst(new HistoricTaskInstanceQueryProperty("RES.SCOPE_ID_"));
     }

      static HistoricTaskInstanceQueryProperty SCOPE_TYPE() {
        __gshared HistoricTaskInstanceQueryProperty inst;
        return initOnce!inst(new HistoricTaskInstanceQueryProperty("RES.SCOPE_TYPE_"));
      }

    static HistoricTaskInstanceQueryProperty INCLUDED_VARIABLE_TIME() {
      __gshared HistoricTaskInstanceQueryProperty inst;
      return initOnce!inst(new HistoricTaskInstanceQueryProperty("VAR.LAST_UPDATED_TIME_"));
    }
    private string name;

    this(string name) {
        this.name = name;
        properties.put(name, this);
    }

    public string getName() {
        return name;
    }

    public static HistoricTaskInstanceQueryProperty findByName(string propertyName) {
        return properties.get(propertyName);
    }
}
