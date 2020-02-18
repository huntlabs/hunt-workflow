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
import org.flowable.job.service.impl.persistence.entity.TimerJobEntity;

/**
 * @author Joram Barrez
 */
class TimerJobsByScopeIdAndSubScopeIdMatcher extends CachedEntityMatcherAdapter<TimerJobEntity> {

    @Override
    public bool isRetained(TimerJobEntity timerJobEntity, Object param) {
        Map<string, string> paramMap = (Map<string, string>) param;
        string scopeId = paramMap.get("scopeId");
        string subScopeId = paramMap.get("subScopeId");
        return timerJobEntity.getScopeId() !is null && timerJobEntity.getScopeId().equals(scopeId)
            && timerJobEntity.getSubScopeId() !is null && timerJobEntity.getSubScopeId().equals(subScopeId);
    }

}