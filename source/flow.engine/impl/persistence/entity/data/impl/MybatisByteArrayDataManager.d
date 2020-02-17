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


import java.util.List;

import flow.engine.impl.cfg.ProcessEngineConfigurationImpl;
import flow.engine.impl.persistence.entity.ByteArrayEntity;
import flow.engine.impl.persistence.entity.ByteArrayEntityImpl;
import flow.engine.impl.persistence.entity.data.AbstractProcessDataManager;
import flow.engine.impl.persistence.entity.data.ByteArrayDataManager;

/**
 * @author Joram Barrez
 */
class MybatisByteArrayDataManager extends AbstractProcessDataManager<ByteArrayEntity> implements ByteArrayDataManager {

    public MybatisByteArrayDataManager(ProcessEngineConfigurationImpl processEngineConfiguration) {
        super(processEngineConfiguration);
    }

    @Override
    public ByteArrayEntity create() {
        return new ByteArrayEntityImpl();
    }

    @Override
    class<? extends ByteArrayEntity> getManagedEntityClass() {
        return ByteArrayEntityImpl.class;
    }

    @Override
    @SuppressWarnings("unchecked")
    public List<ByteArrayEntity> findAll() {
        return getDbSqlSession().selectList("selectByteArrays");
    }

    @Override
    public void deleteByteArrayNoRevisionCheck(string byteArrayEntityId) {
        getDbSqlSession().delete("deleteByteArrayNoRevisionCheck", byteArrayEntityId, ByteArrayEntityImpl.class);
    }

}
