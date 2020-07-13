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

module flow.task.service.impl.TaskQueryProperty;
import hunt.collection.HashMap;
import hunt.collection.Map;

import flow.common.api.query.QueryProperty;
import flow.task.api.TaskQuery;
import std.concurrency : initOnce;
/**
 * Contains the possible properties that can be used in a {@link TaskQuery}.
 *
 * @author Joram Barrez
 */
class TaskQueryProperty : QueryProperty {

  //  private static final Map<string, TaskQueryProperty> properties = new HashMap<>();

    //public static final TaskQueryProperty TASK_ID = new TaskQueryProperty("RES.ID_");
    //public static final TaskQueryProperty NAME = new TaskQueryProperty("RES.NAME_");
    //public static final TaskQueryProperty DESCRIPTION = new TaskQueryProperty("RES.DESCRIPTION_");
    //public static final TaskQueryProperty PRIORITY = new TaskQueryProperty("RES.PRIORITY_");
    //public static final TaskQueryProperty ASSIGNEE = new TaskQueryProperty("RES.ASSIGNEE_");
    //public static final TaskQueryProperty OWNER = new TaskQueryProperty("RES.OWNER_");
    //public static final TaskQueryProperty CREATE_TIME = new TaskQueryProperty("RES.CREATE_TIME_");
    //public static final TaskQueryProperty PROCESS_INSTANCE_ID = new TaskQueryProperty("RES.PROC_INST_ID_");
    //public static final TaskQueryProperty EXECUTION_ID = new TaskQueryProperty("RES.EXECUTION_ID_");
    //public static final TaskQueryProperty PROCESS_DEFINITION_ID = new TaskQueryProperty("RES.PROC_DEF_ID_");
    //public static final TaskQueryProperty DUE_DATE = new TaskQueryProperty("RES.DUE_DATE_");
    //public static final TaskQueryProperty TENANT_ID = new TaskQueryProperty("RES.TENANT_ID_");
    //public static final TaskQueryProperty TASK_DEFINITION_KEY = new TaskQueryProperty("RES.TASK_DEF_KEY_");

    private string name;

    static Map!(string,TaskQueryProperty) properties() {
      __gshared Map!(string,TaskQueryProperty) inst;
      return initOnce!inst(new HashMap!(string,TaskQueryProperty));
    }

    static TaskQueryProperty TASK_ID() {
      __gshared TaskQueryProperty inst;
      return initOnce!inst(new TaskQueryProperty("RES.ID_"));
    }

  static TaskQueryProperty NAME() {
    __gshared TaskQueryProperty inst;
    return initOnce!inst(new TaskQueryProperty("RES.NAME_"));
  }

  static TaskQueryProperty DESCRIPTION() {
    __gshared TaskQueryProperty inst;
    return initOnce!inst(new TaskQueryProperty("RES.DESCRIPTION_"));
  }

  static TaskQueryProperty PRIORITY() {
    __gshared TaskQueryProperty inst;
    return initOnce!inst(new TaskQueryProperty("RES.PRIORITY_"));
  }

  static TaskQueryProperty ASSIGNEE() {
    __gshared TaskQueryProperty inst;
    return initOnce!inst(new TaskQueryProperty("RES.ASSIGNEE_"));
  }

  static TaskQueryProperty OWNER() {
    __gshared TaskQueryProperty inst;
    return initOnce!inst(new TaskQueryProperty("RES.OWNER_"));
  }

  static TaskQueryProperty CREATE_TIME() {
    __gshared TaskQueryProperty inst;
    return initOnce!inst(new TaskQueryProperty("RES.CREATE_TIME_"));
  }

  static TaskQueryProperty PROCESS_INSTANCE_ID() {
    __gshared TaskQueryProperty inst;
    return initOnce!inst(new TaskQueryProperty("RES.PROC_INST_ID_"));
  }

  static TaskQueryProperty EXECUTION_ID() {
    __gshared TaskQueryProperty inst;
    return initOnce!inst(new TaskQueryProperty("RES.EXECUTION_ID_"));
  }

  static TaskQueryProperty PROCESS_DEFINITION_ID() {
    __gshared TaskQueryProperty inst;
    return initOnce!inst(new TaskQueryProperty("RES.PROC_DEF_ID_"));
  }

  static TaskQueryProperty DUE_DATE() {
    __gshared TaskQueryProperty inst;
    return initOnce!inst(new TaskQueryProperty("RES.DUE_DATE_"));
  }

  static TaskQueryProperty TENANT_ID() {
    __gshared TaskQueryProperty inst;
    return initOnce!inst(new TaskQueryProperty("RES.TENANT_ID_"));
  }
  static TaskQueryProperty TASK_DEFINITION_KEY() {
    __gshared TaskQueryProperty inst;
    return initOnce!inst(new TaskQueryProperty("RES.TASK_DEF_KEY_"));
  }
    this(string name) {
        this.name = name;
        properties.put(name, this);
    }

    public string getName() {
        return name;
    }

    public static TaskQueryProperty findByName(string propertyName) {
        return properties.get(propertyName);
    }

}
