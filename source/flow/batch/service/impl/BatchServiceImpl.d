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
module flow.batch.service.impl.BatchServiceImpl;

import hunt.collection.List;

import flow.batch.service.api.Batch;
import flow.batch.service.api.BatchBuilder;
import flow.batch.service.api.BatchPart;
import flow.batch.service.api.BatchQuery;
import flow.batch.service.api.BatchService;
import flow.batch.service.BatchServiceConfiguration;
import flow.batch.service.impl.persistence.entity.BatchEntity;
import flow.batch.service.impl.persistence.entity.BatchEntityManager;
import flow.batch.service.impl.persistence.entity.BatchPartEntity;
import flow.batch.service.impl.persistence.entity.BatchPartEntityManager;
import flow.common.service.CommonServiceImpl;
import flow.batch.service.impl.BatchBuilderImpl;
import flow.batch.service.impl.BatchQueryImpl;

/**
 * @author Tijs Rademakers
 */
class BatchServiceImpl : CommonServiceImpl!BatchServiceConfiguration , BatchService {

    this(BatchServiceConfiguration batchServiceConfiguration) {
        super(batchServiceConfiguration);
    }


    public BatchEntity getBatch(string id) {
        return getBatchEntityManager().findById(id);
    }


    public List!Batch findBatchesBySearchKey(string searchKey) {
        return getBatchEntityManager().findBatchesBySearchKey(searchKey);
    }


    public List!Batch getAllBatches() {
        return getBatchEntityManager().findAllBatches();
    }


    public List!Batch findBatchesByQueryCriteria(BatchQuery batchQuery) {
        return getBatchEntityManager().findBatchesByQueryCriteria(cast(BatchQueryImpl) batchQuery);
    }


    public long findBatchCountByQueryCriteria(BatchQuery batchQuery) {
        return getBatchEntityManager().findBatchCountByQueryCriteria(cast(BatchQueryImpl) batchQuery);
    }


    public BatchBuilder createBatchBuilder() {
        return new BatchBuilderImpl(this);
    }


    public void insertBatch(Batch batch) {
        getBatchEntityManager().insert(cast(BatchEntity) batch);
    }


    public Batch updateBatch(Batch batch) {
        return getBatchEntityManager().update(cast(BatchEntity) batch);
    }


    public void deleteBatch(string batchId) {
        getBatchEntityManager().dele(batchId);
    }


    public BatchPartEntity getBatchPart(string id) {
        return getBatchPartEntityManager().findById(id);
    }


    public List!BatchPart findBatchPartsByBatchId(string batchId) {
        return getBatchPartEntityManager().findBatchPartsByBatchId(batchId);
    }


    public List!BatchPart findBatchPartsByBatchIdAndStatus(string batchId, string status) {
        return getBatchPartEntityManager().findBatchPartsByBatchIdAndStatus(batchId, status);
    }


    public List!BatchPart findBatchPartsByScopeIdAndType(string scopeId, string scopeType) {
        return getBatchPartEntityManager().findBatchPartsByScopeIdAndType(scopeId, scopeType);
    }


    public BatchPart createBatchPart(Batch batch, string status, string scopeId, string subScopeId, string scopeType) {
        return getBatchPartEntityManager().createBatchPart(cast(BatchEntity) batch, status, scopeId, subScopeId, scopeType);
    }


    public BatchPart completeBatchPart(string batchPartId, string status, string resultJson) {
        return getBatchPartEntityManager().completeBatchPart(batchPartId, status, resultJson);
    }

    public Batch createBatch(BatchBuilder batchBuilder) {
        return getBatchEntityManager().createBatch(batchBuilder);
    }

    public BatchEntityManager getBatchEntityManager() {
        return configuration.getBatchEntityManager();
    }

    public BatchPartEntityManager getBatchPartEntityManager() {
        return configuration.getBatchPartEntityManager();
    }
}
