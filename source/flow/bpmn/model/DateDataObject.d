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

module flow.bpmn.model.DateDataObject;

import flow.bpmn.model.ValuedDataObject;
import hunt.time.LocalDateTime;
import hunt.String;
import std.datetime.systime;
import std.string;
import flow.bpmn.model.BaseElement;
import flow.bpmn.model.FlowElement;
import flow.bpmn.model.DataObject;
//import java.text.DateFormat;
//import java.text.ParseException;
//import hunt.time.LocalDateTime;

//import org.apache.commons.lang3.StringUtils;

/**
 * @author Lori Small
 */

    //static LocalDateTime of(int year, int month, int dayOfMonth, int hour, int minute) {
    //  LocalDate date = LocalDate.of(year, month, dayOfMonth);
    //  LocalTime time = LocalTime.of(hour, minute);
    //  return new LocalDateTime(date, time);
    //}


alias Date = LocalDateTime;

class DateDataObject : ValuedDataObject {

  alias setValues = DataObject.setValues;
  alias setValues = FlowElement.setValues;
    alias setValues = BaseElement.setValues;
  alias setValues = ValuedDataObject.setValues;

    override
    public void setValue(Object value) {
      String s = cast(String)value; //strip
      if (s !is null && strip(s.value).length != 0) { //2018-01-01T10:30:00Z
          SysTime st = SysTime.fromISOExtString(s.value);
				  this.value = Date.of(cast(int)st.year(),st.month(),cast(int)st.daysInMonth(),cast(int)st.hour(),cast(int)st.minute());
    	} else if (cast(Date)value !is null ) {
    		this.value = value;
    	}
    	//if (value instanceof string && !StringUtils.isEmpty(((string) value).trim())) {
    	//	try {
			//	this.value = DateFormat.getDateTimeInstance().parse((string) value);
			//} catch (ParseException e) {
			//	System.out.println("Error parsing Date string: " + value);
			//}
    	//} else if (value instanceof Date) {
    	//	this.value = value;
    	//}
    }

    override
    public DateDataObject clone() {
        DateDataObject clone = new DateDataObject();
        clone.setValues(this);
        return clone;
    }
}
