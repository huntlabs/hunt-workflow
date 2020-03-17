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
module flow.batch.service.impl.BatchQueryProperty;


import hunt.collection.HashMap;
import hunt.collection.Map;

import flow.batch.service.api.BatchQuery;
import flow.common.api.query.QueryProperty;
import std.concurrency : initOnce;
/**
 * Contains the possible properties that can be used in a {@link BatchQuery}.
 */
class BatchQueryProperty : QueryProperty {


    //private static final Map<string, BatchQueryProperty> properties = new HashMap<>();

    //public static final BatchQueryProperty BATCH_ID = new BatchQueryProperty("RES.ID_");
    //public static final BatchQueryProperty CREATETIME = new BatchQueryProperty("RES.CREATE_TIME_");
    //public static final BatchQueryProperty TENANT_ID = new BatchQueryProperty("RES.TENANT_ID_");

    private string name;


    static Map!(string,BatchQueryProperty) properties() {
      __gshared Map!(string,BatchQueryProperty) inst;
      return initOnce!inst(new HashMap!(string,BatchQueryProperty));
    }

    static BatchQueryProperty BATCH_ID() {
      __gshared BatchQueryProperty inst;
      return initOnce!inst(new BatchQueryProperty("RES.ID_"));
    }

    static BatchQueryProperty CREATETIME() {
      __gshared BatchQueryProperty inst;
      return initOnce!inst(new BatchQueryProperty("RES.CREATE_TIME_"));
    }
    static BatchQueryProperty TENANT_ID() {
      __gshared BatchQueryProperty inst;
      return initOnce!inst(new BatchQueryProperty("RES.TENANT_ID_"));
    }

    this(string name) {
        this.name = name;
        properties.put(name, this);
    }

    public string getName() {
        return name;
    }

    public static BatchQueryProperty findByName(string propertyName) {
        return properties.get(propertyName);
    }

}
