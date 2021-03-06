///* Licensed under the Apache License, Version 2.0 (the "License");
// * you may not use this file except in compliance with the License.
// * You may obtain a copy of the License at
// *
// *      http://www.apache.org/licenses/LICENSE-2.0
// *
// * Unless required by applicable law or agreed to in writing, software
// * distributed under the License is distributed on an "AS IS" BASIS,
// * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// * See the License for the specific language governing permissions and
// * limitations under the License.
// */
//
//
//import hunt.collection;
//import java.util.Objects;
//
//import flow.common.persistence.cache.CachedEntity;
//import flow.common.persistence.cache.CachedEntityMatcher;
//import flow.engine.impl.persistence.entity.ActivityInstanceEntity;
//
///**
// * author martin.grofcik
// */
//class ActivityByProcessInstanceIdMatcher implements CachedEntityMatcher!ActivityInstanceEntity {
//
//    override
//    public bool isRetained(Collection!ActivityInstanceEntity databaseEntities, Collection!CachedEntity cachedEntities,
//                    ActivityInstanceEntity entity, Object param) {
//
//        string processInstanceId = (string) param;
//        return Objects.equals(entity.getProcessInstanceId(), processInstanceId);
//    }
//}
