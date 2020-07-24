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
/**
 * @author Joram Barrez
 */
class MybatisPropertyDataManager : EntityRepository!( PropertyEntityImpl , string) , PropertyDataManager {
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


    public void insert(PropertyEntity entity) {
      super.insert(cast(PropertyEntityImpl)entity);
      //getDbSqlSession().insert(entity);
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
        remove(cast(PropertyEntityImpl)entity);
      }
      //delete(entity);
    }

    public void dele(PropertyEntity entity) {
      if (entity !is null)
      {
        remove(cast(PropertyEntityImpl)entity);
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
      List!PropertyEntity  lst = new ArrayList!PropertyEntity;
      PropertyEntityImpl[] arry =  _manager.createQuery!(PropertyEntityImpl)("SELECT * FROM PropertyEntityImpl")
      .getResultList();
      foreach(PropertyEntityImpl p ; arry)
      {
          lst.add(cast(PropertyEntity)p);
      }

      //lst.addAll(arry);
      return lst;
       // return getDbSqlSession().selectList("selectProperties");
    }

      PropertyEntity findById(string entityId)
     {
        return find(new Condition("%s = '%s'" , Field.name , entityId ));
     }

}
