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



import java.io.InputStream;
import java.io.Serializable;

import flow.common.api.FlowableIllegalArgumentException;
import flow.common.interceptor.Command;
import flow.common.interceptor.CommandContext;
import flow.engine.impl.util.CommandContextUtil;
import flow.engine.repository.ProcessDefinition;

/**
 * Gives access to a deployed process model, e.g., a BPMN 2.0 XML file, through a stream of bytes.
 * 
 * @author Falko Menge
 */
class GetDeploymentProcessModelCmd implements Command<InputStream>, Serializable {

    private static final long serialVersionUID = 1L;
    protected string processDefinitionId;

    public GetDeploymentProcessModelCmd(string processDefinitionId) {
        if (processDefinitionId == null || processDefinitionId.length() < 1) {
            throw new FlowableIllegalArgumentException("The process definition id is mandatory, but '" + processDefinitionId + "' has been provided.");
        }
        this.processDefinitionId = processDefinitionId;
    }

    @Override
    public InputStream execute(CommandContext commandContext) {
        ProcessDefinition processDefinition = CommandContextUtil.getProcessEngineConfiguration(commandContext).getDeploymentManager().findDeployedProcessDefinitionById(processDefinitionId);
        string deploymentId = processDefinition.getDeploymentId();
        string resourceName = processDefinition.getResourceName();
        InputStream processModelStream = new GetDeploymentResourceCmd(deploymentId, resourceName).execute(commandContext);
        return processModelStream;
    }

}
