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
module flow.engine.impl.cmd.AddIdentityLinkForProcessInstanceCmd;


import flow.common.api.FlowableIllegalArgumentException;
import flow.common.api.FlowableObjectNotFoundException;
import flow.common.interceptor.Command;
import flow.common.interceptor.CommandContext;
import flow.engine.compatibility.Flowable5CompatibilityHandler;
import flow.engine.impl.persistence.entity.ExecutionEntity;
import flow.engine.impl.persistence.entity.ExecutionEntityManager;
import flow.engine.impl.util.CommandContextUtil;
//import flow.engine.impl.util.Flowable5Util;
import flow.engine.impl.util.IdentityLinkUtil;
import hunt.Object;

/**
 * @author Marcus Klimstra
 * @author Joram Barrez
 */
class AddIdentityLinkForProcessInstanceCmd : Command!Void {

    protected string processInstanceId;

    protected string userId;

    protected string groupId;

    protected string type;

    this(string processInstanceId, string userId, string groupId, string type) {
        validateParams(processInstanceId, userId, groupId, type);
        this.processInstanceId = processInstanceId;
        this.userId = userId;
        this.groupId = groupId;
        this.type = type;
    }

    protected void validateParams(string processInstanceId, string userId, string groupId, string type) {

        if (processInstanceId is null) {
            throw new FlowableIllegalArgumentException("processInstanceId is null");
        }

        if (type is null) {
            throw new FlowableIllegalArgumentException("type is required when adding a new process instance identity link");
        }

        if (userId is null && groupId is null) {
            throw new FlowableIllegalArgumentException("userId and groupId cannot both be null");
        }

    }

    public Void execute(CommandContext commandContext) {

        ExecutionEntityManager executionEntityManager = CommandContextUtil.getExecutionEntityManager(commandContext);
        ExecutionEntity processInstance = executionEntityManager.findById(processInstanceId);

        if (processInstance is null) {
            throw new FlowableObjectNotFoundException("Cannot find process instance with id " ~ processInstanceId);
        }

        //if (Flowable5Util.isFlowable5ProcessDefinitionId(commandContext, processInstance.getProcessDefinitionId())) {
        //    Flowable5CompatibilityHandler compatibilityHandler = Flowable5Util.getFlowable5CompatibilityHandler();
        //    compatibilityHandler.addIdentityLinkForProcessInstance(processInstanceId, userId, groupId, type);
        //    return null;
        //}

        IdentityLinkUtil.createProcessInstanceIdentityLink(processInstance, userId, groupId, type);
        CommandContextUtil.getHistoryManager(commandContext).createProcessInstanceIdentityLinkComment(processInstance, userId, groupId, type, true);

        return null;

    }

}
