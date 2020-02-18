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
import flow.engine.compatibility.Flowable5CompatibilityHandler;
import flow.engine.impl.persistence.entity.ProcessDefinitionEntity;
import flow.engine.impl.util.CommandContextUtil;
import flow.engine.impl.util.Flowable5Util;
import flow.engine.repository.ProcessDefinition;
import org.flowable.identitylink.service.impl.persistence.entity.IdentityLinkEntity;

/**
 * @author Tijs Rademakers
 */
class AddIdentityLinkForProcessDefinitionCmd implements Command<Void>, Serializable {

    private static final long serialVersionUID = 1L;

    protected string processDefinitionId;

    protected string userId;

    protected string groupId;

    public AddIdentityLinkForProcessDefinitionCmd(string processDefinitionId, string userId, string groupId) {
        validateParams(userId, groupId, processDefinitionId);
        this.processDefinitionId = processDefinitionId;
        this.userId = userId;
        this.groupId = groupId;
    }

    protected void validateParams(string userId, string groupId, string processDefinitionId) {
        if (processDefinitionId is null) {
            throw new FlowableIllegalArgumentException("processDefinitionId is null");
        }

        if (userId is null && groupId is null) {
            throw new FlowableIllegalArgumentException("userId and groupId cannot both be null");
        }
    }

    @Override
    public Void execute(CommandContext commandContext) {
        ProcessDefinitionEntity processDefinition = CommandContextUtil.getProcessDefinitionEntityManager(commandContext).findById(processDefinitionId);

        if (processDefinition is null) {
            throw new FlowableObjectNotFoundException("Cannot find process definition with id " + processDefinitionId, ProcessDefinition.class);
        }

        if (Flowable5Util.isFlowable5ProcessDefinition(processDefinition, commandContext)) {
            Flowable5CompatibilityHandler compatibilityHandler = Flowable5Util.getFlowable5CompatibilityHandler();
            compatibilityHandler.addCandidateStarter(processDefinitionId, userId, groupId);
            return null;
        }

        IdentityLinkEntity identityLinkEntity = CommandContextUtil.getIdentityLinkService().createProcessDefinitionIdentityLink(processDefinition.getId(), userId, groupId);
        processDefinition.getIdentityLinks().add(identityLinkEntity);

        return null;
    }

}
