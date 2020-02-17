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


import java.util.List;

import flow.common.api.FlowableIllegalArgumentException;
import flow.common.api.delegate.Expression;
import flow.engine.delegate.DelegateExecution;
import flow.engine.delegate.ExecutionListener;
import flow.engine.delegate.JavaDelegate;
import flow.engine.impl.bpmn.helper.DelegateExpressionUtil;
import flow.engine.impl.bpmn.parser.FieldDeclaration;
import flow.engine.impl.delegate.invocation.ExecutionListenerInvocation;
import flow.engine.impl.delegate.invocation.JavaDelegateInvocation;
import flow.engine.impl.util.CommandContextUtil;

/**
 * @author Joram Barrez
 */
class DelegateExpressionExecutionListener implements ExecutionListener {

    protected Expression expression;
    private final List<FieldDeclaration> fieldDeclarations;

    public DelegateExpressionExecutionListener(Expression expression, List<FieldDeclaration> fieldDeclarations) {
        this.expression = expression;
        this.fieldDeclarations = fieldDeclarations;
    }

    @Override
    public void notify(DelegateExecution execution) {
        Object delegate = DelegateExpressionUtil.resolveDelegateExpression(expression, execution, fieldDeclarations);
        if (delegate instanceof ExecutionListener) {
            CommandContextUtil.getProcessEngineConfiguration().getDelegateInterceptor().handleInvocation(new ExecutionListenerInvocation((ExecutionListener) delegate, execution));
        } else if (delegate instanceof JavaDelegate) {
            CommandContextUtil.getProcessEngineConfiguration().getDelegateInterceptor().handleInvocation(new JavaDelegateInvocation((JavaDelegate) delegate, execution));
        } else {
            throw new FlowableIllegalArgumentException("Delegate expression " + expression + " did not resolve to an implementation of " + ExecutionListener.class + " nor " + JavaDelegate.class);
        }
    }

    /**
     * returns the expression text for this execution listener. Comes in handy if you want to check which listeners you already have.
     */
    public string getExpressionText() {
        return expression.getExpressionText();
    }

}
