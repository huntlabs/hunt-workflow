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

module flow.batch.service.impl.persistence.entity.BatchEntityManagerImpl;

import hunt.collection.List;

import flow.batch.service.api.Batch;
import flow.batch.service.api.BatchBuilder;
import flow.batch.service.api.BatchPart;
import flow.batch.service.BatchServiceConfiguration;
import flow.batch.service.impl.BatchQueryImpl;
import flow.batch.service.impl.persistence.entity.data.BatchDataManager;
import flow.common.persistence.entity.AbstractServiceEngineEntityManager;
import flow.batch.service.impl.persistence.entity.BatchEntity;
import flow.batch.service.impl.persistence.entity.BatchEntityManager;
import flow.batch.service.impl.persistence.entity.BatchPartEntityManager;
import flow.batch.service.impl.persistence.entity.BatchByteArrayRef;
import flow.batch.service.impl.persistence.entity.BatchEntityImpl;
import flow.batch.service.impl.persistence.entity.BatchPartEntity;

class BatchEntityManagerImpl
    : AbstractServiceEngineEntityManager!(BatchServiceConfiguration, BatchEntity, BatchDataManager)
    , BatchEntityManager {

    this(BatchServiceConfiguration batchServiceConfiguration, BatchDataManager batchDataManager) {
        super(batchServiceConfiguration, batchDataManager);
    }


    public List!Batch findBatchesBySearchKey(string searchKey) {
        return dataManager.findBatchesBySearchKey(searchKey);
    }


    public List!Batch findAllBatches() {
        return dataManager.findAllBatches();
    }


    public List!Batch findBatchesByQueryCriteria(BatchQueryImpl batchQuery) {
        return dataManager.findBatchesByQueryCriteria(batchQuery);
    }


    public long findBatchCountByQueryCriteria(BatchQueryImpl batchQuery) {
        return dataManager.findBatchCountByQueryCriteria(batchQuery);
    }


    public BatchEntity createBatch(BatchBuilder batchBuilder) {
        BatchEntityImpl batchEntity = cast(BatchEntityImpl) dataManager.create();
        batchEntity.setBatchType(batchBuilder.getBatchType());
        batchEntity.setBatchSearchKey(batchBuilder.getSearchKey());
        batchEntity.setBatchSearchKey2(batchBuilder.getSearchKey2());
        batchEntity.setCreateTime(getClock().getCurrentTime());
        batchEntity.setStatus(batchBuilder.getStatus());
        batchEntity.setBatchDocumentJson(batchBuilder.getBatchDocumentJson());
        batchEntity.setTenantId(batchBuilder.getTenantId());

        dataManager.insert(batchEntity);

        return batchEntity;
    }


    public void dele(string batchId) {
        BatchEntity batch = dataManager.findById(batchId);
        List!BatchPart batchParts = getBatchPartEntityManager().findBatchPartsByBatchId(batch.getId());
        if (batchParts !is null && batchParts.size() > 0) {
            foreach (BatchPart batchPart ; batchParts) {
                getBatchPartEntityManager().deleteBatchPartEntityAndResources(cast(BatchPartEntity) batchPart);
            }
        }

        BatchByteArrayRef batchDocRefId = batch.getBatchDocRefId();

        if (batchDocRefId !is null && batchDocRefId.getId() !is null) {
            batchDocRefId.dele();
        }

        dele(batch);
    }

    protected BatchPartEntityManager getBatchPartEntityManager() {
        return serviceConfiguration.getBatchPartEntityManager();
    }
}
