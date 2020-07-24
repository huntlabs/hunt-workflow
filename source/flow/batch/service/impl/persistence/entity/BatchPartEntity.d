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

module flow.batch.service.impl.persistence.entity.BatchPartEntity;
import hunt.time.LocalDateTime;

import flow.batch.service.api.BatchPart;
import flow.common.db.HasRevision;
import flow.common.persistence.entity.Entity;
import flow.batch.service.impl.persistence.entity.BatchByteArrayRef;
import flow.common.persistence.entity.Entity;

interface BatchPartEntity : BatchPart, Entity, HasRevision {

    void setBatchType(string batchType);

    void setBatchId(string batchId);

    void setCreateTime(Date createTime);

    void setCompleteTime(Date completeTime);

    bool isCompleted();

    void setBatchSearchKey(string searchKey);

    void setBatchSearchKey2(string searchKey);

    void setStatus(string status);

    void setScopeId(string scopeId);

    void setScopeType(string scopeType);

    void setSubScopeId(string subScopeId);

    BatchByteArrayRef getResultDocRefId();

    void setResultDocumentJson(string resultDocumentJson);

    void setTenantId(string tenantId);
}

