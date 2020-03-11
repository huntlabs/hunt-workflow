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
module flow.event.registry.DefaultInboundEventProcessor;

import hunt.collection;

import flow.event.registry.api.EventRegistry;
import flow.event.registry.api.EventRegistryEvent;
import flow.event.registry.api.InboundEventProcessingPipeline;
import flow.event.registry.api.InboundEventProcessor;
import flow.event.registry.model.InboundChannelModel;

/**
 * @author Joram Barrez
 * @author Filip Hrisafov
 */
class DefaultInboundEventProcessor : InboundEventProcessor {

    protected EventRegistry eventRegistry;

    this(EventRegistry eventRegistry) {
        this.eventRegistry = eventRegistry;
    }


    public void eventReceived(InboundChannelModel channelModel, string event) {

        InboundEventProcessingPipeline inboundEventProcessingPipeline = cast(InboundEventProcessingPipeline) channelModel.getInboundEventProcessingPipeline();
        Collection!EventRegistryEvent eventRegistryEvents = inboundEventProcessingPipeline.run(channelModel.getKey(), event);

        foreach (EventRegistryEvent eventRegistryEvent ; eventRegistryEvents) {
            eventRegistry.sendEventToConsumers(eventRegistryEvent);
        }

    }

}
