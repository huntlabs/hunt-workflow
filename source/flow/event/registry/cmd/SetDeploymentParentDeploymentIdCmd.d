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
import flow.common.api.FlowableObjectNotFoundException;
import flow.common.interceptor.Command;
import flow.common.interceptor.CommandContext;
import flow.event.registry.persistence.entity.EventDeploymentEntity;
import flow.event.registry.util.CommandContextUtil;

/**
 * @author Tijs Rademakers
 */
class SetDeploymentParentDeploymentIdCmd implements Command<Void>, Serializable {

    private static final long serialVersionUID = 1L;

    protected String deploymentId;
    protected String newParentDeploymentId;

    public SetDeploymentParentDeploymentIdCmd(String deploymentId, String newParentDeploymentId) {
        this.deploymentId = deploymentId;
        this.newParentDeploymentId = newParentDeploymentId;
    }

    @Override
    public Void execute(CommandContext commandContext) {
        if (deploymentId is null) {
            throw new FlowableIllegalArgumentException("deploymentId is null");
        }

        // Update all entities

        EventDeploymentEntity deployment = CommandContextUtil.getDeploymentEntityManager(commandContext).findById(deploymentId);
        if (deployment is null) {
            throw new FlowableObjectNotFoundException("Could not find deployment with id " + deploymentId);
        }

        deployment.setParentDeploymentId(newParentDeploymentId);

        CommandContextUtil.getDeploymentEntityManager(commandContext).update(deployment);

        return null;

    }

}
