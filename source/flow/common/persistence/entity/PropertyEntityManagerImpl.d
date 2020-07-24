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

module flow.common.persistence.entity.PropertyEntityManagerImpl;

import hunt.collection.List;

import flow.common.AbstractEngineConfiguration;
import flow.common.persistence.entity.data.PropertyDataManager;
import flow.common.persistence.entity.AbstractEngineEntityManager;
import flow.common.persistence.entity.PropertyEntityManager;
import flow.common.persistence.entity.PropertyEntity;
/**
 * @author Tom Baeyens
 * @author Joram Barrez
 */
class PropertyEntityManagerImpl
    : AbstractEngineEntityManager!(AbstractEngineConfiguration, PropertyEntity, PropertyDataManager)
    , PropertyEntityManager {

    this(AbstractEngineConfiguration engineConfiguration, PropertyDataManager propertyDataManager) {
        super(engineConfiguration, propertyDataManager);
    }

    public List!PropertyEntity findAll() {
        return dataManager.findAll();
    }

    void upDateDbid(string id) {
        dataManager.upDateDbid(id);
    }

}
