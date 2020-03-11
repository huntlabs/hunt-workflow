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

module flow.idm.api.UserBaseQuery;

import hunt.collection.List;

import flow.common.api.query.Query;

/**
 * Allows programmatic querying of {@link User}
 *
 * @author Joram Barrez
 * @author Filip Hrisafov
 */
interface UserBaseQuery(T,U) : Query!(T, U) {

    /**
     * Only select {@link User}s with the given id/
     */
    T userId(string id);

    /**
     * Only select {@link User}s with the given ids/
     */
    T userIds(List!string ids);

    /**
     * Only select {@link User}s with the given id (ignoring case) /
     */
    T userIdIgnoreCase(string id);

    /**
     * Only select {@link User}s with the given firstName.
     */
    T userFirstName(string firstName);

    /**
     * Only select {@link User}s where the first name matches the given parameter. The syntax is that of SQL, eg. %name%.
     */
    T userFirstNameLike(string firstNameLike);

    /**
     * Only select {@link User}s where the first name matches the given parameter (ignoring case). The syntax is that of SQL, eg. %name%.
     */
    T userFirstNameLikeIgnoreCase(string firstNameLikeIgnoreCase);

    /**
     * Only select {@link User}s with the given lastName.
     */
    T userLastName(string lastName);

    /**
     * Only select {@link User}s where the last name matches the given parameter. The syntax is that of SQL, eg. %name%.
     */
    T userLastNameLike(string lastNameLike);

    /**
     * Only select {@link User}s where the last name matches the given parameter (ignoring case). The syntax is that of SQL, eg. %name%.
     */
    T userLastNameLikeIgnoreCase(string lastNameLikeIgnoreCase);

    /**
     * Only select {@link User}s where the full name matches the given parameters. Both the first name and last name will be tried, ie in semi-sql: where firstName like xxx or lastname like xxx
     */
    T userFullNameLike(string fullNameLike);

    /**
     * Only select {@link User}s where the full name matches the given parameters (ignoring case). Both the first name and last name will be tried, ie in semi-sql: where firstName like xxx or lastname
     * like xxx
     */
    T userFullNameLikeIgnoreCase(string fullNameLikeIgnoreCase);

    /**
     * Only select {@link User}s with the given displayName.
     */
    T userDisplayName(string displayName);

    /**
     * Only select {@link User}s where the display name matches the given parameter. The syntax is that of SQL, eg. %name%.
     */
    T userDisplayNameLike(string displayNameLike);

    /**
     * Only select {@link User}s where the display name matches the given parameter (ignoring case). The syntax is that of SQL, eg. %name%.
     */
    T userDisplayNameLikeIgnoreCase(string displayNameLikeIgnoreCase);

    /**
     * Only those {@link User}s with the given email address.
     */
    T userEmail(string email);

    /**
     * Only select {@link User}s where the email matches the given parameter. The syntax is that of SQL, eg. %test%.
     */
    T userEmailLike(string emailLike);

    /**
     * Only select {@link User}s that belong to the given group.
     */
    T memberOfGroup(string groupId);

    /**
     * Only select {@link User}s that belong to the given groups.
     */
    T memberOfGroups(List!string groupIds);

    /**
     * Only select {@link User}s that belong to the given tenant.
     */
    T tenantId(string tenantId);

    // sorting ////////////////////////////////////////////////////////

    /**
     * Order by user id (needs to be followed by {@link #asc()} or {@link #desc()}).
     */
    T orderByUserId();

    /**
     * Order by user first name (needs to be followed by {@link #asc()} or {@link #desc()}).
     */
    T orderByUserFirstName();

    /**
     * Order by user last name (needs to be followed by {@link #asc()} or {@link #desc()}).
     */
    T orderByUserLastName();

    /**
     * Order by user email (needs to be followed by {@link #asc()} or {@link #desc()}).
     */
    T orderByUserEmail();
}
