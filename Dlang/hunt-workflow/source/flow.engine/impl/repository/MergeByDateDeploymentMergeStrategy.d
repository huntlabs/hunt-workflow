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
import flow.engine.impl.DeploymentQueryImpl;
import flow.engine.impl.ProcessDefinitionQueryImpl;
import flow.engine.impl.persistence.entity.ProcessDefinitionEntityManager;
import flow.engine.impl.util.CommandContextUtil;
import flow.engine.repository.DeploymentMergeStrategy;
import flow.engine.repository.ProcessDefinition;

import java.util.List;
import java.util.Map;
import java.util.function.Function;
import java.util.stream.Collectors;

/**
 * @author Valentin Zickner
 */
class MergeByDateDeploymentMergeStrategy implements DeploymentMergeStrategy {

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
            List<ProcessDefinition> allProcessDefinitionsWithKey = new ProcessDefinitionQueryImpl()
                    .processDefinitionTenantId(newTenantId)
                    .processDefinitionKey(processDefinition.getKey())
                    .list();
            List<ProcessDefinition> orderedProcessDefinitions = sortProcessDefinitionsByDeploymentTime(allProcessDefinitionsWithKey);

            int versionNumber = allProcessDefinitionsWithKey.size();
            for (ProcessDefinition alreadyExistingProcessDefinition : orderedProcessDefinitions) {
                processDefinitionEntityManager.updateProcessDefinitionVersionForProcessDefinitionId(alreadyExistingProcessDefinition.getId(), versionNumber--);
            }
        }
    }

    protected List<ProcessDefinition> sortProcessDefinitionsByDeploymentTime(List<ProcessDefinition> allProcessDefinitionsWithKey) {
        List<string> deploymentIds = extractDeploymentIds(allProcessDefinitionsWithKey);
        Map<string, ProcessDefinition> processDefinitionLookupTable = allProcessDefinitionsWithKey
                .stream()
                .collect(Collectors.toMap(ProcessDefinition::getDeploymentId, Function.identity()));

        return new DeploymentQueryImpl()
                .deploymentIds(deploymentIds)
                .orderByDeploymentTime()
                .desc()
                .list()
                .stream()
                .map(deployment -> processDefinitionLookupTable.get(deployment.getId()))
                .collect(Collectors.toList());
    }

    protected List<string> extractDeploymentIds(List<ProcessDefinition> allProcessDefinitionsWithKey) {
        return allProcessDefinitionsWithKey
                .stream()
                .map(ProcessDefinition::getDeploymentId)
                .collect(Collectors.toList());
    }

}
