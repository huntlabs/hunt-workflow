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

module flow.event.registry.model.EventModelBuilderImpl;

import hunt.collection;
import hunt.collection.HashSet;
import hunt.collection.LinkedHashMap;
import hunt.collection.Map;
import hunt.Exceptions;

//import org.apache.commons.lang3.stringUtils;
import flow.common.api.FlowableIllegalArgumentException;
import flow.event.registry.api.EventDeployment;
import flow.event.registry.api.model.EventModelBuilder;
import flow.event.registry.EventRepositoryServiceImpl;
//import flow.event.registry.json.converter.EventJsonConverter;
import flow.event.registry.model.EventCorrelationParameter;
import flow.event.registry.model.EventModel;
import flow.event.registry.model.EventPayload;

/**
 * @author Joram Barrez
 */
class EventModelBuilderImpl : EventModelBuilder {

    protected EventRepositoryServiceImpl eventRepository;

    protected string deploymentName;
    protected string resourceName;
    protected string category;
    protected string parentDeploymentId;
    protected string deploymentTenantId;

    protected string key;
    protected Collection!string inboundChannelKeys;
    protected Collection!string outboundChannelKeys;
    protected Map!(string, EventCorrelationParameter) correlationParameterDefinitions ;//= new LinkedHashMap<>();
    protected Map!(string, EventPayload) eventPayloadDefinitions ;// = new LinkedHashMap<>();

    this(EventRepositoryServiceImpl eventRepository) {
        this.eventRepository = eventRepository;
        correlationParameterDefinitions = new LinkedHashMap!(string, EventCorrelationParameter);
        eventPayloadDefinitions = new LinkedHashMap!(string, EventPayload);
    }


    public EventModelBuilder key(string key) {
        this.key = key;
        return this;
    }


    public EventModelBuilder deploymentName(string deploymentName) {
        this.deploymentName = deploymentName;
        return this;
    }


    public EventModelBuilder resourceName(string resourceName) {
        this.resourceName = resourceName;
        return this;
    }


    public EventModelBuilder category(string category) {
        this.category = category;
        return this;
    }


    public EventModelBuilder parentDeploymentId(string parentDeploymentId) {
        this.parentDeploymentId = parentDeploymentId;
        return this;
    }


    public EventModelBuilder deploymentTenantId(string deploymentTenantId) {
        this.deploymentTenantId = deploymentTenantId;
        return this;
    }


    public EventModelBuilder inboundChannelKey(string channelKey) {
        if (inboundChannelKeys is null) {
            inboundChannelKeys = new HashSet!string();
        }
        inboundChannelKeys.add(channelKey);
        return this;
    }


    public EventModelBuilder inboundChannelKeys(Collection!string channelKeys) {
        foreach (string key ; channelKeys)
        {
            inboundChannelKey(key);
        }
        //channelKeys.forEach(this.inboundChannelKey);
        return this;
    }


    public EventModelBuilder outboundChannelKey(string channelKey) {
        if (outboundChannelKeys is null) {
            outboundChannelKeys = new HashSet!string();
        }
        outboundChannelKeys.add(channelKey);
        return this;
    }


    public EventModelBuilder outboundChannelKeys(Collection!string channelKeys) {
        foreach(string key ; channelKeys)
        {
            outboundChannelKey(key);
        }
        //channelKeys.forEach(this.outboundChannelKey);
        return this;
    }


    public EventModelBuilder correlationParameter(string name, string type) {
        correlationParameterDefinitions.put(name, new EventCorrelationParameter(name, type));
        payload(name, type);
        return this;
    }


    public EventModelBuilder payload(string name, string type) {
        eventPayloadDefinitions.put(name, new EventPayload(name, type));
        return this;
    }


    public EventModel createEventModel() {
        return buildEventModel();
    }


    public EventDeployment deploy() {
        implementationMissing(false);
        return null;
        //if (resourceName is null) {
        //    throw new FlowableIllegalArgumentException("A resource name is mandatory");
        //}
        //
        //EventModel eventModel = buildEventModel();
        //
        //EventDeployment eventDeployment = eventRepository.createDeployment()
        //    .name(deploymentName)
        //    .addEventDefinition(resourceName, new EventJsonConverter().convertToJson(eventModel))
        //    .category(category)
        //    .parentDeploymentId(parentDeploymentId)
        //    .tenantId(deploymentTenantId)
        //    .deploy();
        //
        //return eventDeployment;
    }

    protected EventModel buildEventModel() {
        EventModel eventModel = new EventModel();

        if (key !is null && key.value.length != 0) {
            eventModel.setKey(key);
        } else {
            throw new FlowableIllegalArgumentException("An event definition key is mandatory");
        }

        if (inboundChannelKeys !is null) {
            eventModel.setInboundChannelKeys(inboundChannelKeys);
        }

        if (outboundChannelKeys !is null) {
            eventModel.setOutboundChannelKeys(outboundChannelKeys);
        }

        eventModel.getCorrelationParameters().addAll(correlationParameterDefinitions.values());
        eventModel.getPayload().addAll(eventPayloadDefinitions.values());

        return eventModel;
    }
}
