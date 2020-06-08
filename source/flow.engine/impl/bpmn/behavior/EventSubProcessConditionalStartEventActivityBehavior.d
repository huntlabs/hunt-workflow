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



import flow.bpmn.model.ConditionalEventDefinition;
import flow.common.api.deleg.Expression;
import flow.common.context.Context;
import flow.common.interceptor.CommandContext;
import flow.engine.deleg.DelegateExecution;
import flow.engine.impl.persistence.entity.ExecutionEntity;
import flow.engine.impl.util.CommandContextUtil;

/**
 * Implementation of the BPMN 2.0 event subprocess start event.
 *
 * @author Tijs Rademakers
 */
class EventSubProcessConditionalStartEventActivityBehavior : FlowNodeActivityBehavior {

    private static final long serialVersionUID = 1L;

    protected ConditionalEventDefinition conditionalEventDefinition;
    protected string conditionExpression;

    public EventSubProcessConditionalStartEventActivityBehavior(ConditionalEventDefinition conditionalEventDefinition, string conditionExpression) {
        this.conditionalEventDefinition = conditionalEventDefinition;
        this.conditionExpression = conditionExpression;
    }

    override
    public void trigger(DelegateExecution execution, string signalName, Object signalData) {
        CommandContext commandContext = Context.getCommandContext();

        Expression expression = CommandContextUtil.getProcessEngineConfiguration(commandContext).getExpressionManager().createExpression(conditionExpression);
        Object result = expression.getValue(execution);
        if (result !is null && result instanceof bool && (bool) result) {
            CommandContextUtil.getActivityInstanceEntityManager(commandContext).recordActivityStart((ExecutionEntity) execution);
            super.trigger(execution, signalName, signalData);
        }
    }

}
