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

module flow.job.service.api.JobQuery;





//import hunt.time.LocalDateTime;

import flow.common.api.query.Query;
import flow.job.service.api.Job;
/**
 * Allows programmatic querying of {@link Job}s.
 *
 * @author Joram Barrez
 * @author Falko Menge
 */
interface JobQuery : Query!(JobQuery, Job) {

    /** Only select jobs with the given id */
    JobQuery jobId(string jobId);

    /** Only select jobs which exist for the given process instance. **/
    JobQuery processInstanceId(string processInstanceId);

    /** Only select jobs which exist for the given execution */
    JobQuery executionId(string executionId);

    /** Select jobs which have given job handler type */
    JobQuery handlerType(string handlerType);

    /** Only select jobs which exist for the given process definition id */
    JobQuery processDefinitionId(string processDefinitionId);

    /** Only select jobs which exist for the given element id */
    JobQuery elementId(string elementId);

    /** Only select jobs which exist for the given element name */
    JobQuery elementName(string elementName);

    /** Only select tasks for the given scope identifier. */
    JobQuery scopeId(string scopeId);

    /** Only select tasks for the given sub scope identifier. */
    JobQuery subScopeId(string subScopeId);

    /** Only select tasks for the given scope type. */
    JobQuery scopeType(string scopeType);

    /** Only select tasks for the given scope definition identifier. */
    JobQuery scopeDefinitionId(string scopeDefinitionId);

    /** Only select jobs for the given case instance. */
    JobQuery caseInstanceId(string caseInstanceId);

    /** Only select jobs for the given case definition. */
    JobQuery caseDefinitionId(string caseDefinitionId);

    /** Only select jobs for the given plan item instance.  */
    JobQuery planItemInstanceId(string planItemInstanceId);

    /**
     * Only select jobs that are timers. Cannot be used together with {@link #messages()}
     */
    JobQuery timers();

    /**
     * Only select jobs that are messages. Cannot be used together with {@link #timers()}
     */
    JobQuery messages();

    /** Only select jobs where the duedate is lower than the given date. */
    JobQuery duedateLowerThan(Date date);

    /** Only select jobs where the duedate is higher then the given date. */
    JobQuery duedateHigherThan(Date date);

    /** Only select jobs that failed due to an exception. */
    JobQuery withException();

    /** Only select jobs that failed due to an exception with the given message. */
    JobQuery exceptionMessage(string exceptionMessage);

    /**
     * Only select jobs that have the given tenant id.
     */
    JobQuery jobTenantId(string tenantId);

    /**
     * Only select jobs with a tenant id like the given one.
     */
    JobQuery jobTenantIdLike(string tenantIdLike);

    /**
     * Only select jobs that do not have a tenant id.
     */
    JobQuery jobWithoutTenantId();

    /**
     * Only return jobs with the given lock owner.
     */
    JobQuery lockOwner(string lockOwner);

    /**
     * Only return jobs that are locked (i.e. they are acquired by an executor).
     */
    JobQuery locked();

    /**
     * Only return jobs that are not locked.
     */
    JobQuery unlocked();

    // sorting //////////////////////////////////////////

    /**
     * Order by job id (needs to be followed by {@link #asc()} or {@link #desc()}).
     */
    JobQuery orderByJobId();

    /**
     * Order by duedate (needs to be followed by {@link #asc()} or {@link #desc()}).
     */
    JobQuery orderByJobDuedate();

    /**
     * Order by retries (needs to be followed by {@link #asc()} or {@link #desc()}).
     */
    JobQuery orderByJobRetries();

    /**
     * Order by process instance id (needs to be followed by {@link #asc()} or {@link #desc()}).
     */
    JobQuery orderByProcessInstanceId();

    /**
     * Order by execution id (needs to be followed by {@link #asc()} or {@link #desc()}).
     */
    JobQuery orderByExecutionId();

    /**
     * Order by tenant id (needs to be followed by {@link #asc()} or {@link #desc()}).
     */
    JobQuery orderByTenantId();

}
