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

module flow.idm.engine.impl.persistence.entity.IdentityInfoEntity;

import hunt.collection.Map;

import flow.common.db.HasRevision;
import flow.common.persistence.entity.Entity;

/**
 * @author Tom Baeyens
 */
interface IdentityInfoEntity : Entity, HasRevision {

    string TYPE_USERINFO = "userinfo";

    string getType();

    void setType(string type);

    string getUserId();

    void setUserId(string userId);

    string getKey();

    void setKey(string key);

    string getValue();

    void setValue(string value);

    byte[] getPasswordBytes();

    void setPasswordBytes(byte[] passwordBytes);

    string getPassword();

    void setPassword(string password);

    string getName();

    string getUsername();

    string getParentId();

    void setParentId(string parentId);

    Map!(string, string) getDetails();

    void setDetails(Map!(string, string) details);

}
