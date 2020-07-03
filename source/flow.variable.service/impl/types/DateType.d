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

module flow.variable.service.impl.types.DateType;

import hunt.time.LocalDateTime;

import flow.variable.service.api.types.ValueFields;
import flow.variable.service.api.types.VariableType;
import hunt.Long;
alias Date = LocalDateTime;
/**
 * @author Tom Baeyens
 */
class DateType : VariableType {

    public static  string TYPE_NAME = "date";


    public string getTypeName() {
        return TYPE_NAME;
    }


    public bool isCachable() {
        return true;
    }


    public bool isAbleToStore(Object value) {
        if (value is null) {
            return true;
        }
        return cast(Date)value is null? false : true;
       // return Date.class.isAssignableFrom(value.getClass());
    }


    public Object getValue(ValueFields valueFields) {
        Long longValue = valueFields.getLongValue();
        if (longValue !is null) {
            return Date.ofEpochMilli(longValue.longValue());
        }
        return null;
    }


    public void setValue(Object value, ValueFields valueFields) {
        if (value !is null) {
            valueFields.setLongValue(cast(Long)value);
        } else {
            valueFields.setLongValue(null);
        }
    }
}
