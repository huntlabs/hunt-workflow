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


module flow.bpmn.model.IntegerDataObject;

import flow.bpmn.model.FlowElement;
import flow.bpmn.model.BaseElement;
import  flow.bpmn.model.DataObject;

import flow.bpmn.model.ValuedDataObject;
import std.string;
import hunt.String;
import hunt.Integer;
//import org.apache.commons.lang3.StringUtils;


    //String s = cast(String)value; //strip
    //  if (s !is null && strip(s.value).length != 0) {
/**
 * @author Lori Small
 */
class IntegerDataObject : ValuedDataObject {

    alias setValues = BaseElement.setValues;
    alias setValues = FlowElement.setValues;
    alias  setValues = DataObject.setValues;
    alias setValues = ValuedDataObject.setValues;

    override
    public void setValue(Object value) {
      String s = cast(String)value;
    	if (s !is null && strip(s.value).length != 0) {
    		this.value = Integer.valueOf(s.value);
    	} else if (cast(Integer)value !is null) {
    		this.value = cast(Integer) value;
    	}
    }

    override
    public IntegerDataObject clone() {
        IntegerDataObject clone = new IntegerDataObject();
        clone.setValues(this);
        return clone;
    }
}
