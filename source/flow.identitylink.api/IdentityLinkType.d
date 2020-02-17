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


/**
 * Contains constants for all types of identity links that can be used to involve a user or group with a certain object.
 * 
 * see e.g. TaskService#addUserIdentityLink(string, string, string)
 * see e.g. TaskService#addGroupIdentityLink(string, string, string)}
 * 
 * @author Joram Barrez
 */
class IdentityLinkType {

    public static final string ASSIGNEE = "assignee";

    public static final string CANDIDATE = "candidate";

    public static final string OWNER = "owner";

    public static final string STARTER = "starter";

    public static final string PARTICIPANT = "participant";

}
