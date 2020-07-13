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

//          Copyright linse 2020.
// Distributed under the Boost Software License, Version 1.0.
//    (See accompanying file LICENSE_1_0.txt or copy at
//          http://www.boost.org/LICENSE_1_0.txt)}

module flow.idm.api.GroupQuery;





import hunt.collection.List;

import flow.common.api.query.Query;
import flow.idm.api.Group;

/**
 * Allows to programmatically query for {@link Group}s.
 *
 * @author Joram Barrez
 */
interface GroupQuery : Query!(GroupQuery, Group) {

    /** Only select {@link Group}s with the given id. */
    GroupQuery groupId(string groupId);

    /** Only select {@link Group}s with the given ids. */
    GroupQuery groupIds(List!string groupIds);

    /** Only select {@link Group}s with the given name. */
    GroupQuery groupName(string groupName);

    /**
     * Only select {@link Group}s where the name matches the given parameter. The syntax to use is that of SQL, eg. %test%.
     */
    GroupQuery groupNameLike(string groupNameLike);

    /**
     * Only select {@link Group}s where the name matches the given parameter (ignoring case). The syntax to use is that of SQL, eg. %test%.
     */
    GroupQuery groupNameLikeIgnoreCase(string groupNameLikeIgnoreCase);

    /** Only select {@link Group}s which have the given type. */
    GroupQuery groupType(string groupType);

    /** Only selects {@link Group}s where the given user is a member of. */
    GroupQuery groupMember(string groupMemberUserId);

    /** Only selects {@link Group}s where the given users are a member of. */
    GroupQuery groupMembers(List!string groupMemberUserIds);

    // sorting ////////////////////////////////////////////////////////

    /**
     * Order by group id (needs to be followed by {@link #asc()} or {@link #desc()}).
     */
    GroupQuery orderByGroupId();

    /**
     * Order by group name (needs to be followed by {@link #asc()} or {@link #desc()}).
     */
    GroupQuery orderByGroupName();

    /**
     * Order by group type (needs to be followed by {@link #asc()} or {@link #desc()}).
     */
    GroupQuery orderByGroupType();

}
