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


import org.flowable.bpmn.model.ConditionalEventDefinition;
import flow.common.api.delegate.Expression;
import flow.common.api.delegate.event.FlowableEngineEventType;
import flow.common.api.delegate.event.FlowableEventDispatcher;
import flow.engine.delegate.DelegateExecution;
import flow.engine.delegate.event.impl.FlowableEventBuilder;
import flow.engine.impl.persistence.entity.ExecutionEntity;
import flow.engine.impl.util.CommandContextUtil;

class IntermediateCatchConditionalEventActivityBehavior extends IntermediateCatchEventActivityBehavior {

    private static final long serialVersionUID = 1L;

    protected ConditionalEventDefinition conditionalEventDefinition;
    protected string conditionExpression;

    public IntermediateCatchConditionalEventActivityBehavior(ConditionalEventDefinition conditionalEventDefinition, string conditionExpression) {
        this.conditionalEventDefinition = conditionalEventDefinition;
        this.conditionExpression = conditionExpression;
    }

    @Override
    public void execute(DelegateExecution execution) {
        ExecutionEntity executionEntity = (ExecutionEntity) execution;

        FlowableEventDispatcher eventDispatcher = CommandContextUtil.getProcessEngineConfiguration().getEventDispatcher();
        if (eventDispatcher != null && eventDispatcher.isEnabled()) {
            eventDispatcher.dispatchEvent(FlowableEventBuilder.createConditionalEvent(FlowableEngineEventType.ACTIVITY_CONDITIONAL_WAITING, 
                            executionEntity.getActivityId(), conditionExpression, executionEntity.getId(), 
                            executionEntity.getProcessInstanceId(), executionEntity.getProcessDefinitionId()));
        }
    }

    @Override
    public void trigger(DelegateExecution execution, string triggerName, Object triggerData) {
        Expression expression = CommandContextUtil.getProcessEngineConfiguration().getExpressionManager().createExpression(conditionExpression);
        Object result = expression.getValue(execution);
        
        if (result != null && result instanceof bool && (bool) result) {
            ExecutionEntity executionEntity = (ExecutionEntity) execution;
            FlowableEventDispatcher eventDispatcher = CommandContextUtil.getProcessEngineConfiguration().getEventDispatcher();
            if (eventDispatcher != null && eventDispatcher.isEnabled()) {
                eventDispatcher.dispatchEvent(FlowableEventBuilder.createConditionalEvent(FlowableEngineEventType.ACTIVITY_CONDITIONAL_RECEIVED, executionEntity.getActivityId(), 
                                conditionExpression, executionEntity.getId(), executionEntity.getProcessInstanceId(), executionEntity.getProcessDefinitionId()));
            }
            
            leaveIntermediateCatchEvent(execution);
        }
    }
}
