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
 
module flow.identitylink.api.IdentityLinkInfo;
 
 
 


interface IdentityLinkInfo {

    /**
     * Returns the type of link. See for the native supported types.
     */
    string getType();

    /**
     * If the identity link involves a user, then this will be a non-null id of a user. That userId can be used to query for user information through the UserQuery API.
     */
    string getUserId();

    /**
     * If the identity link involves a group, then this will be a non-null id of a group. That groupId can be used to query for user information through the GroupQuery API.
     */
    string getGroupId();

    /**
     * The id of the task associated with this identity link.
     */
    string getTaskId();

    /**
     * The process instance id associated with this identity link.
     */
    string getProcessInstanceId();
    
    /**
     * The scope id associated with this identity link
     */
    string getScopeId();
    
    /**
     * The sub scope id associated with this identity link
     */
    string getSubScopeId();
    
    /**
     * The scope type associated with this identity link
     */
    string getScopeType();
    
    /**
     * The scope definition id associated with this identity link
     */
    string getScopeDefinitionId();
}
