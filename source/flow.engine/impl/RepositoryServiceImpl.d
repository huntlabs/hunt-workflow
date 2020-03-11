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

module flow.engine.impl.RepositoryServiceImpl;





import hunt.io.Common;
import hunt.time.LocalDateTime;
import hunt.collection.List;

import flow.bpmn.model.BpmnModel;
import flow.common.interceptor.Command;
import flow.common.interceptor.CommandContext;
import flow.common.service.CommonEngineServiceImpl;
import org.flowable.dmn.api.DmnDecisionTable;
import flow.engine.RepositoryService;
import flow.engine.app.AppModel;
import flow.engine.impl.cfg.ProcessEngineConfigurationImpl;
import flow.engine.impl.cmd.ActivateProcessDefinitionCmd;
import flow.engine.impl.cmd.AddEditorSourceExtraForModelCmd;
import flow.engine.impl.cmd.AddEditorSourceForModelCmd;
import flow.engine.impl.cmd.AddIdentityLinkForProcessDefinitionCmd;
import flow.engine.impl.cmd.ChangeDeploymentTenantIdCmd;
import flow.engine.impl.cmd.CreateModelCmd;
import flow.engine.impl.cmd.DeleteDeploymentCmd;
import flow.engine.impl.cmd.DeleteIdentityLinkForProcessDefinitionCmd;
import flow.engine.impl.cmd.DeleteModelCmd;
import flow.engine.impl.cmd.DeployCmd;
import flow.engine.impl.cmd.GetAppResourceModelCmd;
import flow.engine.impl.cmd.GetAppResourceObjectCmd;
import flow.engine.impl.cmd.GetBpmnModelCmd;
import flow.engine.impl.cmd.GetDecisionTablesForProcessDefinitionCmd;
import flow.engine.impl.cmd.GetDeploymentProcessDefinitionCmd;
import flow.engine.impl.cmd.GetDeploymentProcessDiagramCmd;
import flow.engine.impl.cmd.GetDeploymentProcessDiagramLayoutCmd;
import flow.engine.impl.cmd.GetDeploymentProcessModelCmd;
import flow.engine.impl.cmd.GetDeploymentResourceCmd;
import flow.engine.impl.cmd.GetDeploymentResourceNamesCmd;
import flow.engine.impl.cmd.GetFormDefinitionsForProcessDefinitionCmd;
import flow.engine.impl.cmd.GetIdentityLinksForProcessDefinitionCmd;
import flow.engine.impl.cmd.GetModelCmd;
import flow.engine.impl.cmd.GetModelEditorSourceCmd;
import flow.engine.impl.cmd.GetModelEditorSourceExtraCmd;
import flow.engine.impl.cmd.IsFlowable5ProcessDefinitionCmd;
import flow.engine.impl.cmd.IsProcessDefinitionSuspendedCmd;
import flow.engine.impl.cmd.SaveModelCmd;
import flow.engine.impl.cmd.SetDeploymentCategoryCmd;
import flow.engine.impl.cmd.SetDeploymentKeyCmd;
import flow.engine.impl.cmd.SetDeploymentParentDeploymentIdCmd;
import flow.engine.impl.cmd.SetProcessDefinitionCategoryCmd;
import flow.engine.impl.cmd.SuspendProcessDefinitionCmd;
import flow.engine.impl.cmd.ValidateBpmnModelCmd;
import flow.engine.impl.persistence.entity.ModelEntity;
import flow.engine.impl.repository.DeploymentBuilderImpl;
import flow.engine.repository.DeploymentMergeStrategy;
import flow.engine.repository.Deployment;
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
import flow.form.api.FormDefinition;
import flow.identitylink.api.IdentityLink;
import org.flowable.validation.ValidationError;

/**
 * @author Tom Baeyens
 * @author Falko Menge
 * @author Joram Barrez
 */
class RepositoryServiceImpl : CommonEngineServiceImpl!ProcessEngineConfigurationImpl , RepositoryService {

    public DeploymentBuilder createDeployment() {
        return commandExecutor.execute(new class Command!DeploymentBuilder {

            public DeploymentBuilder execute(CommandContext commandContext) {
                return new DeploymentBuilderImpl(this);
            }
        });
    }

    public Deployment deploy(DeploymentBuilderImpl deploymentBuilder) {
        return commandExecutor.execute(new DeployCmd<Deployment>(deploymentBuilder));
    }

    public void deleteDeployment(string deploymentId) {
        commandExecutor.execute(new DeleteDeploymentCmd(deploymentId, false));
    }

    public void deleteDeploymentCascade(string deploymentId) {
        commandExecutor.execute(new DeleteDeploymentCmd(deploymentId, true));
    }

    public void deleteDeployment(string deploymentId, bool cascade) {
        commandExecutor.execute(new DeleteDeploymentCmd(deploymentId, cascade));
    }


    public void setDeploymentCategory(string deploymentId, string category) {
        commandExecutor.execute(new SetDeploymentCategoryCmd(deploymentId, category));
    }


    public void setDeploymentKey(string deploymentId, string key) {
        commandExecutor.execute(new SetDeploymentKeyCmd(deploymentId, key));
    }


    public void changeDeploymentParentDeploymentId(string deploymentId, string newParentDeploymentId) {
        commandExecutor.execute(new SetDeploymentParentDeploymentIdCmd(deploymentId, newParentDeploymentId));
    }


    public ProcessDefinitionQuery createProcessDefinitionQuery() {
        return new ProcessDefinitionQueryImpl(commandExecutor);
    }


    public NativeProcessDefinitionQuery createNativeProcessDefinitionQuery() {
        return new NativeProcessDefinitionQueryImpl(commandExecutor);
    }


    public List!string getDeploymentResourceNames(string deploymentId) {
        return commandExecutor.execute(new GetDeploymentResourceNamesCmd(deploymentId));
    }


    public InputStream getResourceAsStream(string deploymentId, string resourceName) {
        return commandExecutor.execute(new GetDeploymentResourceCmd(deploymentId, resourceName));
    }


    public void changeDeploymentTenantId(string deploymentId, string newTenantId) {
        commandExecutor.execute(new ChangeDeploymentTenantIdCmd(deploymentId, newTenantId));
    }


    public void changeDeploymentTenantId(string deploymentId, string newTenantId, MergeMode mergeMode) {
        commandExecutor.execute(new ChangeDeploymentTenantIdCmd(deploymentId, newTenantId, mergeMode));
    }


    public void changeDeploymentTenantId(string deploymentId, string newTenantId, DeploymentMergeStrategy deploymentMergeStrategy) {
        commandExecutor.execute(new ChangeDeploymentTenantIdCmd(deploymentId, newTenantId, deploymentMergeStrategy));
    }


    public DeploymentQuery createDeploymentQuery() {
        return new DeploymentQueryImpl(commandExecutor);
    }


    public NativeDeploymentQuery createNativeDeploymentQuery() {
        return new NativeDeploymentQueryImpl(commandExecutor);
    }


    public ProcessDefinition getProcessDefinition(string processDefinitionId) {
        return commandExecutor.execute(new GetDeploymentProcessDefinitionCmd(processDefinitionId));
    }


    public bool isFlowable5ProcessDefinition(string processDefinitionId) {
        return commandExecutor.execute(new IsFlowable5ProcessDefinitionCmd(processDefinitionId));
    }


    public BpmnModel getBpmnModel(string processDefinitionId) {
        return commandExecutor.execute(new GetBpmnModelCmd(processDefinitionId));
    }

    public ProcessDefinition getDeployedProcessDefinition(string processDefinitionId) {
        return commandExecutor.execute(new GetDeploymentProcessDefinitionCmd(processDefinitionId));
    }


    public bool isProcessDefinitionSuspended(string processDefinitionId) {
        return commandExecutor.execute(new IsProcessDefinitionSuspendedCmd(processDefinitionId));
    }


    public void suspendProcessDefinitionById(string processDefinitionId) {
        commandExecutor.execute(new SuspendProcessDefinitionCmd(processDefinitionId, null, false, null, null));
    }


    public void suspendProcessDefinitionById(string processDefinitionId, bool suspendProcessInstances, Date suspensionDate) {
        commandExecutor.execute(new SuspendProcessDefinitionCmd(processDefinitionId, null, suspendProcessInstances, suspensionDate, null));
    }


    public void suspendProcessDefinitionByKey(string processDefinitionKey) {
        commandExecutor.execute(new SuspendProcessDefinitionCmd(null, processDefinitionKey, false, null, null));
    }


    public void suspendProcessDefinitionByKey(string processDefinitionKey, bool suspendProcessInstances, Date suspensionDate) {
        commandExecutor.execute(new SuspendProcessDefinitionCmd(null, processDefinitionKey, suspendProcessInstances, suspensionDate, null));
    }


    public void suspendProcessDefinitionByKey(string processDefinitionKey, string tenantId) {
        commandExecutor.execute(new SuspendProcessDefinitionCmd(null, processDefinitionKey, false, null, tenantId));
    }


    public void suspendProcessDefinitionByKey(string processDefinitionKey, bool suspendProcessInstances, Date suspensionDate, string tenantId) {
        commandExecutor.execute(new SuspendProcessDefinitionCmd(null, processDefinitionKey, suspendProcessInstances, suspensionDate, tenantId));
    }


    public void activateProcessDefinitionById(string processDefinitionId) {
        commandExecutor.execute(new ActivateProcessDefinitionCmd(processDefinitionId, null, false, null, null));
    }


    public void activateProcessDefinitionById(string processDefinitionId, bool activateProcessInstances, Date activationDate) {
        commandExecutor.execute(new ActivateProcessDefinitionCmd(processDefinitionId, null, activateProcessInstances, activationDate, null));
    }


    public void activateProcessDefinitionByKey(string processDefinitionKey) {
        commandExecutor.execute(new ActivateProcessDefinitionCmd(null, processDefinitionKey, false, null, null));
    }


    public void activateProcessDefinitionByKey(string processDefinitionKey, bool activateProcessInstances, Date activationDate) {
        commandExecutor.execute(new ActivateProcessDefinitionCmd(null, processDefinitionKey, activateProcessInstances, activationDate, null));
    }


    public void activateProcessDefinitionByKey(string processDefinitionKey, string tenantId) {
        commandExecutor.execute(new ActivateProcessDefinitionCmd(null, processDefinitionKey, false, null, tenantId));
    }


    public void activateProcessDefinitionByKey(string processDefinitionKey, bool activateProcessInstances, Date activationDate, string tenantId) {
        commandExecutor.execute(new ActivateProcessDefinitionCmd(null, processDefinitionKey, activateProcessInstances, activationDate, tenantId));
    }


    public void setProcessDefinitionCategory(string processDefinitionId, string category) {
        commandExecutor.execute(new SetProcessDefinitionCategoryCmd(processDefinitionId, category));
    }


    public InputStream getProcessModel(string processDefinitionId) {
        return commandExecutor.execute(new GetDeploymentProcessModelCmd(processDefinitionId));
    }


    public InputStream getProcessDiagram(string processDefinitionId) {
        return commandExecutor.execute(new GetDeploymentProcessDiagramCmd(processDefinitionId));
    }


    public DiagramLayout getProcessDiagramLayout(string processDefinitionId) {
        return commandExecutor.execute(new GetDeploymentProcessDiagramLayoutCmd(processDefinitionId));
    }


    public Object getAppResourceObject(string deploymentId) {
        return commandExecutor.execute(new GetAppResourceObjectCmd(deploymentId));
    }


    public AppModel getAppResourceModel(string deploymentId) {
        return commandExecutor.execute(new GetAppResourceModelCmd(deploymentId));
    }


    public Model newModel() {
        return commandExecutor.execute(new CreateModelCmd());
    }


    public void saveModel(Model model) {
        commandExecutor.execute(new SaveModelCmd((ModelEntity) model));
    }


    public void deleteModel(string modelId) {
        commandExecutor.execute(new DeleteModelCmd(modelId));
    }


    public void addModelEditorSource(string modelId, byte[] bytes) {
        commandExecutor.execute(new AddEditorSourceForModelCmd(modelId, bytes));
    }


    public void addModelEditorSourceExtra(string modelId, byte[] bytes) {
        commandExecutor.execute(new AddEditorSourceExtraForModelCmd(modelId, bytes));
    }


    public ModelQuery createModelQuery() {
        return new ModelQueryImpl(commandExecutor);
    }


    public NativeModelQuery createNativeModelQuery() {
        return new NativeModelQueryImpl(commandExecutor);
    }


    public Model getModel(string modelId) {
        return commandExecutor.execute(new GetModelCmd(modelId));
    }


    public byte[] getModelEditorSource(string modelId) {
        return commandExecutor.execute(new GetModelEditorSourceCmd(modelId));
    }


    public byte[] getModelEditorSourceExtra(string modelId) {
        return commandExecutor.execute(new GetModelEditorSourceExtraCmd(modelId));
    }


    public void addCandidateStarterUser(string processDefinitionId, string userId) {
        commandExecutor.execute(new AddIdentityLinkForProcessDefinitionCmd(processDefinitionId, userId, null));
    }


    public void addCandidateStarterGroup(string processDefinitionId, string groupId) {
        commandExecutor.execute(new AddIdentityLinkForProcessDefinitionCmd(processDefinitionId, null, groupId));
    }


    public void deleteCandidateStarterGroup(string processDefinitionId, string groupId) {
        commandExecutor.execute(new DeleteIdentityLinkForProcessDefinitionCmd(processDefinitionId, null, groupId));
    }


    public void deleteCandidateStarterUser(string processDefinitionId, string userId) {
        commandExecutor.execute(new DeleteIdentityLinkForProcessDefinitionCmd(processDefinitionId, userId, null));
    }


    public List!IdentityLink getIdentityLinksForProcessDefinition(string processDefinitionId) {
        return commandExecutor.execute(new GetIdentityLinksForProcessDefinitionCmd(processDefinitionId));
    }


    public List<ValidationError> validateProcess(BpmnModel bpmnModel) {
        return commandExecutor.execute(new ValidateBpmnModelCmd(bpmnModel));
    }


    public List<DmnDecisionTable> getDecisionTablesForProcessDefinition(string processDefinitionId) {
        return commandExecutor.execute(new GetDecisionTablesForProcessDefinitionCmd(processDefinitionId));
    }


    public List<FormDefinition> getFormDefinitionsForProcessDefinition(string processDefinitionId) {
        return commandExecutor.execute(new GetFormDefinitionsForProcessDefinitionCmd(processDefinitionId));
    }
}
