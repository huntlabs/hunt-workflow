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
//
//import flow.common.AbstractEngineConfiguration;
//import flow.event.registry.api.EventRegistryEvent;
//import flow.event.registry.api.EventRepositoryService;
//import flow.event.registry.api.InboundEventDeserializer;
//import flow.event.registry.api.InboundEventKeyDetector;
//import flow.event.registry.api.InboundEventPayloadExtractor;
//import flow.event.registry.api.InboundEventProcessingPipeline;
//import flow.event.registry.api.InboundEventTenantDetector;
//import flow.event.registry.api.InboundEventTransformer;
//import flow.event.registry.api.runtime.EventCorrelationParameterInstance;
//import flow.event.registry.api.runtime.EventInstance;
//import flow.event.registry.api.runtime.EventPayloadInstance;
//import flow.event.registry.runtime.EventInstanceImpl;
//import flow.event.registry.model.EventModel;
//
///**
// * @author Joram Barrez
// * @author Filip Hrisafov
// */
//class DefaultInboundEventProcessingPipeline<T> implements InboundEventProcessingPipeline {
//
//    protected EventRepositoryService eventRepositoryService;
//    protected InboundEventDeserializer<T> inboundEventDeserializer;
//    protected InboundEventKeyDetector<T> inboundEventKeyDetector;
//    protected InboundEventTenantDetector<T> inboundEventTenantDetector;
//    protected InboundEventPayloadExtractor<T> inboundEventPayloadExtractor;
//    protected InboundEventTransformer inboundEventTransformer;
//
//    public DefaultInboundEventProcessingPipeline(EventRepositoryService eventRepositoryService,
//            InboundEventDeserializer<T> inboundEventDeserializer,
//            InboundEventKeyDetector<T> inboundEventKeyDetector,
//            InboundEventTenantDetector<T> inboundEventTenantDetector,
//            InboundEventPayloadExtractor<T> inboundEventPayloadExtractor,
//            InboundEventTransformer inboundEventTransformer) {
//
//        this.eventRepositoryService = eventRepositoryService;
//        this.inboundEventDeserializer = inboundEventDeserializer;
//        this.inboundEventKeyDetector = inboundEventKeyDetector;
//        this.inboundEventTenantDetector = inboundEventTenantDetector;
//        this.inboundEventPayloadExtractor = inboundEventPayloadExtractor;
//        this.inboundEventTransformer = inboundEventTransformer;
//    }
//
//    @Override
//    public Collection!EventRegistryEvent run(String channelKey, String rawEvent) {
//        T event = deserialize(rawEvent);
//        String eventKey = detectEventDefinitionKey(event);
//
//        String tenantId = AbstractEngineConfiguration.NO_TENANT_ID;
//        EventModel eventModel = null;
//        if (inboundEventTenantDetector !is null) {
//            tenantId = inboundEventTenantDetector.detectTenantId(event);
//            eventModel = eventRepositoryService.getEventModelByKey(eventKey, tenantId);
//
//        } else {
//            eventModel = eventRepositoryService.getEventModelByKey(eventKey);
//
//        }
//
//        EventInstanceImpl eventInstance = new EventInstanceImpl(
//            eventModel,
//            extractCorrelationParameters(eventModel, event),
//            extractPayload(eventModel, event),
//            tenantId
//        );
//
//        return transform(eventInstance);
//    }
//
//    public T deserialize(String rawEvent) {
//        return inboundEventDeserializer.deserialize(rawEvent);
//    }
//
//    public String detectEventDefinitionKey(T event) {
//        return inboundEventKeyDetector.detectEventDefinitionKey(event);
//    }
//
//    public Collection!EventCorrelationParameterInstance extractCorrelationParameters(EventModel eventDefinition, T event) {
//        return inboundEventPayloadExtractor.extractCorrelationParameters(eventDefinition, event);
//    }
//
//    public Collection!EventPayloadInstance extractPayload(EventModel eventDefinition, T event) {
//        return inboundEventPayloadExtractor.extractPayload(eventDefinition, event);
//    }
//
//    public Collection!EventRegistryEvent transform(EventInstance eventInstance) {
//        return inboundEventTransformer.transform(eventInstance);
//    }
//
//    public InboundEventDeserializer<T> getInboundEventDeserializer() {
//        return inboundEventDeserializer;
//    }
//
//    public void setInboundEventDeserializer(InboundEventDeserializer<T> inboundEventDeserializer) {
//        this.inboundEventDeserializer = inboundEventDeserializer;
//    }
//
//    public InboundEventKeyDetector<T> getInboundEventKeyDetector() {
//        return inboundEventKeyDetector;
//    }
//    public void setInboundEventKeyDetector(InboundEventKeyDetector<T> inboundEventKeyDetector) {
//        this.inboundEventKeyDetector = inboundEventKeyDetector;
//    }
//    public InboundEventTenantDetector<T> getInboundEventTenantDetector() {
//        return inboundEventTenantDetector;
//    }
//
//    public void setInboundEventTenantDetector(InboundEventTenantDetector<T> inboundEventTenantDetector) {
//        this.inboundEventTenantDetector = inboundEventTenantDetector;
//    }
//
//    public InboundEventPayloadExtractor<T> getInboundEventPayloadExtractor() {
//        return inboundEventPayloadExtractor;
//    }
//
//    public void setInboundEventPayloadExtractor(InboundEventPayloadExtractor<T> inboundEventPayloadExtractor) {
//        this.inboundEventPayloadExtractor = inboundEventPayloadExtractor;
//    }
//
//    public InboundEventTransformer getInboundEventTransformer() {
//        return inboundEventTransformer;
//    }
//
//    public void setInboundEventTransformer(InboundEventTransformer inboundEventTransformer) {
//        this.inboundEventTransformer = inboundEventTransformer;
//    }
//}
