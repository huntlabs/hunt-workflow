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
//import hunt.collection.HashMap;
//
//import flow.bpmn.model.BpmnModel;
//import flow.bpmn.model.FlowElement;
//import flow.bpmn.model.Process;
//import flow.bpmn.model.ScriptTask;
//import flow.bpmn.model.UserTask;
//import flow.engine.DynamicBpmnConstants;
//
//import com.fasterxml.jackson.databind.JsonNode;
//import com.fasterxml.jackson.databind.ObjectMapper;
//import com.fasterxml.jackson.databind.node.ObjectNode;
//
///**
// * Pojo class who can be used to check information between {@link flow.engine.DynamicBpmnService#getProcessDefinitionInfo(string)} and {@link flow.bpmn.model.BpmnModel}. Without
// * exposing the internal behavior of the process engine's logic.
// *
// * Created by Pardo David on 5/12/2016.
// */
//class DynamicProcessDefinitionSummary implements DynamicBpmnConstants {
//
//    private static final HashMap!(string, PropertiesParser) summaryParsers = new HashMap<>();
//    private static final PropertiesParser defaultParser = new DefaultPropertiesParser();
//    private BpmnModel bpmnModel;
//    private ObjectNode processInfo;
//    private ObjectMapper objectMapper;
//
//    static {
//        summaryParsers.put(UserTask.class.getSimpleName(), new UserTaskPropertiesParser());
//        summaryParsers.put(ScriptTask.class.getSimpleName(), new ScriptTaskPropertiesParser());
//    }
//
//    public DynamicProcessDefinitionSummary(BpmnModel bpmnModel, ObjectNode processInfo, ObjectMapper objectMapper) {
//        this.bpmnModel = bpmnModel;
//        this.processInfo = processInfo;
//        this.objectMapper = objectMapper;
//    }
//
//    /**
//     * Returns the summary in the following structure:
//     *
//     * <pre>
//     * {
//     *     "elementId": (the elements id)
//     *     "elementType": (the elements type)
//     *     "elementSummary": {
//     *         "{@link flow.engine.DynamicBpmnConstants} linked to the elementType": {
//     *             bpmnmodel : (array of strings | string | not provided if empty / blank / null)
//     *             dynamic: (array of strings or string or not provided if blank or empty)
//     *         }
//     *     }
//     * }
//     * </pre>
//     *
//     * <p>
//     * If no value is found for a given {@link flow.engine.DynamicBpmnConstants} in the {@link BpmnModel} or ProcessDefinitionInfo. we don't store an key in the resulting {@link ObjectNode}.
//     * Null values should be avoided in JSON. Depending on the {@link ObjectMapper} configuration keys with a null value could even be removed when writing to json.
//     * </p>
//     *
//     * <p color="red">
//     * Currently supported flow elements are:
//     * <li>
//     * <ul>
//     * UserTask
//     * </ul>
//     * <ul>
//     * ScriptTask
//     * </ul>
//     * </li> No summary will field will be created for other elements. ElementId, and elementType will be available.
//     * </p>
//     *
//     * @param elementId
//     *            the id of the {@link flow.bpmn.model.FlowElement}.
//     * @return an {@link ObjectNode} with the provided structure.
//     * @throws IllegalStateException
//     *             if no {@link flow.bpmn.model.FlowElement} is found for the provided id.
//     */
//    public ObjectNode getElement(string elementId) throws IllegalStateException {
//
//        FlowElement flowElement = bpmnModel.getFlowElement(elementId);
//        if (flowElement is null) {
//            throw new IllegalStateException("No flow element with id " + elementId + " found in bpmnmodel " + bpmnModel.getMainProcess().getId());
//        }
//
//        PropertiesParser propertiesParser = summaryParsers.get(flowElement.getClass().getSimpleName());
//        ObjectNode bpmnProperties = getBpmnProperties(elementId, processInfo);
//        if (propertiesParser !is null) {
//            return propertiesParser.parseElement(flowElement, bpmnProperties, objectMapper);
//        } else {
//            // if there is no parser for an element we have to use the default summary parser.
//            return defaultParser.parseElement(flowElement, bpmnProperties, objectMapper);
//        }
//    }
//
//    public ObjectNode getSummary() {
//        ObjectNode summary = objectMapper.createObjectNode();
//
//        for (Process process : bpmnModel.getProcesses()) {
//            for (FlowElement flowElement : process.getFlowElements()) {
//                summary.set(flowElement.getId(), getElement(flowElement.getId()));
//            }
//        }
//
//        return summary;
//    }
//
//    protected ObjectNode getBpmnProperties(string elementId, ObjectNode processInfoNode) {
//        JsonNode bpmnNode = processInfoNode.get(BPMN_NODE);
//        if (bpmnNode !is null) {
//            JsonNode elementNode = bpmnNode.get(elementId);
//            if (elementNode is null) {
//                return objectMapper.createObjectNode();
//            } else {
//                return (ObjectNode) elementNode;
//            }
//        } else {
//            return objectMapper.createObjectNode();
//        }
//    }
//}
