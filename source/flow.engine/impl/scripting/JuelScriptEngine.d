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
//import java.io.IOException;
//import java.io.Reader;
//import java.lang.reflect.Method;
//import java.lang.reflect.Modifier;
//
//import javax.script.AbstractScriptEngine;
//import javax.script.Bindings;
//import javax.script.Compilable;
//import javax.script.CompiledScript;
//import javax.script.ScriptContext;
//import javax.script.ScriptEngine;
//import javax.script.ScriptEngineFactory;
//import javax.script.ScriptException;
//import javax.script.SimpleBindings;
//
//import flow.common.api.FlowableException;
//import flow.common.de.odysseus.el.util.SimpleResolver;
//import flow.common.el.DynamicBeanPropertyELResolver;
//import flow.common.el.ExpressionFactoryResolver;
//import flow.common.el.JsonNodeELResolver;
//import flow.common.javax.el.ArrayELResolver;
//import flow.common.javax.el.BeanELResolver;
//import flow.common.javax.el.CompositeELResolver;
//import flow.common.javax.el.CouldNotResolvePropertyELResolver;
//import flow.common.javax.el.ELContext;
//import flow.common.javax.el.ELException;
//import flow.common.javax.el.ELResolver;
//import flow.common.javax.el.ExpressionFactory;
//import flow.common.javax.el.FunctionMapper;
//import flow.common.javax.el.ListELResolver;
//import flow.common.javax.el.MapELResolver;
//import flow.common.javax.el.ResourceBundleELResolver;
//import flow.common.javax.el.ValueExpression;
//import flow.common.javax.el.VariableMapper;
//import flow.common.util.ReflectUtil;
//import flow.engine.impl.bpmn.data.ItemInstance;
//
///**
// * ScriptEngine that used JUEL for script evaluation and compilation (JSR-223).
// *
// * Uses EL 1.1 if available, to resolve expressions. Otherwise it reverts to EL 1.0, using {@link ExpressionFactoryResolver}.
// *
// * @author Frederik Heremans
// */
//class JuelScriptEngine : AbstractScriptEngine implements Compilable {
//
//    private ScriptEngineFactory scriptEngineFactory;
//    private ExpressionFactory expressionFactory;
//
//    public JuelScriptEngine(ScriptEngineFactory scriptEngineFactory) {
//        this.scriptEngineFactory = scriptEngineFactory;
//        // Resolve the ExpressionFactory
//        expressionFactory = ExpressionFactoryResolver.resolveExpressionFactory();
//    }
//
//    public JuelScriptEngine() {
//        this(null);
//    }
//
//    override
//    public CompiledScript compile(string script) throws ScriptException {
//        ValueExpression expr = parse(script, context);
//        return new JuelCompiledScript(expr);
//    }
//
//    override
//    public CompiledScript compile(Reader reader) throws ScriptException {
//        // Create a string based on the reader and compile it
//        return compile(readFully(reader));
//    }
//
//    override
//    public Object eval(string script, ScriptContext scriptContext) throws ScriptException {
//        ValueExpression expr = parse(script, scriptContext);
//        return evaluateExpression(expr, scriptContext);
//    }
//
//    override
//    public Object eval(Reader reader, ScriptContext scriptContext) throws ScriptException {
//        return eval(readFully(reader), scriptContext);
//    }
//
//    override
//    public ScriptEngineFactory getFactory() {
//        synchronized (this) {
//            if (scriptEngineFactory is null) {
//                scriptEngineFactory = new JuelScriptEngineFactory();
//            }
//        }
//        return scriptEngineFactory;
//    }
//
//    override
//    public Bindings createBindings() {
//        return new SimpleBindings();
//    }
//
//    private Object evaluateExpression(ValueExpression expr, ScriptContext ctx) throws ScriptException {
//        try {
//            return expr.getValue(createElContext(ctx));
//        } catch (ELException elexp) {
//            throw new ScriptException(elexp);
//        }
//    }
//
//    private ELResolver createElResolver() {
//        CompositeELResolver compositeResolver = new CompositeELResolver();
//        compositeResolver.add(new ArrayELResolver());
//        compositeResolver.add(new ListELResolver());
//        compositeResolver.add(new MapELResolver());
//        compositeResolver.add(new JsonNodeELResolver());
//        compositeResolver.add(new ResourceBundleELResolver());
//        compositeResolver.add(new DynamicBeanPropertyELResolver(ItemInstance.class, "getFieldValue", "setFieldValue"));
//        compositeResolver.add(new BeanELResolver());
//        compositeResolver.add(new CouldNotResolvePropertyELResolver());
//        return new SimpleResolver(compositeResolver);
//    }
//
//    private string readFully(Reader reader) throws ScriptException {
//        char[] array = new char[8192];
//        StringBuilder strBuffer = new StringBuilder();
//        int count;
//        try {
//            while ((count = reader.read(array, 0, array.length)) > 0) {
//                strBuffer.append(array, 0, count);
//            }
//        } catch (IOException exp) {
//            throw new ScriptException(exp);
//        }
//        return strBuffer.toString();
//    }
//
//    private ValueExpression parse(string script, ScriptContext scriptContext) throws ScriptException {
//        try {
//            return expressionFactory.createValueExpression(createElContext(scriptContext), script, Object.class);
//        } catch (ELException ele) {
//            throw new ScriptException(ele);
//        }
//    }
//
//    private ELContext createElContext(final ScriptContext scriptCtx) {
//        // Check if the ELContext is already stored on the ScriptContext
//        Object existingELCtx = scriptCtx.getAttribute("elcontext");
//        if (existingELCtx instanceof ELContext) {
//            return (ELContext) existingELCtx;
//        }
//
//        scriptCtx.setAttribute("context", scriptCtx, ScriptContext.ENGINE_SCOPE);
//
//        // Built-in function are added to ScriptCtx
//        scriptCtx.setAttribute("out:print", getPrintMethod(), ScriptContext.ENGINE_SCOPE);
//
//        SecurityManager securityManager = System.getSecurityManager();
//        if (securityManager is null) {
//            scriptCtx.setAttribute("lang:import", getImportMethod(), ScriptContext.ENGINE_SCOPE);
//        }
//
//        ELContext elContext = new ELContext() {
//
//            ELResolver resolver = createElResolver();
//            VariableMapper varMapper = new ScriptContextVariableMapper(scriptCtx);
//            FunctionMapper funcMapper = new ScriptContextFunctionMapper(scriptCtx);
//
//            override
//            public ELResolver getELResolver() {
//                return resolver;
//            }
//
//            override
//            public VariableMapper getVariableMapper() {
//                return varMapper;
//            }
//
//            override
//            public FunctionMapper getFunctionMapper() {
//                return funcMapper;
//            }
//        };
//        // Store the elcontext in the scriptContext to be able to reuse
//        scriptCtx.setAttribute("elcontext", elContext, ScriptContext.ENGINE_SCOPE);
//        return elContext;
//    }
//
//    private static Method getPrintMethod() {
//        try {
//            return JuelScriptEngine.class.getMethod("print", new Class[] { Object.class });
//        } catch (Exception exp) {
//            // Will never occur
//            return null;
//        }
//    }
//
//    public static void print(Object object) {
//        System.out.print(object);
//    }
//
//    private static Method getImportMethod() {
//        try {
//            return JuelScriptEngine.class.getMethod("importFunctions", new Class[] { ScriptContext.class, string.class, Object.class });
//        } catch (Exception exp) {
//            // Will never occur
//            return null;
//        }
//    }
//
//    public static void importFunctions(ScriptContext ctx, string namespace, Object obj) {
//        Class<?> clazz = null;
//        if (obj instanceof Class) {
//            clazz = (Class<?>) obj;
//        } else if (obj instanceof string) {
//            try {
//                clazz = ReflectUtil.loadClass((string) obj);
//            } catch (FlowableException ae) {
//                throw new ELException(ae);
//            }
//        } else {
//            throw new ELException("Class or class name is missing");
//        }
//        Method[] methods = clazz.getMethods();
//        for (Method m : methods) {
//            int mod = m.getModifiers();
//            if (Modifier.isStatic(mod) && Modifier.isPublic(mod)) {
//                string name = namespace + ":" + m.getName();
//                ctx.setAttribute(name, m, ScriptContext.ENGINE_SCOPE);
//            }
//        }
//    }
//
//    /**
//     * Class representing a compiled script using JUEL.
//     *
//     * @author Frederik Heremans
//     */
//    private class JuelCompiledScript : CompiledScript {
//
//        private ValueExpression valueExpression;
//
//        JuelCompiledScript(ValueExpression valueExpression) {
//            this.valueExpression = valueExpression;
//        }
//
//        override
//        public ScriptEngine getEngine() {
//            // Return outer class instance
//            return JuelScriptEngine.this;
//        }
//
//        override
//        public Object eval(ScriptContext ctx) throws ScriptException {
//            return evaluateExpression(valueExpression, ctx);
//        }
//    }
//
//    /**
//     * ValueMapper that uses the ScriptContext to get variable values or value expressions.
//     *
//     * @author Frederik Heremans
//     */
//    private class ScriptContextVariableMapper : VariableMapper {
//
//        private ScriptContext scriptContext;
//
//        ScriptContextVariableMapper(ScriptContext scriptCtx) {
//            this.scriptContext = scriptCtx;
//        }
//
//        override
//        public ValueExpression resolveVariable(string variableName) {
//            int scope = scriptContext.getAttributesScope(variableName);
//            if (scope != -1) {
//                Object value = scriptContext.getAttribute(variableName, scope);
//                if (value instanceof ValueExpression) {
//                    // Just return the existing ValueExpression
//                    return (ValueExpression) value;
//                } else {
//                    // Create a new ValueExpression based on the variable value
//                    return expressionFactory.createValueExpression(value, Object.class);
//                }
//            }
//            return null;
//        }
//
//        override
//        public ValueExpression setVariable(string name, ValueExpression value) {
//            ValueExpression previousValue = resolveVariable(name);
//            scriptContext.setAttribute(name, value, ScriptContext.ENGINE_SCOPE);
//            return previousValue;
//        }
//    }
//
//    /**
//     * FunctionMapper that uses the ScriptContext to resolve functions in EL.
//     *
//     * @author Frederik Heremans
//     */
//    private static class ScriptContextFunctionMapper : FunctionMapper {
//
//        private ScriptContext scriptContext;
//
//        ScriptContextFunctionMapper(ScriptContext ctx) {
//            this.scriptContext = ctx;
//        }
//
//        private string getFullFunctionName(string prefix, string localName) {
//            return prefix + ":" + localName;
//        }
//
//        override
//        public Method resolveFunction(string prefix, string localName) {
//            string functionName = getFullFunctionName(prefix, localName);
//            int scope = scriptContext.getAttributesScope(functionName);
//            if (scope != -1) {
//                // Methods are added as variables in the ScriptScope
//                Object attributeValue = scriptContext.getAttribute(functionName);
//                return (attributeValue instanceof Method) ? (Method) attributeValue : null;
//            } else {
//                return null;
//            }
//        }
//    }
//
//}
