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
module flow.engine.impl.cmd.SetDeploymentKeyCmd;

import flow.common.api.FlowableException;
import flow.common.api.FlowableIllegalArgumentException;
import flow.common.api.FlowableObjectNotFoundException;
import flow.common.api.deleg.event.FlowableEngineEventType;
import flow.common.api.deleg.event.FlowableEventDispatcher;
import flow.common.interceptor.Command;
import flow.common.interceptor.CommandContext;
import flow.engine.deleg.event.impl.FlowableEventBuilder;
import flow.engine.impl.persistence.entity.DeploymentEntity;
import flow.engine.impl.util.CommandContextUtil;
//import flow.engine.impl.util.Flowable5Util;
import flow.engine.repository.Deployment;
import hunt.Object;

/**
 * @author Tijs Rademakers
 */
class SetDeploymentKeyCmd : Command!Void {

    protected string deploymentId;
    protected string key;

    this(string deploymentId, string key) {
        this.deploymentId = deploymentId;
        this.key = key;
    }

    public Void execute(CommandContext commandContext) {

        if (deploymentId is null) {
            throw new FlowableIllegalArgumentException("Deployment id is null");
        }

        DeploymentEntity deployment = CommandContextUtil.getDeploymentEntityManager(commandContext).findById(deploymentId);

        if (deployment is null) {
            throw new FlowableObjectNotFoundException("No deployment found for id = '" ~ deploymentId ~ "'");
        }

        //if (Flowable5Util.isFlowable5Deployment(deployment, commandContext)) {
        //    throw new FlowableException("Not supported for version 5 deployments");
        //}

        // Update category
        deployment.setKey(key);

        FlowableEventDispatcher eventDispatcher = CommandContextUtil.getProcessEngineConfiguration(commandContext).getEventDispatcher();
        if (eventDispatcher !is null && eventDispatcher.isEnabled()) {
            eventDispatcher
                .dispatchEvent(FlowableEventBuilder.createEntityEvent(FlowableEngineEventType.ENTITY_UPDATED, cast(Object)deployment));
        }

        return null;
    }

    public string getDeploymentId() {
        return deploymentId;
    }

    public void setDeploymentId(string deploymentId) {
        this.deploymentId = deploymentId;
    }

    public string getKey() {
        return key;
    }

    public void setKey(string key) {
        this.key = key;
    }

}
