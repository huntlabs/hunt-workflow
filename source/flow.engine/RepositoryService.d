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

//          Copyright linse 2020.
// Distributed under the Boost Software License, Version 1.0.
//    (See accompanying file LICENSE_1_0.txt or copy at
//          http://www.boost.org/LICENSE_1_0.txt)}

module flow.engine.RepositoryService;






import hunt.stream.Common;
import hunt.collection.List;
import hunt.time.LocalDateTime;

import flow.bpmn.model.BpmnModel;
import flow.common.api.FlowableException;
import flow.common.api.FlowableObjectNotFoundException;
//import org.flowable.dmn.api.DmnDecisionTable;
import flow.engine.app.AppModel;
import flow.engine.repository.DeploymentMergeStrategy;
import flow.engine.repository.DeploymentBuilder;
import flow.engine.repository.DeploymentQuery;
import flow.engine.repository.DiagramLayout;
import flow.engine.repository.MergeMode;
import flow.engine.repository.Model;
import flow.engine.repository.ModelQuery;
import flow.engine.repository.NativeDeploymentQuery;
import flow.engine.repository.NativeModelQuery;
import flow.engine.repository.NativeProcessDefinitionQuery;
import flow.engine.repository.ProcessDefinition;
import flow.engine.repository.ProcessDefinitionQuery;
//import flow.form.api.FormDefinition;
//import flow.identitylink.api.IdentityLink;
//import org.flowable.validation.ValidationError;
alias Date = LocalDateTime;
/**
 * Service providing access to the repository of process definitions and deployments.
 *
 * @author Tom Baeyens
 * @author Falko Menge
 * @author Tijs Rademakers
 * @author Joram Barrez
 * @author Henry Yan
 * @author Yvo Swillens
 */
interface RepositoryService {

    /** Starts creating a new deployment */
    DeploymentBuilder createDeployment();

    /**
     * Deletes the given deployment.
     *
     * @param deploymentId
     *            id of the deployment, cannot be null.
     * @throws RuntimeException
     *             if there are still runtime or history process instances or jobs.
     */
    void deleteDeployment(string deploymentId);

    /**
     * Deletes the given deployment and cascade deletion to process instances, history process instances and jobs.
     *
     * @param deploymentId
     *            id of the deployment, cannot be null.
     */
    void deleteDeployment(string deploymentId, bool cascade);

    /**
     * Sets the category of the deployment. Deployments can be queried by category: see {@link DeploymentQuery#deploymentCategory(string)}.
     *
     * @throws FlowableObjectNotFoundException
     *             if no deployment with the provided id can be found.
     */
    void setDeploymentCategory(string deploymentId, string category);

    /**
     * Sets the key of the deployment. Deployments can be queried by key: see {@link DeploymentQuery#deploymentKey(string)}.
     *
     * @throws FlowableObjectNotFoundException
     *             if no deployment with the provided id can be found.
     */
    void setDeploymentKey(string deploymentId, string key);

    /**
     * Retrieves a list of deployment resources for the given deployment, ordered alphabetically.
     *
     * @param deploymentId
     *            id of the deployment, cannot be null.
     */
    List!string getDeploymentResourceNames(string deploymentId);

    /**
     * Gives access to a deployment resource through a stream of bytes.
     *
     * @param deploymentId
     *            id of the deployment, cannot be null.
     * @param resourceName
     *            name of the resource, cannot be null.
     * @throws FlowableObjectNotFoundException
     *             when the resource doesn't exist in the given deployment or when no deployment exists for the given deploymentId.
     */
    InputStream getResourceAsStream(string deploymentId, string resourceName);

    /**
     *
     * EXPERIMENTAL FEATURE!
     *
     * Changes the tenant identifier of a deployment to match the given tenant identifier. This change will cascade to any related entity: - process definitions related to the deployment - process
     * instances related to those process definitions - executions related to those process instances - tasks related to those process instances - jobs related to the process definitions and process
     * instances
     *
     * This method can be used in the case that there was no tenant identifier set on the deployment or those entities before.
     *
     * This method can be used to remove a tenant identifier from the deployment and related entities (simply pass null).
     *
     * Important: no optimistic locking will be done while executing the tenant identifier change!
     *
     * This is an experimental feature, mainly because it WILL NOT work properly in a clustered environment without special care: suppose some process instance is in flight. The process definition is
     * in the process definition cache. When a task or job is created when continuing the process instance, the process definition cache will be consulted to get the process definition and from it the
     * tenant identifier. Since it's cached, it will not be the new tenant identifier. This method does clear the cache for this engineinstance , but it will not be cleared on other nodes in a cluster
     * (unless using a shared process definition cache).
     *
     * @param deploymentId
     *            The id of the deployment of which the tenant identifier will be changed.
     * @param newTenantId
     *            The new tenant identifier.
     */
    void changeDeploymentTenantId(string deploymentId, string newTenantId);

    /**
     *
     * EXPERIMENTAL FEATURE!
     *
     * See more usage information {@link RepositoryService#changeDeploymentTenantId(string, string)}
     *
     * @param deploymentId
     *            The id of the deployment of which the tenant identifier will be changed.
     * @param newTenantId
     *            The new tenant identifier.
     * @param mergeMode
     *            Mode which is used to merge the deployment into the new tenant, in case the second tenant already has the same deployment key
     */
    void changeDeploymentTenantId(string deploymentId, string newTenantId, MergeMode mergeMode);

    /**
     *
     * EXPERIMENTAL FEATURE!
     *
     * See more usage information {@link RepositoryService#changeDeploymentTenantId(string, string)}
     *
     * @param deploymentId
     *            The id of the deployment of which the tenant identifier will be changed.
     * @param newTenantId
     *            The new tenant identifier.
     * @param deploymentMergeStrategy
     *            Strategy to be used to merge the deployment into the new tenant, in case the second tenant already has this deployment key
     */
    void changeDeploymentTenantId(string deploymentId, string newTenantId, DeploymentMergeStrategy deploymentMergeStrategy);

    /**
     * Changes the parent deployment id of a deployment. This is used to move deployments to a different app deployment parent.
     *
     * @param deploymentId
     *              The id of the deployment of which the parent deployment identifier will be changed.
     * @param newParentDeploymentId
     *              The new parent deployment identifier.
     */
    void changeDeploymentParentDeploymentId(string deploymentId, string newParentDeploymentId);

    /** Query process definitions. */
    ProcessDefinitionQuery createProcessDefinitionQuery();

    /**
     * Returns a new {@link flow.common.api.query.NativeQuery} for process definitions.
     */
    NativeProcessDefinitionQuery createNativeProcessDefinitionQuery();

    /** Query deployment. */
    DeploymentQuery createDeploymentQuery();

    /**
     * Returns a new {@link flow.common.api.query.NativeQuery} for deployment.
     */
    NativeDeploymentQuery createNativeDeploymentQuery();

    /**
     * Suspends the process definition with the given id.
     *
     * If a process definition is in state suspended, it will not be possible to start new process instances based on the process definition.
     *
     * <strong>Note: all the process instances of the process definition will still be active (ie. not suspended)!</strong>
     *
     * @throws FlowableObjectNotFoundException
     *             if no such processDefinition can be found
     * @throws FlowableException
     *             if the process definition is already in state suspended.
     */
    void suspendProcessDefinitionById(string processDefinitionId);

    /**
     * Suspends the process definition with the given id.
     *
     * If a process definition is in state suspended, it will not be possible to start new process instances based on the process definition.
     *
     * @param suspendProcessInstances
     *            If true, all the process instances of the provided process definition will be suspended too.
     * @param suspensionDate
     *            The date on which the process definition will be suspended. If null, the process definition is suspended immediately. Note: The job executor needs to be active to use this!
     *
     * @throws FlowableObjectNotFoundException
     *             if no such processDefinition can be found.
     * @throws FlowableException
     *             if the process definition is already in state suspended.
     */
    void suspendProcessDefinitionById(string processDefinitionId, bool suspendProcessInstances, Date suspensionDate);

    /**
     * Suspends the <strong>all</strong> process definitions with the given key (= id in the bpmn20.xml file).
     *
     * If a process definition is in state suspended, it will not be possible to start new process instances based on the process definition.
     *
     * <strong>Note: all the process instances of the process definition will still be active (ie. not suspended)!</strong>
     *
     * @throws FlowableObjectNotFoundException
     *             if no such processDefinition can be found
     * @throws FlowableException
     *             if the process definition is already in state suspended.
     */
    void suspendProcessDefinitionByKey(string processDefinitionKey);

    /**
     * Suspends the <strong>all</strong> process definitions with the given key (= id in the bpmn20.xml file).
     *
     * If a process definition is in state suspended, it will not be possible to start new process instances based on the process definition.
     *
     * @param suspendProcessInstances
     *            If true, all the process instances of the provided process definition will be suspended too.
     * @param suspensionDate
     *            The date on which the process definition will be suspended. If null, the process definition is suspended immediately. Note: The job executor needs to be active to use this!
     * @throws FlowableObjectNotFoundException
     *             if no such processDefinition can be found
     * @throws FlowableException
     *             if the process definition is already in state suspended.
     */
    void suspendProcessDefinitionByKey(string processDefinitionKey, bool suspendProcessInstances, Date suspensionDate);

    /**
     * Similar to {@link #suspendProcessDefinitionByKey(string)}, but only applicable for the given tenant identifier.
     */
    void suspendProcessDefinitionByKey(string processDefinitionKey, string tenantId);

    /**
     * Similar to {@link #suspendProcessDefinitionByKey(string, bool, Date)}, but only applicable for the given tenant identifier.
     */
    void suspendProcessDefinitionByKey(string processDefinitionKey, bool suspendProcessInstances, Date suspensionDate, string tenantId);

    /**
     * Activates the process definition with the given id.
     *
     * @throws FlowableObjectNotFoundException
     *             if no such processDefinition can be found or if the process definition is already in state active.
     */
    void activateProcessDefinitionById(string processDefinitionId);

    /**
     * Activates the process definition with the given id.
     *
     * @param activationDate
     *            The date on which the process definition will be activated. If null, the process definition is activated immediately. Note: The job executor needs to be active to use this!
     *
     * @throws FlowableObjectNotFoundException
     *             if no such processDefinition can be found.
     * @throws FlowableException
     *             if the process definition is already in state active.
     */
    void activateProcessDefinitionById(string processDefinitionId, bool activateProcessInstances, Date activationDate);

    /**
     * Activates the process definition with the given key (=id in the bpmn20.xml file).
     *
     * @throws FlowableObjectNotFoundException
     *             if no such processDefinition can be found.
     * @throws FlowableException
     *             if the process definition is already in state active.
     */
    void activateProcessDefinitionByKey(string processDefinitionKey);

    /**
     * Activates the process definition with the given key (=id in the bpmn20.xml file).
     *
     * @param activationDate
     *            The date on which the process definition will be activated. If null, the process definition is activated immediately. Note: The job executor needs to be active to use this!
     *
     * @throws FlowableObjectNotFoundException
     *             if no such processDefinition can be found.
     * @throws FlowableException
     *             if the process definition is already in state active.
     */
    void activateProcessDefinitionByKey(string processDefinitionKey, bool activateProcessInstances, Date activationDate);

    /**
     * Similar to {@link #activateProcessDefinitionByKey(string)}, but only applicable for the given tenant identifier.
     */
    void activateProcessDefinitionByKey(string processDefinitionKey, string tenantId);

    /**
     * Similar to {@link #activateProcessDefinitionByKey(string, bool, Date)} , but only applicable for the given tenant identifier.
     */
    void activateProcessDefinitionByKey(string processDefinitionKey, bool activateProcessInstances, Date activationDate, string tenantId);

    /**
     * Sets the category of the process definition. Process definitions can be queried by category: see {@link ProcessDefinitionQuery#processDefinitionCategory(string)}.
     *
     * @throws FlowableObjectNotFoundException
     *             if no process definition with the provided id can be found.
     */
    void setProcessDefinitionCategory(string processDefinitionId, string category);

    /**
     * Gives access to a deployed process model, e.g., a BPMN 2.0 XML file, through a stream of bytes.
     *
     * @param processDefinitionId
     *            id of a {@link ProcessDefinition}, cannot be null.
     * @throws FlowableObjectNotFoundException
     *             when the process model doesn't exist.
     */
    InputStream getProcessModel(string processDefinitionId);

    /**
     * Gives access to a deployed process diagram, e.g., a PNG image, through a stream of bytes.
     *
     * @param processDefinitionId
     *            id of a {@link ProcessDefinition}, cannot be null.
     * @return null when the diagram resource name of a {@link ProcessDefinition} is null.
     * @throws FlowableObjectNotFoundException
     *             when the process diagram doesn't exist.
     */
    InputStream getProcessDiagram(string processDefinitionId);

    /**
     * Returns the {@link ProcessDefinition} including all BPMN information like additional Properties (e.g. documentation).
     */
    ProcessDefinition getProcessDefinition(string processDefinitionId);

    /**
     * Checks if the process definition should be executed by the V5 engine.
     */
    bool isFlowable5ProcessDefinition(string processDefinitionId);

    /**
     * Checks if the process definition is suspended.
     */
    bool isProcessDefinitionSuspended(string processDefinitionId);

    /**
     * Returns the {@link BpmnModel} corresponding with the process definition with the provided process definition id. The {@link BpmnModel} is a pojo versions of the BPMN 2.0 xml and can be used to
     * introspect the process definition using regular Java.
     */
    //BpmnModel getBpmnModel(string processDefinitionId);

    /**
     * Provides positions and dimensions of elements in a process diagram as provided by {@link RepositoryService#getProcessDiagram(string)}.
     *
     * This method requires a process model and a diagram image to be deployed.
     *
     * @param processDefinitionId
     *            id of a {@link ProcessDefinition}, cannot be null.
     * @return DiagramLayout instance containing diagram info, null when the input stream of a process diagram is null.
     * @throws FlowableObjectNotFoundException
     *             when the process model or diagram doesn't exist.
     */
    //DiagramLayout getProcessDiagramLayout(string processDefinitionId);

    /**
     * Returns the app resource object (.app file) for a deployment.
     */
    Object getAppResourceObject(string deploymentId);

    /**
     * Returns the app model object (.app file) for a deployment.
     */
    AppModel getAppResourceModel(string deploymentId);

    /**
     * Creates a new model. The model is transient and must be saved using {@link #saveModel(Model)}.
     */
    public Model newModel();

    /**
     * Saves the model. If the model already existed, the model is updated otherwise a new model is created.
     *
     * @param model
     *            model to save, cannot be null.
     */
    public void saveModel(Model model);

    /**
     * @param modelId
     *            id of model to delete, cannot be null. When an id is passed for a non-existent model, this operation is ignored.
     */
    public void deleteModel(string modelId);

    /**
     * Saves the model editor source for a model
     *
     * @param modelId
     *            id of model to delete, cannot be null. When an id is passed for a non-existent model, this operation is ignored.
     */
    public void addModelEditorSource(string modelId, byte[] bytes);

    /**
     * Saves the model editor source extra for a model
     *
     * @param modelId
     *            id of model to delete, cannot be null. When an id is passed for an unexisting model, this operation is ignored.
     */
    public void addModelEditorSourceExtra(string modelId, byte[] bytes);

    /** Query models. */
    public ModelQuery createModelQuery();

    /**
     * Returns a new {@link flow.common.api.query.NativeQuery} for process definitions.
     */
    NativeModelQuery createNativeModelQuery();

    /**
     * Returns the {@link Model}
     *
     * @param modelId
     *            id of model
     */
    public Model getModel(string modelId);

    /**
     * Returns the model editor source as a byte array
     *
     * @param modelId
     *            id of model
     */
    public byte[] getModelEditorSource(string modelId);

    /**
     * Returns the model editor source extra as a byte array
     *
     * @param modelId
     *            id of model
     */
    public byte[] getModelEditorSourceExtra(string modelId);

    /**
     * Authorizes a candidate user for a process definition.
     *
     * @param processDefinitionId
     *            id of the process definition, cannot be null.
     * @param userId
     *            id of the user involve, cannot be null.
     * @throws FlowableObjectNotFoundException
     *             when the process definition or user doesn't exist.
     */
    void addCandidateStarterUser(string processDefinitionId, string userId);

    /**
     * Authorizes a candidate group for a process definition.
     *
     * @param processDefinitionId
     *            id of the process definition, cannot be null.
     * @param groupId
     *            id of the group involve, cannot be null.
     * @throws FlowableObjectNotFoundException
     *             when the process definition or group doesn't exist.
     */
    void addCandidateStarterGroup(string processDefinitionId, string groupId);

    /**
     * Removes the authorization of a candidate user for a process definition.
     *
     * @param processDefinitionId
     *            id of the process definition, cannot be null.
     * @param userId
     *            id of the user involve, cannot be null.
     * @throws FlowableObjectNotFoundException
     *             when the process definition or user doesn't exist.
     */
    void deleteCandidateStarterUser(string processDefinitionId, string userId);

    /**
     * Removes the authorization of a candidate group for a process definition.
     *
     * @param processDefinitionId
     *            id of the process definition, cannot be null.
     * @param groupId
     *            id of the group involve, cannot be null.
     * @throws FlowableObjectNotFoundException
     *             when the process definition or group doesn't exist.
     */
    void deleteCandidateStarterGroup(string processDefinitionId, string groupId);

    /**
     * Retrieves the {@link IdentityLink}s associated with the given process definition. Such an {@link IdentityLink} informs how a certain identity (eg. group or user) is authorized for a certain
     * process definition
     */
    //List!IdentityLink getIdentityLinksForProcessDefinition(string processDefinitionId);

    /**
     * Validates the given process definition against the rules for executing a process definition on the process engine.
     *
     * To create such a {@link BpmnModel} from a string, following code may be used:
     *
     * XMLInputFactory xif = XMLInputFactory.newInstance(); InputStreamReader in = new InputStreamReader(new ByteArrayInputStream(myProcess.getBytes()), "UTF-8"); // Change to other streams for eg
     * from classpath XMLStreamReader xtr = xif.createXMLStreamReader(in); bpmnModel = new BpmnXMLConverter().convertToBpmnModel(xtr);
     *
     */
    //List!ValidationError validateProcess(BpmnModel bpmnModel);

    /**
     * Retrieves the {@link DmnDecisionTable}s associated with the given process definition.
     *
     * @param processDefinitionId
     *            id of the process definition, cannot be null.
     *
     */
    //List!DmnDecisionTable getDecisionTablesForProcessDefinition(string processDefinitionId);

    /**
     * Retrieves the {@link FormDefinition}s associated with the given process definition.
     *
     * @param processDefinitionId
     *            id of the process definition, cannot be null.
     *
     */
    //List!FormDefinition getFormDefinitionsForProcessDefinition(string processDefinitionId);

}
