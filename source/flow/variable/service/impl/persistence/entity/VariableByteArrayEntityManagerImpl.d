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

module flow.variable.service.impl.persistence.entity.VariableByteArrayEntityManagerImpl;

import hunt.collection.List;

import flow.common.persistence.entity.AbstractServiceEngineEntityManager;
import flow.variable.service.VariableServiceConfiguration;
import flow.variable.service.impl.persistence.entity.data.VariableByteArrayDataManager;
import flow.variable.service.impl.persistence.entity.VariableByteArrayEntity;
import flow.variable.service.impl.persistence.entity.VariableByteArrayEntityManager;

/**
 * @author Joram Barrez
 * @author Marcus Klimstra (CGI)
 */
class VariableByteArrayEntityManagerImpl
    : AbstractServiceEngineEntityManager!(VariableServiceConfiguration, VariableByteArrayEntity, VariableByteArrayDataManager)
    , VariableByteArrayEntityManager {

    this(VariableServiceConfiguration variableServiceConfiguration, VariableByteArrayDataManager byteArrayDataManager) {
        super(variableServiceConfiguration, byteArrayDataManager);
    }


    public List!VariableByteArrayEntity findAll() {
        return dataManager.findAll();
    }


    public void deleteByteArrayById(string byteArrayEntityId) {
        dataManager.deleteByteArrayNoRevisionCheck(byteArrayEntityId);
    }

}
