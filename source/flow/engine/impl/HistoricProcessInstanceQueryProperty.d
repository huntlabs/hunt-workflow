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
module flow.engine.impl.HistoricProcessInstanceQueryProperty;


import hunt.collection.HashMap;
import hunt.collection.Map;

import flow.common.api.query.QueryProperty;
import std.concurrency : initOnce;
/**
 * Contains the possible properties which can be used in a {@link HistoricProcessInstanceQueryProperty}.
 *
 * @author Joram Barrez
 */
class HistoricProcessInstanceQueryProperty : QueryProperty {

    //private static final Map!(string, HistoricProcessInstanceQueryProperty) properties = new HashMap<>();
    //
    //public static final HistoricProcessInstanceQueryProperty PROCESS_INSTANCE_ID_ = new HistoricProcessInstanceQueryProperty("RES.PROC_INST_ID_");
    //public static final HistoricProcessInstanceQueryProperty PROCESS_DEFINITION_ID = new HistoricProcessInstanceQueryProperty("RES.PROC_DEF_ID_");
    //public static final HistoricProcessInstanceQueryProperty PROCESS_DEFINITION_KEY = new HistoricProcessInstanceQueryProperty("DEF.KEY_");
    //public static final HistoricProcessInstanceQueryProperty BUSINESS_KEY = new HistoricProcessInstanceQueryProperty("RES.BUSINESS_KEY_");
    //public static final HistoricProcessInstanceQueryProperty START_TIME = new HistoricProcessInstanceQueryProperty("RES.START_TIME_");
    //public static final HistoricProcessInstanceQueryProperty END_TIME = new HistoricProcessInstanceQueryProperty("RES.END_TIME_");
    //public static final HistoricProcessInstanceQueryProperty DURATION = new HistoricProcessInstanceQueryProperty("RES.DURATION_");
    //public static final HistoricProcessInstanceQueryProperty TENANT_ID = new HistoricProcessInstanceQueryProperty("RES.TENANT_ID_");
    //
    //public static final HistoricProcessInstanceQueryProperty INCLUDED_VARIABLE_TIME = new HistoricProcessInstanceQueryProperty("VAR.LAST_UPDATED_TIME_");

    static Map!(string,HistoricProcessInstanceQueryProperty) properties() {
      __gshared Map!(string,HistoricProcessInstanceQueryProperty) inst;
      return initOnce!inst(new HashMap!(string,HistoricProcessInstanceQueryProperty));
    }

    static HistoricProcessInstanceQueryProperty PROCESS_INSTANCE_ID_() {
      __gshared HistoricProcessInstanceQueryProperty inst;
      return initOnce!inst(new HistoricProcessInstanceQueryProperty("RES.PROC_INST_ID_"));
    }

    static HistoricProcessInstanceQueryProperty PROCESS_DEFINITION_ID() {
      __gshared HistoricProcessInstanceQueryProperty inst;
      return initOnce!inst(new HistoricProcessInstanceQueryProperty("RES.PROC_DEF_ID_"));
    }

    static HistoricProcessInstanceQueryProperty PROCESS_DEFINITION_KEY() {
      __gshared HistoricProcessInstanceQueryProperty inst;
      return initOnce!inst(new HistoricProcessInstanceQueryProperty("DEF.KEY_"));
    }

    static HistoricProcessInstanceQueryProperty BUSINESS_KEY() {
      __gshared HistoricProcessInstanceQueryProperty inst;
      return initOnce!inst(new HistoricProcessInstanceQueryProperty("RES.BUSINESS_KEY_"));
    }

    static HistoricProcessInstanceQueryProperty START_TIME() {
      __gshared HistoricProcessInstanceQueryProperty inst;
      return initOnce!inst(new HistoricProcessInstanceQueryProperty("RES.START_TIME_"));
    }

    static HistoricProcessInstanceQueryProperty END_TIME() {
      __gshared HistoricProcessInstanceQueryProperty inst;
      return initOnce!inst(new HistoricProcessInstanceQueryProperty("RES.END_TIME_"));
    }

    static HistoricProcessInstanceQueryProperty DURATION() {
      __gshared HistoricProcessInstanceQueryProperty inst;
      return initOnce!inst(new HistoricProcessInstanceQueryProperty("RES.DURATION_"));
    }

    static HistoricProcessInstanceQueryProperty TENANT_ID() {
      __gshared HistoricProcessInstanceQueryProperty inst;
      return initOnce!inst(new HistoricProcessInstanceQueryProperty("RES.TENANT_ID_"));
    }

    static HistoricProcessInstanceQueryProperty INCLUDED_VARIABLE_TIME() {
      __gshared HistoricProcessInstanceQueryProperty inst;
      return initOnce!inst(new HistoricProcessInstanceQueryProperty("VAR.LAST_UPDATED_TIME_"));
    }

    private string name;

    this(string name) {
        this.name = name;
        properties.put(name, this);
    }

    public string getName() {
        return name;
    }

    public static HistoricProcessInstanceQueryProperty findByName(string propertyName) {
        return properties.get(propertyName);
    }

}
