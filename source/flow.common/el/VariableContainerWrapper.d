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

module flow.common.el.VariableContainerWrapper;

import hunt.collection.Map;
import hunt.Exceptions;
import flow.common.api.variable.VariableContainer;
/**
 * @author Joram Barrez
 */
class VariableContainerWrapper : VariableContainer {

    protected Map!(string, Object) variables;
    protected string instanceId;
    protected string scopeType;
    protected string tenantId;

    this(Map!(string, Object) variables) {
        this.variables = variables;
    }


    public bool hasVariable(string variableName) {
        return variables.containsKey(variableName);
    }


    public Object getVariable(string variableName) {
        return variables.get(variableName);
    }


    public void setVariable(string variableName, Object variableValue) {
        variables.put(variableName, variableValue);
    }


    public void setTransientVariable(string variableName, Object variableValue) {
       // throw new UnsupportedOperationException();
        implementationMissing(false);
    }

    public string getInstanceId() {
        return instanceId;
    }

    public void setInstanceId(string instanceId) {
        this.instanceId = instanceId;
    }

    public string getScopeType() {
        return scopeType;
    }

    public void setScopeType(string scopeType) {
        this.scopeType = scopeType;
    }


    public string getTenantId() {
        return tenantId;
    }

    public void setTenantId(string tenantId) {
        this.tenantId = tenantId;
    }
}
