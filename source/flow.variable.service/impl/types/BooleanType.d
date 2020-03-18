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
module flow.variable.service.impl.types.BooleanType;

import flow.variable.service.api.types.ValueFields;
import flow.variable.service.api.types.VariableType;
import hunt.Boolean;
import hunt.Long;
/**
 * @author Frederik Heremans
 */
class BooleanType : VariableType {

    public static  string TYPE_NAME = "boolean";


    public string getTypeName() {
        return TYPE_NAME;
    }


    public bool isCachable() {
        return true;
    }


    public Object getValue(ValueFields valueFields) {
        if (valueFields.getLongValue() !is null) {
            return valueFields.getLongValue().longValue == 1 ? Boolean.TRUE(): Boolean.FALSE();
        }
        return null;
    }


    public void setValue(Object value, ValueFields valueFields) {
        if (value is null) {
            valueFields.setLongValue(null);
        } else {
            Boolean booleanValue = cast(Boolean) value;
            if (booleanValue.booleanValue) {
                valueFields.setLongValue(new Long(1L));
            } else {
                valueFields.setLongValue(new Long(0L));
            }
        }
    }


    public bool isAbleToStore(Object value) {
        if (value is null) {
            return true;
        }
        return cast(Boolean)value !is null? true:false;
       // return Boolean.class.isAssignableFrom(value.getClass()) || boolean.class.isAssignableFrom(value.getClass());
    }
}
