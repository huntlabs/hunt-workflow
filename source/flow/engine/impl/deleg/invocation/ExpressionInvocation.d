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
//module flow.engine.impl.deleg.invocation.ExpressionInvocation;
//
//import flow.common.javax.el.ValueExpression;
//import flow.engine.impl.deleg.invocation.DelegateInvocation;
///**
// * Baseclass responsible for handling invocations of Expressions
// *
// * @author Daniel Meyer
// */
//abstract class ExpressionInvocation : DelegateInvocation {
//
//    protected ValueExpression valueExpression;
//
//    this(ValueExpression valueExpression) {
//        this.valueExpression = valueExpression;
//    }
//
//    override
//    public Object getTarget() {
//        return valueExpression;
//    }
//
//}
