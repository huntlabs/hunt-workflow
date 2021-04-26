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

module flow.bpmn.model.Process;

import hunt.collection.ArrayList;
import hunt.collection;
import hunt.collection.LinkedHashMap;
import hunt.collection.List;
import hunt.collection.Map;
import flow.bpmn.model.BaseElement;
import flow.bpmn.model.FlowElementsContainer;
import flow.bpmn.model.HasExecutionListeners;
import flow.bpmn.model.IOSpecification;
import flow.bpmn.model.FlowableListener;
import flow.bpmn.model.Lane;
import flow.bpmn.model.FlowElement;
import flow.bpmn.model.ValuedDataObject;
import flow.bpmn.model.Artifact;
import flow.bpmn.model.EventListener;
import flow.bpmn.model.Association;
import flow.bpmn.model.SubProcess;

//import org.apache.commons.lang3.StringUtils;

/**
 * @author Tijs Rademakers
 * @author Joram Barrez
 */
class Process : BaseElement , FlowElementsContainer, HasExecutionListeners {


    alias setValues = BaseElement.setValues;
    protected string name;
    protected bool executable = true;
    protected string documentation;
    protected IOSpecification ioSpecification;
    protected List!FlowableListener executionListeners ;//= new ArrayList<>();
    protected List!Lane lanes ;//= new ArrayList<>();
    protected List!FlowElement flowElementList ;//= new ArrayList<>();
    protected List!ValuedDataObject dataObjects ;//= new ArrayList<>();
    protected List!Artifact artifactList ;//= new ArrayList<>();
    protected List!string candidateStarterUsers;// = new ArrayList<>();
    protected List!string candidateStarterGroups ;//= new ArrayList<>();
    protected List!EventListener eventListeners;// = new ArrayList<>();
    protected Map!(string, FlowElement) flowElementMap;// = new LinkedHashMap<>();

    // Added during process definition parsing
    protected FlowElement initialFlowElement;

    // Performance settings
    protected bool enableEagerExecutionTreeFetching;

    this() {
        executionListeners = new ArrayList!FlowableListener;
        lanes = new ArrayList!Lane;
        flowElementList = new ArrayList!FlowElement;
        dataObjects = new  ArrayList!ValuedDataObject;
        artifactList = new ArrayList!Artifact;
        candidateStarterUsers = new ArrayList!string;
        candidateStarterGroups = new ArrayList!string;
        eventListeners = new ArrayList!EventListener;
        flowElementMap = new LinkedHashMap!(string, FlowElement);
    }

    public string getDocumentation() {
        return documentation;
    }

    public void setDocumentation(string documentation) {
        this.documentation = documentation;
    }

    public string getName() {
        return name;
    }

    public void setName(string name) {
        this.name = name;
    }

    public bool isExecutable() {
        return executable;
    }

    public void setExecutable(bool executable) {
        this.executable = executable;
    }

    public IOSpecification getIoSpecification() {
        return ioSpecification;
    }

    public void setIoSpecification(IOSpecification ioSpecification) {
        this.ioSpecification = ioSpecification;
    }

    public List!FlowableListener getExecutionListeners() {
        return executionListeners;
    }

    public void setExecutionListeners(List!FlowableListener executionListeners) {
        this.executionListeners = executionListeners;
    }

    public List!Lane getLanes() {
        return lanes;
    }

    public void setLanes(List!Lane lanes) {
        this.lanes = lanes;
    }

    public Map!(string, FlowElement) getFlowElementMap() {
        return flowElementMap;
    }

    public void setFlowElementMap(Map!(string, FlowElement) flowElementMap) {
        this.flowElementMap = flowElementMap;
    }

    public bool containsFlowElementId(string id) {
        return flowElementMap.containsKey(id);
    }

    public FlowElement getFlowElement(string flowElementId) {
        return getFlowElement(flowElementId, false);
    }

    /**
     * @param searchRecursive
     *            searches the whole process, including subprocesses
     */
    public FlowElement getFlowElement(string flowElementId, bool searchRecursive) {
        if (searchRecursive) {
            return flowElementMap.get(flowElementId);
        } else {
            return findFlowElementInList(flowElementId);
        }
    }

    public List!Association findAssociationsWithSourceRefRecursive(string sourceRef) {
        return findAssociationsWithSourceRefRecursive(this, sourceRef);
    }

    protected List!Association findAssociationsWithSourceRefRecursive(FlowElementsContainer flowElementsContainer, string sourceRef) {
        List!Association associations = new ArrayList!Association();
        foreach (Artifact artifact ; flowElementsContainer.getArtifacts()) {
            Association association = cast(Association) artifact;
            if (association !is null) {
                if (association.getSourceRef() !is null && association.getTargetRef() !is null && association.getSourceRef() == (sourceRef)) {
                    associations.add(association);
                }
            }
        }

        foreach (FlowElement flowElement ; flowElementsContainer.getFlowElements()) {
            FlowElementsContainer f = cast(FlowElementsContainer) flowElement;
            if (f !is null) {
                associations.addAll(findAssociationsWithSourceRefRecursive(f, sourceRef));
            }
        }
        return associations;
    }

    public List!Association findAssociationsWithTargetRefRecursive(string targetRef) {
        return findAssociationsWithTargetRefRecursive(this, targetRef);
    }

    protected List!Association findAssociationsWithTargetRefRecursive(FlowElementsContainer flowElementsContainer, string targetRef) {
        List!Association associations = new ArrayList!Association();
        foreach (Artifact artifact ; flowElementsContainer.getArtifacts()) {
             Association association = cast(Association) artifact;
            if (association !is null) {
                if (association.getTargetRef() !is null && association.getTargetRef() == (targetRef)) {
                    associations.add(association);
                }
            }
        }

        foreach (FlowElement flowElement ; flowElementsContainer.getFlowElements()) {
            FlowElementsContainer f = cast(FlowElementsContainer) flowElement;
            if (f !is null) {
                associations.addAll(findAssociationsWithTargetRefRecursive(f, targetRef));
            }
        }
        return associations;
    }

    /**
     * Searches the whole process, including subprocesses
     */
    public FlowElementsContainer getFlowElementsContainer(string flowElementId) {
        return getFlowElementsContainer(this, flowElementId);
    }

    protected FlowElementsContainer getFlowElementsContainer(FlowElementsContainer flowElementsContainer, string flowElementId) {
        foreach (FlowElement flowElement ; flowElementsContainer.getFlowElements()) {
            FlowElementsContainer f = cast(FlowElementsContainer) flowElement;
            if (flowElement.getId() !is null && flowElement.getId() == (flowElementId)) {
                return flowElementsContainer;
            } else if (f !is null) {
                FlowElementsContainer result = getFlowElementsContainer(f, flowElementId);
                if (result !is null) {
                    return result;
                }
            }
        }
        return null;
    }

    protected FlowElement findFlowElementInList(string flowElementId) {
        foreach (FlowElement f ; flowElementList) {
            if (f.getId() !is null && f.getId() == (flowElementId)) {
                return f;
            }
        }
        return null;
    }

    public Collection!FlowElement getFlowElements() {
        return flowElementList;
    }

    public void addFlowElement(FlowElement element) {
        flowElementList.add(element);
        element.setParentContainer(this);
        addFlowElementToMap(element);
    }

    public void addFlowElementToMap(FlowElement element) {
        if (element !is null && (element.getId()!is null && element.getId().length != 0)) {
            flowElementMap.put(element.getId(), element);
        }
    }

    public void removeFlowElement(string elementId) {
        FlowElement element = flowElementMap.get(elementId);
        if (element !is null) {
            flowElementList.remove(element);
            flowElementMap.remove(element.getId());
        }
    }

    public void removeFlowElementFromMap(string elementId) {
        if (elementId !is null && elementId.length != 0) {
            flowElementMap.remove(elementId);
        }
    }

    public Artifact getArtifact(string id) {
        Artifact foundArtifact = null;
        foreach (Artifact artifact ; artifactList) {
            if (id == (artifact.getId())) {
                foundArtifact = artifact;
                break;
            }
        }
        return foundArtifact;
    }

    public Collection!Artifact getArtifacts() {
        return artifactList;
    }

    public void addArtifact(Artifact artifact) {
        artifactList.add(artifact);
    }

    public void removeArtifact(string artifactId) {
        Artifact artifact = getArtifact(artifactId);
        if (artifact !is null) {
            artifactList.remove(artifact);
        }
    }

    public List!string getCandidateStarterUsers() {
        return candidateStarterUsers;
    }

    public void setCandidateStarterUsers(List!string candidateStarterUsers) {
        this.candidateStarterUsers = candidateStarterUsers;
    }

    public List!string getCandidateStarterGroups() {
        return candidateStarterGroups;
    }

    public void setCandidateStarterGroups(List!string candidateStarterGroups) {
        this.candidateStarterGroups = candidateStarterGroups;
    }

    public List!EventListener getEventListeners() {
        return eventListeners;
    }

    public void setEventListeners(List!EventListener eventListeners) {
        this.eventListeners = eventListeners;
    }

    //public <FlowElementType extends FlowElement> List<FlowElementType> findFlowElementsOfType(Class<FlowElementType> type) {
    //    return findFlowElementsOfType(type, true);
    //}

    public List!T findFlowElementsOfType(T)(TypeInfo type) {
        return findFlowElementsOfType!T(type, true);
    }

    //@SuppressWarnings("unchecked")
    //public <FlowElementType extends FlowElement> List<FlowElementType> findFlowElementsOfType(Class<FlowElementType> type, bool goIntoSubprocesses) {
    //    List<FlowElementType> foundFlowElements = new ArrayList<>();
    //    for (FlowElement flowElement : this.getFlowElements()) {
    //        if (type.isInstance(flowElement)) {
    //            foundFlowElements.add((FlowElementType) flowElement);
    //        }
    //
    //        if (flowElement instanceof SubProcess) {
    //            if (goIntoSubprocesses) {
    //                foundFlowElements.addAll(findFlowElementsInSubProcessOfType((SubProcess) flowElement, type));
    //            }
    //        }
    //    }
    //    return foundFlowElements;
    //}

    public List!T findFlowElementsOfType(T)(TypeInfo type, bool goIntoSubprocesses) {
        List!T foundFlowElements = new ArrayList!T;
        foreach (FlowElement flowElement ; this.getFlowElements()) {
            T obj = cast(T)flowElement;
            if (obj !is null) {
                foundFlowElements.add(obj);
            }

            SubProcess s = cast(SubProcess)flowElement;
            if (s !is null) {
                if (goIntoSubprocesses) {
                    foundFlowElements.addAll(findFlowElementsInSubProcessOfType!T(s, type));
                }
            }
        }
        return foundFlowElements;
    }

    public List!T findFlowElementsInSubProcessOfType(T)(SubProcess subProcess, TypeInfo type) {
        return findFlowElementsInSubProcessOfType!T(subProcess, type, true);
    }

    //@SuppressWarnings("unchecked")
    public List!T findFlowElementsInSubProcessOfType(T)(SubProcess subProcess, TypeInfo type, bool goIntoSubprocesses) {

        List!T foundFlowElements = new ArrayList!T();
        foreach (FlowElement flowElement ; subProcess.getFlowElements()) {
            T obj = cast(T)flowElement;
            if (obj !is null) {
                foundFlowElements.add(obj);
            }
            SubProcess s = cast(SubProcess) flowElement;
            if (s !is null) {
                if (goIntoSubprocesses) {
                    List!SubProcess rt =  findFlowElementsInSubProcessOfType!SubProcess(s, type);
                    foreach(SubProcess sp; rt)
                    {
                         foundFlowElements.add(cast(T)sp);
                    }
                   // foundFlowElements.addAll(findFlowElementsInSubProcessOfType!SubProcess(s, type));
                }
            }
        }
        return foundFlowElements;
    }

    public FlowElementsContainer findParent(FlowElement childElement) {
        return findParent(childElement, this);
    }

    public FlowElementsContainer findParent(FlowElement childElement, FlowElementsContainer flowElementsContainer) {
        foreach (FlowElement flowElement ; flowElementsContainer.getFlowElements()) {
            if (childElement.getId() !is null && childElement.getId() == (flowElement.getId())) {
                return flowElementsContainer;
            }
            FlowElementsContainer f = cast(FlowElementsContainer) flowElement;
            if (f !is null) {
                FlowElementsContainer result = findParent(childElement, f);
                if (result !is null) {
                    return result;
                }
            }
        }
        return null;
    }

    override
    public Process clone() {
        Process clone = new Process();
        clone.setValues(this);
        return clone;
    }

    public void setValues(Process otherElement) {
        super.setValues(otherElement);

        // setBpmnModel(bpmnModel);
        setName(otherElement.getName());
        setExecutable(otherElement.isExecutable());
        setDocumentation(otherElement.getDocumentation());
        if (otherElement.getIoSpecification() !is null) {
            setIoSpecification(otherElement.getIoSpecification().clone());
        }

        executionListeners = new ArrayList!FlowableListener();
        if (otherElement.getExecutionListeners() !is null && !otherElement.getExecutionListeners().isEmpty()) {
            foreach (FlowableListener listener ; otherElement.getExecutionListeners()) {
                executionListeners.add(listener.clone());
            }
        }

        candidateStarterUsers = new ArrayList!string();
        if (otherElement.getCandidateStarterUsers() !is null && !otherElement.getCandidateStarterUsers().isEmpty()) {
            candidateStarterUsers.addAll(otherElement.getCandidateStarterUsers());
        }

        candidateStarterGroups = new ArrayList!string();
        if (otherElement.getCandidateStarterGroups() !is null && !otherElement.getCandidateStarterGroups().isEmpty()) {
            candidateStarterGroups.addAll(otherElement.getCandidateStarterGroups());
        }

        enableEagerExecutionTreeFetching = otherElement.enableEagerExecutionTreeFetching;

        eventListeners = new ArrayList!EventListener();
        if (otherElement.getEventListeners() !is null && !otherElement.getEventListeners().isEmpty()) {
            foreach (EventListener listener ; otherElement.getEventListeners()) {
                eventListeners.add(listener.clone());
            }
        }

        /*
         * This is required because data objects in Designer have no DI info and are added as properties, not flow elements
         *
         * Determine the differences between the 2 elements' data object
         */
        foreach (ValuedDataObject thisObject ; getDataObjects()) {
            bool exists = false;
            foreach (ValuedDataObject otherObject ; otherElement.getDataObjects()) {
                if (thisObject.getId() == (otherObject.getId())) {
                    exists = true;
                    break;
                }
            }
            if (!exists) {
                // missing object
                removeFlowElement(thisObject.getId());
            }
        }

        dataObjects = new ArrayList!ValuedDataObject();
        if (otherElement.getDataObjects() !is null && !otherElement.getDataObjects().isEmpty()) {
            foreach (ValuedDataObject dataObject ; otherElement.getDataObjects()) {
                ValuedDataObject clone = dataObject.clone();
                dataObjects.add(clone);
                // add it to the list of FlowElements
                // if it is already there, remove it first so order is same as
                // data object list
                removeFlowElement(clone.getId());
                addFlowElement(clone);
            }
        }
    }

    public List!ValuedDataObject getDataObjects() {
        return dataObjects;
    }

    public void setDataObjects(List!ValuedDataObject dataObjects) {
        this.dataObjects = dataObjects;
    }

    public FlowElement getInitialFlowElement() {
        return initialFlowElement;
    }

    public void setInitialFlowElement(FlowElement initialFlowElement) {
        this.initialFlowElement = initialFlowElement;
    }

    public bool isEnableEagerExecutionTreeFetching() {
        return enableEagerExecutionTreeFetching;
    }

    public void setEnableEagerExecutionTreeFetching(bool enableEagerExecutionTreeFetching) {
        this.enableEagerExecutionTreeFetching = enableEagerExecutionTreeFetching;
    }

}
