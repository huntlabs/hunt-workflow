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
module flow.common.persistence.entity.data.impl.MybatisPropertyDataManager;

import hunt.collection.List;
import hunt.collection.ArrayList;
import flow.common.db.AbstractDataManager;
import flow.common.persistence.entity.PropertyEntity;
import flow.common.persistence.entity.PropertyEntityImpl;
import flow.common.persistence.entity.data.PropertyDataManager;
import hunt.entity;
import flow.common.persistence.entity.data.DataManager;
import flow.common.AbstractEngineConfiguration;
import flow.engine.impl.util.CommandContextUtil;
import flow.common.persistence.entity.Entity;
import flow.common.interceptor.CommandContext;
import flow.common.api.DataManger;
import flow.common.context.Context;
import hunt.logging;

/**
 * @author Joram Barrez
 */
class MybatisPropertyDataManager : EntityRepository!( PropertyEntityImpl , string) , PropertyDataManager, DataManger {
//class MybatisPropertyDataManager extends AbstractDataManager<PropertyEntity> implements PropertyDataManager {

    //@Override
    //class<? extends PropertyEntity> getManagedEntityClass() {
    //    return PropertyEntityImpl.class;
    //}

  alias findAll = CrudRepository!(PropertyEntityImpl,string).findAll;
  alias findById = CrudRepository!(PropertyEntityImpl,string).findById;
  alias insert = CrudRepository!(PropertyEntityImpl,string).insert;
  alias update = CrudRepository!(PropertyEntityImpl,string).update;

  this()
    {
      //TODO
      super(entityManagerFactory.currentEntityManager());
    }

    TypeInfo getTypeInfo()
    {
      return typeid(MybatisPropertyDataManager);
    }

    public void insert(PropertyEntity entity) {
      super.insert(cast(PropertyEntityImpl)entity);
      //getDbSqlSession().insert(entity);
    }

    public void insertTrans(Entity entity , EntityManager db)
    {
      //auto em = _manager ? _manager : createEntityManager;
      PropertyEntityImpl tmp = cast(PropertyEntityImpl)entity;
      db.persist!PropertyEntityImpl(tmp);
    }

    public void updateTrans(Entity entity , EntityManager db)
    {
      db.merge!PropertyEntityImpl(cast(PropertyEntityImpl)entity);
    }

    void deleteTrans(Entity entity , EntityManager db)
    {
      db.remove!PropertyEntityImpl(cast(PropertyEntityImpl)entity);
    }

  //
    //@Override
    public PropertyEntity update(PropertyEntity entity) {
      return  super.update(cast(PropertyEntityImpl)entity);
      //getDbSqlSession().update(entity);
      //return entity;
    }
    //
    //@Override
    public void dele(string id) {
      PropertyEntity entity = findById(id);
      if (entity !is null)
      {
        deleteJob[entity] = this;
        entity.setDeleted(true);
        // remove(cast(ExecutionEntityImpl)entity);
      }
      //delete(entity);
    }

    public void dele(PropertyEntity entity) {
      if (entity !is null)
      {
        deleteJob[entity] = this;
        entity.setDeleted(true);
        //remove(cast(ExecutionEntityImpl)entity);
      }
      //getDbSqlSession().delete(entity);
    }

    public void upDateDbid(string id)
    {
        scope(exit)
        {
          _manager.close();
        }
        auto update = _manager.createQuery!(PropertyEntityImpl)("update PropertyEntityImpl u set u.value = :value where u.name = 'next.dbid'");
        update.setParameter("value",id);
        try{
          update.exec();
        }
        catch(Exception e)
        {
        }
    }

    //@Override
    public PropertyEntity create() {
        return new PropertyEntityImpl();
    }

    //@Override
    //@SuppressWarnings("unchecked")
    public List!PropertyEntity findAll() {

      scope(exit)
      {
        _manager.close();
      }
      List!PropertyEntity  rt = new ArrayList!PropertyEntity;
      PropertyEntityImpl[] array =  _manager.createQuery!(PropertyEntityImpl)("SELECT * FROM PropertyEntityImpl")
      .getResultList();

      foreach(PropertyEntityImpl a; array)
      {
        rt.add(cast(PropertyEntity)a);
        CommandContextUtil.getEntityCache().put(cast(PropertyEntity)a, false, typeid(PropertyEntityImpl),this);
      }

      foreach(PropertyEntityImpl task ; array)
      {
        foreach (k ,v ; deleteJob)
        {
          if (cast(PropertyEntityImpl)k !is null && (cast(PropertyEntityImpl)k).getId == task.getId)
          {
            rt.remove(cast(PropertyEntityImpl)task);
          }
        }
      }

      //lst.addAll(arry);
      return rt;
       // return getDbSqlSession().selectList("selectProperties");
    }

    PropertyEntity findById(string entityId)
   {
     if (entityId is null) {
       return null;
     }

     auto entity =  CommandContextUtil.getEntityCache().findInCache(typeid(PropertyEntityImpl),entityId);

     if (entity !is null)
     {
       return cast(PropertyEntity)entity;
     }
     PropertyEntity dbData = cast(PropertyEntity)(find(new Condition(`%s = '%s'` , Field.name , entityId)));
     if (dbData !is null)
     {
       CommandContextUtil.getEntityCache().put(dbData, true , typeid(PropertyEntityImpl),this);
     }

     return dbData;
   }

}
