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
//import hunt.collection.Map;
//
//import flow.common.persistence.cache.CachedEntityMatcherAdapter;
//import flow.engine.impl.persistence.entity.ActivityInstanceEntity;
//
///**
// * @author martin.grofcik
// */
//class UnfinishedActivityInstanceMatcher : CachedEntityMatcherAdapter!ActivityInstanceEntity {
//
//    override
//    public bool isRetained(ActivityInstanceEntity entity, Object parameter) {
//        Map!(string, string) paramMap = (Map!(string, string)) parameter;
//        string executionId = paramMap.get("executionId");
//        string activityId = paramMap.get("activityId");
//
//        return entity.getExecutionId() !is null && entity.getExecutionId().equals(executionId)
//                && entity.getActivityId() !is null && entity.getActivityId().equals(activityId)
//                && entity.getEndTime() is null;
//    }
//
//}
