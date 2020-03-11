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

module flow.event.registry.model.InboundChannelModel;

import flow.event.registry.model.ChannelModel;
import flow.event.registry.model.ChannelEventKeyDetection;
import flow.event.registry.model.ChannelEventTenantIdDetection;
//import com.fasterxml.jackson.annotation.JsonIgnore;

/**
 * @author Joram Barrez
 */
class InboundChannelModel : ChannelModel {

    protected string deserializerType;

    protected string deserializerDelegateExpression;
    protected string payloadExtractorDelegateExpression;
    protected string eventTransformerDelegateExpression;
    protected string pipelineDelegateExpression;
    protected ChannelEventKeyDetection channelEventKeyDetection;
    protected ChannelEventTenantIdDetection channelEventTenantIdDetection;

   // @JsonIgnore
    protected Object inboundEventChannelAdapter;

    //@JsonIgnore
    protected Object inboundEventProcessingPipeline;

    this() {
        setChannelType("inbound");
    }

    public string getDeserializerType() {
        return deserializerType;
    }

    public void setDeserializerType(string deserializerType) {
        this.deserializerType = deserializerType;
    }

    public string getDeserializerDelegateExpression() {
        return deserializerDelegateExpression;
    }

    public void setDeserializerDelegateExpression(string deserializerDelegateExpression) {
        this.deserializerDelegateExpression = deserializerDelegateExpression;
    }

    public string getPayloadExtractorDelegateExpression() {
        return payloadExtractorDelegateExpression;
    }

    public void setPayloadExtractorDelegateExpression(string payloadExtractorDelegateExpression) {
        this.payloadExtractorDelegateExpression = payloadExtractorDelegateExpression;
    }

    public string getEventTransformerDelegateExpression() {
        return eventTransformerDelegateExpression;
    }

    public void setEventTransformerDelegateExpression(string eventTransformerDelegateExpression) {
        this.eventTransformerDelegateExpression = eventTransformerDelegateExpression;
    }

    public string getPipelineDelegateExpression() {
        return pipelineDelegateExpression;
    }

    public void setPipelineDelegateExpression(string pipelineDelegateExpression) {
        this.pipelineDelegateExpression = pipelineDelegateExpression;
    }

    public ChannelEventKeyDetection getChannelEventKeyDetection() {
        return channelEventKeyDetection;
    }

    public void setChannelEventKeyDetection(ChannelEventKeyDetection channelEventKeyDetection) {
        this.channelEventKeyDetection = channelEventKeyDetection;
    }

    public ChannelEventTenantIdDetection getChannelEventTenantIdDetection() {
        return channelEventTenantIdDetection;
    }

    public void setChannelEventTenantIdDetection(ChannelEventTenantIdDetection channelEventTenantIdDetection) {
        this.channelEventTenantIdDetection = channelEventTenantIdDetection;
    }

    public Object getInboundEventProcessingPipeline() {
        return inboundEventProcessingPipeline;
    }

    public void setInboundEventProcessingPipeline(Object inboundEventProcessingPipeline) {
        this.inboundEventProcessingPipeline = inboundEventProcessingPipeline;
    }

    public Object getInboundEventChannelAdapter() {
        return inboundEventChannelAdapter;
    }

    public void setInboundEventChannelAdapter(Object inboundEventChannelAdapter) {
        this.inboundEventChannelAdapter = inboundEventChannelAdapter;
    }

}
