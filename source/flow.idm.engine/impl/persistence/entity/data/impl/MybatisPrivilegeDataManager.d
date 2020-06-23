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

module flow.idm.engine.impl.persistence.entity.data.impl.MybatisPrivilegeDataManager;
import hunt.collection.List;
import hunt.collection.Map;

import flow.idm.api.Privilege;
import flow.idm.engine.IdmEngineConfiguration;
import flow.idm.engine.impl.PrivilegeQueryImpl;
import flow.idm.engine.impl.persistence.entity.PrivilegeEntity;
import flow.idm.engine.impl.persistence.entity.PrivilegeEntityImpl;
import flow.idm.engine.impl.persistence.entity.data.AbstractIdmDataManager;
import flow.idm.engine.impl.persistence.entity.data.PrivilegeDataManager;
import hunt.Exceptions;
import hunt.entity;
import flow.common.AbstractEngineConfiguration;
/**
 * @author Joram Barrez
 */
class MybatisPrivilegeDataManager : EntityRepository!( PrivilegeEntityImpl , string), PrivilegeDataManager {
//class MybatisPrivilegeDataManager extends AbstractIdmDataManager<PrivilegeEntity> implements PrivilegeDataManager {

     public IdmEngineConfiguration idmEngineConfiguration;

    this(IdmEngineConfiguration idmEngineConfiguration) {
        this.idmEngineConfiguration = idmEngineConfiguration;
        super(entityManagerFactory.currentEntityManager());
       // super(idmEngineConfiguration);
    }


    public PrivilegeEntity create() {
        return new PrivilegeEntityImpl();
    }


    //class<? extends PrivilegeEntity> getManagedEntityClass() {
    //    return PrivilegeEntityImpl.class;
    //}



    public List!Privilege findPrivilegeByQueryCriteria(PrivilegeQueryImpl query) {
        implementationMissing(false);
        return null;
        //return getDbSqlSession().selectList("selectPrivilegeByQueryCriteria", query, getManagedEntityClass());
    }


    public long findPrivilegeCountByQueryCriteria(PrivilegeQueryImpl query) {
        implementationMissing(false);
        return 0;
       // return (Long) getDbSqlSession().selectOne("selectPrivilegeCountByQueryCriteria", query);
    }



    public List!Privilege findPrivilegeByNativeQuery(Map!(string, Object) parameterMap) {
        implementationMissing(false);
        return null;
        //return getDbSqlSession().selectListWithRawParameter("selectPrivilegeByNativeQuery", parameterMap);
    }


    public long findPrivilegeCountByNativeQuery(Map!(string, Object) parameterMap) {
        implementationMissing(false);
        return null;
        //return (Long) getDbSqlSession().selectOne("selectPrivilegeCountByNativeQuery", parameterMap);
    }

}
