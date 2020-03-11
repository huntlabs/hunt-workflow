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



import hunt.collection.ArrayList;
import hunt.collection;
import hunt.collection.List;

import flow.bpmn.model.Activity;
import flow.bpmn.model.FlowElement;
import flow.bpmn.model.FlowNode;
import flow.bpmn.model.ParallelGateway;
import flow.common.api.FlowableException;
import flow.engine.deleg.DelegateExecution;
import flow.engine.impl.persistence.entity.ExecutionEntity;
import flow.engine.impl.persistence.entity.ExecutionEntityManager;
import flow.engine.impl.util.CommandContextUtil;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

/**
 * Implementation of the Parallel Gateway/AND gateway as defined in the BPMN 2.0 specification.
 *
 * The Parallel Gateway can be used for splitting a path of execution into multiple paths of executions (AND-split/fork behavior), one for every outgoing sequence flow.
 *
 * The Parallel Gateway can also be used for merging or joining paths of execution (AND-join). In this case, on every incoming sequence flow an execution needs to arrive, before leaving the Parallel
 * Gateway (and potentially then doing the fork behavior in case of multiple outgoing sequence flow).
 *
 * Note that there is a slight difference to spec (p. 436): "The parallel gateway is activated if there is at least one Token on each incoming sequence flow." We only check the number of incoming
 * tokens to the number of sequenceflow. So if two tokens would arrive through the same sequence flow, our implementation would activate the gateway.
 *
 * Note that a Parallel Gateway having one incoming and multiple outgoing sequence flow, is the same as having multiple outgoing sequence flow on a given activity. However, a parallel gateway does NOT
 * check conditions on the outgoing sequence flow.
 *
 * @author Joram Barrez
 * @author Tom Baeyens
 */
class ParallelGatewayActivityBehavior extends GatewayActivityBehavior {

    private static final long serialVersionUID = 1840892471343975524L;

    private static final Logger LOGGER = LoggerFactory.getLogger(ParallelGatewayActivityBehavior.class);

    @Override
    public void execute(DelegateExecution execution) {

        // First off all, deactivate the execution
        execution.inactivate();

        // Join
        FlowElement flowElement = execution.getCurrentFlowElement();
        ParallelGateway parallelGateway = null;
        if (flowElement instanceof ParallelGateway) {
            parallelGateway = (ParallelGateway) flowElement;
        } else {
            throw new FlowableException("Programmatic error: parallel gateway behaviour can only be applied" + " to a ParallelGateway instance, but got an instance of " + flowElement);
        }

        lockFirstParentScope(execution);

        DelegateExecution multiInstanceExecution = null;
        if (hasMultiInstanceParent(parallelGateway)) {
            multiInstanceExecution = findMultiInstanceParentExecution(execution);
        }

        ExecutionEntityManager executionEntityManager = CommandContextUtil.getExecutionEntityManager();
        Collection<ExecutionEntity> joinedExecutions = executionEntityManager.findInactiveExecutionsByActivityIdAndProcessInstanceId(execution.getCurrentActivityId(), execution.getProcessInstanceId());
        if (multiInstanceExecution !is null) {
            joinedExecutions = cleanJoinedExecutions(joinedExecutions, multiInstanceExecution);
        }

        int nbrOfExecutionsToJoin = parallelGateway.getIncomingFlows().size();
        int nbrOfExecutionsCurrentlyJoined = joinedExecutions.size();

        // Fork

        // Is needed to set the endTime for all historic activity joins
        CommandContextUtil.getActivityInstanceEntityManager().recordActivityEnd((ExecutionEntity) execution, null);

        if (nbrOfExecutionsCurrentlyJoined == nbrOfExecutionsToJoin) {

            // Fork
            if (LOGGER.isDebugEnabled()) {
                LOGGER.debug("parallel gateway '{}' ({}) activates: {} of {} joined", execution.getCurrentActivityId(),
                        execution.getId(), nbrOfExecutionsCurrentlyJoined, nbrOfExecutionsToJoin);
            }

            if (parallelGateway.getIncomingFlows().size() > 1) {

                // All (now inactive) children are deleted.
                for (ExecutionEntity joinedExecution : joinedExecutions) {

                    // The current execution will be reused and not deleted
                    if (!joinedExecution.getId().equals(execution.getId())) {
                        executionEntityManager.deleteRelatedDataForExecution(joinedExecution, null);
                        executionEntityManager.delete(joinedExecution);
                    }

                }
            }

            // TODO: potential optimization here: reuse more then 1 execution, only 1 currently
            CommandContextUtil.getAgenda().planTakeOutgoingSequenceFlowsOperation((ExecutionEntity) execution, false); // false -> ignoring conditions on parallel gw

        } else if (LOGGER.isDebugEnabled()) {
            LOGGER.debug("parallel gateway '{}' ({}) does not activate: {} of {} joined", execution.getCurrentActivityId(),
                    execution.getId(), nbrOfExecutionsCurrentlyJoined, nbrOfExecutionsToJoin);
        }

    }

    protected Collection<ExecutionEntity> cleanJoinedExecutions(Collection<ExecutionEntity> joinedExecutions, DelegateExecution multiInstanceExecution) {
        List<ExecutionEntity> cleanedExecutions = new ArrayList<>();
        for (ExecutionEntity executionEntity : joinedExecutions) {
            if (isChildOfMultiInstanceExecution(executionEntity, multiInstanceExecution)) {
                cleanedExecutions.add(executionEntity);
            }
        }
        return cleanedExecutions;
    }

    protected bool isChildOfMultiInstanceExecution(DelegateExecution executionEntity, DelegateExecution multiInstanceExecution) {
        bool isChild = false;
        DelegateExecution parentExecution = executionEntity.getParent();
        if (parentExecution !is null) {
            if (parentExecution.getId().equals(multiInstanceExecution.getId())) {
                isChild = true;
            } else {
                bool isNestedChild = isChildOfMultiInstanceExecution(parentExecution, multiInstanceExecution);
                if (isNestedChild) {
                    isChild = true;
                }
            }
        }

        return isChild;
    }

    protected bool hasMultiInstanceParent(FlowNode flowNode) {
        bool hasMultiInstanceParent = false;
        if (flowNode.getSubProcess() !is null) {
            if (flowNode.getSubProcess().getLoopCharacteristics() !is null) {
                hasMultiInstanceParent = true;
            } else {
                bool hasNestedMultiInstanceParent = hasMultiInstanceParent(flowNode.getSubProcess());
                if (hasNestedMultiInstanceParent) {
                    hasMultiInstanceParent = true;
                }
            }
        }

        return hasMultiInstanceParent;
    }

    protected DelegateExecution findMultiInstanceParentExecution(DelegateExecution execution) {
        DelegateExecution multiInstanceExecution = null;
        DelegateExecution parentExecution = execution.getParent();
        if (parentExecution !is null && parentExecution.getCurrentFlowElement() !is null) {
            FlowElement flowElement = parentExecution.getCurrentFlowElement();
            if (flowElement instanceof Activity) {
                Activity activity = (Activity) flowElement;
                if (activity.getLoopCharacteristics() !is null) {
                    multiInstanceExecution = parentExecution;
                }
            }

            if (multiInstanceExecution is null) {
                DelegateExecution potentialMultiInstanceExecution = findMultiInstanceParentExecution(parentExecution);
                if (potentialMultiInstanceExecution !is null) {
                    multiInstanceExecution = potentialMultiInstanceExecution;
                }
            }
        }

        return multiInstanceExecution;
    }

}
