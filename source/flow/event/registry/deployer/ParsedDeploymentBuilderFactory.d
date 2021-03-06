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

//module flow.event.registry.deployer.ParsedDeploymentBuilderFactory;
//
//import flow.event.registry.parser.ChannelDefinitionParseFactory;
//import flow.event.registry.parser.EventDefinitionParseFactory;
//import flow.event.registry.persistence.entity.EventDeploymentEntity;
//
//class ParsedDeploymentBuilderFactory {
//
//    protected EventDefinitionParseFactory eventParseFactory;
//    protected ChannelDefinitionParseFactory channelParseFactory;
//
//    public ParsedDeploymentBuilder getBuilderForDeployment(EventDeploymentEntity deployment) {
//        return new ParsedDeploymentBuilder(deployment, eventParseFactory, channelParseFactory);
//    }
//
//    public EventDefinitionParseFactory getEventParseFactory() {
//        return eventParseFactory;
//    }
//
//    public void setEventParseFactory(EventDefinitionParseFactory eventParseFactory) {
//        this.eventParseFactory = eventParseFactory;
//    }
//
//    public ChannelDefinitionParseFactory getChannelParseFactory() {
//        return channelParseFactory;
//    }
//
//    public void setChannelParseFactory(ChannelDefinitionParseFactory channelParseFactory) {
//        this.channelParseFactory = channelParseFactory;
//    }
//
//}
