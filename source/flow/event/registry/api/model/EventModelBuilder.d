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
module flow.event.registry.api.model.EventModelBuilder;

import hunt.collection;

import flow.event.registry.api.EventDeployment;
//import flow.event.registry.model.EventCorrelationParameter;
import flow.event.registry.model.EventModel;


/**
 * @author Joram Barrez
 */
interface EventModelBuilder {

    /**
     * Each event type will uniquely be identified with a key
     * (similar to the key of a process/case/decision/... definition),
     * which is typically referenced in process/case/... models.
     */
    EventModelBuilder key(string key);

    /**
     * Set the name for the event deployment.
     */
    EventModelBuilder deploymentName(string deploymentName);

    /**
     * Set the resource name for the event model.
     */
    EventModelBuilder resourceName(string resourceName);

    /**
     * Set the category for the event deployment.
     */
    EventModelBuilder category(string category);

    /**
     * Set the tenant id for the event deployment.
     */
    EventModelBuilder deploymentTenantId(string deploymentTenantId);

    /**
     * Set the parent deployment id for the event deployment.
     */
    EventModelBuilder parentDeploymentId(string parentDeploymentId);

    /**
     * {@link EventModel} can be bound to inbound or outbound channels.
     * Calling this method will bind it to an inbound channel with the given key.
     */
    EventModelBuilder inboundChannelKey(string channelKey);

    /**
     * Allows to set multiple channel keys. See {@link #inboundChannelKey(string)}.
     */
    EventModelBuilder inboundChannelKeys(Collection!string channelKeys);

    /**
     * {@link EventModel} can be bound to inbound or outbound channels.
     * Calling this method will bind it to an inbound channel with the given key.
     */
    EventModelBuilder outboundChannelKey(string channelKey);

    /**
     * Allows to set multiple channel keys. See {@link #inboundChannelKey(string)}.
     */
    EventModelBuilder outboundChannelKeys(Collection!string channelKeys);

    /**
     * Defines one payload element of an event definition.
     * Such payload elements are data that is contained within an event.
     * If certain payload needs to be used to correlate runtime instances,
     * use the {@link #correlationParameter(string, string)} method.
     *
     * One {@link EventModel} typically has multiple such elements.
     */
    EventModelBuilder payload(string name, string type);

    /**
     * Defines one parameters for correlation that can be used in models to map onto.
     * Each correlation parameter is automatically a {@link #payload(string, string)} element.
     *
     * Will create a {@link EventCorrelationParameter} behind the scenes.
     */
    EventModelBuilder correlationParameter(string name, string type);

    /**
     * Creates a new event model, but does not deploy it to the Event registry engine.
     */
    EventModel createEventModel();

    /**
     * Deploys a new event definition for this event model.
     */
    EventDeployment deploy();

}
