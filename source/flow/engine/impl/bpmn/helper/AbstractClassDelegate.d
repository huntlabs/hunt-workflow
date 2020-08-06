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

module flow.engine.impl.bpmn.helper.AbstractClassDelegate;

import hunt.collection.List;

import flow.bpmn.model.ServiceTask;
//import flow.common.util.ReflectUtil;
import flow.engine.impl.bpmn.behavior.AbstractBpmnActivityBehavior;
import flow.engine.impl.bpmn.parser.FieldDeclaration;
import hunt.Exceptions;
import std.string;
/**
 * Helper class for bpmn constructs that allow class delegation.
 *
 * This class will lazily instantiate the referenced classes when needed at runtime.
 *
 * @author Tijs Rademakers
 */
abstract class AbstractClassDelegate : AbstractBpmnActivityBehavior {

    protected string serviceTaskId;
    protected string className;
    protected List!FieldDeclaration fieldDeclarations;

    this(string className, List!FieldDeclaration fieldDeclarations) {
        this.className = className;
        this.fieldDeclarations = fieldDeclarations;
    }

    this(TypeInfo clazz, List!FieldDeclaration fieldDeclarations) {
        this.className = clazz.toString();
        this.fieldDeclarations = fieldDeclarations;
    }

    protected Object instantiateDelegate(string className, List!FieldDeclaration fieldDeclarations) {
        return AbstractClassDelegate.defaultInstantiateDelegate(className, fieldDeclarations);
    }

    // --HELPER METHODS (also usable by external classes)
    // ----------------------------------------

    public static Object defaultInstantiateDelegate(TypeInfo clazz, List!FieldDeclaration fieldDeclarations, ServiceTask serviceTask) {
        return defaultInstantiateDelegate(clazz.toString, fieldDeclarations, serviceTask);
    }

    public static Object defaultInstantiateDelegate(TypeInfo clazz, List!FieldDeclaration fieldDeclarations) {
        return defaultInstantiateDelegate(clazz.toString, fieldDeclarations);
    }

    public static Object defaultInstantiateDelegate(string className, List!FieldDeclaration fieldDeclarations, ServiceTask serviceTask) {
        //Object object = ReflectUtil.instantiate(className);
        Object object = Object.factory(className ~ "." ~ className[className.lastIndexOf(".") + 1 .. $]);
        applyFieldDeclaration(fieldDeclarations, object);

        if (serviceTask !is null) {
            implementationMissing(false);
           // ReflectUtil.invokeSetterOrField(object, "serviceTask", serviceTask, false);
        }

        return object;
    }

    public static Object defaultInstantiateDelegate(string className, List!FieldDeclaration fieldDeclarations) {
        return defaultInstantiateDelegate(className, fieldDeclarations, null);
    }

    public static void applyFieldDeclaration(List!FieldDeclaration fieldDeclarations, Object target) {
        applyFieldDeclaration(fieldDeclarations, target, true);
    }

    public static void applyFieldDeclaration(List!FieldDeclaration fieldDeclarations, Object target, bool throwExceptionOnMissingField) {
        if (fieldDeclarations !is null) {
            foreach (FieldDeclaration declaration ; fieldDeclarations) {
                applyFieldDeclaration(declaration, target, throwExceptionOnMissingField);
            }
        }
    }

    public static void applyFieldDeclaration(FieldDeclaration declaration, Object target) {
        applyFieldDeclaration(declaration, target, true);
    }

    public static void applyFieldDeclaration(FieldDeclaration declaration, Object target, bool throwExceptionOnMissingField) {
        implementationMissing(false);
        //ReflectUtil.invokeSetterOrField(target, declaration.getName(), declaration.getValue(), throwExceptionOnMissingField);
    }

    /**
     * returns the class name this {@link AbstractClassDelegate} is configured to. Comes in handy if you want to check which delegates you already have e.g. in a list of listeners
     */
    public string getClassName() {
        return className;
    }

}
