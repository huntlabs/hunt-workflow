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

import flow.common.api.query.Query;

/**
 * Allows programmatic querying of {@link Job}s.
 * 
 * @author Joram Barrez
 * @author Tijs Rademakers
 */
interface TimerJobQuery extends Query<TimerJobQuery, Job> {

    /** Only select jobs with the given id */
    TimerJobQuery jobId(string jobId);

    /** Only select jobs which exist for the given process instance. **/
    TimerJobQuery processInstanceId(string processInstanceId);

    /** Only select jobs which exist for the given execution */
    TimerJobQuery executionId(string executionId);

    /** Only select jobs which exist for the given process definition id */
    TimerJobQuery processDefinitionId(string processDefinitionid);
    
    /** Only select jobs which exist for the given element id */
    TimerJobQuery elementId(string elementId);
    
    /** Only select jobs which exist for the given element name */
    TimerJobQuery elementName(string elementName);
    
    /** Only select jobs for the given scope identifier. */
    TimerJobQuery scopeId(string scopeId);

    /** Only select jobs for the given sub scope identifier. */
    TimerJobQuery subScopeId(string subScopeId);
    
    /** Only select jobs for the given scope type. */
    TimerJobQuery scopeType(string scopeType);
    
    /** Only select tasks for the given scope definition identifier. */
    TimerJobQuery scopeDefinitionId(string scopeDefinitionId);
    
    /** Only select jobs for the given case instance. */
    TimerJobQuery caseInstanceId(string caseInstanceId);
    
    /** Only select jobs for the given case definition. */
    TimerJobQuery caseDefinitionId(string caseDefinitionId);
    
    /** Only select jobs for the given plan item instance.  */
    TimerJobQuery planItemInstanceId(string planItemInstanceId);

    /**
     * Only select jobs which are executable, ie. duedate is null or duedate is in the past
     **/
    TimerJobQuery executable();

    /** Select jobs which have given job handler type */
    TimerJobQuery handlerType(string handlerType);

    /**
     * Only select jobs that are timers. Cannot be used together with {@link #messages()}
     */
    TimerJobQuery timers();

    /**
     * Only select jobs that are messages. Cannot be used together with {@link #timers()}
     */
    TimerJobQuery messages();

    /** Only select jobs where the duedate is lower than the given date. */
    TimerJobQuery duedateLowerThan(Date date);

    /** Only select jobs where the duedate is higher then the given date. */
    TimerJobQuery duedateHigherThan(Date date);

    /** Only select jobs that failed due to an exception. */
    TimerJobQuery withException();

    /** Only select jobs that failed due to an exception with the given message. */
    TimerJobQuery exceptionMessage(string exceptionMessage);

    /**
     * Only select jobs that have the given tenant id.
     */
    TimerJobQuery jobTenantId(string tenantId);

    /**
     * Only select jobs with a tenant id like the given one.
     */
    TimerJobQuery jobTenantIdLike(string tenantIdLike);

    /**
     * Only select jobs that do not have a tenant id.
     */
    TimerJobQuery jobWithoutTenantId();

    // sorting //////////////////////////////////////////

    /**
     * Order by job id (needs to be followed by {@link #asc()} or {@link #desc()}).
     */
    TimerJobQuery orderByJobId();

    /**
     * Order by duedate (needs to be followed by {@link #asc()} or {@link #desc()}).
     */
    TimerJobQuery orderByJobDuedate();

    /**
     * Order by retries (needs to be followed by {@link #asc()} or {@link #desc()}).
     */
    TimerJobQuery orderByJobRetries();

    /**
     * Order by process instance id (needs to be followed by {@link #asc()} or {@link #desc()}).
     */
    TimerJobQuery orderByProcessInstanceId();

    /**
     * Order by execution id (needs to be followed by {@link #asc()} or {@link #desc()}).
     */
    TimerJobQuery orderByExecutionId();

    /**
     * Order by tenant id (needs to be followed by {@link #asc()} or {@link #desc()}).
     */
    TimerJobQuery orderByTenantId();

}
