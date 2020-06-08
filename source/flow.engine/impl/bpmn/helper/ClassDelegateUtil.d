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


import java.lang.reflect.Field;
import java.lang.reflect.InvocationTargetException;
import java.lang.reflect.Method;
import hunt.collection.List;

import flow.common.api.FlowableException;
import flow.common.api.FlowableIllegalArgumentException;
import flow.common.util.ReflectUtil;
import flow.engine.impl.bpmn.parser.FieldDeclaration;

/**
 * @author Joram Barrez
 */
class ClassDelegateUtil {

    public static Object instantiateDelegate(Class<?> clazz, List!FieldDeclaration fieldDeclarations) {
        return instantiateDelegate(clazz.getName(), fieldDeclarations);
    }

    public static Object instantiateDelegate(string className, List!FieldDeclaration fieldDeclarations) {
        Object object = ReflectUtil.instantiate(className);
        applyFieldDeclaration(fieldDeclarations, object);
        return object;
    }

    public static void applyFieldDeclaration(List!FieldDeclaration fieldDeclarations, Object target) {
        if (fieldDeclarations !is null) {
            for (FieldDeclaration declaration : fieldDeclarations) {
                applyFieldDeclaration(declaration, target);
            }
        }
    }

    public static void applyFieldDeclaration(FieldDeclaration declaration, Object target) {
        Method setterMethod = ReflectUtil.getSetter(declaration.getName(), target.getClass(), declaration.getValue().getClass());

        if (setterMethod !is null) {
            try {
                setterMethod.invoke(target, declaration.getValue());
            } catch (IllegalArgumentException e) {
                throw new FlowableException("Error while invoking '" + declaration.getName() + "' on class " + target.getClass().getName(), e);
            } catch (IllegalAccessException e) {
                throw new FlowableException("Illegal access when calling '" + declaration.getName() + "' on class " + target.getClass().getName(), e);
            } catch (InvocationTargetException e) {
                throw new FlowableException("Exception while invoking '" + declaration.getName() + "' on class " + target.getClass().getName(), e);
            }
        } else {
            Field field = ReflectUtil.getField(declaration.getName(), target);
            if (field is null) {
                throw new FlowableIllegalArgumentException("Field definition uses non-existing field '" + declaration.getName() + "' on class " + target.getClass().getName());
            }
            // Check if the delegate field's type is correct
            if (!fieldTypeCompatible(declaration, field)) {
                throw new FlowableIllegalArgumentException("Incompatible type set on field declaration '" + declaration.getName() + "' for class " + target.getClass().getName() + ". Declared value has type "
                        + declaration.getValue().getClass().getName() + ", while expecting " + field.getType().getName());
            }
            ReflectUtil.setField(field, target, declaration.getValue());
        }
    }

    public static bool fieldTypeCompatible(FieldDeclaration declaration, Field field) {
        if (declaration.getValue() !is null) {
            return field.getType().isAssignableFrom(declaration.getValue().getClass());
        } else {
            // Null can be set any field type
            return true;
        }
    }

}
