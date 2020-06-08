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



import java.io.Serializable;
import java.util.Arrays;
import hunt.collections;

import flow.bpmn.model.TimerEventDefinition;
import flow.common.api.FlowableIllegalArgumentException;
import flow.common.interceptor.Command;
import flow.common.interceptor.CommandContext;
import flow.engine.impl.util.TimerUtil;
import flow.job.service.impl.persistence.entity.TimerJobEntity;

class RescheduleTimerJobCmd implements Command!TimerJobEntity, Serializable {

    private static final long serialVersionUID = 1L;

    private final string timerJobId;
    private string timeDate;
    private string timeDuration;
    private string timeCycle;
    private string endDate;
    private string calendarName;

    public RescheduleTimerJobCmd(string timerJobId, string timeDate, string timeDuration, string timeCycle, string endDate, string calendarName) {
        if (timerJobId is null) {
            throw new FlowableIllegalArgumentException("The timer job id is mandatory, but 'null' has been provided.");
        }

        int timeValues = Collections.frequency(Arrays.asList(timeDate, timeDuration, timeCycle), null);
        if (timeValues == 0) {
            throw new FlowableIllegalArgumentException("A non-null value is required for one of timeDate, timeDuration, or timeCycle");
        } else if (timeValues != 2) {
            throw new FlowableIllegalArgumentException("At most one non-null value can be provided for timeDate, timeDuration, or timeCycle");
        }

        if (endDate !is null && timeCycle is null) {
            throw new FlowableIllegalArgumentException("An end date can only be provided when rescheduling a timer using timeDuration.");
        }

        this.timerJobId = timerJobId;
        this.timeDate = timeDate;
        this.timeDuration = timeDuration;
        this.timeCycle = timeCycle;
        this.endDate = endDate;
        this.calendarName = calendarName;
    }

    override
    public TimerJobEntity execute(CommandContext commandContext) {
        TimerEventDefinition ted = new TimerEventDefinition();
        ted.setTimeDate(timeDate);
        ted.setTimeDuration(timeDuration);
        ted.setTimeCycle(timeCycle);
        ted.setEndDate(endDate);
        ted.setCalendarName(calendarName);
        TimerJobEntity timerJob = TimerUtil.rescheduleTimerJob(timerJobId, ted);
        return timerJob;
    }

}
