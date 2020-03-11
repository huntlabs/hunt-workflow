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

module flow.event.registry.model.EventModel;

import hunt.collection.ArrayList;
import hunt.collection;

import flow.event.registry.model.EventCorrelationParameter;
import flow.event.registry.model.EventPayload;

//import com.fasterxml.jackson.annotation.JsonInclude;
//import com.fasterxml.jackson.annotation.JsonInclude.Include;

//@JsonInclude(Include.NON_NULL)
class EventModel {

    protected string key;
    protected string name;
    protected Collection!string inboundChannelKeys ;// = new ArrayList<>();
    protected Collection!string outboundChannelKeys ;//= new ArrayList<>();
    protected Collection!EventCorrelationParameter correlationParameters ;//= new ArrayList<>();
    protected Collection!EventPayload payload ;//= new ArrayList<>();

    this()
    {
        inboundChannelKeys = new ArrayList!string;
        outboundChannelKeys = new ArrayList!string;
        correlationParameters = new ArrayList!EventCorrelationParameter;
        payload = new ArrayList!EventPayload;
    }

    public string getKey() {
        return key;
    }

    public void setKey(string key) {
        this.key = key;
    }

    public string getName() {
        return name;
    }

    public void setName(string name) {
        this.name = name;
    }

    public Collection!string getInboundChannelKeys() {
        return inboundChannelKeys;
    }

    public void addInboundChannelKey(string inboundChannelKey) {
        this.inboundChannelKeys.add(inboundChannelKey);
    }

    public void setInboundChannelKeys(Collection!string inboundChannelKeys) {
        this.inboundChannelKeys = inboundChannelKeys;
    }

    public Collection!string getOutboundChannelKeys() {
        return outboundChannelKeys;
    }

    public void addOutboundChannelKey(string outboundChannelKey) {
        this.outboundChannelKeys.add(outboundChannelKey);
    }

    public void setOutboundChannelKeys(Collection!string outboundChannelKeys) {
        this.outboundChannelKeys = outboundChannelKeys;
    }

    public Collection!EventCorrelationParameter getCorrelationParameters() {
        return correlationParameters;
    }

    public void setCorrelationParameters(Collection!EventCorrelationParameter correlationParameters) {
        this.correlationParameters = correlationParameters;
    }

    public Collection!EventPayload getPayload() {
        return payload;
    }

    public void setPayload(Collection!EventPayload payload) {
        this.payload = payload;
    }

}
