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
//module flow.engine.impl.el.ProcessExpressionManager;
//
//import hunt.collection.List;
//import hunt.collection.Map;
//
//import flow.common.api.deleg.Expression;
//import flow.common.api.variable.VariableContainer;
//import flow.common.el.DynamicBeanPropertyELResolver;
//import flow.common.javax.el.BeanELResolver;
//import flow.common.javax.el.ELResolver;
//import flow.common.javax.el.ValueExpression;
//import flow.engine.impl.bpmn.data.ItemInstance;
//import flow.engine.impl.deleg.invocation.DefaultDelegateInterceptor;
//import flow.engine.impl.interceptor.DelegateInterceptor;
//import flow.variable.service.impl.el.VariableScopeExpressionManager;
//
///**
// * @author Joram Barrez
// */
//class ProcessExpressionManager : VariableScopeExpressionManager {
//
//    protected DelegateInterceptor delegateInterceptor;
//
//    public ProcessExpressionManager() {
//        this(null);
//    }
//
//    public ProcessExpressionManager(Map!(Object, Object) beans) {
//       this(new DefaultDelegateInterceptor(), beans);
//    }
//
//    public ProcessExpressionManager(DelegateInterceptor delegateInterceptor, Map!(Object, Object) beans) {
//        super(beans);
//        this.delegateInterceptor = delegateInterceptor;
//    }
//
//    override
//    protected Expression createJuelExpression(string expression, ValueExpression valueExpression) {
//        return new JuelExpression(this, this.delegateInterceptor, valueExpression, expression);
//    }
//
//    override
//    protected ELResolver createVariableElResolver(VariableContainer variableContainer) {
//        return new ProcessVariableScopeELResolver(variableContainer);
//    }
//
//    override
//    protected void configureResolvers(List!ELResolver elResolvers) {
//        int beanElResolverIndex = -1;
//        for (int i=0; i<elResolvers.size(); i++) {
//            if (elResolvers.get(i) instanceof BeanELResolver) {
//                beanElResolverIndex = i;
//            }
//        }
//
//        if (beanElResolverIndex > 0) {
//            elResolvers.add(beanElResolverIndex, new DynamicBeanPropertyELResolver(ItemInstance.class, "getFieldValue", "setFieldValue"));
//        }
//    }
//
//}
