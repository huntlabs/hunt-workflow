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
module flow.engine.impl.IdentityServiceImpl;

import hunt.collection.List;

import flow.common.api.FlowableException;
//import flow.common.identity.Authentication;
import flow.common.service.CommonEngineServiceImpl;
import flow.engine.IdentityService;
import flow.engine.impl.cfg.ProcessEngineConfigurationImpl;
import flow.engine.impl.cmd.GetPotentialStarterGroupsCmd;
import flow.engine.impl.cmd.GetPotentialStarterUsersCmd;
import flow.engine.impl.util.EngineServiceUtil;
import flow.idm.api.Group;
import flow.idm.api.GroupQuery;
import flow.idm.api.IdmIdentityService;
import flow.idm.api.NativeGroupQuery;
import flow.idm.api.NativeUserQuery;
import flow.idm.api.Picture;
import flow.idm.api.User;
import flow.idm.api.UserQuery;
import hunt.Exceptions;
/**
 * @author Tom Baeyens
 */
class IdentityServiceImpl : CommonEngineServiceImpl!ProcessEngineConfigurationImpl , IdentityService {

    this(ProcessEngineConfigurationImpl processEngineConfiguration) {
        super(processEngineConfiguration);
    }


    public Group newGroup(string groupId) {
        return getIdmIdentityService().newGroup(groupId);
    }


    public User newUser(string userId) {
        return getIdmIdentityService().newUser(userId);
    }


    public void saveGroup(Group group) {
        getIdmIdentityService().saveGroup(group);
    }


    public void saveUser(User user) {
        getIdmIdentityService().saveUser(user);
    }


    public void updateUserPassword(User user) {
        getIdmIdentityService().updateUserPassword(user);
    }


    public UserQuery createUserQuery() {
        return getIdmIdentityService().createUserQuery();
    }


    public NativeUserQuery createNativeUserQuery() {
        return getIdmIdentityService().createNativeUserQuery();
    }


    public GroupQuery createGroupQuery() {
        return getIdmIdentityService().createGroupQuery();
    }


    public NativeGroupQuery createNativeGroupQuery() {
        return getIdmIdentityService().createNativeGroupQuery();
    }


    public List!Group getPotentialStarterGroups(string processDefinitionId) {
        return cast(List!Group)(commandExecutor.execute(new GetPotentialStarterGroupsCmd(processDefinitionId)));
    }


    public List!User getPotentialStarterUsers(string processDefinitionId) {
        return cast(List!User)(commandExecutor.execute(new GetPotentialStarterUsersCmd(processDefinitionId)));
    }


    public void createMembership(string userId, string groupId) {
        getIdmIdentityService().createMembership(userId, groupId);
    }


    public void deleteGroup(string groupId) {
        getIdmIdentityService().deleteGroup(groupId);
    }


    public void deleteMembership(string userId, string groupId) {
        getIdmIdentityService().deleteMembership(userId, groupId);
    }


    public bool checkPassword(string userId, string password) {
        return getIdmIdentityService().checkPassword(userId, password);
    }


    public void deleteUser(string userId) {
        getIdmIdentityService().deleteUser(userId);
    }


    public void setUserPicture(string userId, Picture picture) {
        getIdmIdentityService().setUserPicture(userId, picture);
    }


    public Picture getUserPicture(string userId) {
        return getIdmIdentityService().getUserPicture(userId);
    }


    public void setAuthenticatedUserId(string authenticatedUserId) {
      //  Authentication.setAuthenticatedUserId(authenticatedUserId);
        implementationMissing(false);
    }


    public string getUserInfo(string userId, string key) {
        return getIdmIdentityService().getUserInfo(userId, key);
    }


    public List!string getUserInfoKeys(string userId) {
        return getIdmIdentityService().getUserInfoKeys(userId);
    }


    public void setUserInfo(string userId, string key, string value) {
        getIdmIdentityService().setUserInfo(userId, key, value);
    }


    public void deleteUserInfo(string userId, string key) {
        getIdmIdentityService().deleteUserInfo(userId, key);
    }

    protected IdmIdentityService getIdmIdentityService() {
        IdmIdentityService idmIdentityService = EngineServiceUtil.getIdmIdentityService(configuration);
        if (idmIdentityService is null) {
            throw new FlowableException("Trying to use idm identity service when it is not initialized");
        }
        return idmIdentityService;
    }
}
