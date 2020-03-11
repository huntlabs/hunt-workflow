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

module flow.idm.engine.impl.persistence.entity.data.impl.MybatisGroupDataManager;
import hunt.collection.List;
import hunt.collection.Map;

import flow.idm.api.Group;
import flow.idm.engine.IdmEngineConfiguration;
import flow.idm.engine.impl.GroupQueryImpl;
import flow.idm.engine.impl.persistence.entity.GroupEntity;
import flow.idm.engine.impl.persistence.entity.GroupEntityImpl;
import flow.idm.engine.impl.persistence.entity.data.AbstractIdmDataManager;
import flow.idm.engine.impl.persistence.entity.data.GroupDataManager;
import hunt.entity;
import hunt.Exceptions;
import flow.common.AbstractEngineConfiguration;
/**
 * @author Joram Barrez
 */

class MybatisGroupDataManager : EntityRepository!( GroupEntityImpl , string) , GroupDataManager {
//class MybatisGroupDataManager extends AbstractIdmDataManager<GroupEntity> implements GroupDataManager {

    public IdmEngineConfiguration idmEngineConfiguration;

    this(IdmEngineConfiguration idmEngineConfiguration) {
        //super(idmEngineConfiguration);
        this.idmEngineConfiguration = idmEngineConfiguration;
        super(entityManagerFactory.createEntityManager());
    }

    //
    //class<? extends GroupEntity> getManagedEntityClass() {
    //    return GroupEntityImpl.class;
    //}


    public GroupEntity create() {
        return new GroupEntityImpl();
    }



    public List!Group findGroupByQueryCriteria(GroupQueryImpl query) {
        implementationMissing(false);
        return false;
        //return getDbSqlSession().selectList("selectGroupByQueryCriteria", query, getManagedEntityClass());
    }


    public long findGroupCountByQueryCriteria(GroupQueryImpl query) {
        implementationMissing(false);
        return 0;
       // return (Long) getDbSqlSession().selectOne("selectGroupCountByQueryCriteria", query);
    }



    public List!Group findGroupsByUser(String userId) {
        implementationMissing(false);
        return null;
       // return getDbSqlSession().selectList("selectGroupsByUserId", userId);
    }



    public List!Group findGroupsByPrivilegeId(String privilegeId) {
        implementationMissing(false);
        return null;
       // return getDbSqlSession().selectList("selectGroupsWithPrivilegeId", privilegeId);
    }



    public List!Group findGroupsByNativeQuery(Map!(string, Object) parameterMap) {
        implementationMissing(false);
        return null;
        //return getDbSqlSession().selectListWithRawParameter("selectGroupByNativeQuery", parameterMap);
    }


    public long findGroupCountByNativeQuery(Map!(string, Object) parameterMap) {
        implementationMissing(false);
        return 0;
        //return (Long) getDbSqlSession().selectOne("selectGroupCountByNativeQuery", parameterMap);
    }

}
