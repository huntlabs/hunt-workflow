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
module flow.batch.service.impl.persistence.entity.BatchPartEntityManager;

import hunt.collection.List;

import flow.batch.service.api.BatchPart;
import flow.common.persistence.entity.EntityManager;
import flow.batch.service.impl.persistence.entity.BatchEntity;
import flow.batch.service.impl.persistence.entity.BatchPartEntity;

interface BatchPartEntityManager : EntityManager!BatchPartEntity {

    List!BatchPart findBatchPartsByBatchId(string batchId);

    List!BatchPart findBatchPartsByBatchIdAndStatus(string batchId, string status);

    List!BatchPart findBatchPartsByScopeIdAndType(string scopeId, string scopeType);

    BatchPartEntity createBatchPart(BatchEntity parentBatch, string status, string scopeId, string subScopeId, string scopeType);

    BatchPartEntity completeBatchPart(string batchPartId, string status, string resultJson);

    void deleteBatchPartEntityAndResources(BatchPartEntity batchPartEntity);
}
