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


module flow.variable.service.api.persistence.entity.VariableInstance;

import flow.variable.service.api.types.ValueFields;

/**
 * Generic variable class that can be reused for V6 and V5 engine.
 *
 * @author Tijs Rademakers
 */
interface VariableInstance : ValueFields {

    string getId();

    void setId(string id);

    void setName(string name);

    void setExecutionId(string executionId);

    void setProcessInstanceId(string processInstanceId);

    void setProcessDefinitionId(string processDefinitionId);
    string getProcessDefinitionId();

    Object getValue();

    void setValue(Object value);

    string getTypeName();

    void setTypeName(string typeName);

    void setTaskId(string taskId);

    void setScopeId(string scopeId);

    void setSubScopeId(string subScopeId);

    void setScopeType(string scopeType);

}
