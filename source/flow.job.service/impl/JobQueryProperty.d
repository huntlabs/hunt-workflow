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

module flow.job.service.impl.JobQueryProperty;

import hunt.collection.HashMap;
import hunt.collection.Map;

import flow.common.api.query.QueryProperty;
import flow.job.service.api.JobQuery;
import std.concurrency : initOnce;

/**
 * Contains the possible properties that can be used in a {@link JobQuery}.
 *
 * @author Joram Barrez
 */
class JobQueryProperty : QueryProperty {


    //private static  Map!(string, JobQueryProperty) properties ;// = new HashMap<>();

    //public static  JobQueryProperty JOB_ID = new JobQueryProperty("ID_");
    //public static  JobQueryProperty PROCESS_INSTANCE_ID = new JobQueryProperty("RES.PROCESS_INSTANCE_ID_");
    //public static  JobQueryProperty EXECUTION_ID = new JobQueryProperty("RES.EXECUTION_ID_");
    //public static  JobQueryProperty DUEDATE = new JobQueryProperty("RES.DUEDATE_");
    //public static  JobQueryProperty RETRIES = new JobQueryProperty("RES.RETRIES_");
    //public static  JobQueryProperty TENANT_ID = new JobQueryProperty("RES.TENANT_ID_");

  static Map!(string,JobQueryProperty) properties() {
    __gshared Map!(string,JobQueryProperty) inst;
    return initOnce!inst(new HashMap!(string,JobQueryProperty));
  }
  static JobQueryProperty JOB_ID() {
    __gshared JobQueryProperty inst;
    return initOnce!inst(new JobQueryProperty("ID_"));
  }
  static JobQueryProperty PROCESS_INSTANCE_ID() {
    __gshared JobQueryProperty inst;
    return initOnce!inst(new JobQueryProperty("RES.PROCESS_INSTANCE_ID_"));
  }
  static JobQueryProperty EXECUTION_ID() {
    __gshared JobQueryProperty inst;
    return initOnce!inst(new JobQueryProperty("RES.EXECUTION_ID_"));
  }
  static JobQueryProperty DUEDATE() {
    __gshared JobQueryProperty inst;
    return initOnce!inst(new JobQueryProperty("RES.DUEDATE_"));
  }
  static JobQueryProperty RETRIES() {
    __gshared JobQueryProperty inst;
    return initOnce!inst(new JobQueryProperty("RES.RETRIES_"));
  }
  static JobQueryProperty TENANT_ID() {
    __gshared JobQueryProperty inst;
    return initOnce!inst(new JobQueryProperty("RES.TENANT_ID_"));
  }
    private string name;

    this(string name) {
        this.name = name;
        properties.put(name, this);
    }

    public string getName() {
        return name;
    }

    public static JobQueryProperty findByName(string propertyName) {
        return properties.get(propertyName);
    }

}
