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

module flow.bpmn.model.BpmnModel;

import hunt.collection.ArrayList;
import hunt.collection;
import hunt.collection.LinkedHashMap;
import hunt.collection.List;
import hunt.collection.Map;
import flow.bpmn.model.ExtensionAttribute;
import flow.bpmn.model.Process;
import flow.bpmn.model.Signal;
import flow.bpmn.model.MessageFlow;
import flow.bpmn.model.Message;
import flow.bpmn.model.Escalation;
import flow.bpmn.model.ItemDefinition;
import flow.bpmn.model.DataStore;
import flow.bpmn.model.Pool;
import flow.bpmn.model.Import;
import flow.bpmn.model.Interface;
import flow.bpmn.model.Artifact;
import flow.bpmn.model.Resource;
import flow.bpmn.model.Lane;
import flow.bpmn.model.FlowElement;
import flow.bpmn.model.SubProcess;
import std.uni;
import std.typecons : No;
import std.string;
//import flow.bpmn.model.GraphicInfo;
//import org.apache.commons.lang3.StringUtils;

//import com.fasterxml.jackson.annotation.JsonIgnore;

/**
 * @author Tijs Rademakers
 * @author Joram Barrez
 */
class BpmnModel {

    protected Map!(string, List!ExtensionAttribute) definitionsAttributes ;// = new LinkedHashMap<>();
    protected List!Process processes ;//= new ArrayList<>();
    //protected Map<string, GraphicInfo> locationMap = new LinkedHashMap<>();
    //protected Map<string, GraphicInfo> labelLocationMap = new LinkedHashMap<>();
   // protected Map<string, List<GraphicInfo>> flowLocationMap = new LinkedHashMap<>();
    protected List!Signal signals ;//= new ArrayList<>();
    protected Map!(string, MessageFlow) messageFlowMap ;//= new LinkedHashMap<>();
    protected Map!(string, Message) messageMap ;//= new LinkedHashMap<>();
    protected Map!(string, string) errorMap ;//= new LinkedHashMap<>();
    protected Map!(string, Escalation) escalationMap ;//= new LinkedHashMap<>();
    protected Map!(string, ItemDefinition) itemDefinitionMap ;//= new LinkedHashMap<>();
    protected Map!(string, DataStore) dataStoreMap ;// = new LinkedHashMap<>();
    protected List!Pool pools ;//= new ArrayList<>();
    protected List!Import imports ;//= new ArrayList<>();
    protected List!Interface interfaces ;//= new ArrayList<>();
    protected List!Artifact globalArtifacts ;//= new ArrayList<>();
    protected List!Resource resources  ;//new ArrayList<>();
    protected Map!(string, string) namespaceMap ;//= new LinkedHashMap<>();
    protected string targetNamespace;
    protected string sourceSystemId;
    protected List!string userTaskFormTypes;
    protected List!string startEventFormTypes;
    protected int nextFlowIdCounter = 1;
    protected Object eventSupport;

    public Map!(string, List!ExtensionAttribute) getDefinitionsAttributes() {
        return definitionsAttributes;
    }

    public string getDefinitionsAttributeValue(string namespace, string name) {
        List!ExtensionAttribute attributes = getDefinitionsAttributes().get(name);
        if (attributes !is null && !attributes.isEmpty()) {
            foreach (ExtensionAttribute attribute ; attributes) {
                if (namespace == (attribute.getNamespace()))
                    return attribute.getValue();
            }
        }
        return null;
    }

    public void addDefinitionsAttribute(ExtensionAttribute attribute) {
        if (attribute !is null && (attribute.getName() !is null && attribute.getName().length != 0)) {
            List!ExtensionAttribute attributeList = null;
            if (!this.definitionsAttributes.containsKey(attribute.getName())) {
                attributeList = new ArrayList!ExtensionAttribute();
                this.definitionsAttributes.put(attribute.getName(), attributeList);
            }
            this.definitionsAttributes.get(attribute.getName()).add(attribute);
        }
    }

    public void setDefinitionsAttributes(Map!(string, List!ExtensionAttribute) attributes) {
        this.definitionsAttributes = attributes;
    }

    public Process getMainProcess() {
        if (!getPools().isEmpty()) {
            return getProcess(getPools().get(0).getId());
        } else {
            return getProcess(null);
        }
    }

    public Process getProcess(string poolRef) {
        foreach (Process process ; processes) {
            bool foundPool = false;
            foreach (Pool pool ; pools) {
                if ((pool.getProcessRef() !is null && pool.getProcessRef().length != 0) && (icmp(pool.getProcessRef(),process.getId()) == 0)) {

                    if (poolRef !is null) {
                        if (icmp(pool.getId(),poolRef) == 0) {
                            foundPool = true;
                        }
                    } else {
                        foundPool = true;
                    }
                }
            }

            if (poolRef is null && !foundPool) {
                return process;
            } else if (poolRef !is null && foundPool) {
                return process;
            }
        }

        return null;
    }

    public Process getProcessById(string id) {
        foreach (Process process ; processes) {
            if (process.getId() == (id)) {
                return process;
            }
        }
        return null;
    }

    public List!Process getProcesses() {
        return processes;
    }

    public void addProcess(Process process) {
        processes.add(process);
    }

    public Pool getPool(string id) {
        Pool foundPool = null;
        if (id !is null && id.length != 0) {
            foreach (Pool pool ; pools) {
                if (id == (pool.getId())) {
                    foundPool = pool;
                    break;
                }
            }
        }
        return foundPool;
    }

    public Lane getLane(string id) {
        Lane foundLane = null;
        if (id !is null && id.length != 0) {
            foreach (Process process ; processes) {
                foreach (Lane lane ; process.getLanes()) {
                    if (id == (lane.getId())) {
                        foundLane = lane;
                        break;
                    }
                }
                if (foundLane !is null) {
                    break;
                }
            }
        }
        return foundLane;
    }

    public FlowElement getFlowElement(string id) {
        FlowElement foundFlowElement = null;
        foreach (Process process ; processes) {
            foundFlowElement = process.getFlowElement(id);
            if (foundFlowElement !is null) {
                break;
            }
        }

        if (foundFlowElement is null) {
            foreach (Process process ; processes) {
                foreach (FlowElement flowElement ; process.findFlowElementsOfType!SubProcess(typeid(SubProcess))) {
                    foundFlowElement = getFlowElementInSubProcess(id, cast(SubProcess)flowElement);
                    if (foundFlowElement !is null) {
                        break;
                    }
                }
                if (foundFlowElement !is null) {
                    break;
                }
            }
        }

        return foundFlowElement;
    }

    protected FlowElement getFlowElementInSubProcess(string id, SubProcess subProcess) {
        FlowElement foundFlowElement = subProcess.getFlowElement(id);
        if (foundFlowElement is null) {
            foreach (FlowElement flowElement ; subProcess.getFlowElements()) {
                SubProcess s = cast(SubProcess)flowElement;
                if (s !is null) {
                    foundFlowElement = getFlowElementInSubProcess(id, s);
                    if (foundFlowElement !is null) {
                        break;
                    }
                }
            }
        }
        return foundFlowElement;
    }

    public Artifact getArtifact(string id) {
        Artifact foundArtifact = null;
        foreach (Process process ; processes) {
            foundArtifact = process.getArtifact(id);
            if (foundArtifact !is null) {
                break;
            }
        }

        if (foundArtifact is null) {
            foreach (Process process ; processes) {
                foreach (FlowElement flowElement ; process.findFlowElementsOfType!SubProcess(typeid(SubProcess))) {
                    foundArtifact = getArtifactInSubProcess(id, cast(SubProcess) flowElement);
                    if (foundArtifact !is null) {
                        break;
                    }
                }
                if (foundArtifact !is null) {
                    break;
                }
            }
        }

        return foundArtifact;
    }

    protected Artifact getArtifactInSubProcess(string id, SubProcess subProcess) {
        Artifact foundArtifact = subProcess.getArtifact(id);
        if (foundArtifact is null) {
            foreach (FlowElement flowElement ; subProcess.getFlowElements()) {
                SubProcess s = cast(SubProcess)flowElement;
                if (s !is null) {
                    foundArtifact = getArtifactInSubProcess(id, s);
                    if (foundArtifact !is null) {
                        break;
                    }
                }
            }
        }
        return foundArtifact;
    }

    //public void addGraphicInfo(string key, GraphicInfo graphicInfo) {
    //    locationMap.put(key, graphicInfo);
    //}
    //
    //public GraphicInfo getGraphicInfo(string key) {
    //    return locationMap.get(key);
    //}
    //
    //public void removeGraphicInfo(string key) {
    //    locationMap.remove(key);
    //}

    //public List<GraphicInfo> getFlowLocationGraphicInfo(string key) {
    //    return flowLocationMap.get(key);
    //}
    //
    //public void removeFlowGraphicInfoList(string key) {
    //    flowLocationMap.remove(key);
    //}
    //
    //public Map<string, GraphicInfo> getLocationMap() {
    //    return locationMap;
    //}
    //
    //public Map<string, List<GraphicInfo>> getFlowLocationMap() {
    //    return flowLocationMap;
    //}
    //
    //public GraphicInfo getLabelGraphicInfo(string key) {
    //    return labelLocationMap.get(key);
    //}
    //
    //public void addLabelGraphicInfo(string key, GraphicInfo graphicInfo) {
    //    labelLocationMap.put(key, graphicInfo);
    //}
    //
    //public void removeLabelGraphicInfo(string key) {
    //    labelLocationMap.remove(key);
    //}
    //
    //public Map<string, GraphicInfo> getLabelLocationMap() {
    //    return labelLocationMap;
    //}
    //
    //public void addFlowGraphicInfoList(string key, List<GraphicInfo> graphicInfoList) {
    //    flowLocationMap.put(key, graphicInfoList);
    //}

    public Collection!Resource getResources() {
        return resources;
    }

    public void setResources(Collection!Resource resourceList) {
        if (resourceList !is null) {
            resources.clear();
            resources.addAll(resourceList);
        }
    }

    public void addResource(Resource resource) {
        if (resource !is null) {
            resources.add(resource);
        }
    }

    public bool containsResourceId(string resourceId) {
        return getResource(resourceId) !is null;
    }

    public Resource getResource(string id) {
        foreach (Resource resource ; resources) {
            if (id == (resource.getId())) {
                return resource;
            }
        }
        return null;
    }

    public Collection!Signal getSignals() {
        return signals;
    }

    public void setSignals(Collection!Signal signalList) {
        if (signalList !is null) {
            signals.clear();
            signals.addAll(signalList);
        }
    }

    public void addSignal(Signal signal) {
        if (signal !is null) {
            signals.add(signal);
        }
    }

    public bool containsSignalId(string signalId) {
        return getSignal(signalId) !is null;
    }

    public Signal getSignal(string id) {
        Signal foundSignal = null;
        if (id !is null && id.length != 0) {
            foreach (Signal signal ; signals) {
                if (id == (signal.getId())) {
                    foundSignal = signal;
                    break;
                }
            }
        }
        return foundSignal;
    }

    public Map!(string, MessageFlow) getMessageFlows() {
        return messageFlowMap;
    }

    public void setMessageFlows(Map!(string, MessageFlow) messageFlows) {
        this.messageFlowMap = messageFlows;
    }

    public void addMessageFlow(MessageFlow messageFlow) {
        if (messageFlow !is null && (messageFlow.getId() !is null && messageFlow.getId().length != 0)) {
            messageFlowMap.put(messageFlow.getId(), messageFlow);
        }
    }

    public MessageFlow getMessageFlow(string id) {
        return messageFlowMap.get(id);
    }

    public bool containsMessageFlowId(string messageFlowId) {
        return messageFlowMap.containsKey(messageFlowId);
    }

    public Collection!Message getMessages() {
        return messageMap.values();
    }

    public void setMessages(Collection!Message messageList) {
        if (messageList !is null) {
            messageMap.clear();
            foreach (Message message ; messageList) {
                addMessage(message);
            }
        }
    }

    public void addMessage(Message message) {
        if (message !is null && (message.getId() !is null && message.getId().length != 0)) {
            messageMap.put(message.getId(), message);
        }
    }

    public Message getMessage(string id) {
        Message result = messageMap.get(id);
        if (result is null) {
            int indexOfNS = cast(int)(id.indexOf(':'));
            if (indexOfNS > 0) {
                string idNamespace = id[0 .. indexOfNS];
                if (icmp(idNamespace,this.getTargetNamespace()) == 0) {
                    id = id[indexOfNS + 1 .. $];
                }
                result = messageMap.get(id);
            }
        }
        return result;
    }

    public bool containsMessageId(string messageId) {
        return messageMap.containsKey(messageId);
    }

    public Map!(string, string) getErrors() {
        return errorMap;
    }

    public void setErrors(Map!(string, string) errorMap) {
        this.errorMap = errorMap;
    }

    public void addError(string errorRef, string errorCode) {
        if (errorRef !is null && errorRef.length != 0) {
            errorMap.put(errorRef, errorCode);
        }
    }

    public bool containsErrorRef(string errorRef) {
        return errorMap.containsKey(errorRef);
    }

    public Collection!Escalation getEscalations() {
        return escalationMap.values();
    }

    public void setEscalations(Map!(string, Escalation) escalationMap) {
        this.escalationMap = escalationMap;
    }

    public void addEscalation(string escalationRef, string escalationCode, string name) {
        if (escalationRef !is null && escalationRef.length != 0) {
            escalationMap.put(escalationRef, new Escalation(escalationRef, name, escalationCode));
        }
    }

    public void addEscalation(Escalation escalation) {
        if (escalation.getEscalationCode() !is null && escalation.getEscalationCode().length != 0) {
            escalationMap.put(escalation.getEscalationCode(), escalation);
        }
    }

    public bool containsEscalationRef(string escalationRef) {
        return escalationMap.containsKey(escalationRef);
    }

    public Escalation getEscalation(string escalationRef) {
        return escalationMap.get(escalationRef);
    }

    public Map!(string, ItemDefinition) getItemDefinitions() {
        return itemDefinitionMap;
    }

    public void setItemDefinitions(Map!(string, ItemDefinition) itemDefinitionMap) {
        this.itemDefinitionMap = itemDefinitionMap;
    }

    public void addItemDefinition(string id, ItemDefinition item) {
        if (id !is null && id.length != 0) {
            itemDefinitionMap.put(id, item);
        }
    }

    public bool containsItemDefinitionId(string id) {
        return itemDefinitionMap.containsKey(id);
    }

    public Map!(string, DataStore) getDataStores() {
        return dataStoreMap;
    }

    public void setDataStores(Map!(string, DataStore) dataStoreMap) {
        this.dataStoreMap = dataStoreMap;
    }

    public DataStore getDataStore(string id) {
        DataStore dataStore = null;
        if (dataStoreMap.containsKey(id)) {
            dataStore = dataStoreMap.get(id);
        }
        return dataStore;
    }

    public void addDataStore(string id, DataStore dataStore) {
        if (id !is null && id.length != 0) {
            dataStoreMap.put(id, dataStore);
        }
    }

    public bool containsDataStore(string id) {
        return dataStoreMap.containsKey(id);
    }

    public List!Pool getPools() {
        return pools;
    }

    public void setPools(List!Pool pools) {
        this.pools = pools;
    }

    public List!Import getImports() {
        return imports;
    }

    public void setImports(List!Import imports) {
        this.imports = imports;
    }

    public List!Interface getInterfaces() {
        return interfaces;
    }

    public void setInterfaces(List!Interface interfaces) {
        this.interfaces = interfaces;
    }

    public List!Artifact getGlobalArtifacts() {
        return globalArtifacts;
    }

    public void setGlobalArtifacts(List!Artifact globalArtifacts) {
        this.globalArtifacts = globalArtifacts;
    }

    public void addNamespace(string prefix, string uri) {
        namespaceMap.put(prefix, uri);
    }

    public bool containsNamespacePrefix(string prefix) {
        return namespaceMap.containsKey(prefix);
    }

    public string getNamespace(string prefix) {
        return namespaceMap.get(prefix);
    }

    public Map!(string, string) getNamespaces() {
        return namespaceMap;
    }

    public string getTargetNamespace() {
        return targetNamespace;
    }

    public void setTargetNamespace(string targetNamespace) {
        this.targetNamespace = targetNamespace;
    }

    public string getSourceSystemId() {
        return sourceSystemId;
    }

    public void setSourceSystemId(string sourceSystemId) {
        this.sourceSystemId = sourceSystemId;
    }

    public List!string getUserTaskFormTypes() {
        return userTaskFormTypes;
    }

    public void setUserTaskFormTypes(List!string userTaskFormTypes) {
        this.userTaskFormTypes = userTaskFormTypes;
    }

    public List!string getStartEventFormTypes() {
        return startEventFormTypes;
    }

    public void setStartEventFormTypes(List!string startEventFormTypes) {
        this.startEventFormTypes = startEventFormTypes;
    }

    //@JsonIgnore
    public Object getEventSupport() {
        return eventSupport;
    }

    public void setEventSupport(Object eventSupport) {
        this.eventSupport = eventSupport;
    }
}
