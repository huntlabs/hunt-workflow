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
module flow.batch.service.api.BatchService;

import hunt.collection.List;
import flow.batch.service.api.Batch;
import flow.batch.service.api.BatchQuery;
import flow.batch.service.api.BatchBuilder;
import flow.batch.service.api.BatchPart;
/**
 * Service which provides access to batch entities.
 *
 * @author Tijs Rademakers
 */
interface BatchService {

    Batch getBatch(string id);

    List!Batch getAllBatches();

    List!Batch findBatchesBySearchKey(string searchKey);

    List!Batch findBatchesByQueryCriteria(BatchQuery batchQuery);

    long findBatchCountByQueryCriteria(BatchQuery batchQuery);

    BatchBuilder createBatchBuilder();

    void insertBatch(Batch batch);

    Batch updateBatch(Batch batch);

    void deleteBatch(string batchId);

    BatchPart getBatchPart(string id);

    List!BatchPart findBatchPartsByBatchId(string batchId);

    List!BatchPart findBatchPartsByBatchIdAndStatus(string batchId, string status);

    List!BatchPart findBatchPartsByScopeIdAndType(string scopeId, string scopeType);

    BatchPart createBatchPart(Batch batch, string status, string scopeId, string subScopeId, string scopeType);

    BatchPart completeBatchPart(string batchPartId, string status, string resultJson);

}
