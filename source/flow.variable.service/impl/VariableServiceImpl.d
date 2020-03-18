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
module flow.variable.service.impl.VariableServiceImpl;

import hunt.collection;
import hunt.collection.List;
import hunt.collection.Set;

import flow.common.service.CommonServiceImpl;
import flow.variable.service.api.types.VariableType;
import flow.variable.service.VariableService;
import flow.variable.service.VariableServiceConfiguration;
import flow.variable.service.impl.persistence.entity.VariableInstanceEntity;
import flow.variable.service.impl.persistence.entity.VariableInstanceEntityManager;

/**
 * @author Tom Baeyens
 * @author Joram Barrez
 */
class VariableServiceImpl : CommonServiceImpl!VariableServiceConfiguration , VariableService {

    this(VariableServiceConfiguration variableServiceConfiguration) {
        super(variableServiceConfiguration);
    }


    public VariableInstanceEntity getVariableInstance(string id) {
        return getVariableInstanceEntityManager().findById(id);
    }


    public List!VariableInstanceEntity findVariableInstancesByTaskId(string taskId) {
        return getVariableInstanceEntityManager().findVariableInstancesByTaskId(taskId);
    }


    public List!VariableInstanceEntity findVariableInstancesByTaskIds(Set!string taskIds) {
        return getVariableInstanceEntityManager().findVariableInstancesByTaskIds(taskIds);
    }


    public List!VariableInstanceEntity findVariableInstancesByExecutionId(string executionId) {
        return getVariableInstanceEntityManager().findVariableInstancesByExecutionId(executionId);
    }


    public List!VariableInstanceEntity findVariableInstancesByExecutionIds(Set!string executionIds) {
        return getVariableInstanceEntityManager().findVariableInstancesByExecutionIds(executionIds);
    }


    public VariableInstanceEntity findVariableInstanceByTaskAndName(string taskId, string taskName) {
        return getVariableInstanceEntityManager().findVariableInstanceByTaskAndName(taskId, taskName);
    }


    public List!VariableInstanceEntity findVariableInstancesByTaskAndNames(string taskId, Collection!string taskNames) {
        return getVariableInstanceEntityManager().findVariableInstancesByTaskAndNames(taskId, taskNames);
    }


    public VariableInstanceEntity findVariableInstanceByExecutionAndName(string executionId, string taskName) {
        return getVariableInstanceEntityManager().findVariableInstanceByExecutionAndName(executionId, taskName);
    }


    public List!VariableInstanceEntity findVariableInstancesByExecutionAndNames(string executionId, Collection!string taskNames) {
        return getVariableInstanceEntityManager().findVariableInstancesByExecutionAndNames(executionId, taskNames);
    }


    public List!VariableInstanceEntity findVariableInstanceByScopeIdAndScopeType(string scopeId, string scopeType) {
        return getVariableInstanceEntityManager().findVariableInstanceByScopeIdAndScopeType(scopeId, scopeType);
    }


    public VariableInstanceEntity findVariableInstanceByScopeIdAndScopeTypeAndName(string scopeId, string scopeType, string variableName) {
        return getVariableInstanceEntityManager().findVariableInstanceByScopeIdAndScopeTypeAndName(scopeId, scopeType, variableName);
    }


    public List!VariableInstanceEntity findVariableInstancesByScopeIdAndScopeTypeAndNames(string scopeId, string scopeType, Collection!string variableNames) {
        return getVariableInstanceEntityManager().findVariableInstancesByScopeIdAndScopeTypeAndNames(scopeId, scopeType, variableNames);
    }


    public List!VariableInstanceEntity findVariableInstanceBySubScopeIdAndScopeType(string subScopeId, string scopeType) {
        return getVariableInstanceEntityManager().findVariableInstanceBySubScopeIdAndScopeType(subScopeId, scopeType);
    }


    public VariableInstanceEntity findVariableInstanceBySubScopeIdAndScopeTypeAndName(string subScopeId, string scopeType, string variableName) {
        return getVariableInstanceEntityManager().findVariableInstanceBySubScopeIdAndScopeTypeAndName(subScopeId, scopeType, variableName);
    }


    public List!VariableInstanceEntity findVariableInstancesBySubScopeIdAndScopeTypeAndNames(string subScopeId, string scopeType, Collection!string variableNames) {
        return getVariableInstanceEntityManager().findVariableInstancesBySubScopeIdAndScopeTypeAndNames(subScopeId, scopeType, variableNames);
    }


    public VariableInstanceEntity createVariableInstance(string name, VariableType type, Object value) {
        return getVariableInstanceEntityManager().create(name, type, value);
    }


    public VariableInstanceEntity createVariableInstance(string name, VariableType type) {
        return getVariableInstanceEntityManager().create(name, type);
    }


    public void insertVariableInstance(VariableInstanceEntity variable) {
        getVariableInstanceEntityManager().insert(variable);
    }


    public void updateVariableInstance(VariableInstanceEntity variableInstance) {
        getVariableInstanceEntityManager().update(variableInstance, true);
    }


    public void deleteVariableInstance(VariableInstanceEntity variable) {
        getVariableInstanceEntityManager().dele(variable);
    }


    public void deleteVariablesByExecutionId(string executionId) {
        getVariableInstanceEntityManager().deleteVariablesByExecutionId(executionId);
    }


    public void deleteVariablesByTaskId(string taskId) {
        getVariableInstanceEntityManager().deleteVariablesByTaskId(taskId);
    }

    public VariableInstanceEntityManager getVariableInstanceEntityManager() {
        return configuration.getVariableInstanceEntityManager();
    }

}
