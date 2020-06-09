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
module flow.engine.impl.bpmn.deployer.BpmnDeployer;

import hunt.collection;
import hunt.collection.LinkedHashMap;
import hunt.collection.List;
import hunt.collection.Map;

import flow.bpmn.converter.constants.BpmnXMLConstants;
import flow.bpmn.model.BpmnModel;
import flow.bpmn.model.ExtensionElement;
import flow.bpmn.model.FlowElement;
import flow.bpmn.model.Process;
import flow.bpmn.model.StartEvent;
import flow.bpmn.model.SubProcess;
import flow.bpmn.model.UserTask;
import flow.bpmn.model.ValuedDataObject;
import flow.common.api.deleg.event.FlowableEngineEventType;
import flow.common.api.deleg.event.FlowableEventDispatcher;
import flow.common.api.repository.EngineDeployment;
import flow.common.api.repository.EngineResource;
import flow.common.EngineDeployer;
import flow.common.cfg.IdGenerator;
import flow.common.context.Context;
import flow.common.interceptor.CommandContext;
import flow.engine.DynamicBpmnConstants;
import flow.engine.DynamicBpmnService;
import flow.engine.deleg.event.impl.FlowableEventBuilder;
import flow.engine.impl.cfg.ProcessEngineConfigurationImpl;
import flow.engine.impl.cmd.DeploymentSettings;
import flow.engine.impl.persistence.entity.DeploymentEntity;
import flow.engine.impl.persistence.entity.ProcessDefinitionEntity;
import flow.engine.impl.persistence.entity.ProcessDefinitionEntityManager;
import flow.engine.impl.persistence.entity.ResourceEntity;
import flow.engine.impl.persistence.entity.ResourceEntityManager;
import flow.engine.impl.util.CommandContextUtil;

//import com.fasterxml.jackson.databind.JsonNode;
//import com.fasterxml.jackson.databind.node.ObjectNode;

import flow.engine.impl.bpmn.deployer.ParsedDeploymentBuilderFactory;
import flow.engine.impl.bpmn.deployer.ParsedDeployment;
import flow.engine.impl.bpmn.deployer.CachingAndArtifactsManager;
import flow.engine.impl.bpmn.deployer.ProcessDefinitionDiagramHelper;
import hunt.logging;
import hunt.String;
import std.conv : to;
import hunt.Exceptions;

/**
 * @author Joram Barrez
 * @author Tijs Rademakers
 */
class BpmnDeployer : EngineDeployer {

    protected IdGenerator idGenerator;
    protected ParsedDeploymentBuilderFactory parsedDeploymentBuilderFactory;
    protected BpmnDeploymentHelper bpmnDeploymentHelper;
    protected CachingAndArtifactsManager cachingAndArtifactsManager;
    protected ProcessDefinitionDiagramHelper processDefinitionDiagramHelper;
    protected bool usePrefixId;

    override
    public void deploy(EngineDeployment deployment, Map!(string, Object) deploymentSettings) {
        logInfo("Processing deployment {%s}", deployment.getName());

        // The ParsedDeployment represents the deployment, the process definitions, and the BPMN
        // resource, parse, and model associated with each process definition.
        ParsedDeployment parsedDeployment = parsedDeploymentBuilderFactory
                .getBuilderForDeploymentAndSettings(deployment, deploymentSettings)
                .build();

        bpmnDeploymentHelper.verifyProcessDefinitionsDoNotShareKeys(parsedDeployment.getAllProcessDefinitions());

        bpmnDeploymentHelper.copyDeploymentValuesToProcessDefinitions(
                parsedDeployment.getDeployment(), parsedDeployment.getAllProcessDefinitions());
        bpmnDeploymentHelper.setResourceNamesOnProcessDefinitions(parsedDeployment);

        createAndPersistNewDiagramsIfNeeded(parsedDeployment);
        setProcessDefinitionDiagramNames(parsedDeployment);

        if (deployment.isNew()) {
            if (!deploymentSettings.containsKey(DeploymentSettings.IS_DERIVED_DEPLOYMENT)) {
                Map!(ProcessDefinitionEntity, ProcessDefinitionEntity) mapOfNewProcessDefinitionToPreviousVersion = getPreviousVersionsOfProcessDefinitions(parsedDeployment);
                setProcessDefinitionVersionsAndIds(parsedDeployment, mapOfNewProcessDefinitionToPreviousVersion);
                persistProcessDefinitionsAndAuthorizations(parsedDeployment);
                updateTimersAndEvents(parsedDeployment, mapOfNewProcessDefinitionToPreviousVersion);

            } else {
                Map!(ProcessDefinitionEntity, ProcessDefinitionEntity) mapOfNewProcessDefinitionToPreviousDerivedVersion =
                                getPreviousDerivedFromVersionsOfProcessDefinitions(parsedDeployment);
                setDerivedProcessDefinitionVersionsAndIds(parsedDeployment, mapOfNewProcessDefinitionToPreviousDerivedVersion, deploymentSettings);
                persistProcessDefinitionsAndAuthorizations(parsedDeployment);
            }

        } else {
            makeProcessDefinitionsConsistentWithPersistedVersions(parsedDeployment);
        }

        cachingAndArtifactsManager.updateCachingAndArtifacts(parsedDeployment);

        if (deployment.isNew()) {
            dispatchProcessDefinitionEntityInitializedEvent(parsedDeployment);
        }

        foreach (ProcessDefinitionEntity processDefinition ; parsedDeployment.getAllProcessDefinitions()) {
            BpmnModel bpmnModel = parsedDeployment.getBpmnModelForProcessDefinition(processDefinition);
            createLocalizationValues(processDefinition.getId(), bpmnModel.getProcessById(processDefinition.getKey()));
        }
    }

    /**
     * Creates new diagrams for process definitions if the deployment is new, the process definition in question supports it, and the engine is configured to make new diagrams.
     *
     * When this method creates a new diagram, it also persists it via the ResourceEntityManager and adds it to the resources of the deployment.
     */
    protected void createAndPersistNewDiagramsIfNeeded(ParsedDeployment parsedDeployment) {

         ProcessEngineConfigurationImpl processEngineConfiguration = CommandContextUtil.getProcessEngineConfiguration();
         DeploymentEntity deploymentEntity = parsedDeployment.getDeployment();

         ResourceEntityManager resourceEntityManager = processEngineConfiguration.getResourceEntityManager();

        foreach (ProcessDefinitionEntity processDefinition ; parsedDeployment.getAllProcessDefinitions()) {
            if (processDefinitionDiagramHelper.shouldCreateDiagram(processDefinition, deploymentEntity)) {
                ResourceEntity resource = processDefinitionDiagramHelper.createDiagramForProcessDefinition(
                        processDefinition, parsedDeployment.getBpmnParseForProcessDefinition(processDefinition));
                if (resource !is null) {
                    resourceEntityManager.insert(resource, false);
                    deploymentEntity.addResource(resource); // now we'll find it if we look for the diagram name later.
                }
            }
        }
    }

    /**
     * Updates all the process definition entities to have the correct diagram resource name. Must be called after createAndPersistNewDiagramsAsNeeded to ensure that any newly-created diagrams already
     * have their resources attached to the deployment.
     */
    protected void setProcessDefinitionDiagramNames(ParsedDeployment parsedDeployment) {
        Map!(string, EngineResource) resources = parsedDeployment.getDeployment().getResources();

        foreach (ProcessDefinitionEntity processDefinition ; parsedDeployment.getAllProcessDefinitions()) {
            string diagramResourceName = ResourceNameUtil.getProcessDiagramResourceNameFromDeployment(processDefinition, resources);
            processDefinition.setDiagramResourceName(diagramResourceName);
        }
    }

    /**
     * Constructs a map from new ProcessDefinitionEntities to the previous version by key and tenant. If no previous version exists, no map entry is created.
     */
    protected Map!(ProcessDefinitionEntity, ProcessDefinitionEntity) getPreviousVersionsOfProcessDefinitions(
            ParsedDeployment parsedDeployment) {

        Map!(ProcessDefinitionEntity, ProcessDefinitionEntity) result = new LinkedHashMap!(ProcessDefinitionEntity, ProcessDefinitionEntity)();

        foreach (ProcessDefinitionEntity newDefinition ; parsedDeployment.getAllProcessDefinitions()) {
            ProcessDefinitionEntity existingDefinition = bpmnDeploymentHelper.getMostRecentVersionOfProcessDefinition(newDefinition);

            if (existingDefinition !is null) {
                result.put(newDefinition, existingDefinition);
            }
        }

        return result;
    }

    /**
     * Constructs a map from new ProcessDefinitionEntities to the previous derived from version by key and tenant. If no previous version exists, no map entry is created.
     */
    protected Map!(ProcessDefinitionEntity, ProcessDefinitionEntity) getPreviousDerivedFromVersionsOfProcessDefinitions(
            ParsedDeployment parsedDeployment) {

        Map!(ProcessDefinitionEntity, ProcessDefinitionEntity) result = new LinkedHashMap!(ProcessDefinitionEntity, ProcessDefinitionEntity)();

        foreach (ProcessDefinitionEntity newDefinition ; parsedDeployment.getAllProcessDefinitions()) {
            ProcessDefinitionEntity existingDefinition = bpmnDeploymentHelper.getMostRecentDerivedVersionOfProcessDefinition(newDefinition);

            if (existingDefinition !is null) {
                result.put(newDefinition, existingDefinition);
            }
        }

        return result;
    }

    /**
     * Sets the version on each process definition entity, and the identifier. If the map contains an older version for a process definition, then the version is set to that older entity's version
     * plus one; otherwise it is set to 1. Also dispatches an ENTITY_CREATED event.
     */
    protected void setProcessDefinitionVersionsAndIds(ParsedDeployment parsedDeployment,
            Map!(ProcessDefinitionEntity, ProcessDefinitionEntity) mapNewToOldProcessDefinitions) {
        CommandContext commandContext = Context.getCommandContext();

        foreach (ProcessDefinitionEntity processDefinition ; parsedDeployment.getAllProcessDefinitions()) {
            int ver = 1;

            ProcessDefinitionEntity latest = mapNewToOldProcessDefinitions.get(processDefinition);
            if (latest !is null) {
              ver = latest.getVersion() + 1;
            }

            processDefinition.setVersion(ver);
            processDefinition.setId(getIdForNewProcessDefinition(processDefinition));
            Process process = parsedDeployment.getProcessModelForProcessDefinition(processDefinition);
            FlowElement initialElement = process.getInitialFlowElement();
            if (cast(StartEvent)initialElement !is null) {
                StartEvent startEvent = cast(StartEvent) initialElement;
                if (startEvent.getFormKey() !is null && startEvent.getFormKey().length != 0) {
                    processDefinition.setHasStartFormKey(true);
                }
            }

            cachingAndArtifactsManager.updateProcessDefinitionCache(parsedDeployment);

            FlowableEventDispatcher eventDispatcher = CommandContextUtil.getProcessEngineConfiguration(commandContext).getEventDispatcher();
            if (eventDispatcher !is null && eventDispatcher.isEnabled()) {
                eventDispatcher
                    .dispatchEvent(FlowableEventBuilder.createEntityEvent(FlowableEngineEventType.ENTITY_CREATED, processDefinition));
            }
        }
    }

    protected void setDerivedProcessDefinitionVersionsAndIds(ParsedDeployment parsedDeployment,
            Map!(ProcessDefinitionEntity, ProcessDefinitionEntity) mapNewToOldProcessDefinitions, Map!(string, Object) deploymentSettings) {

        CommandContext commandContext = Context.getCommandContext();

        foreach (ProcessDefinitionEntity processDefinition ; parsedDeployment.getAllProcessDefinitions()) {
            int derivedVersion = 1;

            ProcessDefinitionEntity latest = mapNewToOldProcessDefinitions.get(processDefinition);
            if (latest !is null) {
                derivedVersion = latest.getDerivedVersion() + 1;
            }

            processDefinition.setVersion(0);
            processDefinition.setDerivedVersion(derivedVersion);
            if (usePrefixId) {
                processDefinition.setId(processDefinition.getIdPrefix() ~ idGenerator.getNextId());
            } else {
                processDefinition.setId(idGenerator.getNextId());
            }

            processDefinition.setDerivedFrom((cast(String) deploymentSettings.get(DeploymentSettings.DERIVED_PROCESS_DEFINITION_ID)).value);
            processDefinition.setDerivedFromRoot((cast(String) deploymentSettings.get(DeploymentSettings.DERIVED_PROCESS_DEFINITION_ROOT_ID)).value);

            Process process = parsedDeployment.getProcessModelForProcessDefinition(processDefinition);
            FlowElement initialElement = process.getInitialFlowElement();
            if (cast(StartEvent)initialElement !is null) {
                StartEvent startEvent = cast(StartEvent) initialElement;
                if (startEvent.getFormKey() !is null && startEvent.getFormKey().length != 0) {
                    processDefinition.setHasStartFormKey(true);
                }
            }

            cachingAndArtifactsManager.updateProcessDefinitionCache(parsedDeployment);

            FlowableEventDispatcher eventDispatcher = CommandContextUtil.getProcessEngineConfiguration(commandContext).getEventDispatcher();
            if (eventDispatcher !is null && eventDispatcher.isEnabled()) {
                eventDispatcher
                    .dispatchEvent(FlowableEventBuilder.createEntityEvent(FlowableEngineEventType.ENTITY_CREATED, processDefinition));
            }
        }
    }

    /**
     * Saves each process definition. It is assumed that the deployment is new, the definitions have never been saved before, and that they have all their values properly set up.
     */
    protected void persistProcessDefinitionsAndAuthorizations(ParsedDeployment parsedDeployment) {
        CommandContext commandContext = Context.getCommandContext();
        ProcessDefinitionEntityManager processDefinitionManager = CommandContextUtil.getProcessDefinitionEntityManager(commandContext);

        foreach (ProcessDefinitionEntity processDefinition ; parsedDeployment.getAllProcessDefinitions()) {
            processDefinitionManager.insert(processDefinition, false);
            bpmnDeploymentHelper.addAuthorizationsForNewProcessDefinition(parsedDeployment.getProcessModelForProcessDefinition(processDefinition), processDefinition);
        }
    }

    protected void updateTimersAndEvents(ParsedDeployment parsedDeployment,
            Map!(ProcessDefinitionEntity, ProcessDefinitionEntity) mapNewToOldProcessDefinitions) {

        foreach (ProcessDefinitionEntity processDefinition ; parsedDeployment.getAllProcessDefinitions()) {
            bpmnDeploymentHelper.updateTimersAndEvents(processDefinition,
                    mapNewToOldProcessDefinitions.get(processDefinition),
                    parsedDeployment);
        }
    }

    protected void dispatchProcessDefinitionEntityInitializedEvent(ParsedDeployment parsedDeployment) {
        CommandContext commandContext = Context.getCommandContext();
        foreach (ProcessDefinitionEntity processDefinitionEntity ; parsedDeployment.getAllProcessDefinitions()) {
            FlowableEventDispatcher eventDispatcher = CommandContextUtil.getProcessEngineConfiguration(commandContext).getEventDispatcher();
            if (eventDispatcher !is null && eventDispatcher.isEnabled()) {
                eventDispatcher.dispatchEvent(
                        FlowableEventBuilder.createEntityEvent(FlowableEngineEventType.ENTITY_INITIALIZED, processDefinitionEntity));
            }
        }
    }

    /**
     * Returns the ID to use for a new process definition; subclasses may override this to provide their own identification scheme.
     *
     * Process definition ids NEED to be unique across the whole engine!
     */
    protected string getIdForNewProcessDefinition(ProcessDefinitionEntity processDefinition) {
        string prefixId = "";
        if (usePrefixId) {
            prefixId = processDefinition.getIdPrefix();
        }

        string nextId = idGenerator.getNextId();

        string result = prefixId ~ processDefinition.getKey() ~ ":" ~ to!string(processDefinition.getVersion()) ~ ":" ~ nextId; // ACT-505
        // ACT-115: maximum id length is 64 characters
        if (result.length() > 64) {
            // The length is exceeded due to the long process definition key
            result = prefixId ~ nextId;
        }

        return result;
    }

    /**
     * Loads the persisted version of each process definition and set values on the in-memory version to be consistent.
     */
    protected void makeProcessDefinitionsConsistentWithPersistedVersions(ParsedDeployment parsedDeployment) {
        foreach (ProcessDefinitionEntity processDefinition ; parsedDeployment.getAllProcessDefinitions()) {
            ProcessDefinitionEntity persistedProcessDefinition = bpmnDeploymentHelper.getPersistedInstanceOfProcessDefinition(processDefinition);

            if (persistedProcessDefinition !is null) {
                processDefinition.setId(persistedProcessDefinition.getId());
                processDefinition.setVersion(persistedProcessDefinition.getVersion());
                processDefinition.setSuspensionState(persistedProcessDefinition.getSuspensionState());
                processDefinition.setHasStartFormKey(persistedProcessDefinition.hasStartFormKey());
                processDefinition.setGraphicalNotationDefined(persistedProcessDefinition.isGraphicalNotationDefined());
            }
        }
    }

    protected void createLocalizationValues(string processDefinitionId, Process process) {
        implementationMissing(false);
        //if (process is null)
        //    return;
        //
        //CommandContext commandContext = Context.getCommandContext();
        //DynamicBpmnService dynamicBpmnService = CommandContextUtil.getProcessEngineConfiguration(commandContext).getDynamicBpmnService();
        //ObjectNode infoNode = dynamicBpmnService.getProcessDefinitionInfo(processDefinitionId);
        //
        //bool localizationValuesChanged = false;
        //List!ExtensionElement localizationElements = process.getExtensionElements().get("localization");
        //if (localizationElements !is null) {
        //    for (ExtensionElement localizationElement : localizationElements) {
        //        if (BpmnXMLConstants.FLOWABLE_EXTENSIONS_PREFIX.equals(localizationElement.getNamespacePrefix()) ||
        //                BpmnXMLConstants.ACTIVITI_EXTENSIONS_PREFIX.equals(localizationElement.getNamespacePrefix())) {
        //
        //            string locale = localizationElement.getAttributeValue(null, "locale");
        //            string name = localizationElement.getAttributeValue(null, "name");
        //            string documentation = null;
        //            List!ExtensionElement documentationElements = localizationElement.getChildElements().get("documentation");
        //            if (documentationElements !is null) {
        //                for (ExtensionElement documentationElement : documentationElements) {
        //                    documentation = StringUtils.trimToNull(documentationElement.getElementText());
        //                    break;
        //                }
        //            }
        //
        //            string processId = process.getId();
        //            if (!isEqualToCurrentLocalizationValue(locale, processId, "name", name, infoNode)) {
        //                dynamicBpmnService.changeLocalizationName(locale, processId, name, infoNode);
        //                localizationValuesChanged = true;
        //            }
        //
        //            if (documentation !is null && !isEqualToCurrentLocalizationValue(locale, processId, "description", documentation, infoNode)) {
        //                dynamicBpmnService.changeLocalizationDescription(locale, processId, documentation, infoNode);
        //                localizationValuesChanged = true;
        //            }
        //        }
        //    }
        //}
        //
        //bool isFlowElementLocalizationChanged = localizeFlowElements(process.getFlowElements(), infoNode);
        //bool isDataObjectLocalizationChanged = localizeDataObjectElements(process.getDataObjects(), infoNode);
        //if (isFlowElementLocalizationChanged || isDataObjectLocalizationChanged) {
        //    localizationValuesChanged = true;
        //}
        //
        //if (localizationValuesChanged) {
        //    dynamicBpmnService.saveProcessDefinitionInfo(processDefinitionId, infoNode);
        //}
    }

    //protected bool localizeFlowElements(Collection!FlowElement flowElements, ObjectNode infoNode) {
    //    bool localizationValuesChanged = false;
    //
    //    if (flowElements is null)
    //        return localizationValuesChanged;
    //
    //    CommandContext commandContext = Context.getCommandContext();
    //    DynamicBpmnService dynamicBpmnService = CommandContextUtil.getProcessEngineConfiguration(commandContext).getDynamicBpmnService();
    //
    //    for (FlowElement flowElement : flowElements) {
    //        if (flowElement instanceof UserTask || flowElement instanceof SubProcess) {
    //            List!ExtensionElement localizationElements = flowElement.getExtensionElements().get("localization");
    //            if (localizationElements !is null) {
    //                for (ExtensionElement localizationElement : localizationElements) {
    //                    if (BpmnXMLConstants.FLOWABLE_EXTENSIONS_PREFIX.equals(localizationElement.getNamespacePrefix()) ||
    //                            BpmnXMLConstants.ACTIVITI_EXTENSIONS_PREFIX.equals(localizationElement.getNamespacePrefix())) {
    //
    //                        string locale = localizationElement.getAttributeValue(null, "locale");
    //                        string name = localizationElement.getAttributeValue(null, "name");
    //                        string documentation = null;
    //                        List!ExtensionElement documentationElements = localizationElement.getChildElements().get("documentation");
    //                        if (documentationElements !is null) {
    //                            for (ExtensionElement documentationElement : documentationElements) {
    //                                documentation = StringUtils.trimToNull(documentationElement.getElementText());
    //                                break;
    //                            }
    //                        }
    //
    //                        string flowElementId = flowElement.getId();
    //                        if (!isEqualToCurrentLocalizationValue(locale, flowElementId, "name", name, infoNode)) {
    //                            dynamicBpmnService.changeLocalizationName(locale, flowElementId, name, infoNode);
    //                            localizationValuesChanged = true;
    //                        }
    //
    //                        if (documentation !is null && !isEqualToCurrentLocalizationValue(locale, flowElementId, "description", documentation, infoNode)) {
    //                            dynamicBpmnService.changeLocalizationDescription(locale, flowElementId, documentation, infoNode);
    //                            localizationValuesChanged = true;
    //                        }
    //                    }
    //                }
    //            }
    //
    //            if (flowElement instanceof SubProcess) {
    //                SubProcess subprocess = (SubProcess) flowElement;
    //                bool isFlowElementLocalizationChanged = localizeFlowElements(subprocess.getFlowElements(), infoNode);
    //                bool isDataObjectLocalizationChanged = localizeDataObjectElements(subprocess.getDataObjects(), infoNode);
    //                if (isFlowElementLocalizationChanged || isDataObjectLocalizationChanged) {
    //                    localizationValuesChanged = true;
    //                }
    //            }
    //        }
    //    }
    //
    //    return localizationValuesChanged;
    //}
    //
    //protected bool isEqualToCurrentLocalizationValue(string language, string id, string propertyName, string propertyValue, ObjectNode infoNode) {
    //    bool isEqual = false;
    //    JsonNode localizationNode = infoNode.path("localization").path(language).path(id).path(propertyName);
    //    if (!localizationNode.isMissingNode() && !localizationNode.isNull() && localizationNode.asText().equals(propertyValue)) {
    //        isEqual = true;
    //    }
    //    return isEqual;
    //}
    //
    //protected bool localizeDataObjectElements(List!ValuedDataObject dataObjects, ObjectNode infoNode) {
    //    bool localizationValuesChanged = false;
    //    CommandContext commandContext = Context.getCommandContext();
    //    DynamicBpmnService dynamicBpmnService = CommandContextUtil.getProcessEngineConfiguration(commandContext).getDynamicBpmnService();
    //
    //    for (ValuedDataObject dataObject : dataObjects) {
    //        List!ExtensionElement localizationElements = dataObject.getExtensionElements().get("localization");
    //        if (localizationElements !is null) {
    //            for (ExtensionElement localizationElement : localizationElements) {
    //                if (BpmnXMLConstants.FLOWABLE_EXTENSIONS_PREFIX.equals(localizationElement.getNamespacePrefix()) ||
    //                        BpmnXMLConstants.ACTIVITI_EXTENSIONS_PREFIX.equals(localizationElement.getNamespacePrefix())) {
    //
    //                    string locale = localizationElement.getAttributeValue(null, "locale");
    //                    string name = localizationElement.getAttributeValue(null, "name");
    //                    string documentation = null;
    //
    //                    List!ExtensionElement documentationElements = localizationElement.getChildElements().get("documentation");
    //                    if (documentationElements !is null) {
    //                        for (ExtensionElement documentationElement : documentationElements) {
    //                            documentation = StringUtils.trimToNull(documentationElement.getElementText());
    //                            break;
    //                        }
    //                    }
    //
    //                    if (name !is null && !isEqualToCurrentLocalizationValue(locale, dataObject.getId(), DynamicBpmnConstants.LOCALIZATION_NAME, name, infoNode)) {
    //                        dynamicBpmnService.changeLocalizationName(locale, dataObject.getId(), name, infoNode);
    //                        localizationValuesChanged = true;
    //                    }
    //
    //                    if (documentation !is null && !isEqualToCurrentLocalizationValue(locale, dataObject.getId(),
    //                            DynamicBpmnConstants.LOCALIZATION_DESCRIPTION, documentation, infoNode)) {
    //
    //                        dynamicBpmnService.changeLocalizationDescription(locale, dataObject.getId(), documentation, infoNode);
    //                        localizationValuesChanged = true;
    //                    }
    //                }
    //            }
    //        }
    //    }
    //
    //    return localizationValuesChanged;
    //}

    public IdGenerator getIdGenerator() {
        return idGenerator;
    }

    public void setIdGenerator(IdGenerator idGenerator) {
        this.idGenerator = idGenerator;
    }

    public ParsedDeploymentBuilderFactory getExParsedDeploymentBuilderFactory() {
        return parsedDeploymentBuilderFactory;
    }

    public void setParsedDeploymentBuilderFactory(ParsedDeploymentBuilderFactory parsedDeploymentBuilderFactory) {
        this.parsedDeploymentBuilderFactory = parsedDeploymentBuilderFactory;
    }

    public BpmnDeploymentHelper getBpmnDeploymentHelper() {
        return bpmnDeploymentHelper;
    }

    public void setBpmnDeploymentHelper(BpmnDeploymentHelper bpmnDeploymentHelper) {
        this.bpmnDeploymentHelper = bpmnDeploymentHelper;
    }

    public CachingAndArtifactsManager getCachingAndArtifcatsManager() {
        return cachingAndArtifactsManager;
    }

    public void setCachingAndArtifactsManager(CachingAndArtifactsManager manager) {
        this.cachingAndArtifactsManager = manager;
    }

    public ProcessDefinitionDiagramHelper getProcessDefinitionDiagramHelper() {
        return processDefinitionDiagramHelper;
    }

    public void setProcessDefinitionDiagramHelper(ProcessDefinitionDiagramHelper processDefinitionDiagramHelper) {
        this.processDefinitionDiagramHelper = processDefinitionDiagramHelper;
    }

    public bool isUsePrefixId() {
        return usePrefixId;
    }

    public void setUsePrefixId(bool usePrefixId) {
        this.usePrefixId = usePrefixId;
    }
}
