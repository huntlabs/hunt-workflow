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



import org.flowable.bpmn.model.Escalation;
import org.flowable.bpmn.model.EscalationEventDefinition;
import org.flowable.bpmn.model.ThrowEvent;
import flow.common.context.Context;
import flow.common.interceptor.CommandContext;
import flow.engine.delegate.DelegateExecution;
import flow.engine.impl.bpmn.helper.EscalationPropagation;
import flow.engine.impl.persistence.entity.ExecutionEntity;
import flow.engine.impl.util.CommandContextUtil;

/**
 * @author Tijs Rademakers
 */
class IntermediateThrowEscalationEventActivityBehavior extends AbstractBpmnActivityBehavior {

    private static final long serialVersionUID = 1L;

    protected final EscalationEventDefinition escalationEventDefinition;
    protected string escalationCode;
    protected string escalationName;

    public IntermediateThrowEscalationEventActivityBehavior(ThrowEvent throwEvent, EscalationEventDefinition escalationEventDefinition, 
                    Escalation escalation) {
        
        if (escalation != null) {
            escalationCode = escalation.getEscalationCode();
            escalationName = escalation.getName();
            
        } else {
            escalationCode = escalationEventDefinition.getEscalationCode();
            escalationName = escalationCode;
        }

        this.escalationEventDefinition = escalationEventDefinition;
    }

    @Override
    public void execute(DelegateExecution execution) {
        CommandContext commandContext = Context.getCommandContext();
        EscalationPropagation.propagateEscalation(escalationCode, escalationName, execution);
        CommandContextUtil.getAgenda(commandContext).planTakeOutgoingSequenceFlowsOperation((ExecutionEntity) execution, true);
    }

}
