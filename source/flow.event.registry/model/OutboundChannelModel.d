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

module flow.event.registry.model.OutboundChannelModel;


import flow.event.registry.model.ChannelModel;
//import com.fasterxml.jackson.annotation.JsonIgnore;

/**
 * @author Joram Barrez
 */
class OutboundChannelModel : ChannelModel {

    protected string serializerType;

    protected string serializerDelegateExpression;
    protected string pipelineDelegateExpression;

   // @JsonIgnore
    protected Object outboundEventChannelAdapter;

    //@JsonIgnore
    protected Object outboundEventProcessingPipeline;

    this() {
        setChannelType("outbound");
    }

    public string getSerializerType() {
        return serializerType;
    }

    public void setSerializerType(string serializerType) {
        this.serializerType = serializerType;
    }

    public string getSerializerDelegateExpression() {
        return serializerDelegateExpression;
    }

    public void setSerializerDelegateExpression(string serializerDelegateExpression) {
        this.serializerDelegateExpression = serializerDelegateExpression;
    }

    public string getPipelineDelegateExpression() {
        return pipelineDelegateExpression;
    }

    public void setPipelineDelegateExpression(string pipelineDelegateExpression) {
        this.pipelineDelegateExpression = pipelineDelegateExpression;
    }

    public Object getOutboundEventChannelAdapter() {
        return outboundEventChannelAdapter;
    }

    public void setOutboundEventChannelAdapter(Object outboundEventChannelAdapter) {
        this.outboundEventChannelAdapter = outboundEventChannelAdapter;
    }

    public Object getOutboundEventProcessingPipeline() {
        return outboundEventProcessingPipeline;
    }

    public void setOutboundEventProcessingPipeline(Object outboundEventProcessingPipeline) {
        this.outboundEventProcessingPipeline = outboundEventProcessingPipeline;
    }

}
