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

module flow.form.api.FormInstanceQuery;

import hunt.time.LocalDateTime;
import hunt.collection.Set;
import flow.form.api.FormInstance;

alias Date = LocalDateTime;

import flow.common.api.query.Query;

/**
 * Allows programmatic querying of {@link FormInstance}s.
 *
 * @author Tijs Rademakers
 */
interface FormInstanceQuery : Query!(FormInstanceQuery, FormInstance) {

    /**
     * Only select submitted forms with the given id.
     */
    FormInstanceQuery id(string id);

    /**
     * Only select submitted forms with the given ids.
     */
    FormInstanceQuery ids(Set!string ids);

    /**
     * Only select submitted forms with the given form definition id.
     */
    FormInstanceQuery formDefinitionId(string formDefinitionId);

    /**
     * Only select submitted forms with a form definition id like the given string.
     */
    FormInstanceQuery formDefinitionIdLike(string formDefinitionIdLike);

    /**
     * Only select submitted forms with the given task id.
     */
    FormInstanceQuery taskId(string taskId);

    /**
     * Only select submitted forms with a task id like the given string.
     */
    FormInstanceQuery taskIdLike(string taskIdLike);

    /**
     * Only select submitted forms with the given process instance id.
     */
    FormInstanceQuery processInstanceId(string processInstanceId);

    /**
     * Only select submitted forms with a process instance id like the given string.
     */
    FormInstanceQuery processInstanceIdLike(string processInstanceIdLike);

    /**
     * Only select submitted forms with the given process definition id.
     */
    FormInstanceQuery processDefinitionId(string processDefinitionId);

    /**
     * Only select submitted forms with a process definition id like the given string.
     */
    FormInstanceQuery processDefinitionIdLike(string processDefinitionIdLike);

    /**
     * Only select submitted forms with the given scope id.
     */
    FormInstanceQuery scopeId(string scopeId);

    /**
     * Only select submitted forms with the given scope type.
     */
    FormInstanceQuery scopeType(string scopeType);

    /**
     * Only select submitted forms with the given scope definition id.
     */
    FormInstanceQuery scopeDefinitionId(string scopeDefinitionId);

    /**
     * Only select submitted forms submitted on the given time
     */
    FormInstanceQuery submittedDate(Date submittedDate);

    /**
     * Only select submitted forms submitted before the given time
     */
    FormInstanceQuery submittedDateBefore(Date beforeTime);

    /**
     * Only select submitted forms submitted after the given time
     */
    FormInstanceQuery submittedDateAfter(Date afterTime);

    /**
     * Only select submitted forms with the given submitted by value.
     */
    FormInstanceQuery submittedBy(string submittedBy);

    /**
     * Only select submitted forms with a submitted by like the given string.
     */
    FormInstanceQuery submittedByLike(string submittedByLike);

    /**
     * Only select submitted forms that have the given tenant id.
     */
    FormInstanceQuery tenantId(string tenantId);

    /**
     * Only select submitted forms with a tenant id like the given one.
     */
    FormInstanceQuery tenantIdLike(string tenantIdLike);

    /**
     * Only select submitted forms that do not have a tenant id.
     */
    FormInstanceQuery withoutTenantId();

    /**
     * Only select submitted forms that do not have a task id.
     */
    FormInstanceQuery withoutTaskId();

    // sorting ////////////////////////////////////////////////////////

    /**
     * Order by submitted date (needs to be followed by {@link #asc()} or {@link #desc()}).
     */
    FormInstanceQuery orderBySubmittedDate();

    /**
     * Order by tenant id (needs to be followed by {@link #asc()} or {@link #desc()}).
     */
    FormInstanceQuery orderByTenantId();
}
