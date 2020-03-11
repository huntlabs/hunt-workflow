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

//          Copyright linse 2020.
// Distributed under the Boost Software License, Version 1.0.
//    (See accompanying file LICENSE_1_0.txt or copy at
//          http://www.boost.org/LICENSE_1_0.txt)}

module flow.job.service.api.Job;





//import hunt.time.LocalDateTime;

/**
 * Represents one job (timer, async job, etc.).
 *
 * @author Joram Barrez
 */
interface Job : JobInfo {

    string JOB_TYPE_TIMER = "timer";
    string JOB_TYPE_MESSAGE = "message";

    bool DEFAULT_EXCLUSIVE = true;
    int MAX_EXCEPTION_MESSAGE_LENGTH = 255;

    /**
     * Returns the date on which this job is supposed to be processed.
     */
    Date getDuedate();

    /**x
     * Returns the id of the process instance which execution created the job.
     */
    string getProcessInstanceId();

    /**
     * Returns the specific execution on which the job was created.
     */
    string getExecutionId();

    /**
     * Returns the specific process definition on which the job was created
     */
    string getProcessDefinitionId();

    /**
     * Reference to an element identifier or null if none is set.
     */
    string getElementId();

    /**
     * Reference to an element name or null if none is set.
     */
    string getElementName();

    /**
     * Reference to a scope identifier or null if none is set.
     */
    string getScopeId();

    /**
     * Reference to a sub scope identifier or null if none is set.
     */
    string getSubScopeId();

    /**
     * Reference to a scope type or null if none is set.
     */
    string getScopeType();

    /**
     * Reference to a scope definition identifier or null if none is set.
     */
    string getScopeDefinitionId();

    /**
     * Is the job exclusive?
     */
    bool isExclusive();

    /**
     * Get the job type for this job.
     */
    string getJobType();

    /**
     * Returns the create datetime of the job.
     */
    Date getCreateTime();

}
