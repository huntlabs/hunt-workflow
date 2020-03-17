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


import java.util.Map;

import flow.common.persistence.cache.CachedEntityMatcherAdapter;
import flow.variable.service.impl.persistence.entity.VariableInstanceEntity;

/**
 * @author Joram Barrez
 */
class VariableInstanceByScopeIdAndScopeTypeMatcher extends CachedEntityMatcherAdapter<VariableInstanceEntity> {

    @Override
    public boolean isRetained(VariableInstanceEntity variableInstanceEntity, Object parameter) {
        Map<String, String> map = (Map<String, String>) parameter;
        return map.get("scopeId").equals(variableInstanceEntity.getScopeId())
                && map.get("scopeType").equals(variableInstanceEntity.getScopeType());
    }

}
