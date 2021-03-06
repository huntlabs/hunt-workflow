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
module flow.engine.impl.bpmn.behavior.BoundaryEscalationEventActivityBehavior;

import flow.bpmn.model.Escalation;
import flow.bpmn.model.EscalationEventDefinition;
import flow.common.api.deleg.event.FlowableEngineEventType;
import flow.common.api.deleg.event.FlowableEventDispatcher;
import flow.common.context.Context;
import flow.common.interceptor.CommandContext;
import flow.engine.deleg.DelegateExecution;
import flow.engine.deleg.event.impl.FlowableEventBuilder;
import flow.engine.impl.persistence.entity.ExecutionEntity;
import flow.engine.impl.util.CommandContextUtil;
import flow.engine.impl.bpmn.behavior.BoundaryEventActivityBehavior;
/**
 * @author Tijs Rademakers
 */
class BoundaryEscalationEventActivityBehavior : BoundaryEventActivityBehavior {

    protected EscalationEventDefinition escalationEventDefinition;
    protected Escalation escalation;

    this(EscalationEventDefinition escalationEventDefinition, Escalation escalation, bool interrupting) {
        super(interrupting);
        this.escalationEventDefinition = escalationEventDefinition;
        this.escalation = escalation;
    }

    override
    public void execute(DelegateExecution execution) {
        CommandContext commandContext = Context.getCommandContext();
        ExecutionEntity executionEntity = cast(ExecutionEntity) execution;

        string escalationCode = null;
        string escalationName = null;
        if (escalation !is null) {
            escalationCode = escalation.getEscalationCode();
            escalationName = escalation.getName();
        } else {
            escalationCode = escalationEventDefinition.getEscalationCode();
        }

        FlowableEventDispatcher eventDispatcher = CommandContextUtil.getProcessEngineConfiguration(commandContext).getEventDispatcher();
        if (eventDispatcher !is null && eventDispatcher.isEnabled()) {
            eventDispatcher
                    .dispatchEvent(FlowableEventBuilder.createEscalationEvent(FlowableEngineEventType.ACTIVITY_ESCALATION_WAITING, executionEntity.getActivityId(), escalationCode,
                                    escalationName, executionEntity.getId(), executionEntity.getProcessInstanceId(), executionEntity.getProcessDefinitionId()));
        }
    }
}
