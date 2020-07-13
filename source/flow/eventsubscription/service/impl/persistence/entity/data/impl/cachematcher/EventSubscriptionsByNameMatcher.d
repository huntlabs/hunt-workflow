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
//import flow.eventsubscription.service.EventSubscriptionServiceConfiguration;
//import flow.eventsubscription.service.impl.persistence.entity.EventSubscriptionEntity;
//
///**
// * @author Joram Barrez
// */
//class EventSubscriptionsByNameMatcher extends CachedEntityMatcherAdapter<EventSubscriptionEntity> {
//
//    @Override
//    @SuppressWarnings("unchecked")
//    public boolean isRetained(EventSubscriptionEntity eventSubscriptionEntity, Object parameter) {
//
//        Map<String, String> params = (Map<String, String>) parameter;
//        String type = params.get("eventType");
//        String eventName = params.get("eventName");
//        String tenantId = params.get("tenantId");
//
//        if (eventSubscriptionEntity.getEventType() !is null && eventSubscriptionEntity.getEventType().equals(type)
//                && eventSubscriptionEntity.getEventName() !is null && eventSubscriptionEntity.getEventName().equals(eventName)) {
//            if (tenantId !is null && !tenantId.equals(EventSubscriptionServiceConfiguration.NO_TENANT_ID)) {
//                return eventSubscriptionEntity.getTenantId() !is null && eventSubscriptionEntity.getTenantId().equals(tenantId);
//            } else {
//                return EventSubscriptionServiceConfiguration.NO_TENANT_ID.equals(eventSubscriptionEntity.getTenantId()) || eventSubscriptionEntity.getTenantId() is null;
//            }
//        }
//        return false;
//    }
//
//}
