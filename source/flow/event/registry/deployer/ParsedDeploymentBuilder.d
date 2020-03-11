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


import java.io.ByteArrayInputStream;
import hunt.collection.ArrayList;
import hunt.collection.LinkedHashMap;
import hunt.collection.List;
import hunt.collection.Map;

import flow.event.registry.parser.ChannelDefinitionParse;
import flow.event.registry.parser.ChannelDefinitionParseFactory;
import flow.event.registry.parser.EventDefinitionParse;
import flow.event.registry.parser.EventDefinitionParseFactory;
import flow.event.registry.persistence.entity.ChannelDefinitionEntity;
import flow.event.registry.persistence.entity.EventDefinitionEntity;
import flow.event.registry.persistence.entity.EventDeploymentEntity;
import flow.event.registry.persistence.entity.EventResourceEntity;
import flow.event.registry.util.CommandContextUtil;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

class ParsedDeploymentBuilder {

    private static final Logger LOGGER = LoggerFactory.getLogger(ParsedDeploymentBuilder.class);

    public static final String[] EVENT_RESOURCE_SUFFIXES = new String[] { "event" };
    public static final String[] CHANNEL_RESOURCE_SUFFIXES = new String[] { "channel" };

    protected EventDeploymentEntity deployment;
    protected EventDefinitionParseFactory eventDefinitionParseFactory;
    protected ChannelDefinitionParseFactory channelDefinitionParseFactory;

    public ParsedDeploymentBuilder(EventDeploymentEntity deployment, EventDefinitionParseFactory eventDefinitionParseFactory,
                    ChannelDefinitionParseFactory channelDefinitionParseFactory) {

        this.deployment = deployment;
        this.eventDefinitionParseFactory = eventDefinitionParseFactory;
        this.channelDefinitionParseFactory = channelDefinitionParseFactory;
    }

    public ParsedDeployment build() {
        List<EventDefinitionEntity> eventDefinitions = new ArrayList<>();
        List<ChannelDefinitionEntity> channelDefinitions = new ArrayList<>();
        Map<EventDefinitionEntity, EventDefinitionParse> eventDefinitionToParseMap = new LinkedHashMap<>();
        Map<EventDefinitionEntity, EventResourceEntity> eventDefinitionToResourceMap = new LinkedHashMap<>();
        Map<ChannelDefinitionEntity, ChannelDefinitionParse> channelDefinitionToParseMap = new LinkedHashMap<>();
        Map<ChannelDefinitionEntity, EventResourceEntity> channelDefinitionToResourceMap = new LinkedHashMap<>();

        for (EventResourceEntity resource : deployment.getResources().values()) {
            if (isEventResource(resource.getName())) {
                LOGGER.debug("Processing Event definition resource {}", resource.getName());
                EventDefinitionParse parse = createEventParseFromResource(resource);
                for (EventDefinitionEntity eventDefinition : parse.getEventDefinitions()) {
                    eventDefinitions.add(eventDefinition);
                    eventDefinitionToParseMap.put(eventDefinition, parse);
                    eventDefinitionToResourceMap.put(eventDefinition, resource);
                }

            } else if (isChannelResource(resource.getName())) {
                LOGGER.debug("Processing Channel definition resource {}", resource.getName());
                ChannelDefinitionParse parse = createChannelParseFromResource(resource);
                for (ChannelDefinitionEntity channelDefinition : parse.getChannelDefinitions()) {
                    channelDefinitions.add(channelDefinition);
                    channelDefinitionToParseMap.put(channelDefinition, parse);
                    channelDefinitionToResourceMap.put(channelDefinition, resource);
                }
            }
        }

        return new ParsedDeployment(deployment, eventDefinitions, channelDefinitions, eventDefinitionToParseMap, eventDefinitionToResourceMap,
                        channelDefinitionToParseMap, channelDefinitionToResourceMap);
    }

    protected EventDefinitionParse createEventParseFromResource(EventResourceEntity resource) {
        String resourceName = resource.getName();
        ByteArrayInputStream inputStream = new ByteArrayInputStream(resource.getBytes());

        EventDefinitionParse eventParse = eventDefinitionParseFactory.createParse()
                .sourceInputStream(inputStream)
                .setSourceSystemId(resourceName)
                .deployment(deployment)
                .name(resourceName);

        eventParse.execute(CommandContextUtil.getEventRegistryConfiguration());
        return eventParse;
    }

    protected ChannelDefinitionParse createChannelParseFromResource(EventResourceEntity resource) {
        String resourceName = resource.getName();
        ByteArrayInputStream inputStream = new ByteArrayInputStream(resource.getBytes());

        ChannelDefinitionParse eventParse = channelDefinitionParseFactory.createParse()
                .sourceInputStream(inputStream)
                .setSourceSystemId(resourceName)
                .deployment(deployment)
                .name(resourceName);

        eventParse.execute(CommandContextUtil.getEventRegistryConfiguration());
        return eventParse;
    }

    protected boolean isEventResource(String resourceName) {
        for (String suffix : EVENT_RESOURCE_SUFFIXES) {
            if (resourceName.endsWith(suffix)) {
                return true;
            }
        }

        return false;
    }

    protected boolean isChannelResource(String resourceName) {
        for (String suffix : CHANNEL_RESOURCE_SUFFIXES) {
            if (resourceName.endsWith(suffix)) {
                return true;
            }
        }

        return false;
    }

}
