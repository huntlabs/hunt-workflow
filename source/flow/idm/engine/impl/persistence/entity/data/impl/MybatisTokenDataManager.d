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
module flow.idm.engine.impl.persistence.entity.data.impl.MybatisTokenDataManager;

import hunt.collection.List;
import hunt.collection.Map;

import flow.idm.api.Token;
import flow.idm.engine.IdmEngineConfiguration;
import flow.idm.engine.impl.TokenQueryImpl;
import flow.idm.engine.impl.persistence.entity.TokenEntity;
import flow.idm.engine.impl.persistence.entity.TokenEntityImpl;
import flow.idm.engine.impl.persistence.entity.data.AbstractIdmDataManager;
import flow.idm.engine.impl.persistence.entity.data.TokenDataManager;
import hunt.entity;
import hunt.Exceptions;
import flow.common.AbstractEngineConfiguration;
/**
 * @author Tijs Rademakers
 */
class MybatisTokenDataManager : EntityRepository!( TokenEntityImpl , string) , TokenDataManager {
//class MybatisTokenDataManager extends AbstractIdmDataManager<TokenEntity> implements TokenDataManager {

    public IdmEngineConfiguration idmEngineConfiguration;

    alias insert = CrudRepository!( TokenEntityImpl , string).insert;
    alias update = CrudRepository!( TokenEntityImpl , string).update;
    this(IdmEngineConfiguration idmEngineConfiguration) {
       // super(idmEngineConfiguration);
      this.idmEngineConfiguration =  idmEngineConfiguration;
      super(entityManagerFactory.currentEntityManager());

    }

    //@Override
    //class<? extends TokenEntity> getManagedEntityClass() {
    //    return TokenEntityImpl.class;
    //}

    public void insert(TokenEntity entity) {
      insert(cast(TokenEntityImpl)entity);
      //getDbSqlSession().insert(entity);
    }
    //
    //@Override
    public TokenEntity update(TokenEntity entity) {
      return  update(cast(TokenEntityImpl)entity);
      //getDbSqlSession().update(entity);
      //return entity;
    }

    public void dele(TokenEntity entity) {
      if (entity !is null)
      {
        remove(cast(TokenEntityImpl)entity);
      }
      //getDbSqlSession().delete(entity);
    }

    //
    //@Override
    public void dele(string id) {
      TokenEntity entity = findById(id);
      if (entity !is null)
      {
        remove(cast(TokenEntityImpl)entity);
      }
      //delete(entity);
    }


    public TokenEntity create() {
        return new TokenEntityImpl();
    }



    public List!Token findTokenByQueryCriteria(TokenQueryImpl query) {
        implementationMissing(false);
         return null;
       // return getDbSqlSession().selectList("selectTokenByQueryCriteria", query, getManagedEntityClass());
    }


    public long findTokenCountByQueryCriteria(TokenQueryImpl query) {
        //return (Long) getDbSqlSession().selectOne("selectTokenCountByQueryCriteria", query);
        implementationMissing(false);
        return 0;
    }



    public List!Token findTokensByNativeQuery(Map!(string, Object) parameterMap) {
        implementationMissing(false);
        return null;
        //return getDbSqlSession().selectListWithRawParameter("selectTokenByNativeQuery", parameterMap);
    }


    public long findTokenCountByNativeQuery(Map!(string, Object) parameterMap) {
        implementationMissing(false);
        return 0;
        //return (Long) getDbSqlSession().selectOne("selectTokenCountByNativeQuery", parameterMap);
    }
}
