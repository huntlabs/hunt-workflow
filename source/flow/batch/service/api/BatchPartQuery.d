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

module flow.batch.service.api.BatchPartQuery;

import flow.common.api.query.Query;
import flow.batch.service.api.Batch;

interface BatchPartQuery : Query!(BatchPartQuery, Batch) {

    /** Only select batches with the given id */
    BatchPartQuery batchId(string batchId);

    /** Only select batches which exist for the given type. **/
    BatchPartQuery batchType(string batchType);

    /** Only select batches which exist for the given search key. **/
    BatchPartQuery searchKey(string searchKey);

    /** Only select batches which exist for the given search key. **/
    BatchPartQuery searchKey2(string searchKey2);

    /** Only select batches which exist for the given scope id. **/
    BatchPartQuery scopeId(string scopeId);

    /** Only select batches which exist for the given sub scope id. **/
    BatchPartQuery subScopeId(string subScopeId);

    /** Only select batches which exist for the given scope type. **/
    BatchPartQuery scopeType(string scopeType);

    /** Only select batches which exist for the given tenant id. **/
    BatchPartQuery tenantId(string tenantId);

    /** Only select batches with a tenant id like the given one. **/
    BatchPartQuery tenantIdLike(string tenantIdLike);

    /** Only select batches that do not have a tenant id. **/
    BatchPartQuery withoutTenantId();

    // sorting //////////////////////////////////////////

    /**
     * Order by batch id (needs to be followed by {@link #asc()} or {@link #desc()}).
     */
    BatchPartQuery orderByBatchId();

    /**
     * Order by batch create time (needs to be followed by {@link #asc()} or {@link #desc()}).
     */
    BatchPartQuery orderByBatchCreateTime();

    /**
     * Order by batch create time (needs to be followed by {@link #asc()} or {@link #desc()}).
     */
    BatchPartQuery orderByBatchTenantId();

}
