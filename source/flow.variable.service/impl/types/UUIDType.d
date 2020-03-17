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
module flow.variable.service.impl.types.UUIDType;

import std.uuid;
import hunt.String;
import flow.variable.service.api.types.ValueFields;
import flow.variable.service.api.types.VariableType;

/**
 * @author Birger Zimmermann
 */
class UUIDType : VariableType {

    public static  string TYPE_NAME = "uuid";



    public string getTypeName() {
        return TYPE_NAME;
    }


    public bool isCachable() {
        return true;
    }


    public Object getValue(ValueFields valueFields) {
        string textValue = valueFields.getTextValue();
        if (textValue is null)
            return null;
        //return UUID.fromString(textValue);
        return new String(textValue);
    }


    public void setValue(Object value, ValueFields valueFields) {
        if (value !is null) {
            valueFields.setTextValue(value.toString());
        } else {
            valueFields.setTextValue(null);
        }
    }


    public bool isAbleToStore(Object value) {
        if (value is null) {
            return true;
        }
        return null;
        //return UUID.class.isAssignableFrom(value.getClass());
    }
}
