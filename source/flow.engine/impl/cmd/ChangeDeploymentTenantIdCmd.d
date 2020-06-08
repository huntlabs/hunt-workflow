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


import java.io.Serializable;
import hunt.collection.List;

import flow.common.api.FlowableException;
import flow.common.api.FlowableIllegalArgumentException;
import flow.common.api.FlowableObjectNotFoundException;
import flow.common.interceptor.Command;
import flow.common.interceptor.CommandContext;
import flow.engine.impl.ProcessDefinitionQueryImpl;
import flow.engine.impl.persistence.entity.DeploymentEntity;
import flow.engine.impl.repository.AddAsNewDeploymentMergeStrategy;
import flow.engine.impl.repository.AddAsOldDeploymentMergeStrategy;
import flow.engine.impl.repository.MergeByDateDeploymentMergeStrategy;
import flow.engine.impl.repository.VerifyDeploymentMergeStrategy;
import flow.engine.impl.util.CommandContextUtil;
import flow.engine.impl.util.Flowable5Util;
import flow.engine.repository.Deployment;
import flow.engine.repository.DeploymentMergeStrategy;
import flow.engine.repository.MergeMode;
import flow.engine.repository.ProcessDefinition;

/**
 * @author Joram Barrez
 */
class ChangeDeploymentTenantIdCmd implements Command!Void, Serializable {

    private static final long serialVersionUID = 1L;

    protected string deploymentId;
    protected string newTenantId;
    protected DeploymentMergeStrategy deploymentMergeStrategy;

    public ChangeDeploymentTenantIdCmd(string deploymentId, string newTenantId) {
        this(deploymentId, newTenantId, MergeMode.VERIFY);
    }

    public ChangeDeploymentTenantIdCmd(string deploymentId, string newTenantId, MergeMode mergeMode) {
        this.deploymentId = deploymentId;
        this.newTenantId = newTenantId;
        switch (mergeMode) {
            case VERIFY:
                deploymentMergeStrategy = new VerifyDeploymentMergeStrategy();
                break;
            case AS_NEW:
                deploymentMergeStrategy = new AddAsNewDeploymentMergeStrategy();
                break;
            case AS_OLD:
                deploymentMergeStrategy = new AddAsOldDeploymentMergeStrategy();
                break;
            case BY_DATE:
                deploymentMergeStrategy = new MergeByDateDeploymentMergeStrategy();
                break;
            default:
                throw new FlowableException("Merge mode '" + mergeMode + "' not found.");
        }
    }

    public ChangeDeploymentTenantIdCmd(string deploymentId, string newTenantId, DeploymentMergeStrategy deploymentMergeStrategy) {
        this.deploymentId = deploymentId;
        this.newTenantId = newTenantId;
        this.deploymentMergeStrategy = deploymentMergeStrategy;
    }

    override
    public Void execute(CommandContext commandContext) {
        if (deploymentId is null) {
            throw new FlowableIllegalArgumentException("deploymentId is null");
        }

        // Update all entities

        DeploymentEntity deployment = CommandContextUtil.getDeploymentEntityManager(commandContext).findById(deploymentId);
        if (deployment is null) {
            throw new FlowableObjectNotFoundException("Could not find deployment with id " + deploymentId, Deployment.class);
        }

        if (Flowable5Util.isFlowable5Deployment(deployment, commandContext)) {
            CommandContextUtil.getProcessEngineConfiguration(commandContext).getFlowable5CompatibilityHandler().changeDeploymentTenantId(deploymentId, newTenantId);
            return null;
        }

        deploymentMergeStrategy.prepareMerge(commandContext, deploymentId, newTenantId);
        string oldTenantId = deployment.getTenantId();
        deployment.setTenantId(newTenantId);

        // Doing process instances, executions and tasks with direct SQL updates
        // (otherwise would not be performant)
        CommandContextUtil.getProcessDefinitionEntityManager(commandContext).updateProcessDefinitionTenantIdForDeployment(deploymentId, newTenantId);
        CommandContextUtil.getExecutionEntityManager(commandContext).updateExecutionTenantIdForDeployment(deploymentId, newTenantId);
        CommandContextUtil.getTaskService().updateTaskTenantIdForDeployment(deploymentId, newTenantId);
        CommandContextUtil.getJobService().updateAllJobTypesTenantIdForDeployment(deploymentId, newTenantId);
        CommandContextUtil.getEventSubscriptionService(commandContext).updateEventSubscriptionTenantId(oldTenantId, newTenantId);

        deploymentMergeStrategy.finalizeMerge(commandContext, deploymentId, newTenantId);

        // Doing process definitions in memory, cause we need to clear the process definition cache
        List!ProcessDefinition processDefinitions = new ProcessDefinitionQueryImpl().deploymentId(deploymentId).list();
        for (ProcessDefinition processDefinition : processDefinitions) {
            CommandContextUtil.getProcessEngineConfiguration(commandContext).getProcessDefinitionCache().remove(processDefinition.getId());
        }

        // Clear process definition cache
        CommandContextUtil.getProcessEngineConfiguration(commandContext).getProcessDefinitionCache().clear();

        return null;

    }

}
