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
module flow.engine.impl.agenda.ExecuteInactiveBehaviorsOperation;

import hunt.collection.ArrayList;
import hunt.collection;

import flow.bpmn.model.FlowNode;
import flow.bpmn.model.Process;
import flow.common.interceptor.Command;
import flow.common.interceptor.CommandContext;
import flow.engine.impl.deleg.InactiveActivityBehavior;
import flow.engine.impl.persistence.entity.ExecutionEntity;
import flow.engine.impl.util.CommandContextUtil;
import flow.engine.impl.util.ProcessDefinitionUtil;
import flow.engine.impl.agenda.AbstractOperation;
import hunt.logging;

/**
 * Operation that usually gets scheduled as last operation of handling a {@link Command}.
 *
 * Executes 'background' behaviours of executions that currently are in an activity that implements the {@link InactiveActivityBehavior} interface.
 *
 * @author Joram Barrez
 */
class ExecuteInactiveBehaviorsOperation : AbstractOperation {

    protected Collection!ExecutionEntity involvedExecutions;

    this(CommandContext commandContext) {
        super(commandContext, null);
        this.involvedExecutions = new ArrayList!ExecutionEntity(CommandContextUtil.getInvolvedExecutions(commandContext).values());
    }

    public void run() {

        /*
         * Algorithm: for each execution that is involved in this command context,
         *
         * 1) Get its process definition 2) Verify if its process definitions has any InactiveActivityBehavior behaviours. 3) If so, verify if there are any executions inactive in those activities 4)
         * Execute the inactivated behavior
         *
         */

        foreach (ExecutionEntity executionEntity ; involvedExecutions) {

            Process process = ProcessDefinitionUtil.getProcess(executionEntity.getProcessDefinitionId());
            Collection!string flowNodeIdsWithInactivatedBehavior = new ArrayList!string();
            foreach (FlowNode flowNode ; process.findFlowElementsOfType!FlowNode(typeid(FlowNode))) {
                if (cast(InactiveActivityBehavior)flowNode.getBehavior() !is null) {
                    flowNodeIdsWithInactivatedBehavior.add(flowNode.getId());
                }
            }

            if (flowNodeIdsWithInactivatedBehavior.size() > 0) {
                Collection!ExecutionEntity inactiveExecutions = CommandContextUtil.getExecutionEntityManager(commandContext).findInactiveExecutionsByProcessInstanceId(executionEntity.getProcessInstanceId());
                foreach (ExecutionEntity inactiveExecution ; inactiveExecutions) {
                    if (!inactiveExecution.isActive()
                            && flowNodeIdsWithInactivatedBehavior.contains(inactiveExecution.getActivityId())
                            && !inactiveExecution.isDeleted()) {

                        FlowNode flowNode = cast(FlowNode) process.getFlowElement(inactiveExecution.getActivityId(), true);
                        InactiveActivityBehavior inactiveActivityBehavior = (cast(InactiveActivityBehavior) flowNode.getBehavior());
                        logInfo("Found InactiveActivityBehavior instance of class {} that can be executed on activity '{%s}'",  flowNode.getId());
                        inactiveActivityBehavior.executeInactive(inactiveExecution);
                    }
                }
            }

        }
    }

}
