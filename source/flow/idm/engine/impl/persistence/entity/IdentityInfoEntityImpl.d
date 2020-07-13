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


module flow.idm.engine.impl.persistence.entity.IdentityInfoEntityImpl;

import hunt.collection.HashMap;
import hunt.collection.Map;
import hunt.entity;
import flow.idm.engine.impl.persistence.entity.AbstractIdmEngineEntity;
import flow.idm.engine.impl.persistence.entity.IdentityInfoEntity;
/**
 * @author Tom Baeyens
 */
//@Table("ACT_ID_INFO")
//class IdentityInfoEntityImpl : AbstractIdmEngineEntity , Model, IdentityInfoEntity {
//
//    mixin MakeModel;
//
////@Column("FIRST_")
//     string type;
//     string userId;
//     string key;
//     string value;
//     string password;
//     byte[] passwordBytes;
//     string parentId;
//     Map!(string, string) details;
//
//
//    public Object getPersistentState() {
//        Map!(string, Object) persistentState = new HashMap!(string, Object)();
//        persistentState.put("value", value);
//        persistentState.put("password", passwordBytes);
//        return persistentState;
//    }
//
//    public string getType() {
//        return type;
//    }
//
//
//    public void setType(string type) {
//        this.type = type;
//    }
//
//
//    public string getUserId() {
//        return userId;
//    }
//
//
//    public void setUserId(string userId) {
//        this.userId = userId;
//    }
//
//
//    public string getKey() {
//        return key;
//    }
//
//
//    public void setKey(string key) {
//        this.key = key;
//    }
//
//
//    public string getValue() {
//        return value;
//    }
//
//
//    public void setValue(string value) {
//        this.value = value;
//    }
//
//
//    public byte[] getPasswordBytes() {
//        return passwordBytes;
//    }
//
//
//    public void setPasswordBytes(byte[] passwordBytes) {
//        this.passwordBytes = passwordBytes;
//    }
//
//
//    public string getPassword() {
//        return password;
//    }
//
//
//    public void setPassword(string password) {
//        this.password = password;
//    }
//
//
//    public string getName() {
//        return key;
//    }
//
//
//    public string getUsername() {
//        return value;
//    }
//
//
//    public string getParentId() {
//        return parentId;
//    }
//
//
//    public void setParentId(string parentId) {
//        this.parentId = parentId;
//    }
//
//
//    public Map!(string, string) getDetails() {
//        return details;
//    }
//
//
//    public void setDetails(Map!(string, string) details) {
//        this.details = details;
//    }
//}
