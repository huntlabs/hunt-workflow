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
module flow.engine.impl.bpmn.listener.DelegateExpressionTaskListener;

import hunt.collection.List;

import flow.common.api.FlowableException;
import flow.common.api.FlowableIllegalArgumentException;
import flow.common.api.deleg.Expression;
import flow.engine.impl.bpmn.helper.DelegateExpressionUtil;
import flow.engine.impl.bpmn.parser.FieldDeclaration;
import flow.engine.impl.deleg.invocation.TaskListenerInvocation;
import flow.engine.impl.util.CommandContextUtil;
import flow.task.service.deleg.DelegateTask;
import flow.task.service.deleg.TaskListener;

/**
 * @author Joram Barrez
 */
class DelegateExpressionTaskListener : TaskListener {

    protected Expression expression;
    private  List!FieldDeclaration fieldDeclarations;

    this(Expression expression, List!FieldDeclaration fieldDeclarations) {
        this.expression = expression;
        this.fieldDeclarations = fieldDeclarations;
    }

    public void notify(DelegateTask delegateTask) {
        Object deleg = DelegateExpressionUtil.resolveDelegateExpression(expression, delegateTask, fieldDeclarations);
        if (cast(TaskListener)deleg !is null) {
            try {
                CommandContextUtil.getProcessEngineConfiguration().getDelegateInterceptor().handleInvocation(new TaskListenerInvocation(cast(TaskListener) deleg, delegateTask));
            } catch (Exception e) {
                throw new FlowableException("Exception while invoking TaskListener: ");
            }
        } else {
            throw new FlowableIllegalArgumentException("Delegate expression " ~ " did not resolve to an implementation of " ~ typeid(TaskListener).toString);
        }
    }

    /**
     * returns the expression text for this task listener. Comes in handy if you want to check which listeners you already have.
     */
    public string getExpressionText() {
        return expression.getExpressionText();
    }

}
