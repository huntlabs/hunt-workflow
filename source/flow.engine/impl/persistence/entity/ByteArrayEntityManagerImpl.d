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

module flow.engine.impl.persistence.entity.ByteArrayEntityManagerImpl;

import hunt.collection.List;

import flow.engine.impl.cfg.ProcessEngineConfigurationImpl;
import flow.engine.impl.persistence.entity.data.ByteArrayDataManager;
import flow.engine.impl.persistence.entity.AbstractProcessEngineEntityManager;
import flow.engine.impl.persistence.entity.ByteArrayEntityManager;
import flow.engine.impl.persistence.entity.ByteArrayEntity;

/**
 * @author Joram Barrez
 * @author Marcus Klimstra (CGI)
 */
class ByteArrayEntityManagerImpl
    : AbstractProcessEngineEntityManager!(ByteArrayEntity, ByteArrayDataManager)
    , ByteArrayEntityManager {

    this(ProcessEngineConfigurationImpl processEngineConfiguration, ByteArrayDataManager byteArrayDataManager) {
        super(processEngineConfiguration, byteArrayDataManager);
    }

    public List!ByteArrayEntity findAll() {
        return dataManager.findAll();
    }

    public void deleteByteArrayById(string byteArrayEntityId) {
        dataManager.deleteByteArrayNoRevisionCheck(byteArrayEntityId);
    }

}
