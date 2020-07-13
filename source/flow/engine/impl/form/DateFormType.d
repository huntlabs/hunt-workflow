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
module flow.engine.impl.form.DateFormType;


//import java.text.Format;
//import java.text.ParseException;
//
//import org.apache.commons.lang3.StringUtils;
//import org.apache.commons.lang3.time.FastDateFormat;
import flow.common.api.FlowableIllegalArgumentException;
import flow.engine.form.AbstractFormType;
import hunt.Exceptions;
import hunt.String;
/**
 * @author Tom Baeyens
 */
class DateFormType : AbstractFormType {

    protected string datePattern;
   // protected Format dateFormat;

    this(string datePattern) {
        this.datePattern = datePattern;
      //  this.dateFormat = FastDateFormat.getInstance(datePattern);
    }

    public string getName() {
        return "date";
    }

    override
    public Object getInformation(string key) {
        if ("datePattern" == (key)) {
            return new String(datePattern);
        }
        return null;
    }

    override
    public Object convertFormValueToModelValue(string propertyValue) {
        implementationMissing(false);
        return null;
        //if (propertyValue is null || propertyValue.length == 0) {
        //    return null;
        //}
        //try {
        //    return dateFormat.parseObject(propertyValue);
        //} catch (ParseException e) {
        //    throw new FlowableIllegalArgumentException("invalid date value " + propertyValue, e);
        //}
    }

    override
    public string convertModelValueToFormValue(Object modelValue) {
        implementationMissing(false);
        return "";
        //if (modelValue is null) {
        //    return null;
        //}
        //return dateFormat.format(modelValue);
    }
}
