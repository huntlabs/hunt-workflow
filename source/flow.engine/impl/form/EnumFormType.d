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
module flow.engine.impl.form.EnumFormType;


import hunt.collection.Map;

import flow.common.api.FlowableIllegalArgumentException;
import flow.engine.form.AbstractFormType;
import flow.engine.impl.form.AbstractFormType;
import hunt.String;

/**
 * @author Tom Baeyens
 */
class EnumFormType : AbstractFormType {


    protected Map!(string, string) values;

    this(Map!(string, string) values) {
        this.values = values;
    }

    public string getName() {
        return "enum";
    }

    override
    public Object getInformation(string key) {
        if (key == ("values")) {
            return values;
        }
        return null;
    }

    override
    public Object convertFormValueToModelValue(string propertyValue) {
        validateValue(propertyValue);
        return propertyValue;
    }

    override
    public string convertModelValueToFormValue(Object modelValue) {
        if (modelValue !is null) {
            //if (!(modelValue instanceof string)) {
            //    throw new FlowableIllegalArgumentException("Model value should be a string");
            //}
           // validateValue((string) modelValue);
             return (cast(String) modelValue).value;
        }

    }

    protected void validateValue(string value) {
        //if (value !is null) {
        //    if (values !is null && !values.containsKey(value)) {
        //        throw new FlowableIllegalArgumentException("Invalid value for enum form property: " + value);
        //    }
        //}
    }

}
