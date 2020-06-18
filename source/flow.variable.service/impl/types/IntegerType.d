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
module flow.variable.service.impl.types.IntegerType;

import flow.variable.service.api.types.ValueFields;
import flow.variable.service.api.types.VariableType;
import hunt.Integer;
import hunt.Exceptions;
/**
 * @author Joram Barrez
 */
class IntegerType : VariableType {

    public static  string TYPE_NAME = "integer";


    public string getTypeName() {
        return TYPE_NAME;
    }


    public bool isCachable() {
        return true;
    }


    public Object getValue(ValueFields valueFields) {
        if (valueFields.getLongValue() !is null) {
            return Integer.valueOf(valueFields.getLongValue().intValue());
        }
        return null;
    }


    public void setValue(Object value, ValueFields valueFields) {
        if (value !is null) {
            valueFields.setLongValue((cast(Integer) value).longValue());
            valueFields.setTextValue((cast(Integer)value).toString());
        } else {
            valueFields.setLongValue(null);
            valueFields.setTextValue(null);
        }
    }


    public bool isAbleToStore(Object value) {
        implementationMissing(false);
        return false;
        //if (value is null) {
        //    return true;
        //}
        //return Integer.class.isAssignableFrom(value.getClass()) || int.class.isAssignableFrom(value.getClass());
    }
}
