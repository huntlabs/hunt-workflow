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

module flow.idm.engine.impl.persistence.entity.data.impl.MybatisByteArrayDataManager;

import hunt.collection.List;

import flow.idm.engine.IdmEngineConfiguration;
import flow.idm.engine.impl.persistence.entity.IdmByteArrayEntity;
import flow.idm.engine.impl.persistence.entity.IdmByteArrayEntityImpl;
import flow.idm.engine.impl.persistence.entity.data.AbstractIdmDataManager;
import flow.idm.engine.impl.persistence.entity.data.ByteArrayDataManager;
import hunt.Exceptions;
import hunt.entity;
import flow.common.AbstractEngineConfiguration;
/**
 * @author Joram Barrez
 */
class MybatisByteArrayDataManager : EntityRepository!( IdmByteArrayEntityImpl , string), ByteArrayDataManager {
//class MybatisByteArrayDataManager extends AbstractIdmDataManager<IdmByteArrayEntity> implements ByteArrayDataManager {
     public IdmEngineConfiguration idmEngineConfiguration;

    this(IdmEngineConfiguration idmEngineConfiguration) {
       // super(idmEngineConfiguration);
        this.idmEngineConfiguration = idmEngineConfiguration;
        super(entityManagerFactory.createEntityManager());
    }


    public IdmByteArrayEntity create() {
        return new IdmByteArrayEntityImpl();
    }

    //
    //class<? extends IdmByteArrayEntity> getManagedEntityClass() {
    //    return IdmByteArrayEntityImpl.class;
    //}



    public List!IdmByteArrayEntity findAll() {
        implementationMissing(false);
        return null;
       // return getDbSqlSession().selectList("selectIdmByteArrays");
    }


    public void deleteByteArrayNoRevisionCheck(String byteArrayEntityId) {
        implementationMissing(false);
      //  getDbSqlSession().delete("deleteIdmByteArrayNoRevisionCheck", byteArrayEntityId, getManagedEntityClass());
    }

}
