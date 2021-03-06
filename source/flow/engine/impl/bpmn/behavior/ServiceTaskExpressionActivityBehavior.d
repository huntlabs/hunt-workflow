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

module flow.engine.impl.bpmn.behavior.ServiceTaskExpressionActivityBehavior;

import hunt.collection.List;

import flow.bpmn.model.MapExceptionEntry;
import flow.bpmn.model.ServiceTask;
import flow.common.api.deleg.Expression;
import flow.common.interceptor.CommandContext;
import flow.engine.DynamicBpmnConstants;
import flow.engine.deleg.BpmnError;
import flow.engine.deleg.DelegateExecution;
//import flow.engine.impl.bpmn.helper.ErrorPropagation;
import flow.engine.impl.bpmn.helper.SkipExpressionUtil;
//import flow.engine.impl.context.BpmnOverrideContext;
import flow.engine.impl.persistence.entity.ExecutionEntity;
import flow.engine.impl.util.CommandContextUtil;
import flow.engine.impl.bpmn.behavior.TaskActivityBehavior;
import hunt.Exceptions;

//import com.fasterxml.jackson.databind.node.ObjectNode;

/**
 * ActivityBehavior that evaluates an expression when executed. Optionally, it sets the result of the expression as a variable on the execution.
 *
 * @author Tom Baeyens
 * @author Christian Stettler
 * @author Frederik Heremans
 * @author Slawomir Wojtasiak (Patch for ACT-1159)
 * @author Falko Menge
 * @author Filip Hrisafov
 */
class ServiceTaskExpressionActivityBehavior : TaskActivityBehavior {

    protected string serviceTaskId;
    protected Expression expression;
    protected Expression skipExpression;
    protected string resultVariable;
    protected List!MapExceptionEntry mapExceptions;
    protected bool useLocalScopeForResultVariable;

    this(ServiceTask serviceTask, Expression expression, Expression skipExpression) {

        this.serviceTaskId = serviceTask.getId();
        this.expression = expression;
        this.skipExpression = skipExpression;
        this.resultVariable = serviceTask.getResultVariableName();
        this.mapExceptions = serviceTask.getMapExceptions();
        this.useLocalScopeForResultVariable = serviceTask.isUseLocalScopeForResultVariable();
    }

    override
    public void execute(DelegateExecution execution) {
        implementationMissing(false);
        //Object value = null;
        //try {
        //    CommandContext commandContext = CommandContextUtil.getCommandContext();
        //    string skipExpressionText = null;
        //    if (skipExpression !is null) {
        //        skipExpressionText = skipExpression.getExpressionText();
        //    }
        //    bool isSkipExpressionEnabled = SkipExpressionUtil.isSkipExpressionEnabled(skipExpressionText, serviceTaskId, execution, commandContext);
        //    if (!isSkipExpressionEnabled || !SkipExpressionUtil.shouldSkipFlowElement(skipExpressionText, serviceTaskId, execution, commandContext)) {
        //
        //        if (CommandContextUtil.getProcessEngineConfiguration(commandContext).isEnableProcessDefinitionInfoCache()) {
        //            ObjectNode taskElementProperties = BpmnOverrideContext.getBpmnOverrideElementProperties(serviceTaskId, execution.getProcessDefinitionId());
        //            if (taskElementProperties !is null && taskElementProperties.has(DynamicBpmnConstants.SERVICE_TASK_EXPRESSION)) {
        //                string overrideExpression = taskElementProperties.get(DynamicBpmnConstants.SERVICE_TASK_EXPRESSION).asText();
        //                if (StringUtils.isNotEmpty(overrideExpression) && !overrideExpression.equals(expression.getExpressionText())) {
        //                    expression = CommandContextUtil.getProcessEngineConfiguration(commandContext).getExpressionManager().createExpression(overrideExpression);
        //                }
        //            }
        //        }
        //
        //        value = expression.getValue(execution);
        //        if (resultVariable !is null) {
        //            if (useLocalScopeForResultVariable) {
        //                execution.setVariableLocal(resultVariable, value);
        //            } else {
        //                execution.setVariable(resultVariable, value);
        //            }
        //        }
        //    }
        //
        //    leave(execution);
        //
        //} catch (Exception exc) {
        //
        //    Throwable cause = exc;
        //    BpmnError error = null;
        //    while (cause !is null) {
        //        if (cause instanceof BpmnError) {
        //            error = (BpmnError) cause;
        //            break;
        //        } else if (cause instanceof RuntimeException) {
        //            if (ErrorPropagation.mapException((RuntimeException) cause, (ExecutionEntity) execution, mapExceptions)) {
        //                return;
        //            }
        //        }
        //        cause = cause.getCause();
        //    }
        //
        //    if (error !is null) {
        //        ErrorPropagation.propagateError(error, execution);
        //    } else {
        //        throw exc;
        //    }
        //}
    }
}
