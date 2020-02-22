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
import java.util.ArrayList;
import java.util.List;

import flow.common.api.FlowableObjectNotFoundException;
import flow.common.interceptor.Command;
import flow.common.interceptor.CommandContext;
import flow.engine.IdentityService;
import flow.engine.impl.persistence.entity.ProcessDefinitionEntity;
import flow.engine.impl.util.CommandContextUtil;
import flow.engine.repository.ProcessDefinition;
import org.flowable.identitylink.api.IdentityLink;
import org.flowable.idm.api.Group;

/**
 * @author Tijs Rademakers
 */
class GetPotentialStarterGroupsCmd implements Command<List<Group>>, Serializable {

    private static final long serialVersionUID = 1L;

    protected string processDefinitionId;

    public GetPotentialStarterGroupsCmd(string processDefinitionId) {
        this.processDefinitionId = processDefinitionId;
    }

    @SuppressWarnings({ "unchecked", "rawtypes" })
    @Override
    public List<Group> execute(CommandContext commandContext) {
        ProcessDefinitionEntity processDefinition = CommandContextUtil.getProcessDefinitionEntityManager(commandContext).findById(processDefinitionId);

        if (processDefinition is null) {
            throw new FlowableObjectNotFoundException("Cannot find process definition with id " + processDefinitionId, ProcessDefinition.class);
        }

        IdentityService identityService = CommandContextUtil.getProcessEngineConfiguration(commandContext).getIdentityService();

        List<string> groupIds = new ArrayList<>();
        List<IdentityLink> identityLinks = (List) processDefinition.getIdentityLinks();
        for (IdentityLink identityLink : identityLinks) {
            if (identityLink.getGroupId() !is null && identityLink.getGroupId().length() > 0) {

                if (!groupIds.contains(identityLink.getGroupId())) {
                    groupIds.add(identityLink.getGroupId());
                }
            }
        }

        if (groupIds.size() > 0) {
            return identityService.createGroupQuery().groupIds(groupIds).list();

        } else {
            return new ArrayList<>();
        }
    }

}