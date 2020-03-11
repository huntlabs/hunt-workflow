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


import hunt.collection;
import java.util.Objects;

import flow.common.api.FlowableException;
import flow.event.registry.api.EventRepositoryService;
import flow.event.registry.api.OutboundEventChannelAdapter;
import flow.event.registry.api.OutboundEventProcessingPipeline;
import flow.event.registry.api.OutboundEventProcessor;
import flow.event.registry.api.runtime.EventInstance;
import flow.event.registry.model.ChannelModel;
import flow.event.registry.model.OutboundChannelModel;

/**
 * @author Joram Barrez
 */
class DefaultOutboundEventProcessor implements OutboundEventProcessor {

    protected EventRepositoryService eventRepositoryService;
    protected boolean fallbackToDefaultTenant;

    public DefaultOutboundEventProcessor(EventRepositoryService eventRepositoryService, boolean fallbackToDefaultTenant) {
        this.eventRepositoryService = eventRepositoryService;
        this.fallbackToDefaultTenant =fallbackToDefaultTenant;
    }

    @Override
    public void sendEvent(EventInstance eventInstance) {
        Collection!String outboundChannelKeys = eventInstance.getEventModel().getOutboundChannelKeys();
        for (String outboundChannelKey : outboundChannelKeys) {

            ChannelModel channelModel is null;
            if (Objects.equals(EventRegistryEngineConfiguration.NO_TENANT_ID, eventInstance.getTenantId())) {
                channelModel = eventRepositoryService.getChannelModelByKey(outboundChannelKey);
            } else {
                channelModel = eventRepositoryService.getChannelModelByKey(outboundChannelKey, eventInstance.getTenantId());
            }

            if (channelModel is null) {
                throw new FlowableException("Could not find outbound channel model for " + outboundChannelKey);
            }

            if (!(channelModel instanceof OutboundChannelModel)) {
                throw new FlowableException("Channel model is not an outbound channel model for " + outboundChannelKey);
            }

            OutboundChannelModel outboundChannelModel = (OutboundChannelModel) channelModel;

            OutboundEventProcessingPipeline outboundEventProcessingPipeline = (OutboundEventProcessingPipeline) outboundChannelModel.getOutboundEventProcessingPipeline();
            String rawEvent = outboundEventProcessingPipeline.run(eventInstance);

            OutboundEventChannelAdapter outboundEventChannelAdapter = (OutboundEventChannelAdapter) outboundChannelModel.getOutboundEventChannelAdapter();
            if (outboundEventChannelAdapter is null) {
                throw new FlowableException("Could not find an outbound channel adapter for channel " + outboundChannelKey);
            }

            outboundEventChannelAdapter.sendEvent(rawEvent);
        }
    }

}
