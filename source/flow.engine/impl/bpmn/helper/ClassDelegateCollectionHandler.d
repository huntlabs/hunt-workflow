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
module flow.engine.impl.bpmn.helper.ClassDelegateCollectionHandler;


import hunt.collection;
import hunt.collection.List;

import flow.common.api.FlowableIllegalArgumentException;
import flow.engine.deleg.DelegateExecution;
import flow.engine.impl.bpmn.parser.FieldDeclaration;
import flow.engine.impl.deleg.FlowableCollectionHandler;
import flow.engine.impl.bpmn.helper.AbstractClassDelegate;
/**
 * Helper class for Collection handlers to allow class delegation.
 *
 * This class will lazily instantiate the referenced classes when needed at runtime.
 *
 * @author Lori Small
 */
class ClassDelegateCollectionHandler : AbstractClassDelegate , FlowableCollectionHandler {

    this(string className, List!FieldDeclaration fieldDeclarations) {
        super(className, fieldDeclarations);
    }

    this(TypeInfo clazz, List!FieldDeclaration fieldDeclarations) {
        super(clazz, fieldDeclarations);
    }

	public Collection resolveCollection(Object collectionValue, DelegateExecution execution) {
		return getCollectionHandlerInstance().resolveCollection(collectionValue, execution);
	}

    protected FlowableCollectionHandler getCollectionHandlerInstance() {
        Object delegateInstance = instantiateDelegate(className, fieldDeclarations);
        if (cast(FlowableCollectionHandler)delegateInstance !is null) {
            return cast(FlowableCollectionHandler) delegateInstance;
        } else {
            throw new FlowableIllegalArgumentException(typeid(delegateInstance).toString ~ " doesn't implement " ~ typeid(FlowableCollectionHandler).toString);
        }
    }
}
