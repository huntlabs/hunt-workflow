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

module flow.idm.engine.impl.persistence.entity.UserEntityManagerImpl;

import hunt.collection.List;
import hunt.collection.Map;

import flow.idm.api.PasswordEncoder;
import flow.idm.api.PasswordSalt;
import flow.idm.api.Picture;
import flow.idm.api.User;
import flow.idm.api.UserQuery;
import flow.idm.engine.IdmEngineConfiguration;
import flow.idm.engine.impl.UserQueryImpl;
import flow.idm.engine.impl.persistence.entity.data.UserDataManager;
import flow.idm.engine.impl.persistence.entity.AbstractIdmEngineEntityManager;
import flow.idm.engine.impl.persistence.entity.UserEntity;
import flow.idm.engine.impl.persistence.entity.UserEntityManager;
import flow.idm.engine.impl.persistence.entity.IdentityInfoEntityManager;
import flow.idm.engine.impl.persistence.entity.MembershipEntityManager;
/**
 * @author Tijs Rademakers
 * @author Joram Barrez
 */
class UserEntityManagerImpl
    : AbstractIdmEngineEntityManager!(UserEntity, UserDataManager)
    , UserEntityManager {

    this(IdmEngineConfiguration idmEngineConfiguration, UserDataManager userDataManager) {
        super(idmEngineConfiguration, userDataManager);
    }


    override
    public UserEntity findById(string entityId) {
        return dataManager.findById(entityId);
    }

    public User createNewUser(string userId) {
        UserEntity userEntity = create();
        userEntity.setId(userId);
        userEntity.setRevision(0); // needed as users can be transient
        return userEntity;
    }

    public void updateUser(User updatedUser) {
        super.update(cast(UserEntity) updatedUser);
    }

    override
    public void dele(UserEntity userEntity) {
        super.dele(userEntity);
        deletePicture(userEntity);
    }


    public void deletePicture(User user) {
        UserEntity userEntity = cast(UserEntity) user;
        if (userEntity.getPictureByteArrayRef() !is null) {
            userEntity.getPictureByteArrayRef().dele();
        }
    }

    override
    public void dele(string userId) {
        UserEntity user = findById(userId);
        if (user !is null) {
            List!IdentityInfoEntity identityInfos = getIdentityInfoEntityManager().findIdentityInfoByUserId(userId);
            foreach (IdentityInfoEntity identityInfo ; identityInfos) {
                getIdentityInfoEntityManager().dele(identityInfo);
            }
            getMembershipEntityManager().deleteMembershipByUserId(userId);
            delete(user);
        }
    }


    public List!User findUserByQueryCriteria(UserQueryImpl query) {
        return dataManager.findUserByQueryCriteria(query);
    }


    public long findUserCountByQueryCriteria(UserQueryImpl query) {
        return dataManager.findUserCountByQueryCriteria(query);
    }


    public UserQuery createNewUserQuery() {
        return new UserQueryImpl(getCommandExecutor());
    }


    //public bool checkPassword(string userId, string password, PasswordEncoder passwordEncoder, PasswordSalt salt) {
    //    User user = null;
    //
    //    if (userId !is null) {
    //        user = findById(userId);
    //    }
    //
    //    return (user !is null) && (password !is null) && passwordEncoder.isMatches(password, user.getPassword(), salt);
    //}


    public List!User findUsersByNativeQuery(Map!(string, Object) parameterMap) {
        return dataManager.findUsersByNativeQuery(parameterMap);
    }


    public long findUserCountByNativeQuery(Map!(string, Object) parameterMap) {
        return dataManager.findUserCountByNativeQuery(parameterMap);
    }


    public bool isNewUser(User user) {
        return (cast(UserEntity) user).getRevision() == 0;
    }


    public Picture getUserPicture(User user) {
        UserEntity userEntity = cast(UserEntity) user;
        return userEntity.getPicture();
    }


    public void setUserPicture(User user, Picture picture) {
        UserEntity userEntity = cast(UserEntity) user;
        userEntity.setPicture(picture);
        dataManager.update(userEntity);
    }


    public List!User findUsersByPrivilegeId(string name) {
        return dataManager.findUsersByPrivilegeId(name);
    }

    public UserDataManager getUserDataManager() {
        return dataManager;
    }

    public void setUserDataManager(UserDataManager userDataManager) {
        this.dataManager = userDataManager;
    }

    protected IdentityInfoEntityManager getIdentityInfoEntityManager() {
        return engineConfiguration.getIdentityInfoEntityManager();
    }

    protected MembershipEntityManager getMembershipEntityManager() {
        return engineConfiguration.getMembershipEntityManager();
    }

}
