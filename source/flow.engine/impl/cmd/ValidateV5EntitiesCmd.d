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
module flow.engine.impl.cmd.ValidateV5EntitiesCmd;

import hunt.collection.List;

import flow.common.api.FlowableException;
import flow.common.interceptor.Command;
import flow.common.interceptor.CommandContext;
import flow.engine.RepositoryService;
import flow.engine.RuntimeService;
import flow.engine.impl.cfg.ProcessEngineConfigurationImpl;
import flow.engine.impl.util.CommandContextUtil;
//import flow.engine.impl.util.Flowable5Util;
import flow.engine.repository.ProcessDefinition;
import hunt.Object;
import hunt.Exceptions;
/**
 * @author Tijs Rademakers
 */
class ValidateV5EntitiesCmd : Command!Void {

    public Void execute(CommandContext commandContext) {
        ProcessEngineConfigurationImpl processEngineConfiguration = CommandContextUtil.getProcessEngineConfiguration(commandContext);
        implementationMissing(false);
        return null;
        //if (!processEngineConfiguration.isFlowable5CompatibilityEnabled() || processEngineConfiguration.getFlowable5CompatibilityHandler() is null) {
        //
        //    RepositoryService repositoryService = processEngineConfiguration.getRepositoryService();
        //    long numberOfV5Deployments = repositoryService.createDeploymentQuery().deploymentEngineVersion(Flowable5Util.V5_ENGINE_TAG).count();
        //    LOGGER.info("Total of v5 deployments found: {}", numberOfV5Deployments);
        //
        //    if (numberOfV5Deployments > 0) {
        //        List!ProcessDefinition processDefinitions = repositoryService.createProcessDefinitionQuery()
        //                .latestVersion()
        //                .processDefinitionEngineVersion(Flowable5Util.V5_ENGINE_TAG)
        //                .list();
        //
        //        if (!processDefinitions.isEmpty()) {
        //            string message = new StringBuilder("Found v5 process definitions that are the latest version.")
        //                    .append(" Enable the 'flowable5CompatibilityEnabled' property in the process engine configuration")
        //                    .append(" and make sure the flowable5-compatibility dependency is available on the classpath").toString();
        //            LOGGER.error(message);
        //
        //            for (ProcessDefinition processDefinition : processDefinitions) {
        //                LOGGER.error("Found v5 process definition with id: {}, and key: {}", processDefinition.getId(), processDefinition.getKey());
        //            }
        //
        //            throw new FlowableException(message);
        //        }
        //
        //        RuntimeService runtimeService = processEngineConfiguration.getRuntimeService();
        //        long numberOfV5ProcessInstances = runtimeService.createProcessInstanceQuery().processDefinitionEngineVersion(Flowable5Util.V5_ENGINE_TAG).count();
        //
        //        if (numberOfV5ProcessInstances > 0) {
        //            string message = new StringBuilder("Found at least one running v5 process instance.")
        //                    .append(" Enable the 'flowable5CompatibilityEnabled' property in the process engine configuration")
        //                    .append(" and make sure the flowable5-compatibility dependency is available on the classpath").toString();
        //            LOGGER.error(message);
        //
        //            throw new FlowableException(message);
        //        }
        //    }
        }

       // return null;
    }

