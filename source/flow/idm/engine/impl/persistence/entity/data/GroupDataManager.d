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
module flow.idm.engine.impl.persistence.entity.data.GroupDataManager;

import hunt.collection.List;
import hunt.collection.Map;

import flow.common.persistence.entity.data.DataManager;
import flow.idm.api.Group;
import flow.idm.engine.impl.GroupQueryImpl;
import flow.idm.engine.impl.persistence.entity.GroupEntity;

/**
 * @author Joram Barrez
 */
interface GroupDataManager : DataManager!GroupEntity {

    List!Group findGroupByQueryCriteria(GroupQueryImpl query);

    long findGroupCountByQueryCriteria(GroupQueryImpl query);

    List!Group findGroupsByUser(string userId);

    List!Group findGroupsByPrivilegeId(string privilegeId);

    List!Group findGroupsByNativeQuery(Map!(string, Object) parameterMap);

    long findGroupCountByNativeQuery(Map!(string, Object) parameterMap);

}
