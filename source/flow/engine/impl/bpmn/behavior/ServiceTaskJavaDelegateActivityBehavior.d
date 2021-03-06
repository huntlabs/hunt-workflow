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

module flow.engine.impl.bpmn.behavior.ServiceTaskJavaDelegateActivityBehavior;

import flow.common.api.deleg.Expression;
import flow.common.interceptor.CommandContext;
//import flow.common.logging.LoggingSessionConstants;
import flow.engine.deleg.DelegateExecution;
import flow.engine.deleg.ExecutionListener;
import flow.engine.deleg.JavaDelegate;
import flow.engine.impl.bpmn.helper.SkipExpressionUtil;
import flow.engine.impl.cfg.ProcessEngineConfigurationImpl;
import flow.engine.impl.deleg.ActivityBehavior;
import flow.engine.impl.deleg.TriggerableActivityBehavior;
import flow.engine.impl.deleg.invocation.JavaDelegateInvocation;
//import flow.engine.impl.util.BpmnLoggingSessionUtil;
import flow.engine.impl.util.CommandContextUtil;
import flow.engine.impl.bpmn.behavior.TaskActivityBehavior;
/**
 * @author Tom Baeyens
 */
class ServiceTaskJavaDelegateActivityBehavior : TaskActivityBehavior , ActivityBehavior, ExecutionListener {

    protected JavaDelegate javaDelegate;
    protected Expression skipExpression;
    protected bool triggerable;

    this() {
    }

    this(JavaDelegate javaDelegate, bool triggerable, Expression skipExpression) {
        this.javaDelegate = javaDelegate;
        this.triggerable = triggerable;
        this.skipExpression = skipExpression;
    }

    override
    public void trigger(DelegateExecution execution, string signalName, Object signalData) {
        CommandContext commandContext = CommandContextUtil.getCommandContext();
        ProcessEngineConfigurationImpl processEngineConfiguration = CommandContextUtil.getProcessEngineConfiguration(commandContext);

        if (triggerable && cast(TriggerableActivityBehavior)javaDelegate !is null) {
            //if (processEngineConfiguration.isLoggingSessionEnabled()) {
            //    BpmnLoggingSessionUtil.addLoggingData(LoggingSessionConstants.TYPE_SERVICE_TASK_BEFORE_TRIGGER,
            //                    "Triggering service task with java class " + javaDelegate.getClass().getName(), execution);
            //}

            (cast(TriggerableActivityBehavior) javaDelegate).trigger(execution, signalName, signalData);

            //if (processEngineConfiguration.isLoggingSessionEnabled()) {
            //    BpmnLoggingSessionUtil.addLoggingData(LoggingSessionConstants.TYPE_SERVICE_TASK_BEFORE_TRIGGER,
            //                    "Triggered service task with java class " + javaDelegate.getClass().getName(), execution);
            //}

            leave(execution);

        } else {
            //if (processEngineConfiguration.isLoggingSessionEnabled()) {
            //    if (!triggerable) {
            //        BpmnLoggingSessionUtil.addLoggingData(LoggingSessionConstants.TYPE_SERVICE_TASK_WRONG_TRIGGER,
            //                        "Service task with java class triggered but not triggerable " + javaDelegate.getClass().getName(), execution);
            //    } else {
            //        BpmnLoggingSessionUtil.addLoggingData(LoggingSessionConstants.TYPE_SERVICE_TASK_WRONG_TRIGGER,
            //                        "Service task with java class triggered but not implementing TriggerableActivityBehavior " + javaDelegate.getClass().getName(), execution);
            //    }
            //}
        }
    }

    override
    public void execute(DelegateExecution execution) {
        CommandContext commandContext = CommandContextUtil.getCommandContext();
        string skipExpressionText = null;
        if (skipExpression !is null) {
            skipExpressionText = skipExpression.getExpressionText();
        }
        bool isSkipExpressionEnabled = SkipExpressionUtil.isSkipExpressionEnabled(skipExpressionText,
                        execution.getCurrentActivityId(), execution, commandContext);

        ProcessEngineConfigurationImpl processEngineConfiguration = CommandContextUtil.getProcessEngineConfiguration(commandContext);
        if (!isSkipExpressionEnabled || !SkipExpressionUtil.shouldSkipFlowElement(skipExpressionText,
                        execution.getCurrentActivityId(), execution, commandContext)) {

            try {
                //if (processEngineConfiguration.isLoggingSessionEnabled()) {
                //    BpmnLoggingSessionUtil.addLoggingData(LoggingSessionConstants.TYPE_SERVICE_TASK_ENTER,
                //                    "Executing service task with java class " + javaDelegate.getClass().getName(), execution);
                //}

                processEngineConfiguration.getDelegateInterceptor().handleInvocation(new JavaDelegateInvocation(javaDelegate, execution));

                //if (processEngineConfiguration.isLoggingSessionEnabled()) {
                //    BpmnLoggingSessionUtil.addLoggingData(LoggingSessionConstants.TYPE_SERVICE_TASK_EXIT,
                //                    "Executed service task with java class " + javaDelegate.getClass().getName(), execution);
                //}

            } catch (Exception e) {
                //if (processEngineConfiguration.isLoggingSessionEnabled()) {
                //    BpmnLoggingSessionUtil.addErrorLoggingData(LoggingSessionConstants.TYPE_SERVICE_TASK_EXCEPTION,
                //                    "Service task with java class " + javaDelegate.getClass().getName() + " threw exception " + e.getMessage(), e, execution);
                //}
                //
                //throw e;
            }

        } else {
            //if (processEngineConfiguration.isLoggingSessionEnabled()) {
            //    BpmnLoggingSessionUtil.addLoggingData(LoggingSessionConstants.TYPE_SKIP_TASK, "Skipped service task " + execution.getCurrentActivityId() +
            //                    " with skip expression " + skipExpressionText, execution);
            //}
        }

        if (!triggerable) {
            leave(execution);
        }
    }

    override
    public void notify(DelegateExecution execution) {
        execute(execution);
    }
}
