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

module flow.engine.impl.form.BooleanFormType;

import flow.common.api.FlowableIllegalArgumentException;
import flow.engine.form.AbstractFormType;
import hunt.Boolean;
/**
 * @author Frederik Heremans
 */
class BooleanFormType : AbstractFormType {

    public string getName() {
        return "bool";
    }

    public string getMimeType() {
        return "plain/text";
    }

    override
    public Object convertFormValueToModelValue(string propertyValue) {
        if (propertyValue is null || "" == (propertyValue)) {
            return null;
        }
        return Boolean.valueOf(propertyValue);
    }

    override
    public string convertModelValueToFormValue(Object modelValue) {

        if (modelValue is null) {
            return null;
        }

        return (cast(Boolean)modelValue).toString();

        //if (bool.class.isAssignableFrom(modelValue.getClass()) || bool.class.isAssignableFrom(modelValue.getClass())) {
        //    return modelValue.toString();
        //}
        //throw new FlowableIllegalArgumentException("Model value is not of type bool, but of type " + modelValue.getClass().getName());
    }
}
