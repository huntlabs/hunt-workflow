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

module flow.batch.service.impl.persistence.entity.BatchByteArrayEntityManagerImpl;

import hunt.collection.List;

import flow.batch.service.BatchServiceConfiguration;
import flow.batch.service.impl.persistence.entity.data.BatchByteArrayDataManager;
import flow.common.persistence.entity.AbstractServiceEngineEntityManager;
import flow.batch.service.impl.persistence.entity.BatchByteArrayEntity;
import flow.batch.service.impl.persistence.entity.BatchByteArrayEntityManager;
/**
 * @author Joram Barrez
 * @author Marcus Klimstra (CGI)
 */
class BatchByteArrayEntityManagerImpl
    : AbstractServiceEngineEntityManager!(BatchServiceConfiguration, BatchByteArrayEntity, BatchByteArrayDataManager)
    , BatchByteArrayEntityManager {

    this(BatchServiceConfiguration batchServiceConfiguration, BatchByteArrayDataManager byteArrayDataManager) {
        super(batchServiceConfiguration, byteArrayDataManager);
    }


    public List!BatchByteArrayEntity findAll() {
        return dataManager.findAll();
    }


    public void deleteByteArrayById(string byteArrayEntityId) {
        dataManager.deleteByteArrayNoRevisionCheck(byteArrayEntityId);
    }

}
