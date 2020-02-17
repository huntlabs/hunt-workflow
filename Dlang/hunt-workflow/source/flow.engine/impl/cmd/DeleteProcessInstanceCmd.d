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
import flow.engine.impl.persistence.entity.ExecutionEntity;
import flow.engine.impl.util.CommandContextUtil;
import flow.engine.impl.util.Flowable5Util;
import flow.engine.runtime.ProcessInstance;

/**
 * @author Joram Barrez
 */
class DeleteProcessInstanceCmd implements Command<Void>, Serializable {

    private static final long serialVersionUID = 1L;
    protected string processInstanceId;
    protected string deleteReason;

    public DeleteProcessInstanceCmd(string processInstanceId, string deleteReason) {
        this.processInstanceId = processInstanceId;
        this.deleteReason = deleteReason;
    }

    @Override
    public Void execute(CommandContext commandContext) {
        if (processInstanceId == null) {
            throw new FlowableIllegalArgumentException("processInstanceId is null");
        }

        ExecutionEntity processInstanceEntity = CommandContextUtil.getExecutionEntityManager(commandContext).findById(processInstanceId);
        if (processInstanceEntity == null) {
            throw new FlowableObjectNotFoundException("No process instance found for id '" + processInstanceId + "'", ProcessInstance.class);
        }
        if (processInstanceEntity.isDeleted()) {
            return null;
        }

        if (Flowable5Util.isFlowable5ProcessDefinitionId(commandContext, processInstanceEntity.getProcessDefinitionId())) {
            Flowable5CompatibilityHandler compatibilityHandler = Flowable5Util.getFlowable5CompatibilityHandler();
            compatibilityHandler.deleteProcessInstance(processInstanceId, deleteReason);
        } else {
            CommandContextUtil.getExecutionEntityManager(commandContext).deleteProcessInstance(processInstanceEntity.getProcessInstanceId(), deleteReason, false);
        }

        return null;
    }

}
