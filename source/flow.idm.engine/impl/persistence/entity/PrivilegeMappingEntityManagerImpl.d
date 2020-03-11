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

module flow.idm.engine.impl.persistence.entity.PrivilegeMappingEntityManagerImpl;

import hunt.collection.List;

import flow.idm.api.PrivilegeMapping;
import flow.idm.engine.IdmEngineConfiguration;
import flow.idm.engine.impl.persistence.entity.data.PrivilegeMappingDataManager;
import flow.idm.engine.impl.persistence.entity.AbstractIdmEngineEntityManager;
import flow.idm.engine.impl.persistence.entity.PrivilegeMappingEntity;
import flow.idm.engine.impl.persistence.entity.PrivilegeMappingEntityManager;

class PrivilegeMappingEntityManagerImpl
    : AbstractIdmEngineEntityManager!(PrivilegeMappingEntity, PrivilegeMappingDataManager)
    , PrivilegeMappingEntityManager {

    this(IdmEngineConfiguration idmEngineConfiguration, PrivilegeMappingDataManager privilegeMappingDataManager) {
        super(idmEngineConfiguration, privilegeMappingDataManager);
    }


    public void deleteByPrivilegeId(string privilegeId) {
        dataManager.deleteByPrivilegeId(privilegeId);
    }


    public void deleteByPrivilegeIdAndUserId(string privilegeId, string userId) {
        dataManager.deleteByPrivilegeIdAndUserId(privilegeId, userId);
    }


    public void deleteByPrivilegeIdAndGroupId(string privilegeId, string groupId) {
        dataManager.deleteByPrivilegeIdAndGroupId(privilegeId, groupId);
    }


    public List!PrivilegeMapping getPrivilegeMappingsByPrivilegeId(string privilegeId) {
        return dataManager.getPrivilegeMappingsByPrivilegeId(privilegeId);
    }

}
