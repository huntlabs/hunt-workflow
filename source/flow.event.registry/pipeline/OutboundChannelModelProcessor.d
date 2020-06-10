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
//import flow.event.registry.api.OutboundEventProcessingPipeline;
//import flow.event.registry.api.OutboundEventSerializer;
//import flow.event.registry.serialization.EventPayloadToJsonStringSerializer;
//import flow.event.registry.serialization.EventPayloadToXmlStringSerializer;
//import flow.event.registry.util.CommandContextUtil;
//import flow.event.registry.model.ChannelModel;
//import flow.event.registry.model.OutboundChannelModel;
//
///**
// * @author Filip Hrisafov
// */
//class OutboundChannelModelProcessor implements ChannelModelProcessor {
//
//    @Override
//    public boolean canProcess(ChannelModel channelModel) {
//        return channelModel instanceof OutboundChannelModel;
//    }
//
//    @Override
//    public void registerChannelModel(ChannelModel channelModel, String tenantId, EventRegistry eventRegistry,
//                    EventRepositoryService eventRepositoryService, boolean fallbackToDefaultTenant) {
//
//        if (channelModel instanceof OutboundChannelModel) {
//            registerChannelModel((OutboundChannelModel) channelModel);
//        }
//
//    }
//
//    protected void registerChannelModel(OutboundChannelModel inboundChannelModel) {
//        if (inboundChannelModel.getOutboundEventProcessingPipeline() is null) {
//
//            OutboundEventProcessingPipeline eventProcessingPipeline;
//
//            if (StringUtils.isNotEmpty(inboundChannelModel.getPipelineDelegateExpression())) {
//                eventProcessingPipeline = resolveExpression(inboundChannelModel.getPipelineDelegateExpression(), OutboundEventProcessingPipeline.class);
//            } else if ("json".equals(inboundChannelModel.getSerializerType())) {
//                OutboundEventSerializer eventSerializer = new EventPayloadToJsonStringSerializer();
//                eventProcessingPipeline = new DefaultOutboundEventProcessingPipeline(eventSerializer);
//
//            } else if ("xml".equals(inboundChannelModel.getSerializerType())) {
//                OutboundEventSerializer eventSerializer = new EventPayloadToXmlStringSerializer();
//                eventProcessingPipeline = new DefaultOutboundEventProcessingPipeline(eventSerializer);
//
//            } else if ("expression".equals(inboundChannelModel.getSerializerType())) {
//                if (StringUtils.isNotEmpty(inboundChannelModel.getSerializerDelegateExpression())) {
//                    OutboundEventSerializer outboundEventSerializer = resolveExpression(inboundChannelModel.getSerializerDelegateExpression(),
//                        OutboundEventSerializer.class);
//                    eventProcessingPipeline = new DefaultOutboundEventProcessingPipeline(outboundEventSerializer);
//                } else {
//                    throw new FlowableException(
//                        "The channel key " + inboundChannelModel.getKey()
//                            + " is using expression deserialization, but pipelineDelegateExpression was not set.");
//                }
//            }  else {
//                eventProcessingPipeline = null;
//            }
//
//            if (eventProcessingPipeline !is null) {
//                inboundChannelModel.setOutboundEventProcessingPipeline(eventProcessingPipeline);
//            }
//
//        }
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
//    }
//
//    @Override
//    public void unregisterChannelModel(ChannelModel channelModel, String tenantId, EventRepositoryService eventRepositoryService) {
//        // nothing to do
//    }
//}
