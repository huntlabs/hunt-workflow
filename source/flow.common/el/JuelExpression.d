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
//module flow.common.el.JuelExpression;
//
//import flow.common.api.FlowableException;
//import flow.common.api.deleg.Expression;
//import flow.common.api.variable.VariableContainer;
//import flow.common.javax.el.ELContext;
//import flow.common.javax.el.MethodNotFoundException;
//import flow.common.javax.el.PropertyNotFoundException;
//import flow.common.javax.el.ValueExpression;
//
///**
// * Expression implementation backed by a JUEL {@link ValueExpression}.
// *
// * @author Frederik Heremans
// * @author Joram Barrez
// */
//class JuelExpression : Expression {
//
//
//    protected string expressionText;
//    protected ValueExpression valueExpression;
//    protected ExpressionManager expressionManager;
//
//    this(ExpressionManager expressionManager, ValueExpression valueExpression, string expressionText) {
//        this.valueExpression = valueExpression;
//        this.expressionText = expressionText;
//        this.expressionManager = expressionManager;
//    }
//
//    public Object getValue(VariableContainer variableContainer) {
//        ELContext elContext = expressionManager.getElContext(variableContainer);
//        try {
//            return resolveGetValueExpression(elContext);
//        } catch (PropertyNotFoundException pnfe) {
//            throw new FlowableException("Unknown property used in expression: " + expressionText, pnfe);
//        } catch (MethodNotFoundException mnfe) {
//            throw new FlowableException("Unknown method used in expression: " + expressionText, mnfe);
//        } catch (FlowableException ex) {
//            throw ex;
//        } catch (Exception e) {
//            throw new FlowableException("Error while evaluating expression: " + expressionText, e);
//        }
//    }
//
//    protected Object resolveGetValueExpression(ELContext elContext) {
//        return valueExpression.getValue(elContext);
//    }
//
//    public void setValue(Object value, VariableContainer variableContainer) {
//        ELContext elContext = expressionManager.getElContext(variableContainer);
//        try {
//            resolveSetValueExpression(value, elContext);
//        } catch (Exception e) {
//            throw new FlowableException("Error while evaluating expression: " + expressionText, e);
//        }
//    }
//
//    protected void resolveSetValueExpression(Object value, ELContext elContext) {
//        valueExpression.setValue(elContext, value);
//    }
//
//    override
//    public string toString() {
//        if (valueExpression != null) {
//            return valueExpression.getExpressionString();
//        }
//        return super.toString();
//    }
//
//    public string getExpressionText() {
//        return expressionText;
//    }
//
//}
