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
module flow.engine.impl.bpmn.parser.BpmnParse;

import hunt.stream.Common;
//import java.io.InputStream;
//import java.net.MalformedURLException;
//import java.net.URL;
import hunt.collection.ArrayList;
import hunt.collection;
import hunt.collection.HashMap;
import hunt.collection.LinkedList;
import hunt.collection.List;
import hunt.collection.Map;

import flow.engine.impl.bpmn.parser.BpmnParser;
import flow.bpmn.converter.constants.BpmnXMLConstants;
import flow.bpmn.converter.converter.BpmnXMLConverter;
//import org.flowable.bpmn.exceptions.XMLException;
import flow.bpmn.model.BoundaryEvent;
import flow.bpmn.model.BpmnModel;
import flow.bpmn.model.Event;
import flow.bpmn.model.FlowElement;
import flow.bpmn.model.FlowNode;
import flow.bpmn.model.GraphicInfo;
import flow.bpmn.model.Process;
import flow.bpmn.model.SequenceFlow;
import flow.bpmn.model.SubProcess;
import flow.common.api.FlowableException;
import flow.common.api.FlowableIllegalArgumentException;
import flow.common.api.repository.EngineDeployment;
import flow.common.event.FlowableEventSupport;
//import flow.common.util.io.InputStreamSource;
//import flow.common.util.io.StreamSource;
//import flow.common.util.io.StringStreamSource;
//import flow.common.util.io.UrlStreamSource;
import flow.engine.impl.bpmn.parser.factory.ActivityBehaviorFactory;
import flow.engine.impl.bpmn.parser.factory.ListenerFactory;
import flow.engine.impl.cfg.ProcessEngineConfigurationImpl;
import flow.engine.impl.persistence.entity.ProcessDefinitionEntity;
import flow.engine.impl.util.CommandContextUtil;
//import flow.engine.impl.util.io.ResourceStreamSource;
import flow.engine.impl.bpmn.parser.BpmnParseHandlers;
//import org.flowable.validation.ProcessValidator;
//import org.flowable.validation.ValidationError;
//import org.slf4j.Logger;
//import org.slf4j.LoggerFactory;
import hunt.Exceptions;
import hunt.stream.ByteArrayInputStream;
import hunt.xml.Document;
/**
 * Specific parsing of one BPMN 2.0 XML file, created by the {@link BpmnParser}.
 *
 * @author Tijs Rademakers
 * @author Joram Barrez
 */
class BpmnParse : BpmnXMLConstants {

    public static  string PROPERTYNAME_INITIAL = "initial";
    public static  string PROPERTYNAME_INITIATOR_VARIABLE_NAME = "initiatorVariableName";
    public static  string PROPERTYNAME_CONDITION = "condition";
    public static  string PROPERTYNAME_CONDITION_TEXT = "conditionText";
    public static  string PROPERTYNAME_TIMER_DECLARATION = "timerDeclarations";
    public static  string PROPERTYNAME_ISEXPANDED = "isExpanded";
    public static  string PROPERTYNAME_START_TIMER = "timerStart";
    public static  string PROPERTYNAME_COMPENSATION_HANDLER_ID = "compensationHandler";
    public static  string PROPERTYNAME_IS_FOR_COMPENSATION = "isForCompensation";
    public static  string PROPERTYNAME_ERROR_EVENT_DEFINITIONS = "errorEventDefinitions";
    public static  string PROPERTYNAME_EVENT_SUBSCRIPTION_DECLARATION = "eventDefinitions";

    protected string _name;

    protected bool validateSchema = true;
    protected bool validateProcess = true;

    protected string streamSource;
    protected string sourceSystemId;

    protected BpmnModel bpmnModel;

    protected string targetNamespace;

    /** The deployment to which the parsed process definitions will be added. */
    protected EngineDeployment _deployment;

    /** The end result of the parsing: a list of process definition. */
    protected List!ProcessDefinitionEntity processDefinitions  ;//= new ArrayList<>();

    /** A map for storing sequence flow based on their id during parsing. */
    protected Map!(string, SequenceFlow) sequenceFlows;

    protected BpmnParseHandlers bpmnParserHandlers;

    protected ProcessDefinitionEntity currentProcessDefinition;

    protected Process currentProcess;

    protected FlowElement currentFlowElement;

    protected LinkedList!SubProcess currentSubprocessStack ;// = new LinkedList<>();

    /**
     * Mapping containing values stored during the first phase of parsing since other elements can reference these messages.
     *
     * All the map's elements are defined outside the process definition(s), which means that this map doesn't need to be re-initialized for each new process definition.
     */
    protected Map!(string, string) prefixs ;//= new HashMap<>();

    // Factories
    protected ActivityBehaviorFactory activityBehaviorFactory;
    protected ListenerFactory listenerFactory;

    /**
     * Constructor to be called by the {@link BpmnParser}.
     */
    this(BpmnParser parser) {
        this.activityBehaviorFactory = parser.getActivityBehaviorFactory();
        this.listenerFactory = parser.getListenerFactory();
        this.bpmnParserHandlers = parser.getBpmnParserHandlers();
        processDefinitions = new ArrayList!ProcessDefinitionEntity;
        currentSubprocessStack = new LinkedList!SubProcess;
        prefixs = new HashMap!(string, string);
    }

    public BpmnParse deployment(EngineDeployment deployment) {
        this._deployment = deployment;
        return this;
    }

    public BpmnParse execute() {
        try {

            ProcessEngineConfigurationImpl processEngineConfiguration = CommandContextUtil.getProcessEngineConfiguration();
            BpmnXMLConverter converter = new BpmnXMLConverter();

            bool enableSafeBpmnXml = false;
            string encoding = null;
            if (processEngineConfiguration !is null) {
                enableSafeBpmnXml = processEngineConfiguration.isEnableSafeBpmnXml();
                encoding = processEngineConfiguration.getXmlEncoding();
            }

            if (encoding !is null) {
                bpmnModel = converter.convertToBpmnModel(Document.parse(streamSource), validateSchema, enableSafeBpmnXml, encoding);
            } else {
                bpmnModel = converter.convertToBpmnModel(Document.parse(streamSource), validateSchema, enableSafeBpmnXml);
            }

            // XSD validation goes first, then process/semantic validation
            //if (validateProcess) {
            //    ProcessValidator processValidator = processEngineConfiguration.getProcessValidator();
            //    if (processValidator is null) {
            //        LOGGER.warn("Process should be validated, but no process validator is configured on the process engine configuration!");
            //    } else {
            //        List!ValidationError validationErrors = processValidator.validate(bpmnModel);
            //        if (validationErrors !is null && !validationErrors.isEmpty()) {
            //
            //            StringBuilder warningBuilder = new StringBuilder();
            //            StringBuilder errorBuilder = new StringBuilder();
            //
            //            for (ValidationError error : validationErrors) {
            //                if (error.isWarning()) {
            //                    warningBuilder.append(error);
            //                    warningBuilder.append("\n");
            //                } else {
            //                    errorBuilder.append(error);
            //                    errorBuilder.append("\n");
            //                }
            //            }
            //
            //            // Throw exception if there is any error
            //            if (errorBuilder.length() > 0) {
            //                throw new FlowableException("Errors while parsing:\n" + errorBuilder);
            //            }
            //
            //            // Write out warnings (if any)
            //            if (warningBuilder.length() > 0) {
            //                LOGGER.warn("Following warnings encountered during process validation: {}", warningBuilder);
            //            }
            //
            //        }
            //    }
            //}

            bpmnModel.setSourceSystemId(sourceSystemId);
            bpmnModel.setEventSupport(new FlowableEventSupport());

            // Validation successful (or no validation)

            // Attach logic to the processes (eg. map ActivityBehaviors to bpmn model elements)
            applyParseHandlers();

            // Finally, process the diagram interchange info
            processDI();

        } catch (Exception e) {
            implementationMissing(false);
            //if (e instanceof FlowableException) {
            //    throw (FlowableException) e;
            //} else if (e instanceof XMLException) {
            //    throw (XMLException) e;
            //} else {
            //    throw new FlowableException("Error parsing XML", e);
            //}
        }

        return this;
    }

    public BpmnParse name(string name) {
        this._name = name;
        return this;
    }

    public BpmnParse sourceInputStream(InputStream inputStream) {
        if (_name is null) {
            name("inputStream");
        }
        streamSource = cast(string)((cast(ByteArrayInputStream) inputStream).getRawBuffer);
       // setStreamSource(new InputStreamSource(inputStream));
        return this;
    }

    public BpmnParse sourceResource(string resource) {
        return sourceResource(resource, null);
    }

    //public BpmnParse sourceUrl(URL url) {
    //    if (name is null) {
    //        name(url.toString());
    //    }
    //    setStreamSource(new UrlStreamSource(url));
    //    return this;
    //}

    //public BpmnParse sourceUrl(string url) {
    //    try {
    //        return sourceUrl(new URL(url));
    //    } catch (MalformedURLException e) {
    //        throw new FlowableIllegalArgumentException("malformed url: " + url, e);
    //    }
    //}

    //public BpmnParse sourceResource(string resource, ClassLoader classLoader) {
    //    if (name is null) {
    //        name(resource);
    //    }
    //    setStreamSource(new ResourceStreamSource(resource, classLoader));
    //    return this;
    //}

    //public BpmnParse sourceString(string str) {
    //    if (name is null) {
    //        name("string");
    //    }
    //    setStreamSource(new StringStreamSource(string));
    //    return this;
    //}

    //protected void setStreamSource(StreamSource streamSource) {
    //    if (this.streamSource !is null) {
    //        throw new FlowableIllegalArgumentException("invalid: multiple sources " + this.streamSource + " and " + streamSource);
    //    }
    //    this.streamSource = streamSource;
    //}

    public BpmnParse setSourceSystemId(string sourceSystemId) {
        this.sourceSystemId = sourceSystemId;
        return this;
    }

    /**
     * Parses the 'definitions' root element
     */
    protected void applyParseHandlers() {
        sequenceFlows = new HashMap!(string, SequenceFlow)();
        foreach (Process process ; bpmnModel.getProcesses()) {
            currentProcess = process;
            if (process.isExecutable()) {
                bpmnParserHandlers.parseElement(this, process);
            }
        }
    }

    public void processFlowElements(Collection!FlowElement flowElements) {

        // Parsing the elements is done in a strict order of types,
        // as otherwise certain information might not be available when parsing
        // a certain type.

        // Using lists as we want to keep the order in which they are defined
        List!SequenceFlow sequenceFlowToParse = new ArrayList!SequenceFlow();
        List!BoundaryEvent boundaryEventsToParse = new ArrayList!BoundaryEvent();

        // Flow elements that depend on other elements are parse after the first run-through
        List!FlowElement defferedFlowElementsToParse = new ArrayList!FlowElement();

        // Activities are parsed first
        foreach (FlowElement flowElement ; flowElements) {

            // Sequence flow are also flow elements, but are only parsed once every activity is found
            if (cast(SequenceFlow)flowElement !is null) {
                sequenceFlowToParse.add(cast(SequenceFlow) flowElement);
            } else if (cast(BoundaryEvent)flowElement !is null) {
                boundaryEventsToParse.add(cast(BoundaryEvent) flowElement);
            } else if (cast(Event)flowElement !is null) {
                defferedFlowElementsToParse.add(flowElement);
            } else {
                bpmnParserHandlers.parseElement(this, flowElement);
            }

        }

        // Deferred elements
        foreach (FlowElement flowElement ; defferedFlowElementsToParse) {
            bpmnParserHandlers.parseElement(this, flowElement);
        }

        // Boundary events are parsed after all the regular activities are parsed
        foreach (BoundaryEvent boundaryEvent ; boundaryEventsToParse) {
            bpmnParserHandlers.parseElement(this, boundaryEvent);
        }

        // sequence flows
        foreach (SequenceFlow sequenceFlow ; sequenceFlowToParse) {
            bpmnParserHandlers.parseElement(this, sequenceFlow);
        }

    }

    // Diagram interchange
    // /////////////////////////////////////////////////////////////////

    public void processDI() {

        if (processDefinitions.isEmpty()) {
            return;
        }

        //if (!bpmnModel.getLocationMap().isEmpty()) {
        //
        //    // Verify if all referenced elements exist
        //    foreach (string bpmnReference ; bpmnModel.getLocationMap().keySet()) {
        //        if (bpmnModel.getFlowElement(bpmnReference) is null) {
        //            // ACT-1625: don't warn when artifacts are referenced from DI
        //            if (bpmnModel.getArtifact(bpmnReference) is null) {
        //                // Check if it's a Pool or Lane, then DI is ok
        //                if (bpmnModel.getPool(bpmnReference) is null && bpmnModel.getLane(bpmnReference) is null) {
        //                    LOGGER.warn("Invalid reference in diagram interchange definition: could not find {}", bpmnReference);
        //                }
        //            }
        //        } else if (!(bpmnModel.getFlowElement(bpmnReference) instanceof FlowNode)) {
        //            LOGGER.warn("Invalid reference in diagram interchange definition: {} does not reference a flow node", bpmnReference);
        //        }
        //    }
        //
        //    for (string bpmnReference : bpmnModel.getFlowLocationMap().keySet()) {
        //        if (bpmnModel.getFlowElement(bpmnReference) is null) {
        //            // ACT-1625: don't warn when artifacts are referenced from DI
        //            if (bpmnModel.getArtifact(bpmnReference) is null) {
        //                LOGGER.warn("Invalid reference in diagram interchange definition: could not find {}", bpmnReference);
        //            }
        //        } else if (!(bpmnModel.getFlowElement(bpmnReference) instanceof SequenceFlow)) {
        //            LOGGER.warn("Invalid reference in diagram interchange definition: {} does not reference a sequence flow", bpmnReference);
        //        }
        //    }
        //
        //    for (Process process : bpmnModel.getProcesses()) {
        //        if (!process.isExecutable()) {
        //            continue;
        //        }
        //
        //        // Parse diagram interchange information
        //        ProcessDefinitionEntity processDefinition = getProcessDefinition(process.getId());
        //        if (processDefinition !is null) {
        //            processDefinition.setGraphicalNotationDefined(true);
        //
        //            for (string edgeId : bpmnModel.getFlowLocationMap().keySet()) {
        //                if (bpmnModel.getFlowElement(edgeId) !is null) {
        //                    createBPMNEdge(edgeId, bpmnModel.getFlowLocationGraphicInfo(edgeId));
        //                }
        //            }
        //        }
        //    }
        //}
    }

    //public void createBPMNEdge(string key, List!GraphicInfo graphicList) {
    //    FlowElement flowElement = bpmnModel.getFlowElement(key);
    //    if (flowElement instanceof SequenceFlow) {
    //        SequenceFlow sequenceFlow = (SequenceFlow) flowElement;
    //        List!Integer waypoints = new ArrayList<>();
    //        for (GraphicInfo waypointInfo : graphicList) {
    //            waypoints.add((int) waypointInfo.getX());
    //            waypoints.add((int) waypointInfo.getY());
    //        }
    //        sequenceFlow.setWaypoints(waypoints);
    //
    //    } else if (bpmnModel.getArtifact(key) !is null) {
    //        // it's an association, so nothing to do
    //    } else {
    //        LOGGER.warn("Invalid reference in 'bpmnElement' attribute, sequenceFlow {} not found", key);
    //    }
    //}

    public ProcessDefinitionEntity getProcessDefinition(string processDefinitionKey) {
        foreach (ProcessDefinitionEntity processDefinition ; processDefinitions) {
            if (processDefinition.getKey() == (processDefinitionKey)) {
                return processDefinition;
            }
        }
        return null;
    }

    /*
     * ------------------- GETTERS AND SETTERS -------------------
     */

    public bool isValidateSchema() {
        return validateSchema;
    }

    public void setValidateSchema(bool validateSchema) {
        this.validateSchema = validateSchema;
    }

    public bool isValidateProcess() {
        return validateProcess;
    }

    public void setValidateProcess(bool validateProcess) {
        this.validateProcess = validateProcess;
    }

    public List!ProcessDefinitionEntity getProcessDefinitions() {
        return processDefinitions;
    }

    public string getTargetNamespace() {
        return targetNamespace;
    }

    public BpmnParseHandlers getBpmnParserHandlers() {
        return bpmnParserHandlers;
    }

    public void setBpmnParserHandlers(BpmnParseHandlers bpmnParserHandlers) {
        this.bpmnParserHandlers = bpmnParserHandlers;
    }

    public EngineDeployment getDeployment() {
        return _deployment;
    }

    public void setDeployment(EngineDeployment deployment) {
        this._deployment = deployment;
    }

    public BpmnModel getBpmnModel() {
        return bpmnModel;
    }

    public void setBpmnModel(BpmnModel bpmnModel) {
        this.bpmnModel = bpmnModel;
    }

    public ActivityBehaviorFactory getActivityBehaviorFactory() {
        return activityBehaviorFactory;
    }

    public void setActivityBehaviorFactory(ActivityBehaviorFactory activityBehaviorFactory) {
        this.activityBehaviorFactory = activityBehaviorFactory;
    }

    public ListenerFactory getListenerFactory() {
        return listenerFactory;
    }

    public void setListenerFactory(ListenerFactory listenerFactory) {
        this.listenerFactory = listenerFactory;
    }

    public Map!(string, SequenceFlow) getSequenceFlows() {
        return sequenceFlows;
    }

    public ProcessDefinitionEntity getCurrentProcessDefinition() {
        return currentProcessDefinition;
    }

    public void setCurrentProcessDefinition(ProcessDefinitionEntity currentProcessDefinition) {
        this.currentProcessDefinition = currentProcessDefinition;
    }

    public FlowElement getCurrentFlowElement() {
        return currentFlowElement;
    }

    public void setCurrentFlowElement(FlowElement currentFlowElement) {
        this.currentFlowElement = currentFlowElement;
    }

    public Process getCurrentProcess() {
        return currentProcess;
    }

    public void setCurrentProcess(Process currentProcess) {
        this.currentProcess = currentProcess;
    }

    public void setCurrentSubProcess(SubProcess subProcess) {
        currentSubprocessStack.push(subProcess);
    }

    public SubProcess getCurrentSubProcess() {
        return currentSubprocessStack.peek();
    }

    public void removeCurrentSubProcess() {
        currentSubprocessStack.pop();
    }
}
