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
module flow.common.util.DefaultClockImpl;

import hunt.time.LocalDateTime;

alias Date = LocalDateTime;
//import java.util.Calendar;
//import java.util.Date;
//import java.util.GregorianCalendar;
//import java.util.TimeZone;
import flow.common.runtime.Clockm;
/**
 * @author Joram Barrez
 */
class DefaultClockImpl : Clockm {
    private Date timeZone;
    protected static  Date CURRENT_TIME;

    this() {
    }

    this(Date timeZone) {
        this.timeZone = timeZone;
    }

    public void setCurrentTime(Date currentTime) {
        Date time = null;

        if (currentTime != null) {
            time = (timeZone == null) ? Date.now : currentTime;
           // time.setTime(currentTime);
        }

        setCurrentCalendar(time);
    }


    public void setCurrentCalendar(Date currentTime) {
        CURRENT_TIME = currentTime;
    }


    public void reset() {
        CURRENT_TIME = null;
    }


    public Date getCurrentTime() {
        return CURRENT_TIME == null ? new Date() : CURRENT_TIME;
    }


    public Date getCurrentCalendar() {
        if (CURRENT_TIME == null) {
            return  Date.now();
        }

        return CURRENT_TIME;
    }


    //public Calendar getCurrentCalendar(TimeZone timeZone) {
    //    return TimeZoneUtil.convertToTimeZone(getCurrentCalendar(), timeZone);
    //}
    //
    //
    //public TimeZone getCurrentTimeZone() {
    //    return getCurrentCalendar().getTimeZone();
    //}

}
