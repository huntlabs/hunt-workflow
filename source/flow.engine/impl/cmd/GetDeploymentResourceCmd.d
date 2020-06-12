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
module flow.engine.impl.cmd.GetDeploymentResourceCmd;

import hunt.stream.ByteArrayInputStream;
import hunt.stream.Common;

import flow.common.api.FlowableIllegalArgumentException;
import flow.common.api.FlowableObjectNotFoundException;
import flow.common.interceptor.Command;
import flow.common.interceptor.CommandContext;
import flow.engine.impl.persistence.entity.ResourceEntity;
import flow.engine.impl.util.CommandContextUtil;
import flow.engine.repository.Deployment;

/**
 * @author Joram Barrez
 */
class GetDeploymentResourceCmd : Command!InputStream {

    protected string deploymentId;
    protected string resourceName;

    this(string deploymentId, string resourceName) {
        this.deploymentId = deploymentId;
        this.resourceName = resourceName;
    }

    public InputStream execute(CommandContext commandContext) {
        if (deploymentId is null) {
            throw new FlowableIllegalArgumentException("deploymentId is null");
        }
        if (resourceName is null) {
            throw new FlowableIllegalArgumentException("resourceName is null");
        }

        ResourceEntity resource = CommandContextUtil.getResourceEntityManager().findResourceByDeploymentIdAndResourceName(deploymentId, resourceName);
        if (resource is null) {
            if (CommandContextUtil.getDeploymentEntityManager(commandContext).findById(deploymentId) is null) {
                throw new FlowableObjectNotFoundException("deployment does not exist: " ~ deploymentId);
            } else {
                throw new FlowableObjectNotFoundException("no resource found with name '" ~ resourceName ~ "' in deployment '" ~ deploymentId ~ "'");
            }
        }
        return new ByteArrayInputStream(resource.getBytes());
    }

}
