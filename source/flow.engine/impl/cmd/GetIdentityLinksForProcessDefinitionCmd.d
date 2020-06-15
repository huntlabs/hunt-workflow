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
module flow.engine.impl.cmd.GetIdentityLinksForProcessDefinitionCmd;

import hunt.collection.List;

import flow.common.api.FlowableObjectNotFoundException;
import flow.common.interceptor.Command;
import flow.common.interceptor.CommandContext;
import flow.engine.impl.persistence.entity.ProcessDefinitionEntity;
import flow.engine.impl.util.CommandContextUtil;
import flow.engine.repository.ProcessDefinition;
import flow.identitylink.api.IdentityLink;

/**
 * @author Tijs Rademakers
 */
class GetIdentityLinksForProcessDefinitionCmd : Command!(List!IdentityLink) {

    protected string processDefinitionId;

    this(string processDefinitionId) {
        this.processDefinitionId = processDefinitionId;
    }

    public List!IdentityLink execute(CommandContext commandContext) {
        ProcessDefinitionEntity processDefinition = CommandContextUtil.getProcessDefinitionEntityManager(commandContext).findById(processDefinitionId);

        if (processDefinition is null) {
            throw new FlowableObjectNotFoundException("Cannot find process definition with id " ~ processDefinitionId);
        }

        List!IdentityLink identityLinks = cast(List!IdentityLink) processDefinition.getIdentityLinks();
        return identityLinks;
    }

}
