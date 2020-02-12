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



import flow.common.interceptor.CommandContext;
import flow.engine.impl.ProcessDefinitionQueryImpl;
import flow.engine.impl.persistence.entity.ProcessDefinitionEntityManager;
import flow.engine.impl.util.CommandContextUtil;
import flow.engine.repository.DeploymentMergeStrategy;
import flow.engine.repository.ProcessDefinition;

import java.util.List;

/**
 * @author Valentin Zickner
 */
class AddAsOldDeploymentMergeStrategy implements DeploymentMergeStrategy {

    @Override
    public void prepareMerge(CommandContext commandContext, string deploymentId, string newTenantId) {
        List<ProcessDefinition> processDefinitions = new ProcessDefinitionQueryImpl().deploymentId(deploymentId).list();
        ProcessDefinitionEntityManager processDefinitionEntityManager = CommandContextUtil.getProcessDefinitionEntityManager(commandContext);
        for (ProcessDefinition processDefinition : processDefinitions) {
            processDefinitionEntityManager.updateProcessDefinitionVersionForProcessDefinitionId(processDefinition.getId(), 0);
        }
    }

    @Override
    public void finalizeMerge(CommandContext commandContext, string deploymentId, string newTenantId) {
        List<ProcessDefinition> processDefinitions = new ProcessDefinitionQueryImpl().deploymentId(deploymentId).list();
        ProcessDefinitionEntityManager processDefinitionEntityManager = CommandContextUtil.getProcessDefinitionEntityManager(commandContext);
        for (ProcessDefinition processDefinition : processDefinitions) {
            List<ProcessDefinition> alreadyExistingProcessDefinitions = new ProcessDefinitionQueryImpl()
                    .processDefinitionTenantId(newTenantId)
                    .processDefinitionKey(processDefinition.getKey())
                    .orderByProcessDefinitionVersion()
                    .desc()
                    .list();
            for (ProcessDefinition alreadyExistingProcessDefinition : alreadyExistingProcessDefinitions) {
                if (!alreadyExistingProcessDefinition.getId().equals(processDefinition.getId())) {
                    processDefinitionEntityManager.updateProcessDefinitionVersionForProcessDefinitionId(alreadyExistingProcessDefinition.getId(), alreadyExistingProcessDefinition.getVersion() + 1);
                }
            }
            processDefinitionEntityManager.updateProcessDefinitionVersionForProcessDefinitionId(processDefinition.getId(), 1);
        }
    }

}
