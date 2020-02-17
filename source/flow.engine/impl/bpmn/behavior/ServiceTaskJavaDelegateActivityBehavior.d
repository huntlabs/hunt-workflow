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



import flow.common.api.delegate.Expression;
import flow.common.interceptor.CommandContext;
import flow.common.logging.LoggingSessionConstants;
import flow.engine.delegate.DelegateExecution;
import flow.engine.delegate.ExecutionListener;
import flow.engine.delegate.JavaDelegate;
import flow.engine.impl.bpmn.helper.SkipExpressionUtil;
import flow.engine.impl.cfg.ProcessEngineConfigurationImpl;
import flow.engine.impl.delegate.ActivityBehavior;
import flow.engine.impl.delegate.TriggerableActivityBehavior;
import flow.engine.impl.delegate.invocation.JavaDelegateInvocation;
import flow.engine.impl.util.BpmnLoggingSessionUtil;
import flow.engine.impl.util.CommandContextUtil;

/**
 * @author Tom Baeyens
 */
class ServiceTaskJavaDelegateActivityBehavior extends TaskActivityBehavior implements ActivityBehavior, ExecutionListener {

    private static final long serialVersionUID = 1L;

    protected JavaDelegate javaDelegate;
    protected Expression skipExpression;
    protected bool triggerable;

    protected ServiceTaskJavaDelegateActivityBehavior() {
    }

    public ServiceTaskJavaDelegateActivityBehavior(JavaDelegate javaDelegate, bool triggerable, Expression skipExpression) {
        this.javaDelegate = javaDelegate;
        this.triggerable = triggerable;
        this.skipExpression = skipExpression;
    }

    @Override
    public void trigger(DelegateExecution execution, string signalName, Object signalData) {
        CommandContext commandContext = CommandContextUtil.getCommandContext();
        ProcessEngineConfigurationImpl processEngineConfiguration = CommandContextUtil.getProcessEngineConfiguration(commandContext);
        
        if (triggerable && javaDelegate instanceof TriggerableActivityBehavior) {
            if (processEngineConfiguration.isLoggingSessionEnabled()) {
                BpmnLoggingSessionUtil.addLoggingData(LoggingSessionConstants.TYPE_SERVICE_TASK_BEFORE_TRIGGER, 
                                "Triggering service task with java class " + javaDelegate.getClass().getName(), execution);
            }
            
            ((TriggerableActivityBehavior) javaDelegate).trigger(execution, signalName, signalData);
            
            if (processEngineConfiguration.isLoggingSessionEnabled()) {
                BpmnLoggingSessionUtil.addLoggingData(LoggingSessionConstants.TYPE_SERVICE_TASK_BEFORE_TRIGGER, 
                                "Triggered service task with java class " + javaDelegate.getClass().getName(), execution);
            }
            
            leave(execution);
        
        } else {
            if (processEngineConfiguration.isLoggingSessionEnabled()) {
                if (!triggerable) {
                    BpmnLoggingSessionUtil.addLoggingData(LoggingSessionConstants.TYPE_SERVICE_TASK_WRONG_TRIGGER, 
                                    "Service task with java class triggered but not triggerable " + javaDelegate.getClass().getName(), execution);
                } else {
                    BpmnLoggingSessionUtil.addLoggingData(LoggingSessionConstants.TYPE_SERVICE_TASK_WRONG_TRIGGER, 
                                    "Service task with java class triggered but not implementing TriggerableActivityBehavior " + javaDelegate.getClass().getName(), execution);
                }
            }
        }
    }

    @Override
    public void execute(DelegateExecution execution) {
        CommandContext commandContext = CommandContextUtil.getCommandContext();
        string skipExpressionText = null;
        if (skipExpression != null) {
            skipExpressionText = skipExpression.getExpressionText();
        }
        bool isSkipExpressionEnabled = SkipExpressionUtil.isSkipExpressionEnabled(skipExpressionText,
                        execution.getCurrentActivityId(), execution, commandContext);
        
        ProcessEngineConfigurationImpl processEngineConfiguration = CommandContextUtil.getProcessEngineConfiguration(commandContext);
        if (!isSkipExpressionEnabled || !SkipExpressionUtil.shouldSkipFlowElement(skipExpressionText, 
                        execution.getCurrentActivityId(), execution, commandContext)) {
            
            try {
                if (processEngineConfiguration.isLoggingSessionEnabled()) {
                    BpmnLoggingSessionUtil.addLoggingData(LoggingSessionConstants.TYPE_SERVICE_TASK_ENTER, 
                                    "Executing service task with java class " + javaDelegate.getClass().getName(), execution);
                }
                
                processEngineConfiguration.getDelegateInterceptor().handleInvocation(new JavaDelegateInvocation(javaDelegate, execution));
                
                if (processEngineConfiguration.isLoggingSessionEnabled()) {
                    BpmnLoggingSessionUtil.addLoggingData(LoggingSessionConstants.TYPE_SERVICE_TASK_EXIT, 
                                    "Executed service task with java class " + javaDelegate.getClass().getName(), execution);
                }
                
            } catch (RuntimeException e) {
                if (processEngineConfiguration.isLoggingSessionEnabled()) {
                    BpmnLoggingSessionUtil.addErrorLoggingData(LoggingSessionConstants.TYPE_SERVICE_TASK_EXCEPTION, 
                                    "Service task with java class " + javaDelegate.getClass().getName() + " threw exception " + e.getMessage(), e, execution);
                }
                
                throw e;
            }
            
        } else {
            if (processEngineConfiguration.isLoggingSessionEnabled()) {
                BpmnLoggingSessionUtil.addLoggingData(LoggingSessionConstants.TYPE_SKIP_TASK, "Skipped service task " + execution.getCurrentActivityId() + 
                                " with skip expression " + skipExpressionText, execution);
            }
        }

        if (!triggerable) {
            leave(execution);
        }
    }

    @Override
    public void notify(DelegateExecution execution) {
        execute(execution);
    }
}
