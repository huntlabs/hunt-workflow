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

import flow.common.api.FlowableObjectNotFoundException;
import org.flowable.idm.api.Group;
import org.flowable.idm.api.GroupQuery;
import org.flowable.idm.api.NativeGroupQuery;
import org.flowable.idm.api.NativeUserQuery;
import org.flowable.idm.api.Picture;
import org.flowable.idm.api.User;
import org.flowable.idm.api.UserQuery;

/**
 * Service to manage {@link User}s and {@link Group}s.
 * 
 * @author Tom Baeyens
 */
interface IdentityService {

    /**
     * Creates a new user. The user is transient and must be saved using {@link #saveUser(User)}.
     * 
     * @param userId
     *            id for the new user, cannot be null.
     */
    User newUser(string userId);

    /**
     * Saves the user. If the user already existed, the user is updated except user password.
     * Use {@link #updateUserPassword(User)} to update existing user password.
     * 
     * @param user
     *            user to save, cannot be null.
     * @throws RuntimeException
     *             when a user with the same name already exists.
     * @see #updateUserPassword(User)
     */
    void saveUser(User user);

    /**
     * Update user password. Use {@link #saveUser(User)} for new user.
     *
     * @param user user password to change, cannot be null.
     * @see #saveUser(User)
     */
    void updateUserPassword(User user);

    /**
     * Creates a {@link UserQuery} that allows to programmatically query the users.
     */
    UserQuery createUserQuery();

    /**
     * Returns a new {@link flow.common.api.query.NativeQuery} for tasks.
     */
    NativeUserQuery createNativeUserQuery();

    /**
     * @param userId
     *            id of user to delete, cannot be null. When an id is passed for a non-existent user, this operation is ignored.
     */
    void deleteUser(string userId);

    /**
     * Creates a new group. The group is transient and must be saved using {@link #saveGroup(Group)}.
     * 
     * @param groupId
     *            id for the new group, cannot be null.
     */
    Group newGroup(string groupId);

    /**
     * Creates a {@link GroupQuery} that allows to programmatically query the groups.
     */
    GroupQuery createGroupQuery();

    /**
     * Returns a new {@link flow.common.api.query.NativeQuery} for tasks.
     */
    NativeGroupQuery createNativeGroupQuery();

    /**
     * Returns the potential starter groups for a given process definition.
     * 
     * @param processDefinitionId
     *            process definition identifier
     * @return list of potential starter groups
     */
    List<Group> getPotentialStarterGroups(string processDefinitionId);

    /**
     * Returns the potential starter users for a given process definition.
     * 
     * @param processDefinitionId
     *            process definition identifier
     * @return list of potential starter users
     */
    List<User> getPotentialStarterUsers(string processDefinitionId);

    /**
     * Saves the group. If the group already existed, the group is updated.
     * 
     * @param group
     *            group to save. Cannot be null.
     * @throws RuntimeException
     *             when a group with the same name already exists.
     */
    void saveGroup(Group group);

    /**
     * Deletes the group. When no group exists with the given id, this operation is ignored.
     * 
     * @param groupId
     *            id of the group that should be deleted, cannot be null.
     */
    void deleteGroup(string groupId);

    /**
     * @param userId
     *            the userId, cannot be null.
     * @param groupId
     *            the groupId, cannot be null.
     * @throws RuntimeException
     *             when the given user or group doesn't exist or when the user is already member of the group.
     */
    void createMembership(string userId, string groupId);

    /**
     * Delete the membership of the user in the group. When the group or user don't exist or when the user is not a member of the group, this operation is ignored.
     * 
     * @param userId
     *            the user's id, cannot be null.
     * @param groupId
     *            the group's id, cannot be null.
     */
    void deleteMembership(string userId, string groupId);

    /**
     * Checks if the password is valid for the given user. Arguments userId and password are nullsafe.
     */
    bool checkPassword(string userId, string password);

    /**
     * Passes the authenticated user id for this particular thread. All service method (from any service) invocations done by the same thread will have access to this authenticatedUserId.
     */
    void setAuthenticatedUserId(string authenticatedUserId);

    /**
     * Sets the picture for a given user.
     *
     * @param userId
     * @param picture
     *            can be null to delete the picture.
     * @throws FlowableObjectNotFoundException
     *             if the user doesn't exist.
     */
    void setUserPicture(string userId, Picture picture);

    /**
     * Retrieves the picture for a given user.
     *
     * @return null if the user doesn't have a picture.
     * @throws FlowableObjectNotFoundException
     *             if the user doesn't exist.
     */
    Picture getUserPicture(string userId);

    /** Generic extensibility key-value pairs associated with a user */
    void setUserInfo(string userId, string key, string value);

    /** Generic extensibility key-value pairs associated with a user */
    string getUserInfo(string userId, string key);

    /** Generic extensibility keys associated with a user */
    List<string> getUserInfoKeys(string userId);

    /**
     * Delete an entry of the generic extensibility key-value pairs associated with a user
     */
    void deleteUserInfo(string userId, string key);
}
