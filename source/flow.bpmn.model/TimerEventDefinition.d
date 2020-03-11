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

module flow.bpmn.model.TimerEventDefinition;

import flow.bpmn.model.EventDefinition;

/**
 * @author Tijs Rademakers
 */
class TimerEventDefinition : EventDefinition {

    protected string timeDate;
    protected string timeDuration;
    protected string timeCycle;
    protected string endDate;
    protected string calendarName;

    public string getTimeDate() {
        return timeDate;
    }

    public void setTimeDate(string timeDate) {
        this.timeDate = timeDate;
    }

    public string getTimeDuration() {
        return timeDuration;
    }

    public void setTimeDuration(string timeDuration) {
        this.timeDuration = timeDuration;
    }

    public string getTimeCycle() {
        return timeCycle;
    }

    public void setTimeCycle(string timeCycle) {
        this.timeCycle = timeCycle;
    }

    public void setEndDate(string endDate) {
        this.endDate = endDate;
    }

    public string getEndDate() {
        return endDate;
    }

    public string getCalendarName() {
        return calendarName;
    }

    public void setCalendarName(string calendarName) {
        this.calendarName = calendarName;
    }

    override
    public TimerEventDefinition clone() {
        TimerEventDefinition clone = new TimerEventDefinition();
        clone.setValues(this);
        return clone;
    }

    public void setValues(TimerEventDefinition otherDefinition) {
        super.setValues(otherDefinition);
        setTimeDate(otherDefinition.getTimeDate());
        setTimeDuration(otherDefinition.getTimeDuration());
        setTimeCycle(otherDefinition.getTimeCycle());
        setEndDate(otherDefinition.getEndDate());
        setCalendarName(otherDefinition.getCalendarName());
    }
}
