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
module flow.event.registry.DefaultEventRegistry;


import hunt.collection;
import hunt.collection.Map;

import flow.event.registry.api.CorrelationKeyGenerator;
import flow.event.registry.api.EventRegistry;
import flow.event.registry.api.EventRegistryEvent;
import flow.event.registry.api.EventRegistryEventConsumer;
import flow.event.registry.api.InboundEventProcessor;
import flow.event.registry.api.OutboundEventProcessor;
import flow.event.registry.api.runtime.EventInstance;
import flow.event.registry.model.InboundChannelModel;
import flow.event.registry.EventRegistryEngineConfiguration;
import flow.event.registry.DefaultCorrelationKeyGenerator;
import hunt.collection.ArrayList;
/**
 * @author Joram Barrez
 */
class DefaultEventRegistry : EventRegistry {

    protected EventRegistryEngineConfiguration engineConfiguration;

    protected CorrelationKeyGenerator!(Map!(string, Object)) correlationKeyGenerator;

    protected InboundEventProcessor inboundEventProcessor;
    protected OutboundEventProcessor outboundEventProcessor;

    this(EventRegistryEngineConfiguration engineConfiguration) {
        this.engineConfiguration = engineConfiguration;
        this.correlationKeyGenerator = new DefaultCorrelationKeyGenerator();
    }


    public void setInboundEventProcessor(InboundEventProcessor inboundEventProcessor) {
        this.inboundEventProcessor = inboundEventProcessor;
    }


    public void setOutboundEventProcessor(OutboundEventProcessor outboundEventProcessor) {
        this.outboundEventProcessor = outboundEventProcessor;
    }


    public void eventReceived(InboundChannelModel channelModel, string event) {
        inboundEventProcessor.eventReceived(channelModel, event);
    }


    public void sendEventToConsumers(EventRegistryEvent eventRegistryEvent) {
        Collection!EventRegistryEventConsumer engineEventRegistryEventConsumers = new ArrayList!EventRegistryEventConsumer (engineConfiguration.getEventRegistryEventConsumers().values());
        foreach (EventRegistryEventConsumer eventConsumer ; engineEventRegistryEventConsumers) {
            eventConsumer.eventReceived(eventRegistryEvent);
        }
    }


    public void sendEventOutbound(EventInstance eventInstance) {
        outboundEventProcessor.sendEvent(eventInstance);
    }


    public void registerEventRegistryEventConsumer(EventRegistryEventConsumer eventRegistryEventBusConsumer) {
        engineConfiguration.getEventRegistryEventConsumers().put(eventRegistryEventBusConsumer.getConsumerKey(), eventRegistryEventBusConsumer);
    }


    public void removeFlowableEventRegistryEventConsumer(EventRegistryEventConsumer eventRegistryEventBusConsumer) {
        engineConfiguration.getEventRegistryEventConsumers().remove(eventRegistryEventBusConsumer.getConsumerKey());
    }


    public string generateKey(Map!(string, Object) data) {
        return correlationKeyGenerator.generateKey(data);
    }

}
