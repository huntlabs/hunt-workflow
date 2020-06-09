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
module flow.engine.impl.bpmn.helper.DefaultClassDelegateFactory;

import hunt.collection.List;

import flow.bpmn.model.MapExceptionEntry;
import flow.common.api.deleg.Expression;
import flow.engine.impl.bpmn.parser.FieldDeclaration;
import flow.engine.impl.bpmn.helper.ClassDelegateFactory;
import flow.engine.impl.bpmn.helper.ClassDelegate;

class DefaultClassDelegateFactory : ClassDelegateFactory {
    public ClassDelegate create(string id, string className, List!FieldDeclaration fieldDeclarations,
            bool triggerable, Expression skipExpression, List!MapExceptionEntry mapExceptions) {
        return new ClassDelegate(id, className, fieldDeclarations, triggerable, skipExpression, mapExceptions);
    }

    public ClassDelegate create(string className, List!FieldDeclaration fieldDeclarations) {
        return new ClassDelegate(className, fieldDeclarations);
    }
}
