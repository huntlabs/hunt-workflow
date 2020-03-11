/*
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *       http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

module flow.engine.history.HistoricActivityInstance;

import hunt.time.LocalDateTime;

import flow.common.api.history.HistoricData;

alias Date = LocalDateTime;

/**
 * Represents one execution of an activity and it's stored permanent for statistics, audit and other business intelligence purposes.
 *
 * @author Christian Stettler
 * @author Joram Barrez
 */
interface HistoricActivityInstance : HistoricData {

    /** The unique identifier of this historic activity instance. */
    string getId();

    /** The unique identifier of the activity in the process */
    string getActivityId();

    /** The display name for the activity */
    string getActivityName();

    /** The XML tag of the activity as in the process file */
    string getActivityType();

    /** Process definition reference */
    string getProcessDefinitionId();

    /** Process instance reference */
    string getProcessInstanceId();

    /** Execution reference */
    string getExecutionId();

    /** The corresponding task in case of task activity */
    string getTaskId();

    /** The called process instance in case of call activity */
    string getCalledProcessInstanceId();

    /** Assignee in case of user task activity */
    string getAssignee();

    /** Time when the activity instance started */
    Date getStartTime();

    /** Time when the activity instance ended */
    Date getEndTime();

    /** Difference between {@link #getEndTime()} and {@link #getStartTime()}. */
    long getDurationInMillis();

    /** Returns the delete reason for this activity, if any was set (if completed normally, no delete reason is set) */
    string getDeleteReason();

    /** Returns the tenant identifier for the historic activity */
    string getTenantId();
}
