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

module flow.variable.service.impl.HistoricVariableInstanceQueryProperty;

import hunt.collection.HashMap;
import hunt.collection.Map;

import flow.common.api.query.QueryProperty;
import flow.variable.service.api.history.HistoricVariableInstanceQuery;
import std.concurrency : initOnce;
/**
 * Contains the possible properties which can be used in a {@link HistoricVariableInstanceQuery}.
 *
 * @author Tijs Rademakers
 */
class HistoricVariableInstanceQueryProperty : QueryProperty {


   // private static final Map<string, HistoricVariableInstanceQueryProperty> properties = new HashMap<>();

    //public static final HistoricVariableInstanceQueryProperty PROCESS_INSTANCE_ID = new HistoricVariableInstanceQueryProperty("PROC_INST_ID_");
    //public static final HistoricVariableInstanceQueryProperty SCOPE_ID = new HistoricVariableInstanceQueryProperty("SCOPE_ID_");
    //public static final HistoricVariableInstanceQueryProperty VARIABLE_NAME = new HistoricVariableInstanceQueryProperty("NAME_");

    private string name;


     static Map!(string, HistoricVariableInstanceQueryProperty)  properties() {
       __gshared Map!(string, HistoricVariableInstanceQueryProperty)  inst;
       return initOnce!inst(new HashMap!(string, HistoricVariableInstanceQueryProperty));
     }

    static HistoricVariableInstanceQueryProperty  PROCESS_INSTANCE_ID() {
      __gshared HistoricVariableInstanceQueryProperty  inst;
      return initOnce!inst(new HistoricVariableInstanceQueryProperty("PROC_INST_ID_"));
    }

  static HistoricVariableInstanceQueryProperty  SCOPE_ID() {
    __gshared HistoricVariableInstanceQueryProperty  inst;
    return initOnce!inst(new HistoricVariableInstanceQueryProperty("SCOPE_ID_"));
  }

  static HistoricVariableInstanceQueryProperty  VARIABLE_NAME() {
    __gshared HistoricVariableInstanceQueryProperty  inst;
    return initOnce!inst(new HistoricVariableInstanceQueryProperty("NAME_"));
  }

    this(string name) {
        this.name = name;
        properties.put(name, this);
    }

    public string getName() {
        return name;
    }

    public static HistoricVariableInstanceQueryProperty findByName(string propertyName) {
        return properties.get(propertyName);
    }
}
