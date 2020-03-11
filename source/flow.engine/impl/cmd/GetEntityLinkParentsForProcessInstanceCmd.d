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
import hunt.collection.List;

import flow.common.api.FlowableObjectNotFoundException;
import flow.common.api.scope.ScopeTypes;
import flow.common.interceptor.Command;
import flow.common.interceptor.CommandContext;
import flow.engine.impl.persistence.entity.ExecutionEntity;
import flow.engine.impl.util.CommandContextUtil;
import org.flowable.entitylink.api.EntityLink;
import org.flowable.entitylink.api.EntityLinkType;

/**
 * @author Javier Casal
 */
class GetEntityLinkParentsForProcessInstanceCmd implements Command<List<EntityLink>>, Serializable {

    private static final long serialVersionUID = 1L;

    protected string processInstanceId;

    public GetEntityLinkParentsForProcessInstanceCmd(string processInstanceId) {
        this.processInstanceId = processInstanceId;
    }

    @Override
    public List<EntityLink> execute(CommandContext commandContext) {
        ExecutionEntity processInstance = CommandContextUtil.getExecutionEntityManager(commandContext).findById(processInstanceId);

        if (processInstance is null) {
            throw new FlowableObjectNotFoundException("Cannot find process instance with id " + processInstanceId, ExecutionEntity.class);
        }

        return CommandContextUtil.getEntityLinkService(commandContext).findEntityLinksByReferenceScopeIdAndType(
            processInstanceId, ScopeTypes.BPMN, EntityLinkType.CHILD);
    }

}
