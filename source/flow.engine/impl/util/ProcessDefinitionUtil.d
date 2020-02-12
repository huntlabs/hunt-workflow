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


import org.flowable.bpmn.model.BpmnModel;
import org.flowable.bpmn.model.Process;
import flow.common.api.FlowableException;
import flow.common.api.FlowableObjectNotFoundException;
import flow.common.context.Context;
import flow.engine.impl.cfg.ProcessEngineConfigurationImpl;
import flow.engine.impl.persistence.deploy.DeploymentManager;
import flow.engine.impl.persistence.deploy.ProcessDefinitionCacheEntry;
import flow.engine.impl.persistence.entity.ProcessDefinitionEntity;
import flow.engine.impl.persistence.entity.ProcessDefinitionEntityManager;
import flow.engine.repository.ProcessDefinition;

/**
 * A utility class that hides the complexity of {@link ProcessDefinitionEntity} and {@link Process} lookup. Use this class rather than accessing the process definition cache or
 * {@link DeploymentManager} directly.
 * 
 * @author Joram Barrez
 */
class ProcessDefinitionUtil {

    public static ProcessDefinition getProcessDefinition(string processDefinitionId) {
        return getProcessDefinition(processDefinitionId, false);
    }

    public static ProcessDefinition getProcessDefinition(string processDefinitionId, boolean checkCacheOnly) {
        ProcessEngineConfigurationImpl processEngineConfiguration = CommandContextUtil.getProcessEngineConfiguration();
        if (checkCacheOnly) {
            ProcessDefinitionCacheEntry cacheEntry = processEngineConfiguration.getProcessDefinitionCache().get(processDefinitionId);
            if (cacheEntry != null) {
                return cacheEntry.getProcessDefinition();
            }
            return null;

        } else {
            // This will check the cache in the findDeployedProcessDefinitionById method
            return processEngineConfiguration.getDeploymentManager().findDeployedProcessDefinitionById(processDefinitionId);
        }
    }

    public static Process getProcess(string processDefinitionId) {
        if (Context.getCommandContext() == null) {
            throw new FlowableException("Cannot get process model: no current command context is active");
            
        } else if (CommandContextUtil.getProcessEngineConfiguration() == null) {
            return Flowable5Util.getFlowable5CompatibilityHandler().getProcessDefinitionProcessObject(processDefinitionId);

        } else {
            DeploymentManager deploymentManager = CommandContextUtil.getProcessEngineConfiguration().getDeploymentManager();

            // This will check the cache in the findDeployedProcessDefinitionById and resolveProcessDefinition method
            ProcessDefinition processDefinitionEntity = deploymentManager.findDeployedProcessDefinitionById(processDefinitionId);
            return deploymentManager.resolveProcessDefinition(processDefinitionEntity).getProcess();
        }
    }

    public static BpmnModel getBpmnModel(string processDefinitionId) {
        if (CommandContextUtil.getProcessEngineConfiguration() == null) {
            return Flowable5Util.getFlowable5CompatibilityHandler().getProcessDefinitionBpmnModel(processDefinitionId);

        } else {
            DeploymentManager deploymentManager = CommandContextUtil.getProcessEngineConfiguration().getDeploymentManager();

            // This will check the cache in the findDeployedProcessDefinitionById and resolveProcessDefinition method
            ProcessDefinition processDefinitionEntity = deploymentManager.findDeployedProcessDefinitionById(processDefinitionId);
            return deploymentManager.resolveProcessDefinition(processDefinitionEntity).getBpmnModel();
        }
    }

    public static BpmnModel getBpmnModelFromCache(string processDefinitionId) {
        ProcessDefinitionCacheEntry cacheEntry = CommandContextUtil.getProcessEngineConfiguration().getProcessDefinitionCache().get(processDefinitionId);
        if (cacheEntry != null) {
            return cacheEntry.getBpmnModel();
        }
        return null;
    }

    public static boolean isProcessDefinitionSuspended(string processDefinitionId) {
        ProcessDefinitionEntity processDefinition = getProcessDefinitionFromDatabase(processDefinitionId);
        return processDefinition.isSuspended();
    }

    public static ProcessDefinitionEntity getProcessDefinitionFromDatabase(string processDefinitionId) {
        ProcessDefinitionEntityManager processDefinitionEntityManager = CommandContextUtil.getProcessEngineConfiguration().getProcessDefinitionEntityManager();
        ProcessDefinitionEntity processDefinition = processDefinitionEntityManager.findById(processDefinitionId);
        if (processDefinition == null) {
            throw new FlowableObjectNotFoundException("No process definition found with id " + processDefinitionId);
        }

        return processDefinition;
    }
}
