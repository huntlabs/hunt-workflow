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
 
module flow.idm.api.User;
 
 
 

//import java.io.Serializable;

/**
 * Represents a user, used in {@link IdmIdentityService}.
 *
 * @author Tom Baeyens
 */
interface User  {

    string getId();

    void setId(string id);

    string getFirstName();

    void setFirstName(string firstName);

    void setLastName(string lastName);

    string getLastName();
    
    void setDisplayName(string displayName);

    string getDisplayName();

    void setEmail(string email);

    string getEmail();

    string getPassword();

    void setPassword(string string);

    string getTenantId();

    void setTenantId(string tenantId);

    bool isPictureSet();
}
