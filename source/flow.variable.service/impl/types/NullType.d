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

module flow.variable.service.impl.types.NullType;
import flow.variable.service.api.types.ValueFields;
import flow.variable.service.api.types.VariableType;

/**
 * @author Tom Baeyens
 */
class NullType : VariableType {

    public static  string TYPE_NAME = "null";



    public string getTypeName() {
        return TYPE_NAME;
    }


    public bool isCachable() {
        return true;
    }


    public Object getValue(ValueFields valueFields) {
        return null;
    }


    public bool isAbleToStore(Object value) {
        return (value is null);
    }


    public void setValue(Object value, ValueFields valueFields) {
    }
}
