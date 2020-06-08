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
module flow.bpmn.converter.converter.BpmnXMLConverter;

//import java.io.ByteArrayOutputStream;
//import java.io.IOException;
//import java.io.InputStreamReader;
//import java.io.OutputStreamWriter;
//import java.io.UnsupportedEncodingException;
import hunt.collection.ArrayList;
import hunt.collection;
import hunt.collection.HashMap;
import hunt.collection.List;
import hunt.collection.Map;
import std.uni;
import hunt.Exceptions;
import flow.bpmn.converter.converter.BaseBpmnXMLConverter;
//import javax.xml.XMLConstants;
//import javax.xml.stream.XMLInputFactory;
//import javax.xml.stream.XMLOutputFactory;
//import javax.xml.stream.XMLStreamException;
//import javax.xml.stream.XMLStreamReader;
//import javax.xml.stream.XMLStreamWriter;
//import javax.xml.transform.stax.StAXSource;
//import javax.xml.transform.stream.StreamSource;
//import javax.xml.validation.Schema;
//import javax.xml.validation.SchemaFactory;
//import javax.xml.validation.Validator;

import flow.bpmn.converter.constants.BpmnXMLConstants;
import flow.bpmn.converter.converter.alfresco.AlfrescoStartEventXMLConverter;
import flow.bpmn.converter.converter.alfresco.AlfrescoUserTaskXMLConverter;
import flow.bpmn.converter.converter.child.DocumentationParser;
import flow.bpmn.converter.converter.child.IOSpecificationParser;
import flow.bpmn.converter.converter.child.MultiInstanceParser;
import flow.bpmn.converter.converter.exp.BPMNDIExport;
import flow.bpmn.converter.converter.exp.CollaborationExport;
import flow.bpmn.converter.converter.exp.DataStoreExport;
import flow.bpmn.converter.converter.exp.DefinitionsRootExport;
import flow.bpmn.converter.converter.exp.EscalationDefinitionExport;
import flow.bpmn.converter.converter.exp.FlowableListenerExport;
import flow.bpmn.converter.converter.exp.MultiInstanceExport;
import flow.bpmn.converter.converter.exp.ProcessExport;
import flow.bpmn.converter.converter.exp.SignalAndMessageDefinitionExport;
import flow.bpmn.converter.converter.parser.BpmnEdgeParser;
import flow.bpmn.converter.converter.parser.BpmnShapeParser;
import flow.bpmn.converter.converter.parser.DataStoreParser;
import flow.bpmn.converter.converter.parser.DefinitionsParser;
import flow.bpmn.converter.converter.parser.ExtensionElementsParser;
import flow.bpmn.converter.converter.parser.ImportParser;
import flow.bpmn.converter.converter.parser.InterfaceParser;
import flow.bpmn.converter.converter.parser.ItemDefinitionParser;
import flow.bpmn.converter.converter.parser.LaneParser;
import flow.bpmn.converter.converter.parser.MessageFlowParser;
import flow.bpmn.converter.converter.parser.MessageParser;
import flow.bpmn.converter.converter.parser.ParticipantParser;
import flow.bpmn.converter.converter.parser.PotentialStarterParser;
import flow.bpmn.converter.converter.parser.ProcessParser;
import flow.bpmn.converter.converter.parser.ResourceParser;
import flow.bpmn.converter.converter.parser.SignalParser;
import flow.bpmn.converter.converter.parser.SubProcessParser;
import flow.bpmn.converter.converter.EndEventXMLConverter;
import flow.bpmn.converter.converter.StartEventXMLConverter;
import flow.bpmn.converter.converter.BusinessRuleTaskXMLConverter;
import flow.bpmn.converter.converter.ManualTaskXMLConverter;
import flow.bpmn.converter.converter.ReceiveTaskXMLConverter;
import flow.bpmn.converter.converter.ScriptTaskXMLConverter;
import flow.bpmn.converter.converter.ServiceTaskXMLConverter;
import flow.bpmn.converter.converter.HttpServiceTaskXMLConverter;
import flow.bpmn.converter.converter.CaseServiceTaskXMLConverter;
import flow.bpmn.converter.converter.SendEventServiceTaskXMLConverter;
import flow.bpmn.converter.converter.SendTaskXMLConverter;
import flow.bpmn.converter.converter.UserTaskXMLConverter;
import flow.bpmn.converter.converter.TaskXMLConverter;
import flow.bpmn.converter.converter.CallActivityXMLConverter;
import flow.bpmn.converter.converter.EventGatewayXMLConverter;
import flow.bpmn.converter.converter.ExclusiveGatewayXMLConverter;
import flow.bpmn.converter.converter.InclusiveGatewayXMLConverter;
import flow.bpmn.converter.converter.ParallelGatewayXMLConverter;
import flow.bpmn.converter.converter.ComplexGatewayXMLConverter;
import flow.bpmn.converter.converter.SequenceFlowXMLConverter;
import flow.bpmn.converter.converter.CatchEventXMLConverter;
import flow.bpmn.converter.converter.ThrowEventXMLConverter;
import flow.bpmn.converter.converter.BoundaryEventXMLConverter;
import flow.bpmn.converter.converter.TextAnnotationXMLConverter;
import flow.bpmn.converter.converter.AssociationXMLConverter;
import flow.bpmn.converter.converter.DataStoreReferenceXMLConverter;
import flow.bpmn.converter.converter.ValuedDataObjectXMLConverter;


import flow.bpmn.converter.converter.util.BpmnXMLUtil;
import flow.bpmn.converter.exceptions.XMLException;
import flow.bpmn.model.Activity;
import flow.bpmn.model.AdhocSubProcess;
import flow.bpmn.model.Artifact;
import flow.bpmn.model.Association;
import flow.bpmn.model.BaseElement;
import flow.bpmn.model.BooleanDataObject;
import flow.bpmn.model.BoundaryEvent;
import flow.bpmn.model.BpmnModel;
import flow.bpmn.model.DateDataObject;
import flow.bpmn.model.DoubleDataObject;
import flow.bpmn.model.EventSubProcess;
import flow.bpmn.model.FlowElement;
import flow.bpmn.model.FlowNode;
import flow.bpmn.model.IntegerDataObject;
import flow.bpmn.model.LongDataObject;
import flow.bpmn.model.Pool;
import flow.bpmn.model.Process;
import flow.bpmn.model.SequenceFlow;
import flow.bpmn.model.StringDataObject;
import flow.bpmn.model.SubProcess;
import flow.bpmn.model.TextAnnotation;
import flow.bpmn.model.Transaction;
import flow.common.api.io.InputStreamProvider;
//import org.xml.sax.SAXException;
import hunt.xml;
import std.concurrency : initOnce;
/**
 * @author Tijs Rademakers
 * @author Joram Barrez
 */
class BpmnXMLConverter : BpmnXMLConstants {


    protected static  string BPMN_XSD = "org/flowable/impl/bpmn/parser/BPMN20.xsd";
    protected static  string DEFAULT_ENCODING = "UTF-8";

    static Map!(string, BaseBpmnXMLConverter) convertersToBpmnMap() {
      __gshared Map!(string, BaseBpmnXMLConverter) inst;
      return initOnce!inst(new HashMap!(string, BaseBpmnXMLConverter));
    }
     static Map!(TypeInfo, BaseBpmnXMLConverter) convertersToXMLMap() {
       __gshared Map!(TypeInfo, BaseBpmnXMLConverter) inst;
       return initOnce!inst(new HashMap!(TypeInfo, BaseBpmnXMLConverter));
     }

    shared static this ()
    {
        addConverter(new EndEventXMLConverter());
        addConverter(new StartEventXMLConverter());

        // tasks
        addConverter(new BusinessRuleTaskXMLConverter());
        addConverter(new ManualTaskXMLConverter());
        addConverter(new ReceiveTaskXMLConverter());
        addConverter(new ScriptTaskXMLConverter());
        addConverter(new ServiceTaskXMLConverter());
        addConverter(new HttpServiceTaskXMLConverter());
        addConverter(new CaseServiceTaskXMLConverter());
        addConverter(new SendEventServiceTaskXMLConverter());
        addConverter(new SendTaskXMLConverter());
        addConverter(new UserTaskXMLConverter());
        addConverter(new TaskXMLConverter());
        addConverter(new CallActivityXMLConverter());

        // gateways
        addConverter(new EventGatewayXMLConverter());
        addConverter(new ExclusiveGatewayXMLConverter());
        addConverter(new InclusiveGatewayXMLConverter());
        addConverter(new ParallelGatewayXMLConverter());
        addConverter(new ComplexGatewayXMLConverter());

        // connectors
        addConverter(new SequenceFlowXMLConverter());

        // catch, throw and boundary event
        addConverter(new CatchEventXMLConverter());
        addConverter(new ThrowEventXMLConverter());
        addConverter(new BoundaryEventXMLConverter());

        // artifacts
        addConverter(new TextAnnotationXMLConverter());
        addConverter(new AssociationXMLConverter());

        // data store reference
        addConverter(new DataStoreReferenceXMLConverter());

        // data objects
        addConverter(new ValuedDataObjectXMLConverter(), typeid(StringDataObject));
        addConverter(new ValuedDataObjectXMLConverter(), typeid(BooleanDataObject));
        addConverter(new ValuedDataObjectXMLConverter(), typeid(IntegerDataObject));
        addConverter(new ValuedDataObjectXMLConverter(), typeid(LongDataObject));
        addConverter(new ValuedDataObjectXMLConverter(), typeid(DoubleDataObject));
        addConverter(new ValuedDataObjectXMLConverter(), typeid(DateDataObject));

        // Alfresco types
        addConverter(new AlfrescoStartEventXMLConverter());
        addConverter(new AlfrescoUserTaskXMLConverter());
    }
    //protected static Map!(string, BaseBpmnXMLConverter) convertersToBpmnMap = new HashMap<>();
    //protected static Map!(TypeInfo, BaseBpmnXMLConverter>) convertersToXMLMap = new HashMap<>();

    //protected ClassLoader classloader;
    protected List!string userTaskFormTypes;
    protected List!string startEventFormTypes;

    //protected BpmnEdgeParser bpmnEdgeParser = new BpmnEdgeParser();
    //protected BpmnShapeParser bpmnShapeParser = new BpmnShapeParser();
    protected DefinitionsParser definitionsParser = new DefinitionsParser();
    protected DocumentationParser documentationParser = new DocumentationParser();
    protected ExtensionElementsParser extensionElementsParser = new ExtensionElementsParser();
    protected ImportParser importParser = new ImportParser();
    protected InterfaceParser interfaceParser = new InterfaceParser();
    protected ItemDefinitionParser itemDefinitionParser = new ItemDefinitionParser();
    protected IOSpecificationParser ioSpecificationParser = new IOSpecificationParser();
    protected DataStoreParser dataStoreParser = new DataStoreParser();
    protected LaneParser laneParser = new LaneParser();
    protected MessageParser messageParser = new MessageParser();
    protected MessageFlowParser messageFlowParser = new MessageFlowParser();
    protected MultiInstanceParser multiInstanceParser = new MultiInstanceParser();
    protected ParticipantParser participantParser = new ParticipantParser();
    //protected PotentialStarterParser potentialStarterParser = new PotentialStarterParser();
    protected ProcessParser processParser = new ProcessParser();
    protected ResourceParser resourceParser = new ResourceParser();
    protected SignalParser signalParser = new SignalParser();
    protected SubProcessParser subProcessParser = new SubProcessParser();

    //static {
    //    // events
    //    addConverter(new EndEventXMLConverter());
    //    addConverter(new StartEventXMLConverter());
    //
    //    // tasks
    //    addConverter(new BusinessRuleTaskXMLConverter());
    //    addConverter(new ManualTaskXMLConverter());
    //    addConverter(new ReceiveTaskXMLConverter());
    //    addConverter(new ScriptTaskXMLConverter());
    //    addConverter(new ServiceTaskXMLConverter());
    //    addConverter(new HttpServiceTaskXMLConverter());
    //    addConverter(new CaseServiceTaskXMLConverter());
    //    addConverter(new SendEventServiceTaskXMLConverter());
    //    addConverter(new SendTaskXMLConverter());
    //    addConverter(new UserTaskXMLConverter());
    //    addConverter(new TaskXMLConverter());
    //    addConverter(new CallActivityXMLConverter());
    //
    //    // gateways
    //    addConverter(new EventGatewayXMLConverter());
    //    addConverter(new ExclusiveGatewayXMLConverter());
    //    addConverter(new InclusiveGatewayXMLConverter());
    //    addConverter(new ParallelGatewayXMLConverter());
    //    addConverter(new ComplexGatewayXMLConverter());
    //
    //    // connectors
    //    addConverter(new SequenceFlowXMLConverter());
    //
    //    // catch, throw and boundary event
    //    addConverter(new CatchEventXMLConverter());
    //    addConverter(new ThrowEventXMLConverter());
    //    addConverter(new BoundaryEventXMLConverter());
    //
    //    // artifacts
    //    addConverter(new TextAnnotationXMLConverter());
    //    addConverter(new AssociationXMLConverter());
    //
    //    // data store reference
    //    addConverter(new DataStoreReferenceXMLConverter());
    //
    //    // data objects
    //    addConverter(new ValuedDataObjectXMLConverter(), stringDataObject.class);
    //    addConverter(new ValuedDataObjectXMLConverter(), BooleanDataObject.class);
    //    addConverter(new ValuedDataObjectXMLConverter(), IntegerDataObject.class);
    //    addConverter(new ValuedDataObjectXMLConverter(), LongDataObject.class);
    //    addConverter(new ValuedDataObjectXMLConverter(), DoubleDataObject.class);
    //    addConverter(new ValuedDataObjectXMLConverter(), DateDataObject.class);
    //
    //    // Alfresco types
    //    addConverter(new AlfrescoStartEventXMLConverter());
    //    addConverter(new AlfrescoUserTaskXMLConverter());
    //}

    public static void addConverter(BaseBpmnXMLConverter converter) {
        addConverter(converter, converter.getBpmnElementType());
    }

    public static void addConverter(BaseBpmnXMLConverter converter, TypeInfo elementType) {
        convertersToBpmnMap.put(converter.getXMLElementName(), converter);
        convertersToXMLMap.put(elementType, converter);
    }

    //public void setClassloader(ClassLoader classloader) {
    //    this.classloader = classloader;
    //}

    public void setUserTaskFormTypes(List!string userTaskFormTypes) {
        this.userTaskFormTypes = userTaskFormTypes;
    }

    public void setStartEventFormTypes(List!string startEventFormTypes) {
        this.startEventFormTypes = startEventFormTypes;
    }

    public void validateModel(InputStreamProvider inputStreamProvider)  {
        //Schema schema = createSchema();
        //
        //Validator validator = schema.newValidator();
        //validator.validate(new StreamSource(inputStreamProvider.getInputStream()));
    }

    //public void validateModel(XMLStreamReader xmlStreamReader)  {
    //    Schema schema = createSchema();
    //
    //    Validator validator = schema.newValidator();
    //    validator.validate(new StAXSource(xmlStreamReader));
    //}

    //protected Schema createSchema() t {
    //    SchemaFactory factory = SchemaFactory.newInstance(XMLConstants.W3C_XML_SCHEMA_NS_URI);
    //    Schema schema = null;
    //    if (classloader !is null) {
    //        schema = factory.newSchema(classloader.getResource(BPMN_XSD));
    //    }
    //
    //    if (schema is null) {
    //        schema = factory.newSchema(BpmnXMLConverter.class.getClassLoader().getResource(BPMN_XSD));
    //    }
    //
    //    if (schema is null) {
    //        throw new XMLException("BPMN XSD could not be found");
    //    }
    //    return schema;
    //}

    public BpmnModel convertToBpmnModel(Document inputStreamProvider, bool validateSchema, bool enableSafeBpmnXml) {
        return convertToBpmnModel(inputStreamProvider, validateSchema, enableSafeBpmnXml, DEFAULT_ENCODING);
    }

    public BpmnModel convertToBpmnModel(Document inputStreamProvider, bool validateSchema, bool enableSafeBpmnXml, string encoding) {

          return convertToBpmnModel(inputStreamProvider);
        //XMLInputFactory xif = XMLInputFactory.newInstance();
        //
        //if (xif.isPropertySupported(XMLInputFactory.IS_REPLACING_ENTITY_REFERENCES)) {
        //    xif.setProperty(XMLInputFactory.IS_REPLACING_ENTITY_REFERENCES, false);
        //}
        //
        //if (xif.isPropertySupported(XMLInputFactory.IS_SUPPORTING_EXTERNAL_ENTITIES)) {
        //    xif.setProperty(XMLInputFactory.IS_SUPPORTING_EXTERNAL_ENTITIES, false);
        //}
        //
        //if (xif.isPropertySupported(XMLInputFactory.SUPPORT_DTD)) {
        //    xif.setProperty(XMLInputFactory.SUPPORT_DTD, false);
        //}
        //
        //if (validateSchema) {
        //    try (InputStreamReader in = new InputStreamReader(inputStreamProvider.getInputStream(), encoding)) {
        //        if (!enableSafeBpmnXml) {
        //            validateModel(inputStreamProvider);
        //        } else {
        //            validateModel(xif.createXMLStreamReader(in));
        //        }
        //    } catch (UnsupportedEncodingException e) {
        //        throw new XMLException("The bpmn 2.0 xml is not properly encoded", e);
        //    } catch(XMLStreamException e){
        //        throw new XMLException("Error while reading the BPMN 2.0 XML", e);
        //    } catch(Exception e){
        //        throw new XMLException(e.getMessage(), e);
        //    }
        //}
        //// The input stream is closed after schema validation
        //try (InputStreamReader in = new InputStreamReader(inputStreamProvider.getInputStream(), encoding)) {
        //    // XML conversion
        //    return convertToBpmnModel(xif.createXMLStreamReader(in));
        //} catch (UnsupportedEncodingException e) {
        //    throw new XMLException("The bpmn 2.0 xml is not properly encoded", e);
        //} catch (XMLStreamException e) {
        //    throw new XMLException("Error while reading the BPMN 2.0 XML", e);
        //} catch (IOException e) {
        //    throw new XMLException(e.getMessage(), e);
        //}
    }

    public BpmnModel convertToBpmnModel(Element xtr) {
        BpmnModel model = new BpmnModel();
        model.setStartEventFormTypes(startEventFormTypes);
        model.setUserTaskFormTypes(userTaskFormTypes);
          Process activeProcess = new Process();
          List!SubProcess activeSubProcessList = new ArrayList!SubProcess();
          Element no = xtr.firstNode();
          Element node = no.nextSibling.firstNode();
          if (node !is null && ELEMENT_PROCESS == node.getName())
          {
              Process process = processParser.parse(node, model);
              if (process !is null) {
                activeProcess = process;
                // copy over anything already parsed
                process.setAttributes(activeProcess.getAttributes());
                process.setDocumentation(activeProcess.getDocumentation());
                process.setExtensionElements(activeProcess.getExtensionElements());
              }
          }
          Element element =  node.firstNode;
          while (element !is null) {
              if ((ELEMENT_SUBPROCESS == (element.getName()) ||
                      ELEMENT_TRANSACTION == (element.getName()) ||
                      ELEMENT_ADHOC_SUBPROCESS == (element.getName()))) {

                  activeSubProcessList.remove(activeSubProcessList.size() - 1);
              }

              //if (!xtr.isStartElement()) {
              //    continue;
              //}

              if (ELEMENT_DEFINITIONS == (element.getName())) {
                  definitionsParser.parse(element, model);

              } else if (ELEMENT_RESOURCE == (element.getName())) {
                  resourceParser.parse(element, model);

              } else if (ELEMENT_SIGNAL == (element.getName())) {
                  signalParser.parse(element, model);

              } else if (ELEMENT_MESSAGE == (element.getName())) {
                  messageParser.parse(element, model);

              } else if (ELEMENT_ERROR == (element.getName())) {
                  auto att =  element.firstAttribute(ATTRIBUTE_ID);
                  if (att !is null && att.getValue().length != 0) {
                      model.addError(att.getValue(), element.firstAttribute(ATTRIBUTE_ERROR_CODE).getValue());
                  }

              } else if (ELEMENT_ESCALATION == (element.getName())) {
                  auto att =  element.firstAttribute(ATTRIBUTE_ID);
                  if (att !is null && att.getValue().length != 0) {
                      model.addEscalation(att.getValue(), element.firstAttribute(ATTRIBUTE_ESCALATION_CODE).getValue(),
                      element.firstAttribute(ATTRIBUTE_NAME).getValue());
                  }

              } else if (ELEMENT_IMPORT == (element.getName())) {
                  importParser.parse(element, model);

              } else if (ELEMENT_ITEM_DEFINITION == (element.getName())) {
                  itemDefinitionParser.parse(element, model);

              } else if (ELEMENT_DATA_STORE == (element.getName())) {
                  dataStoreParser.parse(element, model);

              } else if (ELEMENT_INTERFACE == (element.getName())) {
                  interfaceParser.parse(element, model);

              } else if (ELEMENT_IOSPECIFICATION == (element.getName())) {
                  ioSpecificationParser.parseChildElement(element, activeProcess, model);

              } else if (ELEMENT_PARTICIPANT == (element.getName())) {
                  participantParser.parse(element, model);

              } else if (ELEMENT_MESSAGE_FLOW == (element.getName())) {
                  messageFlowParser.parse(element, model);

              }
              //else if (ELEMENT_PROCESS (xtr.getLocalName())) {
              //
              //    Process process = processParser.parse(xtr, model);
              //    if (process !is null) {
              //        activeProcess = process;
              //        // copy over anything already parsed
              //        process.setAttributes(activeProcess.getAttributes());
              //        process.setDocumentation(activeProcess.getDocumentation());
              //        process.setExtensionElements(activeProcess.getExtensionElements());
              //    }
              //
              //}
              else if (ELEMENT_POTENTIAL_STARTER == (element.getName())) {
                  implementationMissing(false);
                 // potentialStarterParser.parse(element, activeProcess);

              } else if (ELEMENT_LANE == (element.getName())) {
                  laneParser.parse(element, activeProcess, model);

              } else if (ELEMENT_DOCUMENTATION == (element.getName())) {

                  BaseElement parentElement = null;
                  if (!activeSubProcessList.isEmpty()) {
                      parentElement = activeSubProcessList.get(activeSubProcessList.size() - 1);
                  } else if (activeProcess !is null) {
                      parentElement = activeProcess;
                  }
                  documentationParser.parseChildElement(element, parentElement, model);

              } else if (activeProcess is null && ELEMENT_TEXT_ANNOTATION == (element.getName())) {
                  string elementId = element.firstAttribute(ATTRIBUTE_ID) is null ? "" : element.firstAttribute(ATTRIBUTE_ID).getValue();
                  TextAnnotation textAnnotation = cast(TextAnnotation) new TextAnnotationXMLConverter().convertXMLToElement(element, model);
                  textAnnotation.setId(elementId);
                  model.getGlobalArtifacts().add(textAnnotation);

              } else if (activeProcess is null && ELEMENT_ASSOCIATION == (element.getName())) {
                  string elementId = element.firstAttribute(ATTRIBUTE_ID) is null ? "" : element.firstAttribute(ATTRIBUTE_ID).getValue();
                  Association association = cast(Association) new AssociationXMLConverter().convertXMLToElement(element, model);
                  association.setId(elementId);
                  model.getGlobalArtifacts().add(association);

              } else if (ELEMENT_EXTENSIONS == (element.getName())) {
                  extensionElementsParser.parse(element, activeSubProcessList, activeProcess, model);

              } else if (ELEMENT_SUBPROCESS == (element.getName()) || ELEMENT_TRANSACTION == (element.getName()) || ELEMENT_ADHOC_SUBPROCESS == (element.getName())) {
                  subProcessParser.parse(element, activeSubProcessList, activeProcess);

              } else if (ELEMENT_COMPLETION_CONDITION == (element.getName())) {
                  if (!activeSubProcessList.isEmpty()) {
                      SubProcess subProcess = activeSubProcessList.get(activeSubProcessList.size() - 1);
                      AdhocSubProcess adhocSubProcess = cast(AdhocSubProcess) subProcess;
                      if (adhocSubProcess !is null) {
                          adhocSubProcess.setCompletionCondition(element.getText());
                      }
                  }

              } else if (ELEMENT_DI_SHAPE == (element.getName())) {
                  bpmnShapeParser.parse(element, model);

              } else if (ELEMENT_DI_EDGE == (element.getName())) {
                  bpmnEdgeParser.parse(element, model);

              } else {

                  if (!activeSubProcessList.isEmpty() && icmp(ELEMENT_MULTIINSTANCE,element.getName()) == 0) {

                      multiInstanceParser.parseChildElement(element, activeSubProcessList.get(activeSubProcessList.size() - 1), model);

                  } else if (convertersToBpmnMap.containsKey(element.getName())) {
                      if (activeProcess !is null) {
                          BaseBpmnXMLConverter converter = convertersToBpmnMap.get(element.getName());
                          converter.convertToBpmnModel(element, model, activeProcess, activeSubProcessList);
                      }
                  }
              }
          }

          foreach (Process process ; model.getProcesses()) {
              foreach (Pool pool ; model.getPools()) {
                  if (process.getId() == (pool.getProcessRef())) {
                      pool.setExecutable(process.isExecutable());
                  }
              }
              processFlowElements(process.getFlowElements(), process);
          }

        return model;
    }

    protected void processFlowElements(Collection!FlowElement flowElementList, BaseElement parentScope) {
        foreach (FlowElement flowElement ; flowElementList) {
             SequenceFlow sequenceFlow = cast(SequenceFlow) flowElement;
            if (sequenceFlow !is null) {
                FlowNode sourceNode = getFlowNodeFromScope(sequenceFlow.getSourceRef(), parentScope);
                if (sourceNode !is null) {
                    sourceNode.getOutgoingFlows().add(sequenceFlow);
                    sequenceFlow.setSourceFlowElement(sourceNode);
                }

                FlowNode targetNode = getFlowNodeFromScope(sequenceFlow.getTargetRef(), parentScope);
                if (targetNode !is null) {
                    targetNode.getIncomingFlows().add(sequenceFlow);
                    sequenceFlow.setTargetFlowElement(targetNode);
                }

            } else if (cast(BoundaryEvent)flowElement !is null) {
                BoundaryEvent boundaryEvent = cast(BoundaryEvent) flowElement;
                FlowElement attachedToElement = getFlowNodeFromScope(boundaryEvent.getAttachedToRefId(), parentScope);
                Activity attachedActivity = cast(Activity) attachedToElement;
                if (attachedActivity !is null) {
                    boundaryEvent.setAttachedToRef(attachedActivity);
                    attachedActivity.getBoundaryEvents().add(boundaryEvent);
                }

            } else if (cast(SubProcess)flowElement !is null) {
                SubProcess subProcess = cast(SubProcess) flowElement;
                processFlowElements(subProcess.getFlowElements(), subProcess);
            }
        }
    }

    protected FlowNode getFlowNodeFromScope(string elementId, BaseElement scop) {
        FlowNode flowNode = null;
        if (elementId !is null && elementId.length != 0) {
            Process p = cast(Process)scop;
            if (p !is null) {
                flowNode = cast(FlowNode) (p.getFlowElement(elementId));
            } else if (cast(SubProcess)scop !is null) {
                flowNode = cast(FlowNode) (cast(SubProcess) scop).getFlowElement(elementId);
            }
        }
        return flowNode;
    }

    public byte[] convertToXML(BpmnModel model) {
        return convertToXML(model, DEFAULT_ENCODING);
    }

    public byte[] convertToXML(BpmnModel model, string encoding) {
         implementationMissing(false);
        //try {
        //
        //    ByteArrayOutputStream outputStream = new ByteArrayOutputStream();
        //
        //    XMLOutputFactory xof = XMLOutputFactory.newInstance();
        //    OutputStreamWriter out = new OutputStreamWriter(outputStream, encoding);
        //
        //    XMLStreamWriter writer = xof.createXMLStreamWriter(out);
        //    XMLStreamWriter xtw = new IndentingXMLStreamWriter(writer);
        //
        //    DefinitionsRootExport.writeRootElement(model, xtw, encoding);
        //    CollaborationExport.writePools(model, xtw);
        //    DataStoreExport.writeDataStores(model, xtw);
        //    SignalAndMessageDefinitionExport.writeSignalsAndMessages(model, xtw);
        //    EscalationDefinitionExport.writeEscalations(model, xtw);
        //
        //    for (Process process : model.getProcesses()) {
        //
        //        if (process.getFlowElements().isEmpty() && process.getLanes().isEmpty()) {
        //            // empty process, ignore it
        //            continue;
        //        }
        //
        //        ProcessExport.writeProcess(process, model, xtw);
        //
        //        for (FlowElement flowElement : process.getFlowElements()) {
        //            createXML(flowElement, model, xtw);
        //        }
        //
        //        for (Artifact artifact : process.getArtifacts()) {
        //            createXML(artifact, model, xtw);
        //        }
        //
        //        // end process element
        //        xtw.writeEndElement();
        //    }
        //
        //    BPMNDIExport.writeBPMNDI(model, xtw);
        //
        //    // end definitions root element
        //    xtw.writeEndElement();
        //    xtw.writeEndDocument();
        //
        //    xtw.flush();
        //
        //    outputStream.close();
        //
        //    xtw.close();
        //
        //    return outputStream.toByteArray();
        //
        //} catch (Exception e) {
        //    LOGGER.error("Error writing BPMN XML", e);
        //    throw new XMLException("Error writing BPMN XML", e);
        //}
    }

    //protected void createXML(FlowElement flowElement, BpmnModel model, XMLStreamWriter xtw)  {
    //
    //    if (flowElement instanceof SubProcess) {
    //
    //        SubProcess subProcess = (SubProcess) flowElement;
    //        if (flowElement instanceof Transaction) {
    //            xtw.writeStartElement(ELEMENT_TRANSACTION);
    //        } else if (flowElement instanceof AdhocSubProcess) {
    //            xtw.writeStartElement(ELEMENT_ADHOC_SUBPROCESS);
    //        } else {
    //            xtw.writeStartElement(ELEMENT_SUBPROCESS);
    //        }
    //
    //        xtw.writeAttribute(ATTRIBUTE_ID, subProcess.getId());
    //        if (stringUtils.isNotEmpty(subProcess.getName())) {
    //            xtw.writeAttribute(ATTRIBUTE_NAME, subProcess.getName());
    //        } else {
    //            xtw.writeAttribute(ATTRIBUTE_NAME, "subProcess");
    //        }
    //
    //        if (subProcess instanceof EventSubProcess) {
    //            xtw.writeAttribute(ATTRIBUTE_TRIGGERED_BY, ATTRIBUTE_VALUE_TRUE);
    //
    //        } else if (subProcess instanceof AdhocSubProcess) {
    //            AdhocSubProcess adhocSubProcess = (AdhocSubProcess) subProcess;
    //            BpmnXMLUtil.writeDefaultAttribute(ATTRIBUTE_CANCEL_REMAINING_INSTANCES, string.valueOf(adhocSubProcess.isCancelRemainingInstances()), xtw);
    //            if (stringUtils.isNotEmpty(adhocSubProcess.getOrdering())) {
    //                BpmnXMLUtil.writeDefaultAttribute(ATTRIBUTE_ORDERING, adhocSubProcess.getOrdering(), xtw);
    //            }
    //        } else if (!(subProcess instanceof Transaction)) {
    //            if (subProcess.isAsynchronous()) {
    //                BpmnXMLUtil.writeQualifiedAttribute(ATTRIBUTE_ACTIVITY_ASYNCHRONOUS, ATTRIBUTE_VALUE_TRUE, xtw);
    //                if (subProcess.isNotExclusive()) {
    //                    BpmnXMLUtil.writeQualifiedAttribute(ATTRIBUTE_ACTIVITY_EXCLUSIVE, ATTRIBUTE_VALUE_FALSE, xtw);
    //                }
    //            }
    //        }
    //
    //        if (stringUtils.isNotEmpty(subProcess.getDocumentation())) {
    //
    //            xtw.writeStartElement(ELEMENT_DOCUMENTATION);
    //            xtw.writeCharacters(subProcess.getDocumentation());
    //            xtw.writeEndElement();
    //        }
    //
    //        bool didWriteExtensionStartElement = FlowableListenerExport.writeListeners(subProcess, false, xtw);
    //
    //        didWriteExtensionStartElement = BpmnXMLUtil.writeExtensionElements(subProcess, didWriteExtensionStartElement, model.getNamespaces(), xtw);
    //        if (didWriteExtensionStartElement) {
    //            // closing extensions element
    //            xtw.writeEndElement();
    //        }
    //
    //        MultiInstanceExport.writeMultiInstance(subProcess, model, xtw);
    //
    //        for (FlowElement subElement : subProcess.getFlowElements()) {
    //            createXML(subElement, model, xtw);
    //        }
    //
    //        if (subProcess instanceof AdhocSubProcess) {
    //            AdhocSubProcess adhocSubProcess = (AdhocSubProcess) subProcess;
    //            if (stringUtils.isNotEmpty(adhocSubProcess.getCompletionCondition())) {
    //                xtw.writeStartElement(ELEMENT_COMPLETION_CONDITION);
    //                xtw.writeCData(adhocSubProcess.getCompletionCondition());
    //                xtw.writeEndElement();
    //            }
    //        }
    //
    //        for (Artifact artifact : subProcess.getArtifacts()) {
    //            createXML(artifact, model, xtw);
    //        }
    //
    //        xtw.writeEndElement();
    //
    //    } else {
    //
    //        BaseBpmnXMLConverter converter = convertersToXMLMap.get(flowElement.getClass());
    //
    //        if (converter is null) {
    //            throw new XMLException("No converter for " + flowElement.getClass() + " found");
    //        }
    //
    //        converter.convertToXML(xtw, flowElement, model);
    //    }
    //}
    //
    //protected void createXML(Artifact artifact, BpmnModel model, XMLStreamWriter xtw)  {
    //
    //    BaseBpmnXMLConverter converter = convertersToXMLMap.get(artifact.getClass());
    //
    //    if (converter is null) {
    //        throw new XMLException("No converter for " + artifact.getClass() + " found");
    //    }
    //
    //    converter.convertToXML(xtw, artifact, model);
    //}
}
