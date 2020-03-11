/* Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

module flow.event.registry.api.model.InboundChannelModelBuilder;

import flow.event.registry.api.EventDeployment;
//import flow.event.registry.api.InboundEventChannelAdapter;
//import flow.event.registry.api.InboundEventKeyDetector;
//import flow.event.registry.api.InboundEventPayloadExtractor;
//import flow.event.registry.api.InboundEventProcessingPipeline;
//import flow.event.registry.api.InboundEventTenantDetector;
import flow.event.registry.model.InboundChannelModel;

/**
 * A builder to create a {@link InboundChannelModel} instance,
 * which represents a channel from the 'outside world' to receive events.
 *
 * An inbound channel consists of the following parts:
 * - An adapter that defines how/where the events are received, each with specific configurations.
 * - An event processing pipeline, which transforms the incoming event and extracts data and metadata:
 *     - deserialization (from the 'raw' event to something else)
 *     - event key detection: detects the 'key' which will define the {@link flow.event.registry.model.EventModel} to be used.
 *     - tenant detection (only relevant when using multi-tenant): detects a 'tenantId' which is used to determine
 *       the correct {@link flow.event.registry.api.EventDefinition}.
 *     - payload extraction: with the {@link flow.event.registry.model.EventModel} determined,
 *       the definition is used to extract the payload from the event data.
 *     - transformation: transforms the event to an internal representation,
 *       ready to be passed to the {@link flow.event.registry.api.EventRegistry}.
 *     - (Optionally) custom steps (or override any of the above)
 *
 * @author Joram Barrez
 * @author Filip Hrisafov
 */
interface InboundChannelModelBuilder {

    /**
     * Each channel needs to have a unique key to identity it.
     */
    InboundChannelModelBuilder key(string key);

    /**
     * Set the name for the channel deployment.
     */
    InboundChannelModelBuilder deploymentName(string deploymentName);

    /**
     * Set the resource name for the channel model.
     */
    InboundChannelModelBuilder resourceName(string resourceName);

    /**
     * Set the category for the channel deployment.
     */
    InboundChannelModelBuilder category(string category);

    /**
     * Set the tenant id for the channel deployment.
     */
    InboundChannelModelBuilder deploymentTenantId(string deploymentTenantId);

    /**
     * Set the parent deployment id for the channel deployment.
     */
    InboundChannelModelBuilder parentDeploymentId(string parentDeploymentId);

    /**
     * Sets a custom {@link InboundEventChannelAdapter} via a delegate expression.
     */
    InboundEventProcessingPipelineBuilder channelAdapter(string delegateExpression);

    /**
     * Configures an adapter which will receive events using JMS.
     */
    InboundJmsChannelBuilder jmsChannelAdapter(string destinationName);

    /**
     * Configures an adapter which will receive events using a RabbitMQ.
     */
    InboundRabbitChannelBuilder rabbitChannelAdapter(string queue);

    /**
     * Configures an adapter which receives events using Kafka.
     */
    InboundKafkaChannelBuilder kafkaChannelAdapter(string topic);

    /**
     * Creates the {@link InboundChannelModel} instance based on the configuration
     * and registers it with the {@link flow.event.registry.api.EventRepositoryService EventRepositoryService}.
     */
    EventDeployment deploy();

    /**
     * Builder to create an {@link InboundEventChannelAdapter} using JMS.
     */
    interface InboundJmsChannelBuilder {

        /**
         * Set the JMS message selector, which can be used to filter
         * out incoming events. See the JMS spec for more info.
         */
        InboundJmsChannelBuilder selector(string selector);

        /**
         * Sets the JMS subscription. See the JMS spec for more info.
         */
        InboundJmsChannelBuilder subscription(string subscription);

        /**
         * Sets the concurrency for the listener (e.g "5-10"). See the Spring JMS docs for more info.
         */
        InboundJmsChannelBuilder concurrency(string concurrency);

        /**
         * Continue building the {@link InboundChannelModel} by configuring the next parts (if any).
         */
        InboundEventProcessingPipelineBuilder eventProcessingPipeline();
    }

    /**
     * Builder to create an {@link InboundEventChannelAdapter} using RabbitMQ.
     */
    interface InboundRabbitChannelBuilder {

        /**
         * Sets whether this adapter will be the only consumer of messages of the provided queue(s).
         * See the Spring Rabbit docs for more info.
         */
        InboundRabbitChannelBuilder exclusive(bool exclusive);

        /**
         * Sets the priority of this adapter. See the Spring Rabbit docs for more info.
         */
        InboundRabbitChannelBuilder priority(string priority);

        /**
         * Bean name of a org.springframework.amqp.rabbit.core.RabbitAdmin instance.
         * See the Spring Rabbit docs for more info.
         */
        InboundRabbitChannelBuilder admin(string admin);

        /**
         * Sets the concurrency for the listener. See the Spring JMS docs for more info.
         */
        InboundRabbitChannelBuilder concurrency(string concurrency);

        /**
         * Bean name of a TaskExecutor instance used to process incoming messages.
         */
        InboundRabbitChannelBuilder executor(string executor);

        /**
         * Sets the AckMode (e.g. NONE/MANUAL/AUTO). See the Spring JMS docs for more info.
         */
        InboundRabbitChannelBuilder ackMode(string ackMode);

        /**
         * Continue building the {@link InboundChannelModel} by configuring the next parts (if any).
         */
        InboundEventProcessingPipelineBuilder eventProcessingPipeline();
    }

    /**
     * Builder to create an {@link InboundEventChannelAdapter} using Kafka.
     */
    interface InboundKafkaChannelBuilder {

        /**
         * Sets the groupId for this Kafka adapter. See Kafka docs for more info.
         */
        InboundKafkaChannelBuilder groupId(string groupId);

        /**
         * Sets the client id prefix for this Kafka adapter. See Kafka docs for more info.
         */
        InboundKafkaChannelBuilder clientIdPrefix(string clientIdPrefix);

        /**
         * Sets the concurrency (and integer) for this Kafka adapter. See the Spring Kafka docs for more information.
         */
        InboundKafkaChannelBuilder concurrency(string concurrency);

        /**
         * Sets custom properties for this Kafka adapter. See the Spring Kafka docs for more information.
         */
        InboundKafkaChannelBuilder property(string name, string value);

        /**
         * Continue building the {@link InboundChannelModel} by configuring the next parts (if any).
         */
        InboundEventProcessingPipelineBuilder eventProcessingPipeline();
    }

    /**
     * Builder for the 'processing pipeline' part of the {@link InboundChannelModel}.
     */
    interface InboundEventProcessingPipelineBuilder {

        /**
         * Deserializes the event to JSON.
         */
        InboundEventKeyJsonDetectorBuilder jsonDeserializer();

        /**
         * Deserializes the event to XML.
         */
        InboundEventKeyXmlDetectorBuilder xmlDeserializer();

        /**
         * Uses a delegate expression to deserialize the event.
         */
        InboundEventKeyDetectorBuilder delegateExpressionDeserializer(string delegateExpression);

        /**
         * Uses a delegate expression to determine the custom {@link InboundEventProcessingPipeline} instance.
         */
        InboundChannelModelBuilder eventProcessingPipeline(string delegateExpression);

    }

    /**
     * Builder for the 'key detection' part of the {@link InboundChannelModel}, specifically for JSON events.
     */
    interface InboundEventKeyJsonDetectorBuilder {

        /**
         * Sets the event key to a hardcoded value. This is useful when the channel only receives one type of event.
         */
        InboundEventTenantJsonDetectorBuilder fixedEventKey(string key);

        /**
         * Determines the key of the event based on a top-level field in the JSON representation in the event.
         */
        InboundEventTenantJsonDetectorBuilder detectEventKeyUsingJsonField(string field);

        /**
         * Determines the key of the event using on a JSON Pointer expression to find the value.
         */
        InboundEventTenantJsonDetectorBuilder detectEventKeyUsingJsonPointerExpression(string jsonPointerExpression);

    }

    /**
     * Builder for the 'tenant ID detection' part of the {@link InboundChannelModel}, specifically for JSON events
     */
    interface InboundEventTenantJsonDetectorBuilder : InboundEventPayloadJsonExtractorBuilder {  // Extends because using tenant extraction is optional

        /**
         * Sets the tenant to a hardcoded value. Useful for when the channel only receives events for a given tenant.
         */
        InboundEventPayloadJsonExtractorBuilder fixedTenantId(string tenantId);

        /**
         * Determines the tenant ID by using a JSOn Pointer expression.
         */
        InboundEventPayloadJsonExtractorBuilder detectEventTenantUsingJsonPointerExpression(string jsonPointerExpression);

    }

    /**
     * Builder for the 'key detection' part of the {@link InboundChannelModel}, specifically for XML events.
     */
    interface InboundEventKeyXmlDetectorBuilder {

        /**
         * Sets the event key to a hardcoded value. This is useful when the channel only receives one type of event.
         */
        InboundEventTenantXmlDetectorBuilder fixedEventKey(string key);

        /**
         * Determines the key of the event using on a XPATH expression to find the value.
         */
        InboundEventTenantXmlDetectorBuilder detectEventKeyUsingXPathExpression(string xPathExpression);

    }

    /**
     * Builder for the 'tenant ID detection' part of the {@link InboundChannelModel}, specifically for XML events
     */
    interface InboundEventTenantXmlDetectorBuilder : InboundEventPayloadXmlExtractorBuilder {  // Extends because using tenant extraction is optional

        /**
         * Sets the tenant to a hardcoded value. Useful for when the channel only receives events for a given tenant.
         */
        InboundEventPayloadXmlExtractorBuilder fixedTenantId(string tenantId);

        /**
         * Determines the tenant ID by using an XPath expression.
         */
        InboundEventPayloadXmlExtractorBuilder detectEventTenantUsingXPathExpression(string xPathExpression);

    }

    /**
     * Builder for the 'key detection' part of the {@link InboundChannelModel}.
     */
    interface InboundEventKeyDetectorBuilder {

        /**
         * Uses delegate expression to determine the custom {@link InboundEventKeyDetector}.
         */
        InboundEventTenantDetectorBuilder delegateExpressionKeyDetector(string delegateExpression);

    }

    /**
     * Builder for the 'tenant ID detection' part of the {@link InboundChannelModel}.
     */
    interface InboundEventTenantDetectorBuilder : InboundEventPayloadExtractorBuilder {  // Extends because using tenant extraction is optional

        /**
         * Sets the tenant to a hardcoded value. Useful for when the channel only receives events for a given tenant.
         */
        InboundEventPayloadExtractorBuilder fixedTenantId(string tenantId);

        /**
         * Uses delegate expression to determine the custom {@link InboundEventTenantDetector} instance.
         */
        InboundEventPayloadExtractorBuilder delegateExpressionTenantDetector(string delegateExpression);

    }

    /**
     * Builder for the 'payload extraction' part of the {@link InboundChannelModel}.
     */
    interface InboundEventPayloadJsonExtractorBuilder {

        /**
         * Extracts the payload directly from (top-level) json fields.
         */
        InboundEventTransformerBuilder jsonFieldsMapDirectlyToPayload();

    }

    /**
     * Builder for the 'payload extraction' part of the {@link InboundChannelModel}.
     */
    interface InboundEventPayloadXmlExtractorBuilder {

        /**
         * Extracts the payload directly from (top-level) xml elements.
         */
        InboundEventTransformerBuilder xmlElementsMapDirectlyToPayload();

    }

    /**
     * Builder for the 'payload extraction' part of the {@link InboundChannelModel}.
     */
    interface InboundEventPayloadExtractorBuilder {

        /**
         * Uses delegate expression to determine the custom {@link InboundEventPayloadExtractor} instance.
         */
        InboundEventTransformerBuilder payloadExtractor(string delegateExpression);

    }

    interface InboundEventTransformerBuilder {

        InboundChannelModelBuilder transformer(string delegateExpression);

        EventDeployment deploy();

    }

}
