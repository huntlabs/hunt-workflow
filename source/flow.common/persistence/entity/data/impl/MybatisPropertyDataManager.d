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

    this()
    {
      //TODO
      super(entityManagerFactory.currentEntityManager());
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
      lst.addAll(arry);
      return lst;
       // return getDbSqlSession().selectList("selectProperties");
    }

      PropertyEntity findById(string entityId)
     {
        return find(entityId);
     }

}
