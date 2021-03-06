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
module flow.variable.service.impl.types.InstantType;

//import java.time.Instant;
import hunt.time.LocalDateTime;
import flow.variable.service.api.types.ValueFields;
import flow.variable.service.api.types.VariableType;
import hunt.Long;
/**
 * @author Filip Hrisafov
 */
class InstantType : VariableType {

    public static  string TYPE_NAME = "instant";


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
        return cast(LocalDateTime)value !is null? true:false;
        //return Instant.class.isAssignableFrom(value.getClass());
    }


    public Object getValue(ValueFields valueFields) {
        Long longValue = valueFields.getLongValue();
        if (longValue !is null) {
            return LocalDateTime.ofEpochMilli(longValue.longValue() * 1000);
        }
        return null;
    }


    public void setValue(Object value, ValueFields valueFields) {
        if (value !is null) {
            LocalDateTime instant = cast(LocalDateTime) value;
            valueFields.setLongValue(new Long(instant.toEpochMilli()/ 1000));
        } else {
            valueFields.setLongValue(null);
        }
    }
}
