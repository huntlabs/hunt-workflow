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
module flow.event.registry.payload.JsonFieldToMapPayloadExtractor;

//import hunt.collection;
//import java.util.stream.Collectors;
//
//import flow.event.registry.api.InboundEventPayloadExtractor;
//import flow.event.registry.api.model.EventPayloadTypes;
//import flow.event.registry.api.runtime.EventCorrelationParameterInstance;
//import flow.event.registry.api.runtime.EventPayloadInstance;
//import flow.event.registry.runtime.EventCorrelationParameterInstanceImpl;
//import flow.event.registry.runtime.EventPayloadInstanceImpl;
//import flow.event.registry.model.EventModel;
//import org.slf4j.Logger;
//import org.slf4j.LoggerFactory;
//
//import com.fasterxml.jackson.databind.JsonNode;
//
///**
// * @author Joram Barrez
// * @author Filip Hrisafov
// */
//class JsonFieldToMapPayloadExtractor implements InboundEventPayloadExtractor<JsonNode> {
//
//    private static final Logger LOGGER = LoggerFactory.getLogger(JsonFieldToMapPayloadExtractor.class);
//
//    @Override
//    public Collection!EventCorrelationParameterInstance extractCorrelationParameters(EventModel eventDefinition, JsonNode event) {
//        return eventDefinition.getCorrelationParameters().stream()
//            .filter(parameterDefinition -> event.has(parameterDefinition.getName()))
//            .map(parameterDefinition -> new EventCorrelationParameterInstanceImpl(parameterDefinition, getPayloadValue(event, parameterDefinition.getName(), parameterDefinition.getType())))
//            .collect(Collectors.toList());
//    }
//
//    @Override
//    public Collection!EventPayloadInstance extractPayload(EventModel eventDefinition, JsonNode event) {
//        return eventDefinition.getPayload().stream()
//            .filter(payloadDefinition -> event.has(payloadDefinition.getName()))
//            .map(payloadDefinition -> new EventPayloadInstanceImpl(payloadDefinition, getPayloadValue(event, payloadDefinition.getName(), payloadDefinition.getType())))
//            .collect(Collectors.toList());
//    }
//
//    protected Object getPayloadValue(JsonNode event, String definitionName, String definitionType) {
//        JsonNode parameterNode = event.get(definitionName);
//        Object value = null;
//
//        if (EventPayloadTypes.STRING.equals(definitionType)) {
//            value = parameterNode.asText();
//
//        } else if (EventPayloadTypes.BOOLEAN.equals(definitionType)) {
//            value = parameterNode.booleanValue();
//
//        } else if (EventPayloadTypes.INTEGER.equals(definitionType)) {
//            value = parameterNode.intValue();
//
//        } else if (EventPayloadTypes.DOUBLE.equals(definitionType)) {
//            value = parameterNode.doubleValue();
//
//        } else {
//            LOGGER.warn("Unsupported payload type: {} ", definitionType);
//            value = parameterNode.asText();
//
//        }
//
//        return value;
//    }
//
//}
