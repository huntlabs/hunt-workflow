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

import flow.common.api.FlowableException;
import flow.common.identity.Authentication;
import flow.common.service.CommonEngineServiceImpl;
import flow.engine.IdentityService;
import flow.engine.impl.cfg.ProcessEngineConfigurationImpl;
import flow.engine.impl.cmd.GetPotentialStarterGroupsCmd;
import flow.engine.impl.cmd.GetPotentialStarterUsersCmd;
import flow.engine.impl.util.EngineServiceUtil;
import org.flowable.idm.api.Group;
import org.flowable.idm.api.GroupQuery;
import org.flowable.idm.api.IdmIdentityService;
import org.flowable.idm.api.NativeGroupQuery;
import org.flowable.idm.api.NativeUserQuery;
import org.flowable.idm.api.Picture;
import org.flowable.idm.api.User;
import org.flowable.idm.api.UserQuery;

/**
 * @author Tom Baeyens
 */
class IdentityServiceImpl extends CommonEngineServiceImpl<ProcessEngineConfigurationImpl> implements IdentityService {

    public IdentityServiceImpl(ProcessEngineConfigurationImpl processEngineConfiguration) {
        super(processEngineConfiguration);
    }

    @Override
    public Group newGroup(string groupId) {
        return getIdmIdentityService().newGroup(groupId);
    }

    @Override
    public User newUser(string userId) {
        return getIdmIdentityService().newUser(userId);
    }

    @Override
    public void saveGroup(Group group) {
        getIdmIdentityService().saveGroup(group);
    }

    @Override
    public void saveUser(User user) {
        getIdmIdentityService().saveUser(user);
    }

    @Override
    public void updateUserPassword(User user) {
        getIdmIdentityService().updateUserPassword(user);
    }

    @Override
    public UserQuery createUserQuery() {
        return getIdmIdentityService().createUserQuery();
    }

    @Override
    public NativeUserQuery createNativeUserQuery() {
        return getIdmIdentityService().createNativeUserQuery();
    }

    @Override
    public GroupQuery createGroupQuery() {
        return getIdmIdentityService().createGroupQuery();
    }

    @Override
    public NativeGroupQuery createNativeGroupQuery() {
        return getIdmIdentityService().createNativeGroupQuery();
    }

    @Override
    public List<Group> getPotentialStarterGroups(string processDefinitionId) {
        return commandExecutor.execute(new GetPotentialStarterGroupsCmd(processDefinitionId));
    }

    @Override
    public List<User> getPotentialStarterUsers(string processDefinitionId) {
        return commandExecutor.execute(new GetPotentialStarterUsersCmd(processDefinitionId));
    }

    @Override
    public void createMembership(string userId, string groupId) {
        getIdmIdentityService().createMembership(userId, groupId);
    }

    @Override
    public void deleteGroup(string groupId) {
        getIdmIdentityService().deleteGroup(groupId);
    }

    @Override
    public void deleteMembership(string userId, string groupId) {
        getIdmIdentityService().deleteMembership(userId, groupId);
    }

    @Override
    public boolean checkPassword(string userId, string password) {
        return getIdmIdentityService().checkPassword(userId, password);
    }

    @Override
    public void deleteUser(string userId) {
        getIdmIdentityService().deleteUser(userId);
    }

    @Override
    public void setUserPicture(string userId, Picture picture) {
        getIdmIdentityService().setUserPicture(userId, picture);
    }

    @Override
    public Picture getUserPicture(string userId) {
        return getIdmIdentityService().getUserPicture(userId);
    }

    @Override
    public void setAuthenticatedUserId(string authenticatedUserId) {
        Authentication.setAuthenticatedUserId(authenticatedUserId);
    }

    @Override
    public string getUserInfo(string userId, string key) {
        return getIdmIdentityService().getUserInfo(userId, key);
    }

    @Override
    public List<string> getUserInfoKeys(string userId) {
        return getIdmIdentityService().getUserInfoKeys(userId);
    }

    @Override
    public void setUserInfo(string userId, string key, string value) {
        getIdmIdentityService().setUserInfo(userId, key, value);
    }

    @Override
    public void deleteUserInfo(string userId, string key) {
        getIdmIdentityService().deleteUserInfo(userId, key);
    }
    
    protected IdmIdentityService getIdmIdentityService() {
        IdmIdentityService idmIdentityService = EngineServiceUtil.getIdmIdentityService(configuration);
        if (idmIdentityService == null) {
            throw new FlowableException("Trying to use idm identity service when it is not initialized");
        }
        return idmIdentityService;
    }
}
