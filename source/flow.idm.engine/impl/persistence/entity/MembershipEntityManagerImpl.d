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

module flow.idm.engine.impl.persistence.entity.MembershipEntityManagerImpl;


import flow.idm.api.event.FlowableIdmEventType;
import flow.idm.engine.IdmEngineConfiguration;
import flow.idm.engine.deleg.event.impl.FlowableIdmEventBuilder;
import flow.idm.engine.impl.persistence.entity.data.MembershipDataManager;
import flow.idm.engine.impl.persistence.entity.AbstractIdmEngineEntityManager;
import flow.idm.engine.impl.persistence.entity.MembershipEntity;
import flow.idm.engine.impl.persistence.entity.MembershipEntityManager;
/**
 * @author Tom Baeyens
 * @author Joram Barrez
 */
class MembershipEntityManagerImpl
    : AbstractIdmEngineEntityManager!(MembershipEntity, MembershipDataManager)
    , MembershipEntityManager {

    this(IdmEngineConfiguration idmEngineConfiguration, MembershipDataManager membershipDataManager) {
        super(idmEngineConfiguration, membershipDataManager);
    }


    public void createMembership(string userId, string groupId) {
        MembershipEntity membershipEntity = create();
        membershipEntity.setUserId(userId);
        membershipEntity.setGroupId(groupId);
        insert(membershipEntity, false);

        if (getEventDispatcher() !is null && getEventDispatcher().isEnabled()) {
            getEventDispatcher().dispatchEvent(FlowableIdmEventBuilder.createMembershipEvent(FlowableIdmEventType.MEMBERSHIP_CREATED, groupId, userId));
        }
    }


    public void deleteMembership(string userId, string groupId) {
        dataManager.deleteMembership(userId, groupId);
        if (getEventDispatcher() !is null && getEventDispatcher().isEnabled()) {
            getEventDispatcher().dispatchEvent(FlowableIdmEventBuilder.createMembershipEvent(FlowableIdmEventType.MEMBERSHIP_DELETED, groupId, userId));
        }
    }


    public void deleteMembershipByGroupId(string groupId) {
        dataManager.deleteMembershipByGroupId(groupId);
    }


    public void deleteMembershipByUserId(string userId) {
        dataManager.deleteMembershipByUserId(userId);
    }

}
