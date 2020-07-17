///* Licensed under the Apache License, Version 2.0 (the "License");
// * you may not use this file except in compliance with the License.
// * You may obtain a copy of the License at
// *
// *      http://www.apache.org/licenses/LICENSE-2.0
// *
// * Unless required by applicable law or agreed to in writing, software
// * distributed under the License is distributed on an "AS IS" BASIS,
// * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// * See the License for the specific language governing permissions and
// * limitations under the License.
// */
//
//
//
//import flow.common.el.ExpressionManager;
//import flow.common.javax.el.ELContext;
//import flow.common.javax.el.ValueExpression;
//import flow.engine.impl.deleg.invocation.ExpressionGetInvocation;
//import flow.engine.impl.deleg.invocation.ExpressionSetInvocation;
//import flow.engine.impl.interceptor.DelegateInterceptor;
//import flow.engine.impl.util.CommandContextUtil;
//
///**
// * Expression implementation backed by a JUEL {@link ValueExpression}.
// *
// * @author Frederik Heremans
// * @author Joram Barrez
// */
//class JuelExpression : flow.common.el.JuelExpression {
//
//    private static final long serialVersionUID = 1L;
//
//    protected DelegateInterceptor delegateInterceptor;
//
//    public JuelExpression(ExpressionManager expressionManager, DelegateInterceptor delegateInterceptor, ValueExpression valueExpression, string expressionText) {
//        super(expressionManager, valueExpression, expressionText);
//        this.delegateInterceptor = delegateInterceptor;
//    }
//
//    override
//    protected Object resolveGetValueExpression(ELContext elContext) {
//        ExpressionGetInvocation invocation = new ExpressionGetInvocation(valueExpression, elContext);
//        delegateInterceptor.handleInvocation(invocation);
//        return invocation.getInvocationResult();
//    }
//
//    override
//    protected void resolveSetValueExpression(Object value, ELContext elContext) {
//        ExpressionSetInvocation invocation = new ExpressionSetInvocation(valueExpression, elContext, value);
//        CommandContextUtil.getProcessEngineConfiguration().getDelegateInterceptor().handleInvocation(invocation);
//    }
//
//}