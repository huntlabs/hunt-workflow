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
module flow.idm.engine.impl.persistence.entity.data.impl.MybatisPrivilegeMappingDataManager;

import hunt.collection.HashMap;
import hunt.collection.List;
import hunt.collection.Map;

import flow.idm.api.PrivilegeMapping;
import flow.idm.engine.IdmEngineConfiguration;
import flow.idm.engine.impl.persistence.entity.PrivilegeMappingEntity;
import flow.idm.engine.impl.persistence.entity.PrivilegeMappingEntityImpl;
import flow.idm.engine.impl.persistence.entity.data.AbstractIdmDataManager;
import flow.idm.engine.impl.persistence.entity.data.PrivilegeMappingDataManager;
import hunt.entity;
import hunt.Exceptions;
import flow.common.AbstractEngineConfiguration;

class MybatisPrivilegeMappingDataManager : EntityRepository!( PrivilegeMappingEntityImpl , string), PrivilegeMappingDataManager {
//class MybatisPrivilegeMappingDataManager extends AbstractIdmDataManager<PrivilegeMappingEntity> implements PrivilegeMappingDataManager {

    public IdmEngineConfiguration idmEngineConfiguration;

    this(IdmEngineConfiguration idmEngineConfiguration) {
       // super(idmEngineConfiguration);
        this.idmEngineConfiguration = idmEngineConfiguration;
        super(entityManagerFactory.currentEntityManager());
    }


    public PrivilegeMappingEntity create() {
        return new PrivilegeMappingEntityImpl();
    }


    //class<? extends PrivilegeMappingEntity> getManagedEntityClass() {
    //    return PrivilegeMappingEntityImpl.class;
    //}


    public void deleteByPrivilegeId(string privilegeId) {
        implementationMissing(false);
       // getDbSqlSession().delete("deleteByPrivilegeId", privilegeId, getManagedEntityClass());
    }


    public void deleteByPrivilegeIdAndUserId(string privilegeId, string userId) {
        implementationMissing(false);
        //Map<string, string> params = new HashMap<>();
        //params.put("privilegeId", privilegeId);
        //params.put("userId", userId);
        //getDbSqlSession().delete("deleteByPrivilegeIdAndUserId", params, getManagedEntityClass());
    }


    public void deleteByPrivilegeIdAndGroupId(string privilegeId, string groupId) {
        implementationMissing(false);
        //Map<string, string> params = new HashMap<>();
        //params.put("privilegeId", privilegeId);
        //params.put("groupId", groupId);
        //getDbSqlSession().delete("deleteByPrivilegeIdAndGroupId", params, getManagedEntityClass());
    }


    public List!PrivilegeMapping getPrivilegeMappingsByPrivilegeId(string privilegeId) {
        implementationMissing(false);
        return null;
       // return (List<PrivilegeMapping>) getDbSqlSession().selectList("selectPrivilegeMappingsByPrivilegeId", privilegeId);
    }

}
