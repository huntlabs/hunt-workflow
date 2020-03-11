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

module flow.event.registry.DeploymentQueryProperty;

import hunt.collection.HashMap;
import hunt.collection.Map;

import flow.common.api.query.QueryProperty;
import std.concurrency : initOnce;

/**
 * Contains the possible properties that can be used in a {@link FormDeploymentQuery}.
 *
 * @author Joram Barrez
 */
class DeploymentQueryProperty : QueryProperty {

    private static  long serialVersionUID = 1L;

    //private static  Map!(string, DeploymentQueryProperty) properties  ;//= new HashMap<>();
    //
    //public static  DeploymentQueryProperty DEPLOYMENT_ID = new DeploymentQueryProperty("RES.ID_");
    //public static  DeploymentQueryProperty DEPLOYMENT_NAME = new DeploymentQueryProperty("RES.NAME_");
    //public static  DeploymentQueryProperty DEPLOYMENT_TENANT_ID = new DeploymentQueryProperty("RES.TENANT_ID_");
    //public static  DeploymentQueryProperty DEPLOY_TIME = new DeploymentQueryProperty("RES.DEPLOY_TIME_");

    static DeploymentQueryProperty DEPLOYMENT_ID() {
      __gshared DeploymentQueryProperty inst;
      return initOnce!inst(new DeploymentQueryProperty("RES.ID_"));
    }

    static DeploymentQueryProperty DEPLOYMENT_NAME() {
      __gshared DeploymentQueryProperty inst;
      return initOnce!inst(new DeploymentQueryProperty("RES.NAME_"));
    }

    static DeploymentQueryProperty DEPLOYMENT_TENANT_ID() {
      __gshared DeploymentQueryProperty inst;
      return initOnce!inst(new DeploymentQueryProperty("RES.TENANT_ID_"));
    }

    static DeploymentQueryProperty DEPLOY_TIME() {
      __gshared DeploymentQueryProperty inst;
      return initOnce!inst(new DeploymentQueryProperty("RES.DEPLOY_TIME_"));
    }

  static Map!(string, DeploymentQueryProperty) properties() {
    __gshared Map!(string, DeploymentQueryProperty) inst;
    return initOnce!inst(new HashMap!(string, DeploymentQueryProperty));
  }


  private string name;

    this(string name) {
        this.name = name;
        properties.put(name, this);
    }

    public string getName() {
        return name;
    }

    public static DeploymentQueryProperty findByName(string propertyName) {
        return properties.get(propertyName);
    }

}
