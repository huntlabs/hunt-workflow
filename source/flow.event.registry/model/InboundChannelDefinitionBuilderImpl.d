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
//module flow.event.registry.model.InboundChannelDefinitionBuilderImpl;
//
//import hunt.collection.LinkedHashSet;
//import hunt.collection.Set;
//
//import flow.event.registry.api.EventDeployment;
//import flow.event.registry.api.EventRepositoryService;
//import flow.event.registry.api.model.InboundChannelModelBuilder;
////import flow.event.registry.json.converter.ChannelJsonConverter;
//import flow.event.registry.model.ChannelEventKeyDetection;
//import flow.event.registry.model.ChannelEventTenantIdDetection;
//import flow.event.registry.model.ChannelModel;
//import flow.event.registry.model.DelegateExpressionInboundChannelModel;
//import flow.event.registry.model.InboundChannelModel;
//import flow.event.registry.model.JmsInboundChannelModel;
//import flow.event.registry.model.KafkaInboundChannelModel;
//import flow.event.registry.model.RabbitInboundChannelModel;
////import org.w3c.dom.Document;
//
////import com.fasterxml.jackson.databind.JsonNode;
//
///**
// * @author Joram Barrez
// * @author Filip Hrisafov
// */
//class InboundChannelDefinitionBuilderImpl : InboundChannelModelBuilder {
//
//    protected EventRepositoryService eventRepository;
//
//    protected InboundChannelModel channelModel;
//    protected string deploymentName;
//    protected string resourceName;
//    protected string category;
//    protected string parentDeploymentId;
//    protected string deploymentTenantId;
//    protected string key;
//    protected InboundEventProcessingPipelineBuilder inboundEventProcessingPipelineBuilder;
//
//    this(EventRepositoryService eventRepository) {
//        this.eventRepository = eventRepository;
//    }
//
//
//    public InboundChannelModelBuilder key(string key) {
//        this.key = key;
//        return this;
//    }
//
//
//    public InboundChannelModelBuilder deploymentName(string deploymentName) {
//        this.deploymentName = deploymentName;
//        return this;
//    }
//
//
//    public InboundChannelModelBuilder resourceName(string resourceName) {
//        this.resourceName = resourceName;
//        return this;
//    }
//
//
//    public InboundChannelModelBuilder category(string category) {
//        this.category = category;
//        return this;
//    }
//
//
//    public InboundChannelModelBuilder parentDeploymentId(string parentDeploymentId) {
//        this.parentDeploymentId = parentDeploymentId;
//        return this;
//    }
//
//
//    public InboundChannelModelBuilder deploymentTenantId(string deploymentTenantId) {
//        this.deploymentTenantId = deploymentTenantId;
//        return this;
//    }
//
//
//    public InboundEventProcessingPipelineBuilder channelAdapter(string delegateExpression) {
//        DelegateExpressionInboundChannelModel channelModel = new DelegateExpressionInboundChannelModel();
//        channelModel.setAdapterDelegateExpression(delegateExpression);
//        this.channelModel = channelModel;
//        this.inboundEventProcessingPipelineBuilder = new InboundEventProcessingPipelineBuilderImpl<>(channelModel, eventRepository, this);
//        return this.inboundEventProcessingPipelineBuilder;
//    }
//
//
//    public InboundJmsChannelBuilder jmsChannelAdapter(string destinationName) {
//        JmsInboundChannelModel channelModel = new JmsInboundChannelModel();
//        channelModel.setDestination(destinationName);
//        this.channelModel = channelModel;
//        this.channelModel.setKey(key);
//        return new InboundJmsChannelBuilderImpl(channelModel, eventRepository, this);
//    }
//
//
//    public InboundRabbitChannelBuilder rabbitChannelAdapter(string queueName) {
//        RabbitInboundChannelModel channelModel = new RabbitInboundChannelModel();
//        Set!string queues = new LinkedHashSet<>();
//        queues.add(queueName);
//        channelModel.setQueues(queues);
//        this.channelModel = channelModel;
//        this.channelModel.setKey(key);
//        return new InboundRabbitChannelBuilderImpl(channelModel, eventRepository, this);
//    }
//
//
//    public InboundKafkaChannelBuilder kafkaChannelAdapter(string topic) {
//        KafkaInboundChannelModel channelModel = new KafkaInboundChannelModel();
//        Set!string topics = new LinkedHashSet<>();
//        topics.add(topic);
//        channelModel.setTopics(topics);
//        this.channelModel = channelModel;
//        this.channelModel.setKey(key);
//        return new InboundKafkaChannelBuilderImpl(channelModel, eventRepository, this);
//    }
//
//
//    public EventDeployment deploy() {
//        if (resourceName is null) {
//            resourceName = "inbound-" ~ key ~ ".channel";
//        }
//
//        ChannelModel channelModel = buildChannelModel();
//
//        EventDeployment eventDeployment = eventRepository.createDeployment()
//            .name(deploymentName)
//            .addChannelDefinition(resourceName, new ChannelJsonConverter().convertToJson(channelModel))
//            .category(category)
//            .parentDeploymentId(parentDeploymentId)
//            .tenantId(deploymentTenantId)
//            .deploy();
//
//        return eventDeployment;
//    }
//
//    protected ChannelModel buildChannelModel() {
//        if (this.channelModel is null) {
//            channelModel = new InboundChannelModel();
//        }
//
//        channelModel.setKey(key);
//
//        return channelModel;
//    }
//
//    class InboundJmsChannelBuilderImpl : InboundJmsChannelBuilder {
//
//        protected  EventRepositoryService eventRepositoryService;
//        protected  InboundChannelDefinitionBuilderImpl channelDefinitionBuilder;
//
//        protected JmsInboundChannelModel jmsChannel;
//
//        this(JmsInboundChannelModel jmsChannel, EventRepositoryService eventRepositoryService,
//                        InboundChannelDefinitionBuilderImpl channelDefinitionBuilder) {
//
//            this.jmsChannel = jmsChannel;
//            this.eventRepositoryService = eventRepositoryService;
//            this.channelDefinitionBuilder = channelDefinitionBuilder;
//        }
//
//
//        public InboundJmsChannelBuilder selector(string selector) {
//            jmsChannel.setSelector(selector);
//            return this;
//        }
//
//
//        public InboundJmsChannelBuilder subscription(string subscription) {
//            jmsChannel.setSubscription(subscription);
//            return this;
//        }
//
//
//        public InboundJmsChannelBuilder concurrency(string concurrency) {
//            jmsChannel.setConcurrency(concurrency);
//            return this;
//        }
//
//
//        public InboundEventProcessingPipelineBuilder eventProcessingPipeline() {
//            channelDefinitionBuilder.inboundEventProcessingPipelineBuilder = new InboundEventProcessingPipelineBuilderImpl<>(jmsChannel,
//                            eventRepositoryService, channelDefinitionBuilder);
//            return channelDefinitionBuilder.inboundEventProcessingPipelineBuilder;
//        }
//    }
//
//    class InboundRabbitChannelBuilderImpl : InboundRabbitChannelBuilder {
//
//        protected  EventRepositoryService eventRepositoryService;
//        protected  InboundChannelDefinitionBuilderImpl channelDefinitionBuilder;
//
//        protected RabbitInboundChannelModel rabbitChannel;
//
//        this(RabbitInboundChannelModel rabbitChannel, EventRepositoryService eventRepositoryService,
//                        InboundChannelDefinitionBuilderImpl channelDefinitionBuilder) {
//
//            this.rabbitChannel = rabbitChannel;
//            this.eventRepositoryService = eventRepositoryService;
//            this.channelDefinitionBuilder = channelDefinitionBuilder;
//        }
//
//
//        public InboundRabbitChannelBuilder exclusive(boolean exclusive) {
//            this.rabbitChannel.setExclusive(exclusive);
//            return this;
//        }
//
//
//        public InboundRabbitChannelBuilder priority(string priority) {
//            this.rabbitChannel.setPriority(priority);
//            return this;
//        }
//
//
//        public InboundRabbitChannelBuilder admin(string admin) {
//            this.rabbitChannel.setAdmin(admin);
//            return this;
//        }
//
//
//        public InboundRabbitChannelBuilder concurrency(string concurrency) {
//            rabbitChannel.setConcurrency(concurrency);
//            return this;
//        }
//
//
//        public InboundRabbitChannelBuilder executor(string executor) {
//            this.rabbitChannel.setExecutor(executor);
//            return this;
//        }
//
//
//        public InboundRabbitChannelBuilder ackMode(string ackMode) {
//            this.rabbitChannel.setAckMode(ackMode);
//            return this;
//        }
//
//
//        public InboundEventProcessingPipelineBuilder eventProcessingPipeline() {
//            channelDefinitionBuilder.inboundEventProcessingPipelineBuilder = new InboundEventProcessingPipelineBuilderImpl<>(rabbitChannel, eventRepositoryService,
//                            channelDefinitionBuilder);
//            return channelDefinitionBuilder.inboundEventProcessingPipelineBuilder;
//        }
//    }
//
//     class InboundKafkaChannelBuilderImpl : InboundKafkaChannelBuilder {
//
//        protected  EventRepositoryService eventRepositoryService;
//        protected  InboundChannelDefinitionBuilderImpl channelDefinitionBuilder;
//
//        protected KafkaInboundChannelModel kafkaChannel;
//
//        this(KafkaInboundChannelModel kafkaChannel, EventRepositoryService eventRepositoryService,
//                        InboundChannelDefinitionBuilderImpl channelDefinitionBuilder) {
//
//            this.kafkaChannel = kafkaChannel;
//            this.eventRepositoryService = eventRepositoryService;
//            this.channelDefinitionBuilder = channelDefinitionBuilder;
//        }
//
//
//        public InboundKafkaChannelBuilder groupId(string groupId) {
//            kafkaChannel.setGroupId(groupId);
//            return this;
//        }
//
//
//        public InboundKafkaChannelBuilder clientIdPrefix(string clientIdPrefix) {
//            kafkaChannel.setClientIdPrefix(clientIdPrefix);
//            return this;
//        }
//
//
//        public InboundKafkaChannelBuilder concurrency(string concurrency) {
//            kafkaChannel.setConcurrency(concurrency);
//            return this;
//        }
//
//
//        public InboundKafkaChannelBuilder property(string name, string value) {
//            kafkaChannel.addProperty(name, value);
//            return this;
//        }
//
//
//        public InboundEventProcessingPipelineBuilder eventProcessingPipeline() {
//            channelDefinitionBuilder.inboundEventProcessingPipelineBuilder = new InboundEventProcessingPipelineBuilderImpl<>(kafkaChannel,
//                            eventRepositoryService, channelDefinitionBuilder);
//            return channelDefinitionBuilder.inboundEventProcessingPipelineBuilder;
//        }
//    }
//
//     class InboundEventProcessingPipelineBuilderImpl(T) : InboundEventProcessingPipelineBuilder {
//
//        protected EventRepositoryService eventRepository;
//        protected InboundChannelDefinitionBuilderImpl channelDefinitionBuilder;
//        protected InboundChannelModel channelModel;
//
//        this(InboundChannelModel channelModel, EventRepositoryService eventRepository,
//                        InboundChannelDefinitionBuilderImpl channelDefinitionBuilder) {
//            this.channelModel = channelModel;
//            this.eventRepository = eventRepository;
//            this.channelDefinitionBuilder = channelDefinitionBuilder;
//        }
//
//
//        public InboundEventKeyJsonDetectorBuilder jsonDeserializer() {
//            channelModel.setDeserializerType(new string("json"));
//
//            InboundEventProcessingPipelineBuilderImpl<JsonNode> jsonPipelineBuilder
//                = new InboundEventProcessingPipelineBuilderImpl<>(channelModel, eventRepository, channelDefinitionBuilder);
//            this.channelDefinitionBuilder.inboundEventProcessingPipelineBuilder = jsonPipelineBuilder;
//
//            return new InboundEventKeyJsonDetectorBuilderImpl(jsonPipelineBuilder);
//        }
//
//
//        public InboundEventKeyXmlDetectorBuilder xmlDeserializer() {
//            channelModel.setDeserializerType("xml");
//            InboundEventProcessingPipelineBuilderImpl<Document> xmlPipelineBuilder
//                = new InboundEventProcessingPipelineBuilderImpl<>(channelModel, eventRepository, channelDefinitionBuilder);
//            this.channelDefinitionBuilder.inboundEventProcessingPipelineBuilder = xmlPipelineBuilder;
//
//            return new InboundEventKeyXmlDetectorBuilderImpl(xmlPipelineBuilder);
//        }
//
//
//        public InboundEventKeyDetectorBuilder delegateExpressionDeserializer(string delegateExpression) {
//            channelModel.setDeserializerType("expression");
//            channelModel.setDeserializerDelegateExpression(delegateExpression);
//            InboundEventProcessingPipelineBuilderImpl customPipelineBuilder = new InboundEventProcessingPipelineBuilderImpl<>(channelModel,
//                eventRepository, channelDefinitionBuilder);
//            this.channelDefinitionBuilder.inboundEventProcessingPipelineBuilder = customPipelineBuilder;
//            return new InboundEventDefinitionKeyDetectorBuilderImpl(customPipelineBuilder);
//        }
//
//
//        public InboundChannelModelBuilder eventProcessingPipeline(string delegateExpression) {
//            this.channelModel.setPipelineDelegateExpression(delegateExpression);
//            return channelDefinitionBuilder;
//        }
//
//    }
//
//    class InboundEventKeyJsonDetectorBuilderImpl : InboundEventKeyJsonDetectorBuilder {
//
//        protected InboundEventProcessingPipelineBuilderImpl<JsonNode> inboundEventProcessingPipelineBuilder;
//
//        this(InboundEventProcessingPipelineBuilderImpl<JsonNode> inboundEventProcessingPipelineBuilder) {
//            this.inboundEventProcessingPipelineBuilder = inboundEventProcessingPipelineBuilder;
//        }
//
//
//        public InboundEventTenantJsonDetectorBuilder fixedEventKey(string key) {
//            ChannelEventKeyDetection keyDetection = new ChannelEventKeyDetection();
//            keyDetection.setFixedValue(key);
//            this.inboundEventProcessingPipelineBuilder.channelModel.setChannelEventKeyDetection(keyDetection);
//            return new InboundEventTenantJsonDetectorBuilderImpl(inboundEventProcessingPipelineBuilder);
//        }
//
//
//        public InboundEventTenantJsonDetectorBuilder detectEventKeyUsingJsonField(string field) {
//            ChannelEventKeyDetection keyDetection = new ChannelEventKeyDetection();
//            keyDetection.setJsonField(field);
//            this.inboundEventProcessingPipelineBuilder.channelModel.setChannelEventKeyDetection(keyDetection);
//            return new InboundEventTenantJsonDetectorBuilderImpl(inboundEventProcessingPipelineBuilder);
//        }
//
//
//        public InboundEventTenantJsonDetectorBuilder detectEventKeyUsingJsonPointerExpression(string jsonPointerExpression) {
//            ChannelEventKeyDetection keyDetection = new ChannelEventKeyDetection();
//            keyDetection.setJsonPointerExpression(jsonPointerExpression);
//            this.inboundEventProcessingPipelineBuilder.channelModel.setChannelEventKeyDetection(keyDetection);
//            return new InboundEventTenantJsonDetectorBuilderImpl(inboundEventProcessingPipelineBuilder);
//        }
//    }
//
//    class InboundEventKeyXmlDetectorBuilderImpl : InboundEventKeyXmlDetectorBuilder {
//
//        protected InboundEventProcessingPipelineBuilderImpl<Document> inboundEventProcessingPipelineBuilder;
//
//        this(InboundEventProcessingPipelineBuilderImpl<Document> inboundEventProcessingPipelineBuilder) {
//            this.inboundEventProcessingPipelineBuilder = inboundEventProcessingPipelineBuilder;
//        }
//
//
//        public InboundEventTenantXmlDetectorBuilder fixedEventKey(string key) {
//            ChannelEventKeyDetection keyDetection = new ChannelEventKeyDetection();
//            keyDetection.setFixedValue(key);
//            this.inboundEventProcessingPipelineBuilder.channelModel.setChannelEventKeyDetection(keyDetection);
//            return new InboundEventTenantXmlDetectorBuilderImpl(inboundEventProcessingPipelineBuilder);
//        }
//
//
//        public InboundEventTenantXmlDetectorBuilder detectEventKeyUsingXPathExpression(string xPathExpression) {
//            ChannelEventKeyDetection keyDetection = new ChannelEventKeyDetection();
//            keyDetection.setXmlXPathExpression(xPathExpression);
//            this.inboundEventProcessingPipelineBuilder.channelModel.setChannelEventKeyDetection(keyDetection);
//            return new InboundEventTenantXmlDetectorBuilderImpl(inboundEventProcessingPipelineBuilder);
//        }
//
//    }
//
//    class InboundEventDefinitionKeyDetectorBuilderImpl : InboundEventKeyDetectorBuilder {
//
//        protected InboundEventProcessingPipelineBuilderImpl inboundEventProcessingPipelineBuilder;
//
//        this(InboundEventProcessingPipelineBuilderImpl inboundEventProcessingPipelineBuilder) {
//            this.inboundEventProcessingPipelineBuilder = inboundEventProcessingPipelineBuilder;
//        }
//
//
//        public InboundEventTenantDetectorBuilder delegateExpressionKeyDetector(string delegateExpression) {
//            ChannelEventKeyDetection keyDetection = new ChannelEventKeyDetection();
//            keyDetection.setDelegateExpression(delegateExpression);
//            inboundEventProcessingPipelineBuilder.channelModel.setChannelEventKeyDetection(keyDetection);
//            return new InboundEventTenantDetectorBuilderImpl(inboundEventProcessingPipelineBuilder);
//        }
//
//    }
//
//    class InboundEventTenantJsonDetectorBuilderImpl
//            : InboundEventPayloadJsonExtractorBuilderImpl , InboundEventTenantJsonDetectorBuilder {
//
//        this(InboundEventProcessingPipelineBuilderImpl<JsonNode> inboundEventProcessingPipelineBuilder) {
//            super(inboundEventProcessingPipelineBuilder);
//        }
//
//
//        public InboundEventPayloadJsonExtractorBuilder fixedTenantId(string tenantId) {
//            ChannelEventTenantIdDetection tenantIdDetection = new ChannelEventTenantIdDetection();
//            tenantIdDetection.setFixedValue(tenantId);
//            this.inboundEventProcessingPipelineBuilder.channelModel.setChannelEventTenantIdDetection(tenantIdDetection);
//            return new InboundEventPayloadJsonExtractorBuilderImpl(inboundEventProcessingPipelineBuilder);
//        }
//
//
//        public InboundEventPayloadJsonExtractorBuilder detectEventTenantUsingJsonPointerExpression(string jsonPointerExpression) {
//            ChannelEventTenantIdDetection tenantIdDetection = new ChannelEventTenantIdDetection();
//            tenantIdDetection.setJsonPointerExpression(jsonPointerExpression);
//            this.inboundEventProcessingPipelineBuilder.channelModel.setChannelEventTenantIdDetection(tenantIdDetection);
//            return new InboundEventPayloadJsonExtractorBuilderImpl(inboundEventProcessingPipelineBuilder);
//        }
//
//    }
//
//    class InboundEventTenantXmlDetectorBuilderImpl
//            : InboundEventPayloadXmlExtractorBuilderImpl , InboundEventTenantXmlDetectorBuilder {
//
//        this(InboundEventProcessingPipelineBuilderImpl<Document> inboundEventProcessingPipelineBuilder) {
//            super(inboundEventProcessingPipelineBuilder);
//        }
//
//
//        public InboundEventPayloadXmlExtractorBuilder fixedTenantId(string tenantId) {
//            ChannelEventTenantIdDetection tenantIdDetection = new ChannelEventTenantIdDetection();
//            tenantIdDetection.setFixedValue(tenantId);
//            this.inboundEventProcessingPipelineBuilder.channelModel.setChannelEventTenantIdDetection(tenantIdDetection);
//            return new InboundEventPayloadXmlExtractorBuilderImpl(inboundEventProcessingPipelineBuilder);
//        }
//
//
//        public InboundEventPayloadXmlExtractorBuilder detectEventTenantUsingXPathExpression(string xPathExpression) {
//            ChannelEventTenantIdDetection tenantIdDetection = new ChannelEventTenantIdDetection();
//            tenantIdDetection.setxPathExpression(xPathExpression);
//            this.inboundEventProcessingPipelineBuilder.channelModel.setChannelEventTenantIdDetection(tenantIdDetection);
//            return new InboundEventPayloadXmlExtractorBuilderImpl(inboundEventProcessingPipelineBuilder);
//        }
//
//    }
//
//    class InboundEventTenantDetectorBuilderImpl
//            : InboundEventPayloadExtractorBuilderImpl , InboundEventTenantDetectorBuilder {
//
//        this(InboundEventProcessingPipelineBuilderImpl inboundEventProcessingPipelineBuilder) {
//            super(inboundEventProcessingPipelineBuilder);
//        }
//
//
//        public InboundEventPayloadExtractorBuilder fixedTenantId(string tenantId) {
//            ChannelEventTenantIdDetection tenantIdDetection = new ChannelEventTenantIdDetection();
//            tenantIdDetection.setFixedValue(tenantId);
//            this.inboundEventProcessingPipelineBuilder.channelModel.setChannelEventTenantIdDetection(tenantIdDetection);
//            return new InboundEventPayloadExtractorBuilderImpl(inboundEventProcessingPipelineBuilder);
//        }
//
//
//        public InboundEventPayloadExtractorBuilder delegateExpressionTenantDetector(string delegateExpression) {
//            ChannelEventTenantIdDetection tenantIdDetection = new ChannelEventTenantIdDetection();
//            tenantIdDetection.setDelegateExpression(delegateExpression);
//            inboundEventProcessingPipelineBuilder.channelModel.setChannelEventTenantIdDetection(tenantIdDetection);
//            return new InboundEventPayloadExtractorBuilderImpl(inboundEventProcessingPipelineBuilder);
//        }
//
//    }
//
//    class InboundEventPayloadJsonExtractorBuilderImpl : InboundEventPayloadJsonExtractorBuilder {
//
//        protected InboundEventProcessingPipelineBuilderImpl<JsonNode> inboundEventProcessingPipelineBuilder;
//
//        this(InboundEventProcessingPipelineBuilderImpl<JsonNode> inboundEventProcessingPipelineBuilder) {
//            this.inboundEventProcessingPipelineBuilder = inboundEventProcessingPipelineBuilder;
//        }
//
//
//        public InboundEventTransformerBuilder jsonFieldsMapDirectlyToPayload() {
//            return new InboundEventTransformerBuilderImpl(inboundEventProcessingPipelineBuilder);
//        }
//
//    }
//
//    class InboundEventPayloadXmlExtractorBuilderImpl : InboundEventPayloadXmlExtractorBuilder {
//
//        protected InboundEventProcessingPipelineBuilderImpl<Document> inboundEventProcessingPipelineBuilder;
//
//        this(InboundEventProcessingPipelineBuilderImpl<Document> inboundEventProcessingPipelineBuilder) {
//            this.inboundEventProcessingPipelineBuilder = inboundEventProcessingPipelineBuilder;
//        }
//
//
//        public InboundEventTransformerBuilder xmlElementsMapDirectlyToPayload() {
//            return new InboundEventTransformerBuilderImpl(inboundEventProcessingPipelineBuilder);
//        }
//
//    }
//
//    class InboundEventPayloadExtractorBuilderImpl : InboundEventPayloadExtractorBuilder {
//
//        protected InboundEventProcessingPipelineBuilderImpl inboundEventProcessingPipelineBuilder;
//
//        this(InboundEventProcessingPipelineBuilderImpl inboundEventProcessingPipelineBuilder) {
//            this.inboundEventProcessingPipelineBuilder = inboundEventProcessingPipelineBuilder;
//        }
//
//
//        public InboundEventTransformerBuilder payloadExtractor(string delegateExpression) {
//            inboundEventProcessingPipelineBuilder.channelModel.setPayloadExtractorDelegateExpression(delegateExpression);
//            return new InboundEventTransformerBuilderImpl(inboundEventProcessingPipelineBuilder);
//        }
//
//    }
//
//    class InboundEventTransformerBuilderImpl : InboundEventTransformerBuilder {
//
//        protected InboundEventProcessingPipelineBuilderImpl inboundEventProcessingPipelineBuilder;
//
//        this(InboundEventProcessingPipelineBuilderImpl inboundEventProcessingPipelineBuilder) {
//            this.inboundEventProcessingPipelineBuilder = inboundEventProcessingPipelineBuilder;
//        }
//
//
//        public InboundChannelModelBuilder transformer(string delegateExpression) {
//            this.inboundEventProcessingPipelineBuilder.channelModel.setEventTransformerDelegateExpression(delegateExpression);
//            return this.inboundEventProcessingPipelineBuilder.channelDefinitionBuilder;
//        }
//
//
//        public EventDeployment deploy() {
//            return this.inboundEventProcessingPipelineBuilder.channelDefinitionBuilder.deploy();
//        }
//
//    }
//
//}
