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
module flow.engine.impl.cmd.DeployCmd;

import hunt.collection.ArrayList;
import hunt.collection.HashMap;
import hunt.collection.List;
import hunt.collection.Map;

import flow.common.api.FlowableException;
import flow.common.api.deleg.event.FlowableEngineEventType;
import flow.common.api.deleg.event.FlowableEventDispatcher;
import flow.common.api.repository.EngineResource;
import flow.common.interceptor.Command;
import flow.common.interceptor.CommandContext;
import flow.engine.ProcessEngineConfiguration;
import flow.engine.compatibility.Flowable5CompatibilityHandler;
import flow.engine.deleg.event.impl.FlowableEventBuilder;
import flow.engine.impl.DeploymentQueryImpl;
import flow.engine.impl.cfg.ProcessEngineConfigurationImpl;
import flow.engine.impl.persistence.entity.DeploymentEntity;
import flow.engine.impl.persistence.entity.ProcessDefinitionEntity;
import flow.engine.impl.repository.DeploymentBuilderImpl;
import flow.engine.impl.util.CommandContextUtil;
import flow.engine.repository.Deployment;
import flow.engine.repository.DeploymentProperties;
import flow.engine.impl.cmd.DeploymentSettings;
import hunt.Exceptions;
import hunt.Boolean;
/**
 * @author Tom Baeyens
 * @author Joram Barrez
 */
class DeployCmd : Command!Deployment {

    protected DeploymentBuilderImpl deploymentBuilder;

    this(DeploymentBuilderImpl deploymentBuilder) {
        this.deploymentBuilder = deploymentBuilder;
    }

    public Deployment execute(CommandContext commandContext) {

        // Backwards compatibility with v5
        //if (deploymentBuilder.getDeploymentProperties() !is null
        //        && deploymentBuilder.getDeploymentProperties().containsKey(DeploymentProperties.DEPLOY_AS_FLOWABLE5_PROCESS_DEFINITION)
        //        && deploymentBuilder.getDeploymentProperties().get(DeploymentProperties.DEPLOY_AS_FLOWABLE5_PROCESS_DEFINITION).equals(bool.TRUE)) {
        //
        //    ProcessEngineConfigurationImpl processEngineConfiguration = CommandContextUtil.getProcessEngineConfiguration(commandContext);
        //    if (processEngineConfiguration.isFlowable5CompatibilityEnabled() && processEngineConfiguration.getFlowable5CompatibilityHandler() !is null) {
        //        return deployAsFlowable5ProcessDefinition(commandContext);
        //    } else {
        //        throw new FlowableException("Can't deploy a v5 deployment with no flowable 5 compatibility enabled or no compatibility handler on the classpath");
        //    }
        //}

        implementationMissing(false);
        return executeDeploy(commandContext);
    }

    protected Deployment executeDeploy(CommandContext commandContext) {
        DeploymentEntity deployment = deploymentBuilder.getDeployment();

        ProcessEngineConfigurationImpl processEngineConfiguration = CommandContextUtil.getProcessEngineConfiguration(commandContext);
        deployment.setDeploymentTime(processEngineConfiguration.getClock().getCurrentTime());

        if (deploymentBuilder.isDuplicateFilterEnabled()) {

            List!Deployment existingDeployments = new ArrayList!Deployment();
            if (deployment.getTenantId() is null || ProcessEngineConfiguration.NO_TENANT_ID == (deployment.getTenantId())) {
                implementationMissing(false);
                //List!Deployment deploymentEntities = new DeploymentQueryImpl(processEngineConfiguration.getCommandExecutor())
                //        .deploymentName(deployment.getName())
                //        .orderByDeploymentTime().desc()
                //        .listPage(0, 1);
                //if (!deploymentEntities.isEmpty()) {
                //    existingDeployments.add(deploymentEntities.get(0));
                //}

            } else {
                implementationMissing(false);
                //List!Deployment deploymentList = processEngineConfiguration.getRepositoryService().createDeploymentQuery().deploymentName(deployment.getName())
                //        .deploymentTenantId(deployment.getTenantId()).orderByDeploymentTime().desc().list();
                //
                //if (!deploymentList.isEmpty()) {
                //    existingDeployments.addAll(deploymentList);
                //}
            }

            DeploymentEntity existingDeployment = null;
            if (!existingDeployments.isEmpty()) {
                existingDeployment = cast(DeploymentEntity) existingDeployments.get(0);
            }

            if (existingDeployment !is null && !deploymentsDiffer(deployment, existingDeployment)) {
                return existingDeployment;
            }
        }

        deployment.setNew(true);

        // Save the data
        CommandContextUtil.getDeploymentEntityManager(commandContext).insert(deployment);

        FlowableEventDispatcher eventDispatcher = processEngineConfiguration.getEventDispatcher();
        if (eventDispatcher !is null && eventDispatcher.isEnabled()) {
            eventDispatcher
                .dispatchEvent(FlowableEventBuilder.createEntityEvent(FlowableEngineEventType.ENTITY_CREATED, cast(Object)deployment));
        }

        // Deployment settings
        Map!(string, Object) deploymentSettings = new HashMap!(string, Object);
        deploymentSettings.put(DeploymentSettings.IS_BPMN20_XSD_VALIDATION_ENABLED, new Boolean(deploymentBuilder.isBpmn20XsdValidationEnabled()));
        deploymentSettings.put(DeploymentSettings.IS_PROCESS_VALIDATION_ENABLED,new Boolean(deploymentBuilder.isProcessValidationEnabled()));

        // Actually deploy
        processEngineConfiguration.getDeploymentManager().deploy(deployment, deploymentSettings);

        if (deploymentBuilder.getProcessDefinitionsActivationDate() !is null) {
            scheduleProcessDefinitionActivation(commandContext, deployment);
        }

        if (eventDispatcher !is null && eventDispatcher.isEnabled()) {
            eventDispatcher
                .dispatchEvent(FlowableEventBuilder.createEntityEvent(FlowableEngineEventType.ENTITY_INITIALIZED, cast(Object)deployment));
        }

        return deployment;
    }

    protected Deployment deployAsFlowable5ProcessDefinition(CommandContext commandContext) {
          implementationMissing(false);
          return null;
        //Flowable5CompatibilityHandler flowable5CompatibilityHandler = CommandContextUtil.getProcessEngineConfiguration(commandContext).getFlowable5CompatibilityHandler();
        //if (flowable5CompatibilityHandler is null) {
        //    throw new FlowableException("Found Flowable 5 process definition, but no compatibility handler on the classpath. "
        //            + "Cannot use the deployment property " + DeploymentProperties.DEPLOY_AS_FLOWABLE5_PROCESS_DEFINITION);
        //}
        //return flowable5CompatibilityHandler.deploy(deploymentBuilder);
    }

    protected bool deploymentsDiffer(DeploymentEntity deployment, DeploymentEntity saved) {
        implementationMissing(false);
        //if (deployment.getResources() is null || saved.getResources() is null) {
        //    return true;
        //}
        //
        //Map!(string, EngineResource) resources = deployment.getResources();
        //Map!(string, EngineResource) savedResources = saved.getResources();
        //
        //foreach (string resourceName ; resources.getKey()) {
        //    EngineResource savedResource = savedResources.get(resourceName);
        //
        //    if (savedResource is null)
        //        return true;
        //
        //    if (!savedResource.isGenerated()) {
        //        EngineResource resource = resources.get(resourceName);
        //
        //        byte[] bytes = resource.getBytes();
        //        byte[] savedBytes = savedResource.getBytes();
        //        if (!Arrays.equals(bytes, savedBytes)) {
        //            return true;
        //        }
        //    }
        //}
        return false;
    }

    protected void scheduleProcessDefinitionActivation(CommandContext commandContext, DeploymentEntity deployment) {
        implementationMissing(false);
        //foreach (ProcessDefinitionEntity processDefinitionEntity ; deployment.getDeployedArtifacts(ProcessDefinitionEntity.class)) {
        //
        //    // If activation date is set, we first suspend all the process
        //    // definition
        //    SuspendProcessDefinitionCmd suspendProcessDefinitionCmd = new SuspendProcessDefinitionCmd(processDefinitionEntity, false, null, deployment.getTenantId());
        //    suspendProcessDefinitionCmd.execute(commandContext);
        //
        //    // And we schedule an activation at the provided date
        //    ActivateProcessDefinitionCmd activateProcessDefinitionCmd = new ActivateProcessDefinitionCmd(processDefinitionEntity, false, deploymentBuilder.getProcessDefinitionsActivationDate(),
        //            deployment.getTenantId());
        //    activateProcessDefinitionCmd.execute(commandContext);
        //}
    }

}
