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

module flow.idm.engine.impl.persistence.entity.GroupEntityManagerImpl;


import hunt.collection.List;
import hunt.collection.Map;

import flow.idm.api.Group;
import flow.idm.api.GroupQuery;
import flow.idm.api.event.FlowableIdmEventType;
import flow.idm.engine.IdmEngineConfiguration;
import flow.idm.engine.deleg.event.impl.FlowableIdmEventBuilder;
import flow.idm.engine.impl.GroupQueryImpl;
import flow.idm.engine.impl.persistence.entity.data.GroupDataManager;
import flow.idm.engine.impl.persistence.entity.AbstractIdmEngineEntityManager;
import flow.idm.engine.impl.persistence.entity.GroupEntity;
import flow.idm.engine.impl.persistence.entity.GroupEntityManager;
import flow.idm.engine.impl.persistence.entity.MembershipEntityManager;
/**
 * @author Tijs Rademakers
 * @author Joram Barrez
 */
class GroupEntityManagerImpl
    : AbstractIdmEngineEntityManager!(GroupEntity, GroupDataManager)
    , GroupEntityManager {

    this(IdmEngineConfiguration idmEngineConfiguration, GroupDataManager groupDataManager) {
        super(idmEngineConfiguration, groupDataManager);
    }

    public Group createNewGroup(string groupId) {
        GroupEntity groupEntity = dataManager.create();
        groupEntity.setId(groupId);
        groupEntity.setRevision(0); // Needed as groups can be transient and not save when they are returned
        return groupEntity;
    }

    override
    public void dele(string groupId) {
        GroupEntity group = dataManager.findById(groupId);

        if (group !is null) {

            getMembershipEntityManager().deleteMembershipByGroupId(groupId);
            if (getEventDispatcher() !is null && getEventDispatcher().isEnabled()) {
                getEventDispatcher().dispatchEvent(FlowableIdmEventBuilder.createMembershipEvent(FlowableIdmEventType.MEMBERSHIPS_DELETED, groupId, null));
            }

            dele(group);
        }
    }


    public GroupQuery createNewGroupQuery() {
        return new GroupQueryImpl(getCommandExecutor());
    }


    public List!Group findGroupByQueryCriteria(GroupQueryImpl query) {
        return dataManager.findGroupByQueryCriteria(query);
    }


    public long findGroupCountByQueryCriteria(GroupQueryImpl query) {
        return dataManager.findGroupCountByQueryCriteria(query);
    }


    public List!Group findGroupsByUser(string userId) {
        return dataManager.findGroupsByUser(userId);
    }


    public List!Group findGroupsByNativeQuery(Map!(string, Object) parameterMap) {
        return dataManager.findGroupsByNativeQuery(parameterMap);
    }


    public long findGroupCountByNativeQuery(Map!(string, Object) parameterMap) {
        return dataManager.findGroupCountByNativeQuery(parameterMap);
    }


    public bool isNewGroup(Group group) {
        return (cast(GroupEntity) group).getRevision() == 0;
    }


    public List!Group findGroupsByPrivilegeId(string privilegeId) {
        return dataManager.findGroupsByPrivilegeId(privilegeId);
    }

    protected MembershipEntityManager getMembershipEntityManager() {
        return engineConfiguration.getMembershipEntityManager();
    }

}
