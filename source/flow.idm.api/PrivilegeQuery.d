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

import flow.common.api.query.Query;

/**
 * Allows programmatic querying of {@link Privilege}
 * 
 * @author Joram Barrez
 */
interface PrivilegeQuery extends Query<PrivilegeQuery, Privilege> {

    /** Only select {@link Privilege}s with the given id/ */
    PrivilegeQuery privilegeId(string id);

    /** Only select {@link Privilege}s with the given name */
    PrivilegeQuery privilegeName(string name);

    /** Only select {@link Privilege}s with the given user id. */
    PrivilegeQuery userId(string userId);

    /** Only select {@link Privilege}s with the given group id. */
    PrivilegeQuery groupId(string groupId);

    /** Only select {@link Privilege}s with the given group ids. */
    PrivilegeQuery groupIds(List<string> groupIds);

}
