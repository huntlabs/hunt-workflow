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
module flow.engine.impl.bpmn.behavior.ServiceTaskDelegateExpressionActivityBehavior;

import hunt.collection.List;

import flow.bpmn.model.MapExceptionEntry;
import flow.common.api.FlowableException;
import flow.common.api.FlowableIllegalArgumentException;
import flow.common.api.deleg.Expression;
import flow.common.interceptor.CommandContext;
import flow.engine.DynamicBpmnConstants;
import flow.engine.deleg.BpmnError;
import flow.engine.deleg.DelegateExecution;
import flow.engine.deleg.JavaDelegate;
import flow.engine.impl.bpmn.helper.DelegateExpressionUtil;
//import flow.engine.impl.bpmn.helper.ErrorPropagation;
import flow.engine.impl.bpmn.helper.SkipExpressionUtil;
import flow.engine.impl.bpmn.parser.FieldDeclaration;
//import flow.engine.impl.context.BpmnOverrideContext;
import flow.engine.impl.deleg.ActivityBehavior;
import flow.engine.impl.deleg.ActivityBehaviorInvocation;
import flow.engine.impl.deleg.TriggerableActivityBehavior;
import flow.engine.impl.deleg.invocation.JavaDelegateInvocation;
import flow.engine.impl.persistence.entity.ExecutionEntity;
import flow.engine.impl.util.CommandContextUtil;
import  flow.engine.impl.bpmn.behavior.AbstractBpmnActivityBehavior;
import flow.engine.impl.bpmn.behavior.TaskActivityBehavior;
import hunt.logging;

//import com.fasterxml.jackson.databind.node.ObjectNode;

/**
 * {@link ActivityBehavior} used when 'delegateExpression' is used for a serviceTask.
 *
 * @author Joram Barrez
 * @author Josh Long
 * @author Slawomir Wojtasiak (Patch for ACT-1159)
 * @author Falko Menge
 */
class ServiceTaskDelegateExpressionActivityBehavior : TaskActivityBehavior {

    protected string serviceTaskId;
    protected Expression expression;
    protected Expression skipExpression;
    protected List!FieldDeclaration fieldDeclarations;
    protected List!MapExceptionEntry mapExceptions;
    protected bool triggerable;

    this(string serviceTaskId, Expression expression, Expression skipExpression,
            List!FieldDeclaration fieldDeclarations, List!MapExceptionEntry mapExceptions, bool triggerable) {
        this.serviceTaskId = serviceTaskId;
        this.expression = expression;
        this.skipExpression = skipExpression;
        this.fieldDeclarations = fieldDeclarations;
        this.mapExceptions = mapExceptions;
        this.triggerable = triggerable;
    }

    override
    public void trigger(DelegateExecution execution, string signalName, Object signalData) {
        Object deleg = DelegateExpressionUtil.resolveDelegateExpression(expression, execution, fieldDeclarations);
        if (triggerable && cast(TriggerableActivityBehavior)deleg !is null) {
            (cast(TriggerableActivityBehavior) deleg).trigger(execution, signalName, signalData);
        }
        leave(execution);
    }

    override
    public void execute(DelegateExecution execution) {

        try {
            CommandContext commandContext = CommandContextUtil.getCommandContext();
            string skipExpressionText = null;
            if (skipExpression !is null) {
                skipExpressionText = skipExpression.getExpressionText();
            }
            bool isSkipExpressionEnabled = SkipExpressionUtil.isSkipExpressionEnabled(skipExpressionText, serviceTaskId, execution, commandContext);
            if (!isSkipExpressionEnabled || !SkipExpressionUtil.shouldSkipFlowElement(skipExpressionText, serviceTaskId, execution, commandContext)) {

                //if (CommandContextUtil.getProcessEngineConfiguration(commandContext).isEnableProcessDefinitionInfoCache()) {
                //    ObjectNode taskElementProperties = BpmnOverrideContext.getBpmnOverrideElementProperties(serviceTaskId, execution.getProcessDefinitionId());
                //    if (taskElementProperties !is null && taskElementProperties.has(DynamicBpmnConstants.SERVICE_TASK_DELEGATE_EXPRESSION)) {
                //        string overrideExpression = taskElementProperties.get(DynamicBpmnConstants.SERVICE_TASK_DELEGATE_EXPRESSION).asText();
                //        if (StringUtils.isNotEmpty(overrideExpression) && !overrideExpression.equals(expression.getExpressionText())) {
                //            expression = CommandContextUtil.getProcessEngineConfiguration(commandContext).getExpressionManager().createExpression(overrideExpression);
                //        }
                //    }
                //}

                Object deleg = DelegateExpressionUtil.resolveDelegateExpression(expression, execution, fieldDeclarations);
                if (cast(ActivityBehavior)deleg  !is null) {

                    if (cast(AbstractBpmnActivityBehavior)deleg !is null) {
                        (cast(AbstractBpmnActivityBehavior) deleg).setMultiInstanceActivityBehavior(getMultiInstanceActivityBehavior());
                    }

                    CommandContextUtil.getProcessEngineConfiguration(commandContext).getDelegateInterceptor().handleInvocation(new ActivityBehaviorInvocation(cast(ActivityBehavior) deleg, execution));

                } else if (cast(JavaDelegate)deleg !is null) {
                    CommandContextUtil.getProcessEngineConfiguration(commandContext).getDelegateInterceptor().handleInvocation(new JavaDelegateInvocation(cast(JavaDelegate) deleg, execution));

                    if (!triggerable) {
                        leave(execution);
                    }
                } else {
                    throw new FlowableIllegalArgumentException("Delegate expression " ~ " did neither resolve to an implementation of " ~ typeid(ActivityBehavior).toString ~ " nor " ~ typeid(JavaDelegate).toString);
                }

            } else {
                leave(execution);
            }
        } catch (Exception exc) {
            logError("Error");
            //Throwable cause = exc;
            //BpmnError error = null;
            //while (cause !is null) {
            //    if (cause instanceof BpmnError) {
            //        error = (BpmnError) cause;
            //        break;
            //
            //    } else if (cause instanceof RuntimeException) {
            //        if (ErrorPropagation.mapException((RuntimeException) cause, (ExecutionEntity) execution, mapExceptions)) {
            //            return;
            //        }
            //    }
            //    cause = cause.getCause();
            //}
            //
            //if (error !is null) {
            //    ErrorPropagation.propagateError(error, execution);
            //} else if (exc instanceof FlowableException) {
            //    throw exc;
            //} else {
            //    throw new FlowableException(exc.getMessage(), exc);
            //}

        }
    }
}
