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

module flow.batch.service.impl.persistence.entity.BatchPartEntityManagerImpl;

import hunt.collection.List;

import flow.batch.service.impl.persistence.entity.BatchEntity;
import flow.batch.service.api.BatchPart;
import flow.batch.service.BatchServiceConfiguration;
import flow.batch.service.impl.persistence.entity.data.BatchPartDataManager;
import flow.common.persistence.entity.AbstractServiceEngineEntityManager;
import flow.batch.service.impl.persistence.entity.BatchPartEntity;
import flow.batch.service.impl.persistence.entity.BatchPartEntityManager;
import flow.batch.service.impl.persistence.entity.BatchByteArrayRef;

class BatchPartEntityManagerImpl
    : AbstractServiceEngineEntityManager!(BatchServiceConfiguration, BatchPartEntity, BatchPartDataManager)
    , BatchPartEntityManager {

    this(BatchServiceConfiguration batchServiceConfiguration, BatchPartDataManager batchPartDataManager) {
        super(batchServiceConfiguration, batchPartDataManager);
    }


    public List!BatchPart findBatchPartsByBatchId(string batchId) {
        return dataManager.findBatchPartsByBatchId(batchId);
    }


    public List!BatchPart findBatchPartsByBatchIdAndStatus(string batchId, string status) {
        return dataManager.findBatchPartsByBatchIdAndStatus(batchId, status);
    }


    public List!BatchPart findBatchPartsByScopeIdAndType(string scopeId, string scopeType) {
        return dataManager.findBatchPartsByScopeIdAndType(scopeId, scopeType);
    }


    public BatchPartEntity createBatchPart(BatchEntity parentBatch, string status, string scopeId, string subScopeId, string scopeType) {
        BatchPartEntity batchPartEntity = dataManager.create();
        batchPartEntity.setBatchId(parentBatch.getId());
        batchPartEntity.setBatchType(parentBatch.getBatchType());
        batchPartEntity.setScopeId(scopeId);
        batchPartEntity.setSubScopeId(subScopeId);
        batchPartEntity.setScopeType(scopeType);
        batchPartEntity.setBatchSearchKey(parentBatch.getBatchSearchKey());
        batchPartEntity.setBatchSearchKey2(parentBatch.getBatchSearchKey2());
        batchPartEntity.setStatus(status);
        batchPartEntity.setCreateTime(getClock().getCurrentTime());
        insert(batchPartEntity);

        return batchPartEntity;
    }


    public BatchPartEntity completeBatchPart(string batchPartId, string status, string resultJson) {
        BatchPartEntity batchPartEntity = getBatchPartEntityManager().findById(batchPartId);
        batchPartEntity.setCompleteTime(getClock().getCurrentTime());
        batchPartEntity.setStatus(status);
        batchPartEntity.setResultDocumentJson(resultJson);

        return batchPartEntity;
    }


    public void deleteBatchPartEntityAndResources(BatchPartEntity batchPartEntity) {
        BatchByteArrayRef resultDocRefId = batchPartEntity.getResultDocRefId();

        if (resultDocRefId !is null && resultDocRefId.getId() !is null) {
            resultDocRefId.dele();
        }

        dele(batchPartEntity);
    }

    protected BatchPartEntityManager getBatchPartEntityManager() {
        return serviceConfiguration.getBatchPartEntityManager();
    }
}
