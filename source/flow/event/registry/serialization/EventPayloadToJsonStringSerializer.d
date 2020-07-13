///* Licensed under the Apache License, Version 2.0 (the "License");
// * you may not use this file except in compliance with the License.
// * You may obtain a copy of the License at
// *
// *      http://www.apache.org/licenses/LICENSE-2.0
// *
// * Unless required by applicable law or agreed to in writing, software
// * distributed under the License is distributed on an "AS IS" BASIS,
// * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// * See the License for the specific language governing permissions and
// * limitations under the License.
// */
//
//
//import hunt.collection;
//
//import flow.common.api.FlowableException;
//import flow.common.api.FlowableIllegalArgumentException;
//import flow.event.registry.api.OutboundEventSerializer;
//import flow.event.registry.api.model.EventPayloadTypes;
//import flow.event.registry.api.runtime.EventInstance;
//import flow.event.registry.api.runtime.EventPayloadInstance;
//
//import com.fasterxml.jackson.core.JsonProcessingException;
//import com.fasterxml.jackson.databind.ObjectMapper;
//import com.fasterxml.jackson.databind.node.ObjectNode;
//
///**
// * Simple {@link EventInstance} serialization that maps all {@link flow.event.registry.api.runtime.EventPayloadInstance}'s
// * to a json which gets transformed to a String.
// *
// * @author Joram Barrez
// */
//class EventPayloadToJsonStringSerializer implements OutboundEventSerializer {
//
//    protected ObjectMapper objectMapper = new ObjectMapper();
//
//    @Override
//    public String serialize(EventInstance eventInstance) {
//        ObjectNode objectNode = objectMapper.createObjectNode();
//
//        Collection!EventPayloadInstance payloadInstances = eventInstance.getPayloadInstances();
//        for (EventPayloadInstance payloadInstance : payloadInstances) {
//
//            String definitionType = payloadInstance.getDefinitionType();
//            if (EventPayloadTypes.STRING.equals(definitionType)) {
//                objectNode.put(payloadInstance.getDefinitionName(), (String) payloadInstance.getValue());
//
//            } else if (EventPayloadTypes.DOUBLE.equals(definitionType)) {
//                objectNode.put(payloadInstance.getDefinitionName(), (Double) payloadInstance.getValue());
//
//            } else if (EventPayloadTypes.INTEGER.equals(definitionType)) {
//                objectNode.put(payloadInstance.getDefinitionName(), (Integer) payloadInstance.getValue());
//
//            } else if (EventPayloadTypes.BOOLEAN.equals(definitionType)) {
//                objectNode.put(payloadInstance.getDefinitionName(), (Boolean) payloadInstance.getValue());
//
//            } else {
//                throw new FlowableIllegalArgumentException("Unsupported event payload instance type: " + definitionType);
//            }
//
//        }
//
//        try {
//            return objectMapper.writeValueAsString(objectNode);
//        } catch (JsonProcessingException e) {
//            throw new FlowableException("Could not serialize event to json string", e);
//        }
//    }
//
//}
