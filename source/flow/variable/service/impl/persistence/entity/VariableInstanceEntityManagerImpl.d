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

module flow.variable.service.impl.persistence.entity.VariableInstanceEntityManagerImpl;

import hunt.collection;
import hunt.collection.List;
import hunt.collection.Set;

import flow.common.persistence.entity.AbstractServiceEngineEntityManager;
import flow.variable.service.api.types.VariableType;
import flow.variable.service.VariableServiceConfiguration;
import flow.variable.service.impl.persistence.entity.data.VariableInstanceDataManager;
import flow.variable.service.impl.persistence.entity.VariableInstanceEntity;
import flow.variable.service.impl.persistence.entity.VariableInstanceEntityManager;
import flow.variable.service.impl.persistence.entity.VariableByteArrayRef;
/**
 * @author Tom Baeyens
 * @author Joram Barrez
 * @author Saeid Mirzaei
 */
class VariableInstanceEntityManagerImpl
    : AbstractServiceEngineEntityManager!(VariableServiceConfiguration, VariableInstanceEntity, VariableInstanceDataManager)
    , VariableInstanceEntityManager {

    this(VariableServiceConfiguration variableServiceConfiguration, VariableInstanceDataManager variableInstanceDataManager) {
        super(variableServiceConfiguration, variableInstanceDataManager);
    }


    public VariableInstanceEntity create(string name, VariableType type, Object value) {
        VariableInstanceEntity variableInstance = create(name, type);
        variableInstance.setValue(value);
        return variableInstance;
    }


    public VariableInstanceEntity create(string name, VariableType type) {
        VariableInstanceEntity variableInstance = super.create();
        variableInstance.setName(name);
        variableInstance.setType(type);
        variableInstance.setTypeName(type.getTypeName());
        return variableInstance;
    }


    public List!VariableInstanceEntity findVariableInstancesByTaskId(string taskId) {
        return dataManager.findVariableInstancesByTaskId(taskId);
    }


    public List!VariableInstanceEntity findVariableInstancesByTaskIds(Set!string taskIds) {
        return dataManager.findVariableInstancesByTaskIds(taskIds);
    }


    public List!VariableInstanceEntity findVariableInstancesByExecutionId( string executionId) {
        return dataManager.findVariableInstancesByExecutionId(executionId);
    }


    public List!VariableInstanceEntity findVariableInstancesByExecutionIds(Set!string executionIds) {
        return dataManager.findVariableInstancesByExecutionIds(executionIds);
    }


    public VariableInstanceEntity findVariableInstanceByExecutionAndName(string executionId, string variableName) {
        return dataManager.findVariableInstanceByExecutionAndName(executionId, variableName);
    }


    public List!VariableInstanceEntity findVariableInstancesByExecutionAndNames(string executionId, Collection!string names) {
        return dataManager.findVariableInstancesByExecutionAndNames(executionId, names);
    }


    public VariableInstanceEntity findVariableInstanceByTaskAndName(string taskId, string variableName) {
        return dataManager.findVariableInstanceByTaskAndName(taskId, variableName);
    }


    public List!VariableInstanceEntity findVariableInstancesByTaskAndNames(string taskId, Collection!string names) {
        return dataManager.findVariableInstancesByTaskAndNames(taskId, names);
    }


    public List!VariableInstanceEntity findVariableInstanceByScopeIdAndScopeType(string scopeId, string scopeType) {
        return dataManager.findVariableInstanceByScopeIdAndScopeType(scopeId, scopeType);
    }


    public VariableInstanceEntity findVariableInstanceByScopeIdAndScopeTypeAndName(string scopeId, string scopeType, string variableName) {
        return dataManager.findVariableInstanceByScopeIdAndScopeTypeAndName(scopeId, scopeType, variableName);
    }


    public List!VariableInstanceEntity findVariableInstancesByScopeIdAndScopeTypeAndNames(string scopeId, string scopeType, Collection!string variableNames) {
        return dataManager.findVariableInstancesByScopeIdAndScopeTypeAndNames(scopeId, scopeType, variableNames);
    }


    public List!VariableInstanceEntity findVariableInstanceBySubScopeIdAndScopeType(string subScopeId, string scopeType) {
        return dataManager.findVariableInstanceBySubScopeIdAndScopeType(subScopeId, scopeType);
    }


    public VariableInstanceEntity findVariableInstanceBySubScopeIdAndScopeTypeAndName(string subScopeId, string scopeType, string variableName) {
        return dataManager.findVariableInstanceBySubScopeIdAndScopeTypeAndName(subScopeId, scopeType, variableName);
    }


    public List!VariableInstanceEntity findVariableInstancesBySubScopeIdAndScopeTypeAndNames(string subScopeId, string scopeType, Collection!string variableNames) {
        return dataManager.findVariableInstancesBySubScopeIdAndScopeTypeAndNames(subScopeId, scopeType, variableNames);
    }

    override
    public void dele(VariableInstanceEntity entity, bool fireDeleteEvent) {
        super.dele(entity, false);
        VariableByteArrayRef byteArrayRef = entity.getByteArrayRef();
        if (byteArrayRef !is null) {
            byteArrayRef.dele();
        }
        entity.setDeleted(true);
    }


    public void deleteVariablesByTaskId(string taskId) {
        dataManager.deleteVariablesByTaskId(taskId);
    }


    public void deleteVariablesByExecutionId(string executionId) {
        dataManager.deleteVariablesByExecutionId(executionId);
    }


    public void deleteByScopeIdAndScopeType(string scopeId, string scopeType) {
        dataManager.deleteByScopeIdAndScopeType(scopeId, scopeType);
    }

}
