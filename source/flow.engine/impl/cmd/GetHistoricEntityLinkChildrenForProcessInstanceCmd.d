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
module flow.engine.impl.cmd.GetHistoricEntityLinkChildrenForProcessInstanceCmd;

import hunt.collection.List;

import flow.common.api.FlowableIllegalArgumentException;
import flow.common.api.scop.ScopeTypes;
import flow.common.interceptor.Command;
import flow.common.interceptor.CommandContext;
import flow.engine.impl.util.CommandContextUtil;
import flow.entitylink.service.api.EntityLinkType;
import flow.entitylink.service.api.history.HistoricEntityLink;

/**
 * @author Tijs Rademakers
 */
class GetHistoricEntityLinkChildrenForProcessInstanceCmd : Command!(List!HistoricEntityLink) {

    protected string processInstanceId;

    this(string processInstanceId) {
        if (processInstanceId is null) {
            throw new FlowableIllegalArgumentException("processInstanceId is required");
        }
        this.processInstanceId = processInstanceId;
    }

    public List!HistoricEntityLink execute(CommandContext commandContext) {
        return CommandContextUtil.getHistoricEntityLinkService().findHistoricEntityLinksByScopeIdAndScopeType(
                        processInstanceId, ScopeTypes.BPMN, EntityLinkType.CHILD);
    }

}
