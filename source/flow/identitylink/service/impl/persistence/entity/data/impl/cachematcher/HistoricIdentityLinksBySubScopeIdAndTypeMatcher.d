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
//import flow.identitylink.service.impl.persistence.entity.HistoricIdentityLinkEntity;
//
///**
// * @author Tijs Rademakers
// */
//class HistoricIdentityLinksBySubScopeIdAndTypeMatcher extends CachedEntityMatcherAdapter<HistoricIdentityLinkEntity> {
//
//    @Override
//    public boolean isRetained(HistoricIdentityLinkEntity historicIdentityLinkEntity, Object parameter) {
//        @SuppressWarnings("unchecked")
//        Map<String, String> parameterMap = (Map<String, String>) parameter;
//        return historicIdentityLinkEntity.getSubScopeId() !is null && historicIdentityLinkEntity.getSubScopeId().equals(parameterMap.get("subScopeId")) &&
//                        historicIdentityLinkEntity.getScopeType() !is null && historicIdentityLinkEntity.getScopeType().equals(parameterMap.get("scopeType"));
//    }
//
//}
