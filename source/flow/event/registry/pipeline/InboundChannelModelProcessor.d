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
//import hunt.collections;
//
//import org.apache.commons.lang3.StringUtils;
//import flow.common.api.FlowableException;
//import flow.common.el.VariableContainerWrapper;
//import flow.event.registry.api.ChannelModelProcessor;
//import flow.event.registry.api.EventRegistry;
//import flow.event.registry.api.EventRepositoryService;
//import flow.event.registry.api.InboundEventDeserializer;
//import flow.event.registry.api.InboundEventKeyDetector;
//import flow.event.registry.api.InboundEventPayloadExtractor;
//import flow.event.registry.api.InboundEventProcessingPipeline;
//import flow.event.registry.api.InboundEventTenantDetector;
//import flow.event.registry.api.InboundEventTransformer;
//import flow.event.registry.keydetector.InboundEventStaticKeyDetector;
//import flow.event.registry.keydetector.JsonFieldBasedInboundEventKeyDetector;
//import flow.event.registry.keydetector.JsonPointerBasedInboundEventKeyDetector;
//import flow.event.registry.keydetector.XpathBasedInboundEventKeyDetector;
//import flow.event.registry.payload.JsonFieldToMapPayloadExtractor;
//import flow.event.registry.payload.XmlElementsToMapPayloadExtractor;
//import flow.event.registry.serialization.StringToJsonDeserializer;
//import flow.event.registry.serialization.StringToXmlDocumentDeserializer;
//import flow.event.registry.tenantdetector.InboundEventStaticTenantDetector;
//import flow.event.registry.tenantdetector.JsonPointerBasedInboundEventTenantDetector;
//import flow.event.registry.tenantdetector.XpathBasedInboundEventTenantDetector;
//import flow.event.registry.transformer.DefaultInboundEventTransformer;
//import flow.event.registry.util.CommandContextUtil;
//import flow.event.registry.model.ChannelEventKeyDetection;
//import flow.event.registry.model.ChannelEventTenantIdDetection;
//import flow.event.registry.model.ChannelModel;
//import flow.event.registry.model.InboundChannelModel;
//import org.w3c.dom.Document;
//
//import com.fasterxml.jackson.databind.JsonNode;
//
///**
// * @author Filip Hrisafov
// */
//class InboundChannelModelProcessor implements ChannelModelProcessor {
//
//    @Override
//    public boolean canProcess(ChannelModel channelModel) {
//        return channelModel instanceof InboundChannelModel;
//    }
//
//    @Override
//    public void registerChannelModel(ChannelModel channelModel, String tenantId, EventRegistry eventRegistry,
//                    EventRepositoryService eventRepositoryService, boolean fallbackToDefaultTenant) {
//
//        if (channelModel instanceof InboundChannelModel) {
//            registerChannelModel((InboundChannelModel) channelModel, eventRepositoryService, fallbackToDefaultTenant);
//        }
//
//    }
//
//    protected void registerChannelModel(InboundChannelModel inboundChannelModel, EventRepositoryService eventRepositoryService, boolean fallbackToDefaultTenant) {
//        if (inboundChannelModel.getInboundEventProcessingPipeline() is null) {
//
//            InboundEventProcessingPipeline eventProcessingPipeline;
//
//            if (StringUtils.isNotEmpty(inboundChannelModel.getPipelineDelegateExpression())) {
//                eventProcessingPipeline = resolveExpression(inboundChannelModel.getPipelineDelegateExpression(), InboundEventProcessingPipeline.class);
//            } else if ("json".equals(inboundChannelModel.getDeserializerType())) {
//                eventProcessingPipeline = createJsonEventProcessingPipeline(inboundChannelModel, eventRepositoryService);
//
//            } else if ("xml".equals(inboundChannelModel.getDeserializerType())) {
//                eventProcessingPipeline = createXmlEventProcessingPipeline(inboundChannelModel, eventRepositoryService);
//
//            } else if ("expression".equals(inboundChannelModel.getDeserializerType())) {
//                eventProcessingPipeline = createExpressionEventProcessingPipeline(inboundChannelModel, eventRepositoryService);
//
//            } else {
//                eventProcessingPipeline = null;
//            }
//
//            if (eventProcessingPipeline !is null) {
//                inboundChannelModel.setInboundEventProcessingPipeline(eventProcessingPipeline);
//            }
//
//        }
//    }
//
//    protected InboundEventProcessingPipeline createJsonEventProcessingPipeline(InboundChannelModel channelModel,
//        EventRepositoryService eventRepositoryService) {
//        InboundEventDeserializer<JsonNode> eventDeserializer;
//        if (StringUtils.isEmpty(channelModel.getDeserializerDelegateExpression())) {
//            eventDeserializer = new StringToJsonDeserializer();
//        } else {
//            //noinspection unchecked
//            eventDeserializer = resolveExpression(channelModel.getDeserializerDelegateExpression(), InboundEventDeserializer.class);
//        }
//
//        InboundEventTenantDetector<JsonNode> eventTenantDetector = null; // By default no multi-tenancy is applied
//
//        InboundEventPayloadExtractor<JsonNode> eventPayloadExtractor;
//        if (StringUtils.isEmpty(channelModel.getPayloadExtractorDelegateExpression())) {
//            eventPayloadExtractor = new JsonFieldToMapPayloadExtractor();
//        } else {
//            //noinspection unchecked
//            eventPayloadExtractor = resolveExpression(channelModel.getPayloadExtractorDelegateExpression(), InboundEventPayloadExtractor.class);
//        }
//
//        InboundEventTransformer eventTransformer;
//        if (StringUtils.isEmpty(channelModel.getEventTransformerDelegateExpression())) {
//            eventTransformer = new DefaultInboundEventTransformer();
//        } else {
//            eventTransformer = resolveExpression(channelModel.getEventTransformerDelegateExpression(), InboundEventTransformer.class);
//        }
//
//        InboundEventKeyDetector<JsonNode> eventKeyDetector;
//        ChannelEventKeyDetection keyDetection = channelModel.getChannelEventKeyDetection();
//
//        if (keyDetection is null) {
//            throw new FlowableException("A channel key detection value is required");
//        }
//
//        if (StringUtils.isNotEmpty(keyDetection.getFixedValue())) {
//            eventKeyDetector = new InboundEventStaticKeyDetector<>(keyDetection.getFixedValue());
//        } else if (StringUtils.isNotEmpty(keyDetection.getJsonField())) {
//            eventKeyDetector = new JsonFieldBasedInboundEventKeyDetector(keyDetection.getJsonField());
//        } else if (StringUtils.isNotEmpty(keyDetection.getJsonPointerExpression())) {
//            eventKeyDetector = new JsonPointerBasedInboundEventKeyDetector(keyDetection.getJsonPointerExpression());
//        } else if (StringUtils.isNotEmpty(keyDetection.getDelegateExpression())) {
//            //noinspection unchecked
//            eventKeyDetector = resolveExpression(keyDetection.getDelegateExpression(), InboundEventKeyDetector.class);
//        } else {
//            throw new FlowableException(
//                "The channel json key detection value was not found for the channel model with key " + channelModel.getKey()
//                    + ". One of fixedValue, jsonField, jsonPointerExpression or delegateExpression should be set.");
//        }
//
//        ChannelEventTenantIdDetection channelEventTenantIdDetection = channelModel.getChannelEventTenantIdDetection();
//        if (channelEventTenantIdDetection !is null) {
//            if (StringUtils.isNotEmpty(channelEventTenantIdDetection.getFixedValue())) {
//                eventTenantDetector = new InboundEventStaticTenantDetector<>(channelEventTenantIdDetection.getFixedValue());
//            } else if (StringUtils.isNotEmpty(channelEventTenantIdDetection.getJsonPointerExpression())) {
//                eventTenantDetector = new JsonPointerBasedInboundEventTenantDetector(channelEventTenantIdDetection.getJsonPointerExpression());
//            } else if (StringUtils.isNotEmpty(channelEventTenantIdDetection.getDelegateExpression())) {
//                //noinspection unchecked
//                eventTenantDetector = resolveExpression(channelEventTenantIdDetection.getDelegateExpression(), InboundEventTenantDetector.class);
//            } else {
//                throw new FlowableException(
//                    "The channel json tenant detection value was not found for the channel model with key " + channelModel.getKey()
//                        + ". One of fixedValue, jsonPointerExpression, delegateExpression should be set.");
//            }
//        }
//
//        return new DefaultInboundEventProcessingPipeline<>(eventRepositoryService, eventDeserializer,
//            eventKeyDetector, eventTenantDetector, eventPayloadExtractor, eventTransformer);
//    }
//
//    protected InboundEventProcessingPipeline createXmlEventProcessingPipeline(InboundChannelModel channelModel, EventRepositoryService eventRepositoryService) {
//        InboundEventDeserializer<Document> eventDeserializer;
//        if (StringUtils.isEmpty(channelModel.getDeserializerDelegateExpression())) {
//            eventDeserializer = new StringToXmlDocumentDeserializer();
//        } else {
//            //noinspection unchecked
//            eventDeserializer = resolveExpression(channelModel.getDeserializerDelegateExpression(), InboundEventDeserializer.class);
//        }
//
//        InboundEventTenantDetector<Document> eventTenantDetector = null; // By default no multi-tenancy is applied
//
//        InboundEventPayloadExtractor<Document> eventPayloadExtractor;
//        if (StringUtils.isEmpty(channelModel.getPayloadExtractorDelegateExpression())) {
//            eventPayloadExtractor = new XmlElementsToMapPayloadExtractor();
//        } else {
//            //noinspection unchecked
//            eventPayloadExtractor = resolveExpression(channelModel.getPayloadExtractorDelegateExpression(), InboundEventPayloadExtractor.class);
//        }
//
//        InboundEventTransformer eventTransformer;
//        if (StringUtils.isEmpty(channelModel.getEventTransformerDelegateExpression())) {
//            eventTransformer = new DefaultInboundEventTransformer();
//        } else {
//            eventTransformer = resolveExpression(channelModel.getEventTransformerDelegateExpression(), InboundEventTransformer.class);
//        }
//
//        InboundEventKeyDetector<Document> eventKeyDetector;
//
//        ChannelEventKeyDetection keyDetection = channelModel.getChannelEventKeyDetection();
//        if (keyDetection is null) {
//            throw new FlowableException("A channel key detection value is required");
//        }
//
//        if (StringUtils.isNotEmpty(keyDetection.getFixedValue())) {
//            eventKeyDetector = new InboundEventStaticKeyDetector<>(keyDetection.getFixedValue());
//        } else if (StringUtils.isNotEmpty(keyDetection.getXmlXPathExpression())) {
//            eventKeyDetector = new XpathBasedInboundEventKeyDetector(keyDetection.getXmlXPathExpression());
//        } else if (StringUtils.isNotEmpty(keyDetection.getDelegateExpression())) {
//            //noinspection unchecked
//            eventKeyDetector = resolveExpression(keyDetection.getDelegateExpression(), InboundEventKeyDetector.class);
//        } else {
//            throw new FlowableException(
//                "The channel xml key detection value was not found for the channel model with key " + channelModel.getKey()
//                    + ". One of fixedValue, xmlPathExpression, delegateExpression should be set.");
//        }
//
//        ChannelEventTenantIdDetection channelEventTenantIdDetection = channelModel.getChannelEventTenantIdDetection();
//        if (channelEventTenantIdDetection !is null) {
//            if (StringUtils.isNotEmpty(channelEventTenantIdDetection.getFixedValue())) {
//                eventTenantDetector = new InboundEventStaticTenantDetector<>(channelEventTenantIdDetection.getFixedValue());
//            } else if (StringUtils.isNotEmpty(channelEventTenantIdDetection.getxPathExpression())) {
//                eventTenantDetector = new XpathBasedInboundEventTenantDetector(channelEventTenantIdDetection.getxPathExpression());
//            } else if (StringUtils.isNotEmpty(channelEventTenantIdDetection.getDelegateExpression())) {
//                //noinspection unchecked
//                eventTenantDetector = resolveExpression(channelEventTenantIdDetection.getDelegateExpression(), InboundEventTenantDetector.class);
//            } else {
//                throw new FlowableException(
//                    "The channel xml tenant detection value was not found for the channel model with key " + channelModel.getKey()
//                        + ". One of fixedValue, xPathExpression, delegateExpression should be set.");
//            }
//        }
//
//        return new DefaultInboundEventProcessingPipeline<>(eventRepositoryService, eventDeserializer,
//            eventKeyDetector, eventTenantDetector, eventPayloadExtractor, eventTransformer);
//    }
//
//    protected InboundEventProcessingPipeline createExpressionEventProcessingPipeline(InboundChannelModel channelModel,
//        EventRepositoryService eventRepositoryService) {
//        InboundEventDeserializer<?> eventDeserializer;
//        if (StringUtils.isNotEmpty(channelModel.getDeserializerDelegateExpression())) {
//            eventDeserializer = resolveExpression(channelModel.getDeserializerDelegateExpression(), InboundEventDeserializer.class);
//        } else {
//            throw new FlowableException(
//                "The channel deserializer expression for the channel model with key " + channelModel.getKey()
//                    + " was empty. The deserializerDelegateExpression has to be provided for a channel with an expression deserializer.");
//        }
//
//        InboundEventTenantDetector<?> eventTenantDetector = null; // By default no multi-tenancy is applied
//
//        InboundEventPayloadExtractor<?> eventPayloadExtractor;
//        if (StringUtils.isNotEmpty(channelModel.getPayloadExtractorDelegateExpression())) {
//            eventPayloadExtractor = resolveExpression(channelModel.getPayloadExtractorDelegateExpression(), InboundEventPayloadExtractor.class);
//        } else {
//            throw new FlowableException(
//                "The channel payload extractor expression for the channel model with key " + channelModel.getKey()
//                    + " was empty. The payloadExtractorExpression has to be provided for a channel with an expression deserializer.");
//        }
//
//        InboundEventTransformer eventTransformer;
//        if (StringUtils.isEmpty(channelModel.getEventTransformerDelegateExpression())) {
//            eventTransformer = new DefaultInboundEventTransformer();
//        } else {
//            eventTransformer = resolveExpression(channelModel.getEventTransformerDelegateExpression(), InboundEventTransformer.class);
//        }
//
//        InboundEventKeyDetector<?> eventKeyDetector;
//        ChannelEventKeyDetection keyDetection = channelModel.getChannelEventKeyDetection();
//
//        if (keyDetection is null) {
//            throw new FlowableException("A channel key detection value is required");
//        }
//
//        if (StringUtils.isNotEmpty(keyDetection.getDelegateExpression())) {
//            eventKeyDetector = resolveExpression(keyDetection.getDelegateExpression(), InboundEventKeyDetector.class);
//        } else if (StringUtils.isNotEmpty(keyDetection.getFixedValue())) {
//            eventKeyDetector = new InboundEventStaticKeyDetector<>(keyDetection.getFixedValue());
//        } else if (StringUtils.isNotEmpty(keyDetection.getJsonField())) {
//            eventKeyDetector = new JsonFieldBasedInboundEventKeyDetector(keyDetection.getJsonField());
//        } else if (StringUtils.isNotEmpty(keyDetection.getJsonPointerExpression())) {
//            eventKeyDetector = new JsonPointerBasedInboundEventKeyDetector(keyDetection.getJsonPointerExpression());
//        } else if (StringUtils.isNotEmpty(keyDetection.getXmlXPathExpression())) {
//            eventKeyDetector = new XpathBasedInboundEventKeyDetector(keyDetection.getXmlXPathExpression());
//        } else {
//            throw new FlowableException(
//                "The channel expression key detection value was not found for the channel model with key " + channelModel.getKey()
//                    + ". One of fixedValue, jsonField, jsonPointerExpression, xmlXPathExpression, delegateExpression should be set.");
//        }
//
//        ChannelEventTenantIdDetection channelEventTenantIdDetection = channelModel.getChannelEventTenantIdDetection();
//        if (channelEventTenantIdDetection !is null) {
//            if (StringUtils.isNotEmpty(channelEventTenantIdDetection.getDelegateExpression())) {
//                eventTenantDetector = resolveExpression(channelEventTenantIdDetection.getDelegateExpression(), InboundEventTenantDetector.class);
//            } else if (StringUtils.isNotEmpty(channelEventTenantIdDetection.getFixedValue())) {
//                eventTenantDetector = new InboundEventStaticTenantDetector<>(channelEventTenantIdDetection.getFixedValue());
//            } else if (StringUtils.isNotEmpty(channelEventTenantIdDetection.getJsonPointerExpression())) {
//                eventTenantDetector = new JsonPointerBasedInboundEventTenantDetector(channelEventTenantIdDetection.getJsonPointerExpression());
//            } else if (StringUtils.isNotEmpty(channelEventTenantIdDetection.getxPathExpression())) {
//                eventTenantDetector = new XpathBasedInboundEventTenantDetector(channelEventTenantIdDetection.getxPathExpression());
//            } else {
//                throw new FlowableException(
//                    "The channel expression tenant detection value was not found for the channel model with key " + channelModel.getKey()
//                        + ". One of fixedValue, jsonField, jsonPointerExpression, xmlXPathExpression, delegateExpression should be set.");
//            }
//        }
//
//        //noinspection unchecked
//        return new DefaultInboundEventProcessingPipeline(eventRepositoryService, eventDeserializer,
//            eventKeyDetector, eventTenantDetector, eventPayloadExtractor, eventTransformer);
//    }
//
//    protected <T> T resolveExpression(String expression, Class<T> type) {
//        Object value = CommandContextUtil.getEventRegistryConfiguration().getExpressionManager()
//            .createExpression(expression)
//            .getValue(new VariableContainerWrapper(Collections.emptyMap()));
//
//        if (type.isInstance(value)) {
//            return type.cast(value);
//        }
//
//        throw new FlowableException("expected expression " + expression + " to resolve to " + type + " but it did not. Resolved value is " + value);
//
//    }
//
//    @Override
//    public void unregisterChannelModel(ChannelModel channelModel, String tenantId, EventRepositoryService eventRepositoryService) {
//        // nothing to do
//    }
//}
