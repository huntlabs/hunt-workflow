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
module flow.variable.service.impl.persistence.entity.VariableInstanceEntityManager;

import hunt.collection;
import hunt.collection.List;
import hunt.collection.Set;

import flow.common.persistence.entity.EntityManager;
import flow.variable.service.api.types.VariableType;
import flow.variable.service.impl.persistence.entity.VariableInstanceEntity;

/**
 * @author Joram Barrez
 */
interface VariableInstanceEntityManager : EntityManager!VariableInstanceEntity {

    VariableInstanceEntity create(string name, VariableType type, Object value);

    /**
     * Create a variable instance without setting the value on it.
     * <b>IMPORTANT:</b> If you use this method you would have to call {@link VariableInstanceEntity#setValue(Object)}
     * for setting the value
     * @param name the name of the variable to create
     * @param type the type of the creted variable
     *
     * @return the {@link VariableInstanceEntity} to be used
     */
    VariableInstanceEntity create(string name, VariableType type);

    List!VariableInstanceEntity findVariableInstancesByTaskId(string taskId);

    List!VariableInstanceEntity findVariableInstancesByTaskIds(Set!string taskIds);

    List!VariableInstanceEntity findVariableInstancesByExecutionId(string executionId);

    List!VariableInstanceEntity findVariableInstancesByExecutionIds(Set!string executionIds);

    VariableInstanceEntity findVariableInstanceByExecutionAndName(string executionId, string variableName);

    List!VariableInstanceEntity findVariableInstancesByExecutionAndNames(string executionId, Collection!string names);

    VariableInstanceEntity findVariableInstanceByTaskAndName(string taskId, string variableName);

    List!VariableInstanceEntity findVariableInstancesByTaskAndNames(string taskId, Collection!string names);

    List!VariableInstanceEntity findVariableInstanceByScopeIdAndScopeType(string scopeId, string scopeType);

    VariableInstanceEntity findVariableInstanceByScopeIdAndScopeTypeAndName(string scopeId, string scopeType, string variableName);

    List!VariableInstanceEntity findVariableInstancesByScopeIdAndScopeTypeAndNames(string scopeId, string scopeType, Collection!string variableNames);

    List!VariableInstanceEntity findVariableInstanceBySubScopeIdAndScopeType(string subScopeId, string scopeType);

    VariableInstanceEntity findVariableInstanceBySubScopeIdAndScopeTypeAndName(string subScopeId, string scopeType, string variableName);

    List!VariableInstanceEntity findVariableInstancesBySubScopeIdAndScopeTypeAndNames(string subScopeId, string scopeType, Collection!string variableNames);

    void deleteVariablesByTaskId(string taskId);

    void deleteVariablesByExecutionId(string executionId);

    void deleteByScopeIdAndScopeType(string scopeId, string scopeType);

}
