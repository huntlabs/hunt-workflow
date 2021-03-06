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
//import flow.engine.impl.persistence.entity.ExecutionEntity;
//
///**
// * @author Joram Barrez
// */
//class InactiveExecutionsByProcInstMatcher : CachedEntityMatcherAdapter!ExecutionEntity {
//
//    override
//    public bool isRetained(ExecutionEntity executionEntity, Object parameter) {
//        Map!(string, Object) paramMap = (Map!(string, Object)) parameter;
//        string processInstanceId = (string) paramMap.get("processInstanceId");
//
//        return executionEntity.getProcessInstanceId() !is null
//                && executionEntity.getProcessInstanceId().equals(processInstanceId)
//                && !executionEntity.isActive();
//    }
//
//}
