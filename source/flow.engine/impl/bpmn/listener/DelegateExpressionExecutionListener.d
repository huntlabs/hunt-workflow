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
module flow.engine.impl.bpmn.listener.DelegateExpressionExecutionListener;

import hunt.collection.List;

import flow.common.api.FlowableIllegalArgumentException;
import flow.common.api.deleg.Expression;
import flow.engine.deleg.DelegateExecution;
import flow.engine.deleg.ExecutionListener;
import flow.engine.deleg.JavaDelegate;
import flow.engine.impl.bpmn.helper.DelegateExpressionUtil;
import flow.engine.impl.bpmn.parser.FieldDeclaration;
import flow.engine.impl.deleg.invocation.ExecutionListenerInvocation;
import flow.engine.impl.deleg.invocation.JavaDelegateInvocation;
import flow.engine.impl.util.CommandContextUtil;

/**
 * @author Joram Barrez
 */
class DelegateExpressionExecutionListener : ExecutionListener {

    protected Expression expression;
    private List!FieldDeclaration fieldDeclarations;

    this(Expression expression, List!FieldDeclaration fieldDeclarations) {
        this.expression = expression;
        this.fieldDeclarations = fieldDeclarations;
    }

    public void notify(DelegateExecution execution) {
        Object deleg = DelegateExpressionUtil.resolveDelegateExpression(expression, execution, fieldDeclarations);
        if (cast(ExecutionListener)deleg !is null) {
            CommandContextUtil.getProcessEngineConfiguration().getDelegateInterceptor().handleInvocation(new ExecutionListenerInvocation(cast(ExecutionListener) deleg, execution));
        } else if (cast(JavaDelegate)deleg !is null) {
            CommandContextUtil.getProcessEngineConfiguration().getDelegateInterceptor().handleInvocation(new JavaDelegateInvocation(cast(JavaDelegate) deleg, execution));
        } else {
            throw new FlowableIllegalArgumentException("Delegate expression " ~ " did not resolve to an implementation of " + typeid(ExecutionListener).toString ~ " nor " ~ typeid(JavaDelegate).toString);
        }
    }

    /**
     * returns the expression text for this execution listener. Comes in handy if you want to check which listeners you already have.
     */
    public string getExpressionText() {
        return expression.getExpressionText();
    }

}
