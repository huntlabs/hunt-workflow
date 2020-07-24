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

module flow.idm.engine.impl.persistence.entity.MembershipEntityImpl;

import  flow.common.persistence.entity.Entity;
import flow.idm.engine.impl.persistence.entity.AbstractIdmEngineNoRevisionEntity;
import flow.idm.engine.impl.persistence.entity.MembershipEntity;
import hunt.entity;
import hunt.Exceptions;
/**
 * @author Tom Baeyens
 */

/**
 * @author Tijs Rademakers
 */
@Table("ACT_ID_MEMBERSHIP")
class MembershipEntityImpl : AbstractIdmEngineNoRevisionEntity ,Model, MembershipEntity {
      mixin MakeModel;

      @PrimaryKey
      @Column("USER_ID_")
     string userId;

     @Column("GROUP_ID_")
     string groupId;


   //
    public Object getPersistentState() {
        implementationMissing(false);
        // membership is not updatable
        //return MembershipEntityImpl.class;
          //this;
        return null;
    }

    override
    public string getId() {
        // membership doesn't have an id, returning a fake one to make the internals work
        return userId ~ groupId;
    }

    override
    public void setId(string id) {
        // membership doesn't have an id
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
      return cast(int)(hashOf(this.userId) - hashOf((cast(MembershipEntityImpl)o).getUserId));
    }

}
