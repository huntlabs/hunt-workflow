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

module flow.idm.engine.impl.persistence.entity.UserEntityManager;

import hunt.collection.List;
import hunt.collection.Map;

import flow.common.persistence.entity.EntityManager;
import flow.idm.api.PasswordEncoder;
import flow.idm.api.PasswordSalt;
import flow.idm.api.Picture;
import flow.idm.api.User;
import flow.idm.api.UserQuery;
import flow.idm.engine.impl.UserQueryImpl;
import flow.idm.engine.impl.persistence.entity.UserEntity;
//import flow.idm.engine.impl.persistence.entity.PasswordEncoder;

/**
 * @author Joram Barrez
 */
interface UserEntityManager : EntityManager!UserEntity {

    User createNewUser(string userId);

    void updateUser(User updatedUser);

    List!User findUserByQueryCriteria(UserQueryImpl query);

    long findUserCountByQueryCriteria(UserQueryImpl query);

    UserQuery createNewUserQuery();

//    bool checkPassword(string userId, string password, PasswordEncoder passwordEncoder, PasswordSalt passwordSalt);

    List!User findUsersByNativeQuery(Map!(string, Object) parameterMap);

    long findUserCountByNativeQuery(Map!(string, Object) parameterMap);

    bool isNewUser(User user);

    Picture getUserPicture(User user);

    void setUserPicture(User user, Picture picture);

    void deletePicture(User user);

    List!User findUsersByPrivilegeId(string privilegeId);

}
