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

module flow.idm.engine.impl.persistence.entity.GroupEntityManager;

import hunt.collection.List;
import hunt.collection.Map;

import flow.common.persistence.entity.EntityManager;
import flow.idm.api.Group;
import flow.idm.api.GroupQuery;
import flow.idm.engine.impl.GroupQueryImpl;
import flow.idm.engine.impl.persistence.entity.GroupEntity;

/**
 * @author Joram Barrez
 */
interface GroupEntityManager : EntityManager!GroupEntity {

    Group createNewGroup(string groupId);

    GroupQuery createNewGroupQuery();

    List!Group findGroupByQueryCriteria(GroupQueryImpl query);

    long findGroupCountByQueryCriteria(GroupQueryImpl query);

    List!Group findGroupsByUser(string userId);

    List!Group findGroupsByNativeQuery(Map!(string, Object) parameterMap);

    long findGroupCountByNativeQuery(Map!(string, Object) parameterMap);

    bool isNewGroup(Group group);

    List!Group findGroupsByPrivilegeId(string privilegeId);

}
