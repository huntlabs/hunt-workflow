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

module flow.task.api.history.HistoricTaskInstance;

import hunt.time.LocalDateTime;

import flow.common.api.history.HistoricData;
import flow.task.api.TaskInfo;

alias  Date = LocalDateTime;

/**
 * Represents a historic task instance (waiting, finished or deleted) that is stored permanent for statistics, audit and other business intelligence purposes.
 *
 * @author Tom Baeyens
 * @author Joram Barrez
 */
interface HistoricTaskInstance : TaskInfo, HistoricData {

    /**
     * The reason why this task was deleted {'completed' | 'deleted' | any other user defined string }.
     */
    string getDeleteReason();

    /**
     * Time when the task created.
     *
     * @deprecated use {@link #getCreateTime()} instead
     **/
   // @Deprecated
    Date getStartTime();

    /** Time when the task was deleted or completed. */
    Date getEndTime();

    /**
     * Difference between {@link #getEndTime()} and {@link #getStartTime()} in milliseconds.
     */
    long getDurationInMillis();

    /**
     * Difference between {@link #getEndTime()} and {@link #getClaimTime()} in milliseconds.
     */
    long getWorkTimeInMillis();

    /** Time when the task was claimed. */
    Date getClaimTime();

}
