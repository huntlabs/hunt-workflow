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
//module flow.common.el.DefaultExpressionManager;
//
//import hunt.collection.ArrayList;
//import hunt.collection.List;
//import hunt.collection.Map;
//import flow.common.el.ExpressionManager;
//import flow.common.api.deleg.Expression;
//import flow.common.api.deleg.FlowableExpressionEnhancer;
//import flow.common.api.deleg.FlowableFunctionDelegate;
//import flow.common.api.variable.VariableContainer;
////import flow.common.javax.el.ArrayELResolver;
////import flow.common.javax.el.BeanELResolver;
////import flow.common.javax.el.CompositeELResolver;
////import flow.common.javax.el.CouldNotResolvePropertyELResolver;
////import flow.common.javax.el.ELContext;
////import flow.common.javax.el.ELResolver;
////import flow.common.javax.el.ExpressionFactory;
////import flow.common.javax.el.ListELResolver;
////import flow.common.javax.el.MapELResolver;
////import flow.common.javax.el.ValueExpression;
//import flow.common.persistence.deploy.DeploymentCache;
//
///**
// * Default {@link ExpressionManager} implementation that contains the logic for creating
// * and resolving {@link Expression} instances.
// *
// * @author Tom Baeyens
// * @author Dave Syer
// * @author Frederik Heremans
// * @author Joram Barrez
// */
//class DefaultExpressionManager : ExpressionManager {
//
//    protected ExpressionFactory expressionFactory;
//    protected List<FlowableFunctionDelegate> functionDelegates;
//    protected List<FlowableExpressionEnhancer> expressionEnhancers;
//
//    protected ELContext parsingElContext;
//    protected Map<Object, Object> beans;
//
//    protected DeploymentCache<Expression> expressionCache;
//    protected int expressionTextLengthCacheLimit = -1;
//
//    public DefaultExpressionManager() {
//        this(null);
//    }
//
//    public DefaultExpressionManager(Map<Object, Object> beans) {
//        this.expressionFactory = ExpressionFactoryResolver.resolveExpressionFactory();
//        this.beans = beans;
//    }
//
//    @Override
//    public Expression createExpression(String text) {
//
//        if (isCacheEnabled(text)) {
//            Expression cachedExpression = expressionCache.get(text);
//            if (cachedExpression !is null) {
//                return cachedExpression;
//            }
//        }
//
//        if (parsingElContext is null) {
//            this.parsingElContext = new ParsingElContext(functionDelegates);
//        } else if (parsingElContext.getFunctionMapper() !is null && parsingElContext.getFunctionMapper() instanceof FlowableFunctionMapper) {
//            ((FlowableFunctionMapper) parsingElContext.getFunctionMapper()).setFunctionDelegates(functionDelegates);
//        }
//
//        String expressionText = text.trim();
//        if (expressionEnhancers !is null) {
//            for (FlowableExpressionEnhancer expressionEnhancer : expressionEnhancers) {
//                expressionText = expressionEnhancer.enhance(expressionText);
//            }
//        }
//
//        ValueExpression valueExpression = expressionFactory.createValueExpression(parsingElContext, expressionText, Object.class);
//        Expression expression = createJuelExpression(text, valueExpression);
//
//        if (isCacheEnabled(text)) {
//            expressionCache.add(text, expression);
//        }
//
//        return expression;
//    }
//
//    protected boolean isCacheEnabled(String text) {
//        return expressionCache !is null && (expressionTextLengthCacheLimit < 0 || text.length() <= expressionTextLengthCacheLimit);
//    }
//
//    protected Expression createJuelExpression(String expression, ValueExpression valueExpression) {
//        return new JuelExpression(this, valueExpression, expression);
//    }
//
//    public void setExpressionFactory(ExpressionFactory expressionFactory) {
//        this.expressionFactory = expressionFactory;
//    }
//
//    @Override
//    public ELContext getElContext(VariableContainer variableContainer) {
//        ELResolver elResolver = createElResolver(variableContainer);
//        return new FlowableElContext(elResolver, functionDelegates);
//    }
//
//    protected ELResolver createElResolver(VariableContainer variableContainer) {
//        List<ELResolver> elResolvers = new ArrayList<>();
//        elResolvers.add(createVariableElResolver(variableContainer));
//        if (beans !is null) {
//            elResolvers.add(new ReadOnlyMapELResolver(beans));
//        }
//        elResolvers.add(new ArrayELResolver());
//        elResolvers.add(new ListELResolver());
//        elResolvers.add(new MapELResolver());
//        elResolvers.add(new JsonNodeELResolver());
//        ELResolver beanElResolver = createBeanElResolver();
//        if (beanElResolver !is null) {
//            elResolvers.add(beanElResolver);
//        }
//
//        configureResolvers(elResolvers);
//
//        CompositeELResolver compositeELResolver = new CompositeELResolver();
//        for (ELResolver elResolver : elResolvers) {
//            compositeELResolver.add(elResolver);
//        }
//        compositeELResolver.add(new CouldNotResolvePropertyELResolver());
//        return compositeELResolver;
//    }
//
//    protected void configureResolvers(List<ELResolver> elResolvers) {
//        // to be extended if needed
//    }
//
//    protected ELResolver createVariableElResolver(VariableContainer variableContainer) {
//        return new VariableContainerELResolver(variableContainer);
//    }
//
//    protected ELResolver createBeanElResolver() {
//        return new BeanELResolver();
//    }
//
//    @Override
//    public Map<Object, Object> getBeans() {
//        return beans;
//    }
//
//    @Override
//    public void setBeans(Map<Object, Object> beans) {
//        this.beans = beans;
//    }
//
//    @Override
//    public List<FlowableFunctionDelegate> getFunctionDelegates() {
//        return functionDelegates;
//    }
//
//    @Override
//    public void setFunctionDelegates(List<FlowableFunctionDelegate> functionDelegates) {
//        this.functionDelegates = functionDelegates;
//    }
//
//    @Override
//    public List<FlowableExpressionEnhancer> getExpressionEnhancers() {
//        return expressionEnhancers;
//    }
//
//    @Override
//    public void setExpressionEnhancers(List<FlowableExpressionEnhancer> expressionEnhancers) {
//        this.expressionEnhancers = expressionEnhancers;
//    }
//
//    public DeploymentCache<Expression> getExpressionCache() {
//        return expressionCache;
//    }
//
//    public void setExpressionCache(DeploymentCache<Expression> expressionCache) {
//        this.expressionCache = expressionCache;
//    }
//
//    public int getExpressionTextLengthCacheLimit() {
//        return expressionTextLengthCacheLimit;
//    }
//
//    public void setExpressionTextLengthCacheLimit(int expressionTextLengthCacheLimit) {
//        this.expressionTextLengthCacheLimit = expressionTextLengthCacheLimit;
//    }
//
//}
