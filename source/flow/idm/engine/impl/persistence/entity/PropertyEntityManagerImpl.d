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

module flow.idm.engine.impl.persistence.entity.PropertyEntityManagerImpl;


import hunt.collection.List;

import flow.idm.engine.IdmEngineConfiguration;
import flow.idm.engine.impl.persistence.entity.data.PropertyDataManager;
import flow.idm.engine.impl.persistence.entity.AbstractIdmEngineEntityManager;
import flow.idm.engine.impl.persistence.entity.IdmPropertyEntity;
import flow.idm.engine.impl.persistence.entity.PropertyEntityManager;
/**
 * @author Tijs Rademakers
 * @author Joram Barrez
 */
class PropertyEntityManagerImpl
    : AbstractIdmEngineEntityManager!(IdmPropertyEntity, PropertyDataManager)
    , PropertyEntityManager {

    this(IdmEngineConfiguration idmEngineConfiguration, PropertyDataManager propertyDataManager) {
        super(idmEngineConfiguration, propertyDataManager);
    }

    public List!IdmPropertyEntity findAll() {
        return dataManager.findAll();
    }

}
