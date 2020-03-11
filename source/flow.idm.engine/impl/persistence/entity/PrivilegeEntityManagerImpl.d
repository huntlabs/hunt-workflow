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
module flow.idm.engine.impl.persistence.entity.PrivilegeEntityManagerImpl;

import hunt.collection.List;
import hunt.collection.Map;

import flow.idm.api.Privilege;
import flow.idm.api.PrivilegeQuery;
import flow.idm.engine.IdmEngineConfiguration;
import flow.idm.engine.impl.PrivilegeQueryImpl;
import flow.idm.engine.impl.persistence.entity.data.PrivilegeDataManager;
import flow.idm.engine.impl.persistence.entity.AbstractIdmEngineEntityManager;
import flow.idm.engine.impl.persistence.entity.PrivilegeEntity;
import flow.idm.engine.impl.persistence.entity.PrivilegeEntityManager;

/**
 * @author Joram Barrez
 */
class PrivilegeEntityManagerImpl
    : AbstractIdmEngineEntityManager!(PrivilegeEntity, PrivilegeDataManager)
    , PrivilegeEntityManager {

    this(IdmEngineConfiguration idmEngineConfiguration, PrivilegeDataManager privilegeDataManager) {
        super(idmEngineConfiguration, privilegeDataManager);
    }

    public PrivilegeQuery createNewPrivilegeQuery() {
        return new PrivilegeQueryImpl(getCommandExecutor());
    }

    public List!Privilege findPrivilegeByQueryCriteria(PrivilegeQueryImpl query) {
        return dataManager.findPrivilegeByQueryCriteria(query);
    }

    public long findPrivilegeCountByQueryCriteria(PrivilegeQueryImpl query) {
        return dataManager.findPrivilegeCountByQueryCriteria(query);
    }

    public List!Privilege findPrivilegeByNativeQuery(Map!(string, Object) parameterMap) {
        return dataManager.findPrivilegeByNativeQuery(parameterMap);
    }

    public long findPrivilegeCountByNativeQuery(Map!(string, Object) parameterMap) {
        return dataManager.findPrivilegeCountByNativeQuery(parameterMap);
    }

}
