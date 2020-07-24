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
module flow.idm.engine.impl.persistence.entity.PrivilegeMappingEntityImpl;

import flow.common.persistence.entity.Entity;
import hunt.collection.HashMap;
import hunt.collection.Map;
import flow.idm.engine.impl.persistence.entity.AbstractIdmEngineEntity;
import flow.idm.engine.impl.persistence.entity.PrivilegeMappingEntity;
import hunt.entity;

@Table("ACT_ID_PRIV_MAPPING")
class PrivilegeMappingEntityImpl : AbstractIdmEngineEntity , Model, PrivilegeMappingEntity {

     mixin MakeModel;

     @PrimaryKey
     @Column("ID_")
     string id;

     @Column("PRIV_ID_")
     string privilegeId;

     @Column("USER_ID_")
     string userId;

     @Column("GROUP_ID_")
     string groupId;

    public Object getPersistentState() {
        Map!(string, string) state = new HashMap!(string, string)();
        state.put("id", id);
        state.put("privilegeId", privilegeId);
        state.put("userId", userId);
        state.put("groupId", groupId);
        return cast(Object)state;
    }

    override string getId()
    {
      return id;
    }

    override void setId(string id)
    {
      this.id = id;
    }


    public string getPrivilegeId() {
        return privilegeId;
    }


    public void setPrivilegeId(string privilegeId) {
        this.privilegeId = privilegeId;
    }


    public string getUserId() {
        return userId;
    }


    public void setUserId(string userId) {
        this.userId = userId;
    }


    public string getGroupId() {
        return groupId;
    }


    public void setGroupId(string groupId) {
        this.groupId = groupId;
    }

    int opCmp(Entity o)
    {
      return cast(int)(hashOf(this.id) - hashOf((cast(PrivilegeMappingEntityImpl)o).getId));
    }

}
