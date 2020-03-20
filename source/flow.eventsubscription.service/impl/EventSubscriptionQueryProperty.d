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

module flow.eventsubscription.service.impl.EventSubscriptionQueryProperty;

import flow.common.api.query.QueryProperty;
import std.concurrency : initOnce;

/**
 * @author Daniel Meyer
 */
class EventSubscriptionQueryProperty : QueryProperty {

    // properties used in event subscription queries:

    public static final EventSubscriptionQueryProperty ID = new EventSubscriptionQueryProperty("RES.ID_");
    public static final EventSubscriptionQueryProperty EXECUTION_ID = new EventSubscriptionQueryProperty("RES.EXECUTION_ID_");
    public static final EventSubscriptionQueryProperty PROCESS_INSTANCE_ID = new EventSubscriptionQueryProperty("RES.PROC_INST_ID_");
    public static final EventSubscriptionQueryProperty PROCESS_DEFINITION_ID = new EventSubscriptionQueryProperty("RES.PROC_DEF_ID_");
    public static final EventSubscriptionQueryProperty CREATED = new EventSubscriptionQueryProperty("RES.CREATED_");
    public static final EventSubscriptionQueryProperty TENANT_ID = new EventSubscriptionQueryProperty("RES.TENANT_ID_");

    // ///////////////////////////////////////////////

    static EventSubscriptionQueryProperty ID() {
      __gshared EventSubscriptionQueryProperty inst;
      return initOnce!inst(new EventSubscriptionQueryProperty("RES.ID_"));
    }

  static EventSubscriptionQueryProperty EXECUTION_ID() {
    __gshared EventSubscriptionQueryProperty inst;
    return initOnce!inst(new EventSubscriptionQueryProperty("RES.EXECUTION_ID_"));
  }

  static EventSubscriptionQueryProperty PROCESS_INSTANCE_ID() {
    __gshared EventSubscriptionQueryProperty inst;
    return initOnce!inst(new EventSubscriptionQueryProperty("RES.PROC_INST_ID_"));
  }

  static EventSubscriptionQueryProperty PROCESS_DEFINITION_ID() {
    __gshared EventSubscriptionQueryProperty inst;
    return initOnce!inst(new EventSubscriptionQueryProperty("RES.PROC_DEF_ID_"));
  }

  static EventSubscriptionQueryProperty CREATED() {
    __gshared EventSubscriptionQueryProperty inst;
    return initOnce!inst(new EventSubscriptionQueryProperty("RES.CREATED_"));
  }
  static EventSubscriptionQueryProperty TENANT_ID() {
    __gshared EventSubscriptionQueryProperty inst;
    return initOnce!inst(new EventSubscriptionQueryProperty("RES.TENANT_ID_"));
  }

    private  string propertyName;

    this(string propertyName) {
        this.propertyName = propertyName;
    }

    public string getName() {
        return propertyName;
    }

}
