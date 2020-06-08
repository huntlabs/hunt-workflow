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
module flow.engine.impl.bpmn.behavior.EscalationEndEventActivityBehavior;

import flow.bpmn.model.Escalation;
import flow.bpmn.model.EscalationEventDefinition;
import flow.engine.deleg.DelegateExecution;
import flow.engine.impl.bpmn.helper.EscalationPropagation;
import flow.engine.impl.persistence.entity.ExecutionEntity;
import flow.engine.impl.util.CommandContextUtil;
import flow.engine.impl.bpmn.behavior.FlowNodeActivityBehavior;

/**
 * @author Tijs Rademakers
 */
class EscalationEndEventActivityBehavior : FlowNodeActivityBehavior {

    protected EscalationEventDefinition escalationEventDefinition;
    protected Escalation escalation;

    this(EscalationEventDefinition escalationEventDefinition, Escalation escalation) {
        this.escalationEventDefinition = escalationEventDefinition;
        this.escalation = escalation;
    }

    override
    public void execute(DelegateExecution execution) {
        if (escalation !is null) {
            EscalationPropagation.propagateEscalation(escalation, execution);
        } else {
            EscalationPropagation.propagateEscalation(escalationEventDefinition.getEscalationCode(),
                            escalationEventDefinition.getEscalationCode(), execution);
        }

        CommandContextUtil.getAgenda().planTakeOutgoingSequenceFlowsOperation(cast(ExecutionEntity) execution, true);
    }

    public EscalationEventDefinition getEscalationEventDefinition() {
        return escalationEventDefinition;
    }

    public void setEscalationEventDefinition(EscalationEventDefinition escalationEventDefinition) {
        this.escalationEventDefinition = escalationEventDefinition;
    }

    public Escalation getEscalation() {
        return escalation;
    }

    public void setEscalation(Escalation escalation) {
        this.escalation = escalation;
    }

}
