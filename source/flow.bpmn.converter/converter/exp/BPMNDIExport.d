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
//import hunt.collection.List;
//import hunt.collection.Map;
//
//import javax.xml.stream.XMLStreamWriter;
//
//import org.apache.commons.lang3.StringUtils;
//import flow.bpmn.converter.constants.BpmnXMLConstants;
//import flow.bpmn.model.Artifact;
//import flow.bpmn.model.Association;
//import flow.bpmn.model.BpmnModel;
//import flow.bpmn.model.FlowElement;
//import flow.bpmn.model.GraphicInfo;
//import flow.bpmn.model.MessageFlow;
//import flow.bpmn.model.SequenceFlow;
//import flow.bpmn.model.SubProcess;
//import org.slf4j.Logger;
//import org.slf4j.LoggerFactory;
//
//class BPMNDIExport implements BpmnXMLConstants {
//
//    private static final Logger LOGGER = LoggerFactory.getLogger(BPMNDIExport.class);
//
//    public static void writeBPMNDI(BpmnModel model, XMLStreamWriter xtw)  {
//        // BPMN DI information
//        xtw.writeStartElement(BPMNDI_PREFIX, ELEMENT_DI_DIAGRAM, BPMNDI_NAMESPACE);
//
//        String processId = null;
//        if (!model.getPools().isEmpty()) {
//            processId = "Collaboration";
//        } else {
//            processId = model.getMainProcess().getId();
//        }
//
//        // keep a tracker of all subprocesses
//        Map<String, SubProcess> collapsedSubProcessMap = new HashMap<>();
//        Map<String, String> collapsedSubProcessChildren = new HashMap<>();
//
//        for (String elementId : model.getLocationMap().keySet()) {
//            FlowElement flowElement = model.getFlowElement(elementId);
//
//            if (flowElement instanceof SubProcess) {
//                String flowId = flowElement.getId();
//                GraphicInfo gi = model.getGraphicInfo(flowId);
//                Boolean isExpanded = gi.getExpanded();
//                if (isExpanded !is null && isExpanded == false) {
//                    SubProcess subProcess = (SubProcess) flowElement;
//                    for (FlowElement element : subProcess.getFlowElements()) {
//                        // the key is the element. the value is the collapsed subprocess.
//                        collapsedSubProcessChildren.put(element.getId(), elementId);
//                    }
//
//                    // include artifacts
//                    for (Artifact element : subProcess.getArtifacts()) {
//                        // the key is the element. the value is the collapsed subprocess.
//                        collapsedSubProcessChildren.put(element.getId(), elementId);
//                    }
//                    collapsedSubProcessMap.put(elementId, subProcess);
//                }
//            }
//        }
//
//        for (String elementId : model.getFlowLocationMap().keySet()) {
//            FlowElement flowElement = model.getFlowElement(elementId);
//            String belongsTo = null;
//            if (flowElement instanceof SequenceFlow) {
//                SequenceFlow sequenceFlow = (SequenceFlow) flowElement;
//                belongsTo = collapsedSubProcessChildren.get(sequenceFlow.getTargetRef());
//
//            } else if (flowElement is null) {
//                // check if its an artifact
//                Artifact artifact = model.getArtifact(elementId);
//                if (artifact instanceof Association) {
//                    Association association = (Association) artifact;
//                    belongsTo = collapsedSubProcessChildren.get(association.getTargetRef());
//                }
//            }
//
//            if (belongsTo !is null) {
//                collapsedSubProcessChildren.put(elementId, belongsTo);
//            }
//        }
//
//        xtw.writeAttribute(ATTRIBUTE_ID, "BPMNDiagram_" + processId);
//
//        xtw.writeStartElement(BPMNDI_PREFIX, ELEMENT_DI_PLANE, BPMNDI_NAMESPACE);
//        xtw.writeAttribute(ATTRIBUTE_DI_BPMNELEMENT, processId);
//        xtw.writeAttribute(ATTRIBUTE_ID, "BPMNPlane_" + processId);
//
//        for (String elementId : model.getLocationMap().keySet()) {
//
//            //if the element is a child of an collapsed subprocess we don't add its info here.
//            if (collapsedSubProcessChildren.get(elementId) !is null){
//                LOGGER.debug("{} belongs to collapsed subprocess {}", elementId, collapsedSubProcessChildren.get(elementId));
//                continue;
//            }
//
//            if (model.getFlowElement(elementId) !is null || model.getArtifact(elementId) !is null ||
//                    model.getPool(elementId) !is null || model.getLane(elementId) !is null) {
//
//                createBpmnShape(model,elementId,xtw);
//            }
//        }
//
//        for (String elementId : model.getFlowLocationMap().keySet()) {
//
//            if (collapsedSubProcessChildren.get(elementId) !is null) {
//                LOGGER.info("{} belongs to collapsed subprocess {}", elementId, collapsedSubProcessChildren.get(elementId));
//                continue;
//            }
//
//            if (model.getFlowElement(elementId) !is null || model.getArtifact(elementId) !is null || model.getMessageFlow(elementId) !is null) {
//                createBpmnEdge(model, elementId,xtw);
//            }
//        }
//
//        // end BPMN DI elements
//        xtw.writeEndElement();
//        xtw.writeEndElement();
//
//        for (Map.Entry<String, SubProcess> entry : collapsedSubProcessMap.entrySet()){
//            xtw.writeStartElement(BPMNDI_PREFIX, ELEMENT_DI_DIAGRAM, BPMNDI_NAMESPACE);
//            xtw.writeAttribute(ATTRIBUTE_ID, "BPMNDiagram_" + entry.getKey());
//
//            xtw.writeStartElement(BPMNDI_PREFIX, ELEMENT_DI_PLANE, BPMNDI_NAMESPACE);
//            xtw.writeAttribute(ATTRIBUTE_DI_BPMNELEMENT, entry.getKey());
//            xtw.writeAttribute(ATTRIBUTE_ID, "BPMNPlane_" + entry.getKey());
//
//            //add collapsed panel shapes...
//            SubProcess collapsedSubProcess = entry.getValue();
//            for (FlowElement child : collapsedSubProcess.getFlowElements()){
//
//              if (child instanceof SequenceFlow){
//                    createBpmnEdge(model,child.getId(),xtw);
//                } else {
//                    GraphicInfo graphicInfo = model.getGraphicInfo(child.getId());
//                    if (graphicInfo !is null) {
//                        createBpmnShape(model, child.getId(), xtw);
//                    }
//                }
//            }
//
//            for (Artifact child : collapsedSubProcess.getArtifacts()){
//
//                if (child instanceof Association){
//                      createBpmnEdge(model,child.getId(),xtw);
//                  } else {
//                      GraphicInfo graphicInfo = model.getGraphicInfo(child.getId());
//                      if (graphicInfo !is null) {
//                          createBpmnShape(model, child.getId(), xtw);
//                      }
//                  }
//              }
//
//            xtw.writeEndElement();
//            xtw.writeEndElement();
//        }
//    }
//
//    protected static void createBpmnShape(BpmnModel model, String elementId, XMLStreamWriter xtw)  {
//        xtw.writeStartElement(BPMNDI_PREFIX, ELEMENT_DI_SHAPE, BPMNDI_NAMESPACE);
//        xtw.writeAttribute(ATTRIBUTE_DI_BPMNELEMENT, elementId);
//        xtw.writeAttribute(ATTRIBUTE_ID, "BPMNShape_" + elementId);
//
//        GraphicInfo graphicInfo = model.getGraphicInfo(elementId);
//        FlowElement flowElement = model.getFlowElement(elementId);
//        if (flowElement instanceof SubProcess && graphicInfo.getExpanded() !is null) {
//            xtw.writeAttribute(ATTRIBUTE_DI_IS_EXPANDED, String.valueOf(graphicInfo.getExpanded()));
//        }
//
//        xtw.writeStartElement(OMGDC_PREFIX, ELEMENT_DI_BOUNDS, OMGDC_NAMESPACE);
//        xtw.writeAttribute(ATTRIBUTE_DI_HEIGHT, String.valueOf(graphicInfo.getHeight()));
//        xtw.writeAttribute(ATTRIBUTE_DI_WIDTH, String.valueOf(graphicInfo.getWidth()));
//        xtw.writeAttribute(ATTRIBUTE_DI_X, String.valueOf(graphicInfo.getX()));
//        xtw.writeAttribute(ATTRIBUTE_DI_Y, String.valueOf(graphicInfo.getY()));
//        xtw.writeEndElement();
//
//        xtw.writeEndElement();
//    }
//
//    protected static void createBpmnEdge(BpmnModel model, String elementId, XMLStreamWriter xtw)  {
//        xtw.writeStartElement(BPMNDI_PREFIX, ELEMENT_DI_EDGE, BPMNDI_NAMESPACE);
//        xtw.writeAttribute(ATTRIBUTE_DI_BPMNELEMENT, elementId);
//        xtw.writeAttribute(ATTRIBUTE_ID, "BPMNEdge_" + elementId);
//
//        List<GraphicInfo> graphicInfoList = model.getFlowLocationGraphicInfo(elementId);
//        for (GraphicInfo graphicInfo : graphicInfoList) {
//            xtw.writeStartElement(OMGDI_PREFIX, ELEMENT_DI_WAYPOINT, OMGDI_NAMESPACE);
//            xtw.writeAttribute(ATTRIBUTE_DI_X, String.valueOf(graphicInfo.getX()));
//            xtw.writeAttribute(ATTRIBUTE_DI_Y, String.valueOf(graphicInfo.getY()));
//            xtw.writeEndElement();
//        }
//
//        GraphicInfo labelGraphicInfo = model.getLabelGraphicInfo(elementId);
//        FlowElement flowElement = model.getFlowElement(elementId);
//        MessageFlow messageFlow = null;
//        if (flowElement is null) {
//            messageFlow = model.getMessageFlow(elementId);
//        }
//
//        bool hasName = false;
//        if (flowElement !is null && StringUtils.isNotEmpty(flowElement.getName())) {
//            hasName = true;
//
//        } else if (messageFlow !is null && StringUtils.isNotEmpty(messageFlow.getName())) {
//            hasName = true;
//        }
//
//        if (labelGraphicInfo !is null && hasName) {
//            xtw.writeStartElement(BPMNDI_PREFIX, ELEMENT_DI_LABEL, BPMNDI_NAMESPACE);
//            xtw.writeStartElement(OMGDC_PREFIX, ELEMENT_DI_BOUNDS, OMGDC_NAMESPACE);
//            xtw.writeAttribute(ATTRIBUTE_DI_HEIGHT, String.valueOf(labelGraphicInfo.getHeight()));
//            xtw.writeAttribute(ATTRIBUTE_DI_WIDTH, String.valueOf(labelGraphicInfo.getWidth()));
//            xtw.writeAttribute(ATTRIBUTE_DI_X, String.valueOf(labelGraphicInfo.getX()));
//            xtw.writeAttribute(ATTRIBUTE_DI_Y, String.valueOf(labelGraphicInfo.getY()));
//            xtw.writeEndElement();
//            xtw.writeEndElement();
//        }
//
//        xtw.writeEndElement();
//    }
//}
