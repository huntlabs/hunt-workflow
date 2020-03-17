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


import hunt.collection;
import java.util.Map;

import flow.common.persistence.cache.CachedEntityMatcherAdapter;
import flow.variable.service.impl.persistence.entity.VariableInstanceEntity;

/**
 * @author Joram Barrez
 */
class VariableInstanceBySubScopeIdAndScopeTypeAndVariableNamesMatcher extends CachedEntityMatcherAdapter<VariableInstanceEntity> {

    @Override
    public boolean isRetained(VariableInstanceEntity variableInstanceEntity, Object parameter) {
        Map<String, Object> map = (Map<String, Object>) parameter;
        Collection<String> variableNames = (Collection<String>) map.get("variableNames");
        return map.get("subScopeId").equals(variableInstanceEntity.getSubScopeId())
                && map.get("scopeType").equals(variableInstanceEntity.getScopeType())
                && variableNames.contains(variableInstanceEntity.getName());
    }

}
