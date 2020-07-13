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
module flow.engine.impl.HistoricDetailQueryProperty;


import hunt.collection.HashMap;
import hunt.collection.Map;

import flow.common.api.query.QueryProperty;
import flow.engine.history.HistoricDetailQuery;
import std.concurrency : initOnce;
/**
 * Contains the possible properties which can be used in a {@link HistoricDetailQuery}.
 *
 * @author Tom Baeyens
 */
class HistoricDetailQueryProperty : QueryProperty {


    //private static final Map!(string, HistoricDetailQueryProperty) properties = new HashMap<>();
    //
    //public static final HistoricDetailQueryProperty PROCESS_INSTANCE_ID = new HistoricDetailQueryProperty("PROC_INST_ID_");
    //public static final HistoricDetailQueryProperty VARIABLE_NAME = new HistoricDetailQueryProperty("NAME_");
    //public static final HistoricDetailQueryProperty VARIABLE_TYPE = new HistoricDetailQueryProperty("TYPE_");
    //public static final HistoricDetailQueryProperty VARIABLE_REVISION = new HistoricDetailQueryProperty("REV_");
    //public static final HistoricDetailQueryProperty TIME = new HistoricDetailQueryProperty("TIME_");


   static Map!(string,HistoricDetailQueryProperty) properties() {
     __gshared Map!(string,HistoricDetailQueryProperty) inst;
     return initOnce!inst(new HashMap!(string,HistoricDetailQueryProperty));
   }

    static HistoricDetailQueryProperty PROCESS_INSTANCE_ID() {
      __gshared HistoricDetailQueryProperty inst;
      return initOnce!inst(new HistoricDetailQueryProperty("PROC_INST_ID_"));
    }

    static HistoricDetailQueryProperty VARIABLE_NAME() {
      __gshared HistoricDetailQueryProperty inst;
      return initOnce!inst(new HistoricDetailQueryProperty("NAME_"));
    }

    static HistoricDetailQueryProperty VARIABLE_TYPE() {
      __gshared HistoricDetailQueryProperty inst;
      return initOnce!inst(new HistoricDetailQueryProperty("TYPE_"));
    }

    static HistoricDetailQueryProperty VARIABLE_REVISION() {
      __gshared HistoricDetailQueryProperty inst;
      return initOnce!inst(new HistoricDetailQueryProperty("REV_"));
    }

    static HistoricDetailQueryProperty TIME() {
      __gshared HistoricDetailQueryProperty inst;
      return initOnce!inst(new HistoricDetailQueryProperty("TIME_"));
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

    public static HistoricDetailQueryProperty findByName(string propertyName) {
        return properties.get(propertyName);
    }
}
