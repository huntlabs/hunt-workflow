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
module flow.engine.impl.cmd.DeleteDeploymentCmd;


import flow.common.api.FlowableIllegalArgumentException;
import flow.common.interceptor.Command;
import flow.common.interceptor.CommandContext;
import flow.engine.impl.util.CommandContextUtil;
import hunt.Object;
/**
 * @author Joram Barrez
 */
class DeleteDeploymentCmd : Command!Void {

    protected string deploymentId;
    protected bool cascade;

    this(string deploymentId, bool cascade) {
        this.deploymentId = deploymentId;
        this.cascade = cascade;
    }

    public Void execute(CommandContext commandContext) {
        if (deploymentId is null) {
            throw new FlowableIllegalArgumentException("deploymentId is null");
        }

        // Remove process definitions from cache:
        CommandContextUtil.getProcessEngineConfiguration(commandContext).getDeploymentManager().removeDeployment(deploymentId, cascade);

        return null;
    }
}
