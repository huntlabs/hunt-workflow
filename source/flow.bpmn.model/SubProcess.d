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
module flow.bpmn.model.SubProcess;

import hunt.collection.ArrayList;
import hunt.collection;
import hunt.collection.LinkedHashMap;
import hunt.collection.List;
import hunt.collection.Map;

import flow.bpmn.model.Activity;
import flow.bpmn.model.FlowElementsContainer;
import flow.bpmn.model.FlowElement;
import flow.bpmn.model.Artifact;
import flow.bpmn.model.ValuedDataObject;
//import java.util.Optional;
//import java.util.stream.Collectors;
//
//import org.apache.commons.lang3.StringUtils;


/**
 * @author Tijs Rademakers
 */
class SubProcess : Activity , FlowElementsContainer {

    protected Map!(string, FlowElement) flowElementMap ;//= new LinkedHashMap<>();
    protected List!FlowElement flowElementList ;//= new ArrayList<>();
    protected List!Artifact artifactList ;//= new ArrayList<>();
    protected List!ValuedDataObject dataObjects ;//= new ArrayList<>();


    this()
    {
      flowElementMap = new LinkedHashMap!(string, FlowElement);
      flowElementList = new ArrayList!FlowElement;
      artifactList = new ArrayList!Artifact;
      dataObjects = new ArrayList!ValuedDataObject;
    }

   // @Override
    public FlowElement getFlowElement(string id) {
        FlowElement foundElement = null;
        if (id !is null && id.length != 0) {
            foundElement = flowElementMap.get(id);
        }
        return foundElement;
    }

    //@Override
    public Collection!FlowElement getFlowElements() {
        return flowElementList;
    }

    //@Override
    public void addFlowElement(FlowElement element) {
        flowElementList.add(element);
        element.setParentContainer(this);
        addFlowElementToMap(element);
    }

    //@Override
    public void addFlowElementToMap(FlowElement element) {
        if (element !is null && (element.getId() !is null && element.getId().length != 0)) {
            flowElementMap.put(element.getId(), element);
            if (getParentContainer() !is null) {
                getParentContainer().addFlowElementToMap(element);
            }
        }
    }

    //@Override
    public void removeFlowElement(string elementId) {
        FlowElement element = getFlowElement(elementId);
        if (element !is null) {
            flowElementList.remove(element);
            flowElementMap.remove(elementId);
            if (element.getParentContainer() !is null) {
                element.getParentContainer().removeFlowElementFromMap(elementId);
            }
        }
    }

    //@Override
    public void removeFlowElementFromMap(string elementId) {
        if (elementId !is null && elementId.length != 0) {
            flowElementMap.remove(elementId);
        }
    }

    //@Override
    public Map!(string, FlowElement) getFlowElementMap() {
        return flowElementMap;
    }

    public void setFlowElementMap(Map!(string, FlowElement) flowElementMap) {
        this.flowElementMap = flowElementMap;
    }

    public bool containsFlowElementId(string id) {
        return flowElementMap.containsKey(id);
    }

    //public <T extends FlowElement> T findFirstSubFlowElementInFlowMapOfType(Class<T> clazz) {
    //    Optional!FlowElement first = flowElementMap.values().stream()
    //        .filter(subFlowElement -> clazz.isInstance(subFlowElement))
    //        .findFirst();
    //    return (T) first.orElse(null);
    //}

    public  T findFirstSubFlowElementInFlowMapOfType(T)(TypeInfo clazz) {
        T obj = null;
        foreach(FlowElement flowelement; flowElementMap.values())
        {
            obj = cast(T)flowelement;
            if (obj !is null)
            {
                break;
            }
        }
        return obj;
    }

    //public <T extends FlowElement> List<T> findAllSubFlowElementInFlowMapOfType(Class<T> clazz) {
    //    return flowElementMap.values().stream()
    //        .filter(clazz::isInstance)
    //        .map(subFlowElement -> (T) subFlowElement)
    //        .collect(Collectors.toList());
    //}


    public List!T findAllSubFlowElementInFlowMapOfType(T)(TypeInfo clazz) {
        List!T  rt = new ArrayList!T;
        foreach(FlowElement flowelement; flowElementMap.values())
        {
          T obj = cast(T)flowelement;
          if (obj !is null)
          {
            rt.add(obj);
          }
        }
        return rt;
    }

    //@Override
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

   // @Override
    public Collection!Artifact getArtifacts() {
        return artifactList;
    }

    //@Override
    public void addArtifact(Artifact artifact) {
        artifactList.add(artifact);
    }

    //@Override
    public void removeArtifact(string artifactId) {
        Artifact artifact = getArtifact(artifactId);
        if (artifact !is null) {
            artifactList.remove(artifact);
        }
    }

    override
    public SubProcess clone() {
        SubProcess clone = new SubProcess();
        clone.setValues(this);
        return clone;
    }

    public void setValues(SubProcess otherElement) {
        super.setValues(otherElement);

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

        flowElementList.clear();
        foreach (FlowElement flowElement ; otherElement.getFlowElements()) {
            addFlowElement(flowElement.clone());
        }

        artifactList.clear();
        foreach (Artifact artifact ; otherElement.getArtifacts()) {
            addArtifact(artifact.clone());
        }
    }

    public List!ValuedDataObject getDataObjects() {
        return dataObjects;
    }

    public void setDataObjects(List!ValuedDataObject dataObjects) {
        this.dataObjects = dataObjects;
    }
}
