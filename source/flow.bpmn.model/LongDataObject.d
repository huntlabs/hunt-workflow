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

module flow.bpmn.model.LongDataObject;

//import org.apache.commons.lang3.StringUtils;

import flow.bpmn.model.ValuedDataObject;
import hunt.Long;
import std.string;
import hunt.String;
import hunt.Number;
/**
 * @author Lori Small
 */

    //String s = cast(String)value; //strip
    //  if (s !is null && strip(s.value).length != 0) {

class LongDataObject : ValuedDataObject {
    override
    public void setValue(Object value) {
      String s = cast(String)value;
    	if (s !is null && strip(s.value).length != 0) {
    		this.value = Long.valueOf(s.value);
    	} else if ((cast(Long) value) !is null) {
    		this.value = cast(Long) value;
    	}
    }

    override
    public LongDataObject clone() {
        LongDataObject clone = new LongDataObject();
        clone.setValues(this);
        return clone;
    }
}
