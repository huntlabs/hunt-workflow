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

module flow.idm.engine.impl.persistence.entity.PrivilegeEntityImpl;

import hunt.collection.HashMap;
import hunt.collection.Map;
import flow.idm.engine.impl.persistence.entity.AbstractIdmEngineEntity;
import flow.idm.engine.impl.persistence.entity.PrivilegeEntity;
import hunt.entity;

/**
 * @author Tom Baeyens
 */

/**
 * @author Tijs Rademakers
 */
@Table("ACT_ID_PRIV")
class PrivilegeEntityImpl : AbstractIdmEngineEntity , Model,PrivilegeEntity {
  mixin MakeModel;

    @PrimaryKey
    @Column("ID_")
    string id;
    @Column("NAME_")
    string name;

    public Object getPersistentState() {
        Map!(string, string) state = new HashMap!(string, string)();
        state.put("id", id);
        state.put("name", name);
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

    public string getName() {
        return name;
    }

    public void setName(string name) {
        this.name = name;
    }

}
