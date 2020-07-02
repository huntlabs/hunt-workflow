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

module flow.idm.engine.impl.persistence.entity.data.impl.MybatisPropertyDataManager;
import hunt.collection.List;

import flow.idm.engine.IdmEngineConfiguration;
import flow.idm.engine.impl.persistence.entity.IdmPropertyEntity;
import flow.idm.engine.impl.persistence.entity.IdmPropertyEntityImpl;
import flow.idm.engine.impl.persistence.entity.data.AbstractIdmDataManager;
import flow.idm.engine.impl.persistence.entity.data.PropertyDataManager;
import hunt.entity;
import hunt.Exceptions;
import hunt.collection.ArrayList;
import flow.common.AbstractEngineConfiguration;

/**
 * @author Joram Barrez
 */
class MybatisPropertyDataManager : EntityRepository!( IdmPropertyEntityImpl , string), PropertyDataManager {
//class MybatisPropertyDataManager extends AbstractIdmDataManager<IdmPropertyEntity> implements PropertyDataManager {

    public IdmEngineConfiguration idmEngineConfiguration;

    this(IdmEngineConfiguration idmEngineConfiguration) {
       // super(idmEngineConfiguration);
       this.idmEngineConfiguration = idmEngineConfiguration;
       super(entityManagerFactory.currentEntityManager());
    }
    //
    //class<? extends IdmPropertyEntity> getManagedEntityClass() {
    //    return IdmPropertyEntityImpl.class;
    //}


    public IdmPropertyEntity create() {
        return new IdmPropertyEntityImpl();
    }


    public List!IdmPropertyEntity findAll() {

      scope(exit)
      {
        _manager.close();
      }
      List!IdmPropertyEntity  lst = new ArrayList!IdmPropertyEntity;
      IdmPropertyEntityImpl[] array =  _manager.createQuery!(IdmPropertyEntityImpl)("SELECT * FROM IdmPropertyEntityImpl")
      .getResultList();

      foreach(IdmPropertyEntityImpl i ; array)
      {
          lst.add(cast(IdmPropertyEntity)i);
      }

      return lst;
        //return getDbSqlSession().selectList("selectIdmProperties");
    }

}
