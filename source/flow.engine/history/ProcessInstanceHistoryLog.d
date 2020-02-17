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


import java.util.Date;
import java.util.List;

import flow.common.api.history.HistoricData;
import flow.engine.IdentityService;
import flow.engine.runtime.ProcessInstance;

/**
 * A trail of data for a given process instance.
 * 
 * @author Joram Barrez
 */
interface ProcessInstanceHistoryLog {

    /**
     * The process instance id (== as the id for the runtime {@link ProcessInstance process instance}).
     */
    string getId();

    /** The user provided unique reference to this process instance. */
    string getBusinessKey();

    /** The process definition reference. */
    string getProcessDefinitionId();

    /** The time the process was started. */
    Date getStartTime();

    /** The time the process was ended. */
    Date getEndTime();

    /**
     * The difference between {@link #getEndTime()} and {@link #getStartTime()} .
     */
    Long getDurationInMillis();

    /**
     * The authenticated user that started this process instance.
     * 
     * @see IdentityService#setAuthenticatedUserId(string)
     */
    string getStartUserId();

    /** The start activity. */
    string getStartActivityId();

    /** Obtains the reason for the process instance's deletion. */
    string getDeleteReason();

    /**
     * The process instance id of a potential super process instance or null if no super process instance exists
     */
    string getSuperProcessInstanceId();

    /**
     * The tenant identifier for the process instance.
     */
    string getTenantId();

    /**
     * The trail of data, ordered by date (ascending). Gives a replay of the process instance.
     */
    List<HistoricData> getHistoricData();

}
