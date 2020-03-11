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
module flow.idm.engine.impl.IdmIdentityServiceImpl;

import hunt.collection.List;

import flow.common.identity.Authentication;
import flow.common.service.CommonEngineServiceImpl;
import flow.idm.api.Group;
import flow.idm.api.GroupQuery;
import flow.idm.api.IdmIdentityService;
import flow.idm.api.NativeGroupQuery;
import flow.idm.api.NativeTokenQuery;
import flow.idm.api.NativeUserQuery;
import flow.idm.api.Picture;
import flow.idm.api.Privilege;
import flow.idm.api.PrivilegeMapping;
import flow.idm.api.PrivilegeQuery;
import flow.idm.api.Token;
import flow.idm.api.TokenQuery;
import flow.idm.api.User;
import flow.idm.api.UserQuery;
import flow.idm.engine.IdmEngineConfiguration;
import flow.idm.engine.impl.cmd.AddPrivilegeMappingCmd;
import flow.idm.engine.impl.cmd.CheckPassword;
import flow.idm.engine.impl.cmd.CreateGroupCmd;
import flow.idm.engine.impl.cmd.CreateGroupQueryCmd;
import flow.idm.engine.impl.cmd.CreateMembershipCmd;
import flow.idm.engine.impl.cmd.CreatePrivilegeCmd;
import flow.idm.engine.impl.cmd.CreatePrivilegeQueryCmd;
import flow.idm.engine.impl.cmd.CreateTokenCmd;
import flow.idm.engine.impl.cmd.CreateTokenQueryCmd;
import flow.idm.engine.impl.cmd.CreateUserCmd;
import flow.idm.engine.impl.cmd.CreateUserQueryCmd;
import flow.idm.engine.impl.cmd.DeleteGroupCmd;
import flow.idm.engine.impl.cmd.DeleteMembershipCmd;
import flow.idm.engine.impl.cmd.DeletePrivilegeCmd;
import flow.idm.engine.impl.cmd.DeletePrivilegeMappingCmd;
import flow.idm.engine.impl.cmd.DeleteTokenCmd;
import flow.idm.engine.impl.cmd.DeleteUserCmd;
import flow.idm.engine.impl.cmd.DeleteUserInfoCmd;
import flow.idm.engine.impl.cmd.GetGroupsWithPrivilegeCmd;
import flow.idm.engine.impl.cmd.GetPrivilegeMappingsByPrivilegeIdCmd;
import flow.idm.engine.impl.cmd.GetUserInfoCmd;
import flow.idm.engine.impl.cmd.GetUserInfoKeysCmd;
import flow.idm.engine.impl.cmd.GetUserPictureCmd;
import flow.idm.engine.impl.cmd.GetUsersWithPrivilegeCmd;
import flow.idm.engine.impl.cmd.SaveGroupCmd;
import flow.idm.engine.impl.cmd.SaveTokenCmd;
import flow.idm.engine.impl.cmd.SaveUserCmd;
import flow.idm.engine.impl.cmd.SetUserInfoCmd;
import flow.idm.engine.impl.cmd.SetUserPictureCmd;
import flow.idm.engine.impl.cmd.UpdateUserPasswordCmd;
import flow.idm.engine.impl.persistence.entity.IdentityInfoEntity;

/**
 * @author Tijs Rademakers
 */
class IdmIdentityServiceImpl : CommonEngineServiceImpl!IdmEngineConfiguration , IdmIdentityService {


    public Group newGroup(string groupId) {
        return commandExecutor.execute(new CreateGroupCmd(groupId));
    }


    public User newUser(string userId) {
        return commandExecutor.execute(new CreateUserCmd(userId));
    }


    public void saveGroup(Group group) {
        commandExecutor.execute(new SaveGroupCmd(group));
    }


    public void saveUser(User user) {
        commandExecutor.execute(new SaveUserCmd(user));
    }


    public void updateUserPassword(User user) {
        commandExecutor.execute(new UpdateUserPasswordCmd(user));
    }


    public UserQuery createUserQuery() {
        return commandExecutor.execute(new CreateUserQueryCmd());
    }


    public NativeUserQuery createNativeUserQuery() {
        return new NativeUserQueryImpl(commandExecutor);
    }


    public GroupQuery createGroupQuery() {
        return commandExecutor.execute(new CreateGroupQueryCmd());
    }


    public NativeGroupQuery createNativeGroupQuery() {
        return new NativeGroupQueryImpl(commandExecutor);
    }


    public void createMembership(string userId, string groupId) {
        commandExecutor.execute(new CreateMembershipCmd(userId, groupId));
    }


    public void deleteGroup(string groupId) {
        commandExecutor.execute(new DeleteGroupCmd(groupId));
    }


    public void deleteMembership(string userId, string groupId) {
        commandExecutor.execute(new DeleteMembershipCmd(userId, groupId));
    }


    public boolean checkPassword(string userId, string password) {
        return commandExecutor.execute(new CheckPassword(userId, password));
    }


    public void setAuthenticatedUserId(string authenticatedUserId) {
        Authentication.setAuthenticatedUserId(authenticatedUserId);
    }


    public void deleteUser(string userId) {
        commandExecutor.execute(new DeleteUserCmd(userId));
    }


    public Token newToken(string tokenId) {
        return commandExecutor.execute(new CreateTokenCmd(tokenId));
    }


    public void saveToken(Token token) {
        commandExecutor.execute(new SaveTokenCmd(token));
    }


    public void deleteToken(string tokenId) {
        commandExecutor.execute(new DeleteTokenCmd(tokenId));
    }


    public TokenQuery createTokenQuery() {
        return commandExecutor.execute(new CreateTokenQueryCmd());
    }


    public NativeTokenQuery createNativeTokenQuery() {
        return new NativeTokenQueryImpl(commandExecutor);
    }


    public void setUserPicture(string userId, Picture picture) {
        commandExecutor.execute(new SetUserPictureCmd(userId, picture));
    }


    public Picture getUserPicture(string userId) {
        return commandExecutor.execute(new GetUserPictureCmd(userId));
    }


    public string getUserInfo(string userId, string key) {
        return commandExecutor.execute(new GetUserInfoCmd(userId, key));
    }


    public List!string getUserInfoKeys(string userId) {
        return commandExecutor.execute(new GetUserInfoKeysCmd(userId, IdentityInfoEntity.TYPE_USERINFO));
    }


    public void setUserInfo(string userId, string key, string value) {
        commandExecutor.execute(new SetUserInfoCmd(userId, key, value));
    }


    public void deleteUserInfo(string userId, string key) {
        commandExecutor.execute(new DeleteUserInfoCmd(userId, key));
    }


    public Privilege createPrivilege(string name) {
        return commandExecutor.execute(new CreatePrivilegeCmd(name));
    }


    public void addUserPrivilegeMapping(string privilegeId, string userId) {
        commandExecutor.execute(new AddPrivilegeMappingCmd(privilegeId, userId, null));
    }


    public void deleteUserPrivilegeMapping(string privilegeId, string userId) {
        commandExecutor.execute(new DeletePrivilegeMappingCmd(privilegeId, userId, null));
    }


    public void addGroupPrivilegeMapping(string privilegeId, string groupId) {
        commandExecutor.execute(new AddPrivilegeMappingCmd(privilegeId, null, groupId));
    }


    public void deleteGroupPrivilegeMapping(string privilegeId, string groupId) {
        commandExecutor.execute(new DeletePrivilegeMappingCmd(privilegeId, null, groupId));
    }


    public List!PrivilegeMapping getPrivilegeMappingsByPrivilegeId(string privilegeId) {
        return commandExecutor.execute(new GetPrivilegeMappingsByPrivilegeIdCmd(privilegeId));
    }


    public void deletePrivilege(string id) {
        commandExecutor.execute(new DeletePrivilegeCmd(id));
    }


    public PrivilegeQuery createPrivilegeQuery() {
        return commandExecutor.execute(new CreatePrivilegeQueryCmd());
    }


    public List!Group getGroupsWithPrivilege(string name) {
        return commandExecutor.execute(new GetGroupsWithPrivilegeCmd(name));
    }


    public List!User getUsersWithPrivilege(string name) {
        return commandExecutor.execute(new GetUsersWithPrivilegeCmd(name));
    }
}
