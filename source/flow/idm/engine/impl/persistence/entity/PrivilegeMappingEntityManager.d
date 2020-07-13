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
module flow.idm.engine.impl.persistence.entity.PrivilegeMappingEntityManager;

import hunt.collection.List;

import flow.common.persistence.entity.EntityManager;
import flow.idm.api.PrivilegeMapping;
import flow.idm.engine.impl.persistence.entity.PrivilegeMappingEntity;

interface PrivilegeMappingEntityManager : EntityManager!PrivilegeMappingEntity {

    void deleteByPrivilegeId(string privilegeId);

    void deleteByPrivilegeIdAndUserId(string privilegeId, string userId);

    void deleteByPrivilegeIdAndGroupId(string privilegeId, string groupId);

    List!PrivilegeMapping getPrivilegeMappingsByPrivilegeId(string privilegeId);

}
