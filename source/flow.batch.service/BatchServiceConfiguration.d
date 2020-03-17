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
module flow.batch.service.BatchServiceConfiguration;


import flow.batch.service.api.BatchService;
import flow.batch.service.impl.BatchServiceImpl;
import flow.batch.service.impl.persistence.entity.BatchByteArrayEntityManager;
import flow.batch.service.impl.persistence.entity.BatchByteArrayEntityManagerImpl;
import flow.batch.service.impl.persistence.entity.BatchEntityManager;
import flow.batch.service.impl.persistence.entity.BatchEntityManagerImpl;
import flow.batch.service.impl.persistence.entity.BatchPartEntityManager;
import flow.batch.service.impl.persistence.entity.BatchPartEntityManagerImpl;
import flow.batch.service.impl.persistence.entity.data.BatchByteArrayDataManager;
import flow.batch.service.impl.persistence.entity.data.BatchDataManager;
import flow.batch.service.impl.persistence.entity.data.BatchPartDataManager;
import flow.batch.service.impl.persistence.entity.data.impl.MybatisBatchByteArrayDataManager;
import flow.batch.service.impl.persistence.entity.data.impl.MybatisBatchDataManager;
import flow.batch.service.impl.persistence.entity.data.impl.MybatisBatchPartDataManager;
import flow.common.AbstractServiceConfiguration;

//import com.fasterxml.jackson.databind.ObjectMapper;

/**
 * @author Tijs Rademakers
 */
class BatchServiceConfiguration : AbstractServiceConfiguration {

    // SERVICES
    // /////////////////////////////////////////////////////////////////

    protected BatchService batchService ;//= new BatchServiceImpl(this);

    // DATA MANAGERS ///////////////////////////////////////////////////

    protected BatchDataManager batchDataManager;
    protected BatchPartDataManager batchPartDataManager;
    protected BatchByteArrayDataManager batchByteArrayDataManager;

    // ENTITY MANAGERS /////////////////////////////////////////////////

    protected BatchEntityManager batchEntityManager;
    protected BatchPartEntityManager batchPartEntityManager;
    protected BatchByteArrayEntityManager batchByteArrayEntityManager;

   // protected ObjectMapper objectMapper;

    this(string engineName) {
        super(engineName);
        batchService = new BatchServiceImpl(this);
    }

    // init
    // /////////////////////////////////////////////////////////////////////

    public void init() {
        initDataManagers();
        initEntityManagers();
    }

    // Data managers
    ///////////////////////////////////////////////////////////

    public void initDataManagers() {
        if (batchDataManager is null) {
            batchDataManager = new MybatisBatchDataManager();
        }
        if (batchPartDataManager is null) {
            batchPartDataManager = new MybatisBatchPartDataManager();
        }
        if (batchByteArrayDataManager is null) {
            batchByteArrayDataManager = new MybatisBatchByteArrayDataManager();
        }
    }

    public void initEntityManagers() {
        if (batchEntityManager is null) {
            batchEntityManager = new BatchEntityManagerImpl(this, batchDataManager);
        }
        if (batchPartEntityManager is null) {
            batchPartEntityManager = new BatchPartEntityManagerImpl(this, batchPartDataManager);
        }
        if (batchByteArrayEntityManager is null) {
            batchByteArrayEntityManager = new BatchByteArrayEntityManagerImpl(this, batchByteArrayDataManager);
        }
    }

    // getters and setters
    // //////////////////////////////////////////////////////

    public BatchServiceConfiguration getIdentityLinkServiceConfiguration() {
        return this;
    }

    public BatchService getBatchService() {
        return batchService;
    }

    public BatchServiceConfiguration setBatchService(BatchService batchService) {
        this.batchService = batchService;
        return this;
    }

    public BatchDataManager getBatchDataManager() {
        return batchDataManager;
    }

    public BatchServiceConfiguration setBatchDataManager(BatchDataManager batchDataManager) {
        this.batchDataManager = batchDataManager;
        return this;
    }

    public BatchPartDataManager getBatchPartDataManager() {
        return batchPartDataManager;
    }

    public BatchServiceConfiguration setBatchPartDataManager(BatchPartDataManager batchPartDataManager) {
        this.batchPartDataManager = batchPartDataManager;
        return this;
    }

    public BatchByteArrayDataManager getBatchByteArrayDataManager() {
        return batchByteArrayDataManager;
    }

    public BatchServiceConfiguration setBatchByteArrayDataManager(BatchByteArrayDataManager batchByteArrayDataManager) {
        this.batchByteArrayDataManager = batchByteArrayDataManager;
        return this;
    }

    public BatchEntityManager getBatchEntityManager() {
        return batchEntityManager;
    }

    public BatchServiceConfiguration setBatchEntityManager(BatchEntityManager batchEntityManager) {
        this.batchEntityManager = batchEntityManager;
        return this;
    }

    public BatchPartEntityManager getBatchPartEntityManager() {
        return batchPartEntityManager;
    }

    public BatchServiceConfiguration setBatchPartEntityManager(BatchPartEntityManager batchPartEntityManager) {
        this.batchPartEntityManager = batchPartEntityManager;
        return this;
    }

    public BatchByteArrayEntityManager getBatchByteArrayEntityManager() {
        return batchByteArrayEntityManager;
    }

    public BatchServiceConfiguration setBatchByteArrayEntityManager(BatchByteArrayEntityManager batchByteArrayEntityManager) {
        this.batchByteArrayEntityManager = batchByteArrayEntityManager;
        return this;
    }

    //@Override
    //public ObjectMapper getObjectMapper() {
    //    return objectMapper;
    //}
    //
    //@Override
    //public BatchServiceConfiguration setObjectMapper(ObjectMapper objectMapper) {
    //    this.objectMapper = objectMapper;
    //    return this;
    //}
}
