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
module flow.engine.impl.persistence.entity.data.impl.MybatisModelDataManager;

import hunt.collection.List;
import hunt.collection.Map;

import flow.engine.impl.ModelQueryImpl;
import flow.engine.impl.cfg.ProcessEngineConfigurationImpl;
import flow.engine.impl.persistence.entity.ModelEntity;
import flow.engine.impl.persistence.entity.ModelEntityImpl;
import flow.engine.impl.persistence.entity.data.AbstractProcessDataManager;
import flow.engine.impl.persistence.entity.data.ModelDataManager;

import hunt.entity;
import hunt.Exceptions;
import flow.common.AbstractEngineConfiguration;
import flow.common.runtime.Clockm;
/**
 * @author Joram Barrez
 */
//EntityRepository!( HistoricIdentityLinkEntityImpl , string
//class MybatisModelDataManager : AbstractProcessDataManager!ModelEntity implements ModelDataManager {
class MybatisModelDataManager : EntityRepository!( ModelEntityImpl , string) , ModelDataManager {
  import flow.engine.repository.Model;
   private ProcessEngineConfigurationImpl processEngineConfiguration;


    public ProcessEngineConfigurationImpl getProcessEngineConfiguration() {
      return processEngineConfiguration;
    }

    public Clockm getClock() {
      return processEngineConfiguration.getClock();
    }

    this(ProcessEngineConfigurationImpl processEngineConfiguration) {
        this.processEngineConfiguration = processEngineConfiguration;
    }

    //
    //class<? : ModelEntity> getManagedEntityClass() {
    //    return ModelEntityImpl.class;
    //}

  public ModelEntity findById(string entityId) {
    if (entityId is null) {
      return null;
    }

    return find(entityId);
  }
  //
  public void insert(ModelEntity entity) {
    insert(cast(ModelEntityImpl)entity);
    //getDbSqlSession().insert(entity);
  }
  public ModelEntity update(ModelEntity entity) {
    return  update(cast(ModelEntityImpl)entity);
    //getDbSqlSession().update(entity);
    //return entity;
  }
  public void dele(string id) {
    ModelEntity entity = findById(id);
    if (entity !is null)
    {
      remove(cast(ModelEntityImpl)entity);
    }
    //delete(entity);
  }

  public void dele(ModelEntity entity) {
    if (entity !is null)
    {
      remove(cast(ModelEntityImpl)entity);
    }
    //getDbSqlSession().delete(entity);
  }

    public ModelEntity create() {
        return new ModelEntityImpl();
    }


    public List!Model findModelsByQueryCriteria(ModelQueryImpl query) {
        implementationMissing(false);
        return null;
        //return getDbSqlSession().selectList("selectModelsByQueryCriteria", query);
    }


    public long findModelCountByQueryCriteria(ModelQueryImpl query) {
        implementationMissing(false);
        return 0;
       // return (Long) getDbSqlSession().selectOne("selectModelCountByQueryCriteria", query);
    }


    public List!Model findModelsByNativeQuery(Map!(string, Object) parameterMap) {
        implementationMissing(false);
        return null;
       // return getDbSqlSession().selectListWithRawParameter("selectModelByNativeQuery", parameterMap);
    }


    public long findModelCountByNativeQuery(Map!(string, Object) parameterMap) {
        implementationMissing(false);
        return 0;
      //  return (Long) getDbSqlSession().selectOne("selectModelCountByNativeQuery", parameterMap);
    }

}
