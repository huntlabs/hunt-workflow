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
//import flow.eventsubscription.service.impl.persistence.entity.EventSubscriptionEntity;
//import flow.eventsubscription.service.impl.persistence.entity.MessageEventSubscriptionEntity;
//
///**
// * @author Joram Barrez
// */
//class MessageEventSubscriptionsByProcInstAndEventNameMatcher extends CachedEntityMatcherAdapter<EventSubscriptionEntity> {
//
//    @Override
//    public boolean isRetained(EventSubscriptionEntity eventSubscriptionEntity, Object param) {
//        Map<String, String> paramMap = (Map<String, String>) param;
//        String processInstanceId = paramMap.get("processInstanceId");
//        String eventName = paramMap.get("eventName");
//
//        return eventSubscriptionEntity.getEventType() !is null && eventSubscriptionEntity.getEventType().equals(MessageEventSubscriptionEntity.EVENT_TYPE)
//                && eventSubscriptionEntity.getEventName() !is null && eventSubscriptionEntity.getEventName().equals(eventName)
//                && eventSubscriptionEntity.getProcessInstanceId() !is null && eventSubscriptionEntity.getProcessInstanceId().equals(processInstanceId);
//    }
//
//}