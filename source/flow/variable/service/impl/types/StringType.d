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
module flow.variable.service.impl.types.StringType;

import flow.variable.service.api.types.ValueFields;
import flow.variable.service.api.types.VariableType;
import hunt.String;
/**
 * @author Tom Baeyens
 */
class StringType : VariableType {

    enum  string TYPE_NAME = "string";
    private  int maxLength;

    this(int maxLength) {
        this.maxLength = maxLength;
    }


    public string getTypeName() {
        return TYPE_NAME;
    }


    public bool isCachable() {
        return true;
    }


    public Object getValue(ValueFields valueFields) {
        return new String(valueFields.getTextValue());
    }


    public void setValue(Object value, ValueFields valueFields) {
        String s  = cast(String) value;
        valueFields.setTextValue(s.value);
    }


    public bool isAbleToStore(Object value) {
        if (value is null) {
            return true;
        }
        String stringValue = cast(String) value;
        if (stringValue !is null) {
            return stringValue.value.length <= maxLength;
        }
        return false;
    }
}
