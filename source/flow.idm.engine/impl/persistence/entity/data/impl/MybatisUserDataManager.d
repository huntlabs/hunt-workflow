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

module flow.idm.engine.impl.persistence.entity.data.impl.MybatisUserDataManager;

import hunt.collection.List;
import hunt.collection.Map;

import flow.idm.api.User;
import flow.idm.engine.IdmEngineConfiguration;
import flow.idm.engine.impl.UserQueryImpl;
import flow.idm.engine.impl.persistence.entity.UserEntity;
import flow.idm.engine.impl.persistence.entity.UserEntityImpl;
import flow.idm.engine.impl.persistence.entity.data.AbstractIdmDataManager;
import flow.idm.engine.impl.persistence.entity.data.UserDataManager;
import hunt.entity;
import hunt.Exceptions;
import flow.common.AbstractEngineConfiguration;

/**
 * @author Joram Barrez
 */
class MybatisUserDataManager  : EntityRepository!( UserEntityImpl , string),  UserDataManager {
//class MybatisUserDataManager : AbstractIdmDataManager<UserEntity> implements UserDataManager {

    public IdmEngineConfiguration idmEngineConfiguration;

    this(IdmEngineConfiguration idmEngineConfiguration) {
        this.idmEngineConfiguration = idmEngineConfiguration;
       // super(idmEngineConfiguration);
        super(entityManagerFactory.currentEntityManager());
    }

    //
    //class<? extends UserEntity> getManagedEntityClass() {
    //    return UserEntityImpl.class;
    //}


    public UserEntity create() {
        return new UserEntityImpl();
    }



    public List!User findUserByQueryCriteria(UserQueryImpl query) {
        implementationMissing(false);
        return null;
       // return getDbSqlSession().selectList("selectUserByQueryCriteria", query, getManagedEntityClass());
    }


    public long findUserCountByQueryCriteria(UserQueryImpl query) {
        implementationMissing(false);
        return 0;
        //return (Long) getDbSqlSession().selectOne("selectUserCountByQueryCriteria", query);
    }



    public List!User findUsersByPrivilegeId(string privilegeId) {
        implementationMissing(false);
        return null;
      //return getDbSqlSession().selectList("selectUsersWithPrivilegeId", privilegeId);
    }



    public List!User findUsersByNativeQuery(Map!(string, Object) parameterMap) {
        implementationMissing(false);
        return null;
      // return getDbSqlSession().selectListWithRawParameter("selectUserByNativeQuery", parameterMap);
    }


    public long findUserCountByNativeQuery(Map!(string, Object) parameterMap) {
        implementationMissing(false);
        return 0;
        //return (Long) getDbSqlSession().selectOne("selectUserCountByNativeQuery", parameterMap);
    }

}
