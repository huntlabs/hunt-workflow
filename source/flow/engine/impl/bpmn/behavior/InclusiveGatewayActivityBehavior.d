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
module flow.engine.impl.bpmn.behavior.InclusiveGatewayActivityBehavior;

import hunt.collection;
import hunt.collection.Iterator;
import std.range;
import flow.common.context.Context;
import flow.common.interceptor.CommandContext;
import flow.engine.deleg.DelegateExecution;
import flow.engine.impl.deleg.InactiveActivityBehavior;
import flow.engine.impl.persistence.entity.ExecutionEntity;
import flow.engine.impl.persistence.entity.ExecutionEntityManager;
import flow.engine.impl.util.CommandContextUtil;
import flow.engine.impl.util.ExecutionGraphUtil;
import flow.engine.impl.bpmn.behavior.GatewayActivityBehavior;

/**
 * Implementation of the Inclusive Gateway/OR gateway/inclusive data-based gateway as defined in the BPMN specification.
 *
 * @author Tijs Rademakers
 * @author Tom Van Buskirk
 * @author Joram Barrez
 */
class InclusiveGatewayActivityBehavior : GatewayActivityBehavior , InactiveActivityBehavior {

    override
    public void execute(DelegateExecution execution) {
        // The join in the inclusive gateway works as follows:
        // When an execution enters it, it is inactivated.
        // All the inactivated executions stay in the inclusive gateway
        // until ALL executions that CAN reach the inclusive gateway have reached it.
        //
        // This check is repeated on execution changes until the inactivated
        // executions leave the gateway.

        execution.inactivate();
        executeInclusiveGatewayLogic(cast(ExecutionEntity) execution);
    }

    override
    public void executeInactive(ExecutionEntity executionEntity) {
        executeInclusiveGatewayLogic(executionEntity);
    }

    protected void executeInclusiveGatewayLogic(ExecutionEntity execution) {
        CommandContext commandContext = Context.getCommandContext();
        ExecutionEntityManager executionEntityManager = CommandContextUtil.getExecutionEntityManager(commandContext);

        lockFirstParentScope(execution);

        Collection!ExecutionEntity allExecutions = executionEntityManager.findChildExecutionsByProcessInstanceId(execution.getProcessInstanceId());
        InputRange!ExecutionEntity executionIterator = allExecutions.iterator();
        bool oneExecutionCanReachGatewayInstance = false;
        while (!oneExecutionCanReachGatewayInstance && !executionIterator.empty) {
            ExecutionEntity executionEntity = executionIterator.front();
            if (executionEntity.getActivityId() != (execution.getCurrentActivityId())) {
                if (ExecutionGraphUtil.isReachable(execution.getProcessDefinitionId(), executionEntity.getActivityId(), execution.getCurrentActivityId())) {
                    //Now check if they are in the same "execution path"
                    if (executionEntity.getParentId() == (execution.getParentId())) {
                        oneExecutionCanReachGatewayInstance = true;
                        break;
                    }
                }
            } else if (executionEntity.getId() == (execution.getId()) && executionEntity.isActive()) {
                // Special case: the execution has reached the inc gw, but the operation hasn't been executed yet for that execution
                oneExecutionCanReachGatewayInstance = true;
                break;
            }
            executionIterator.popFront();
        }

        // Is needed to set the endTime for all historic activity joins
        CommandContextUtil.getActivityInstanceEntityManager(commandContext).recordActivityEnd(execution, null);

        // If no execution can reach the gateway, the gateway activates and executes fork behavior
        if (!oneExecutionCanReachGatewayInstance) {

            //LOGGER.debug("Inclusive gateway cannot be reached by any execution and is activated");

            // Kill all executions here (except the incoming)
            Collection!ExecutionEntity executionsInGateway = executionEntityManager
                .findInactiveExecutionsByActivityIdAndProcessInstanceId(execution.getCurrentActivityId(), execution.getProcessInstanceId());
            foreach (ExecutionEntity executionEntityInGateway ; executionsInGateway) {
                if (executionEntityInGateway.getId() != (execution.getId()) && executionEntityInGateway.getParentId() == (execution.getParentId())) {
                    CommandContextUtil.getActivityInstanceEntityManager(commandContext).recordActivityEnd(executionEntityInGateway, null);
                    executionEntityManager.deleteExecutionAndRelatedData(executionEntityInGateway, null, false);
                }
            }

            // Leave
            CommandContextUtil.getAgenda(commandContext).planTakeOutgoingSequenceFlowsOperation(execution, true);
        }
    }
}
