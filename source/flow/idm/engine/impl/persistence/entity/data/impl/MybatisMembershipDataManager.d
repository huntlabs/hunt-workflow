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

module flow.idm.engine.impl.persistence.entity.data.impl.MybatisMembershipDataManager;

import hunt.collection.HashMap;
import hunt.collection.Map;

import flow.idm.engine.IdmEngineConfiguration;
import flow.idm.engine.impl.persistence.entity.MembershipEntity;
import flow.idm.engine.impl.persistence.entity.MembershipEntityImpl;
import flow.idm.engine.impl.persistence.entity.data.AbstractIdmDataManager;
import flow.idm.engine.impl.persistence.entity.data.MembershipDataManager;
import hunt.Exceptions;
import hunt.entity;
import flow.common.AbstractEngineConfiguration;
/**
 * @author Joram Barrez
 */
class MybatisMembershipDataManager : EntityRepository!( MembershipEntityImpl , string), MembershipDataManager {
//class MybatisMembershipDataManager extends AbstractIdmDataManager<MembershipEntity> implements MembershipDataManager {

    alias insert = CrudRepository!( MembershipEntityImpl , string).insert;
    alias update = CrudRepository!( MembershipEntityImpl , string).update;

    public IdmEngineConfiguration idmEngineConfiguration;

    this(IdmEngineConfiguration idmEngineConfiguration) {
        this.idmEngineConfiguration = idmEngineConfiguration;
        super(entityManagerFactory.currentEntityManager());
        //super(idmEngineConfiguration);
    }

    //
    //class<? extends MembershipEntity> getManagedEntityClass() {
    //    return MembershipEntityImpl.class;
    //}

    public void insert(MembershipEntity entity) {
      insert(cast(MembershipEntityImpl)entity);
      //getDbSqlSession().insert(entity);
    }
    //
    //@Override
    public MembershipEntity update(MembershipEntity entity) {
      return  update(cast(MembershipEntityImpl)entity);
      //getDbSqlSession().update(entity);
      //return entity;
    }

    public void dele(MembershipEntity entity) {
      if (entity !is null)
      {
        remove(cast(MembershipEntityImpl)entity);
      }
      //getDbSqlSession().delete(entity);
    }

    //
    //@Override
    public void dele(string id) {
      MembershipEntity entity = findById(id);
      if (entity !is null)
      {
        remove(cast(MembershipEntityImpl)entity);
      }
      //delete(entity);
    }


    public MembershipEntity create() {
        return new MembershipEntityImpl();
    }


    public void deleteMembership(string userId, string groupId) {
        implementationMissing(false);
        //Map!(string, Object) parameters = new HashMap<>();
        //parameters.put("userId", userId);
        //parameters.put("groupId", groupId);
        //getDbSqlSession().delete("deleteMembership", parameters, getManagedEntityClass());
    }


    public void deleteMembershipByGroupId(string groupId) {
        implementationMissing(false);
        //getDbSqlSession().delete("deleteMembershipsByGroupId", groupId, getManagedEntityClass());
    }


    public void deleteMembershipByUserId(string userId) {
        implementationMissing(false);
       // getDbSqlSession().delete("deleteMembershipsByUserId", userId, getManagedEntityClass());
    }

}
