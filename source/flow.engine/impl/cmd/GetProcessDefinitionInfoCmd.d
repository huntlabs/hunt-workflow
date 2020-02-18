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

import flow.common.api.FlowableIllegalArgumentException;
import flow.common.interceptor.Command;
import flow.common.interceptor.CommandContext;
import flow.engine.compatibility.Flowable5CompatibilityHandler;
import flow.engine.impl.persistence.deploy.DeploymentManager;
import flow.engine.impl.persistence.deploy.ProcessDefinitionInfoCacheObject;
import flow.engine.impl.util.CommandContextUtil;
import flow.engine.impl.util.Flowable5Util;
import flow.engine.repository.ProcessDefinition;

import com.fasterxml.jackson.databind.node.ObjectNode;

/**
 * @author Tijs Rademakers
 */
class GetProcessDefinitionInfoCmd implements Command<ObjectNode>, Serializable {

    private static final long serialVersionUID = 1L;

    protected string processDefinitionId;

    public GetProcessDefinitionInfoCmd(string processDefinitionId) {
        this.processDefinitionId = processDefinitionId;
    }

    @Override
    public ObjectNode execute(CommandContext commandContext) {
        if (processDefinitionId is null) {
            throw new FlowableIllegalArgumentException("process definition id is null");
        }

        ObjectNode resultNode = null;
        DeploymentManager deploymentManager = CommandContextUtil.getProcessEngineConfiguration(commandContext).getDeploymentManager();
        // make sure the process definition is in the cache
        ProcessDefinition processDefinition = deploymentManager.findDeployedProcessDefinitionById(processDefinitionId);
        if (Flowable5Util.isFlowable5ProcessDefinition(processDefinition, commandContext)) {
            Flowable5CompatibilityHandler compatibilityHandler = Flowable5Util.getFlowable5CompatibilityHandler();
            return compatibilityHandler.getProcessDefinitionInfo(processDefinitionId);
        }

        ProcessDefinitionInfoCacheObject definitionInfoCacheObject = deploymentManager.getProcessDefinitionInfoCache().get(processDefinitionId);
        if (definitionInfoCacheObject !is null) {
            resultNode = definitionInfoCacheObject.getInfoNode();
        }

        return resultNode;
    }

}