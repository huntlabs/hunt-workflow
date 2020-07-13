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


module flow.idm.engine.impl.persistence.entity.GroupEntityImpl;

import hunt.collection.HashMap;
import hunt.collection.Map;
import flow.idm.engine.impl.persistence.entity.AbstractIdmEngineEntity;

import flow.idm.engine.impl.persistence.entity.GroupEntity;
import hunt.entity;

/**
 * @author Tom Baeyens
 */
//@Table("ACT_ID_GROUP")
//class GroupEntityImpl : AbstractIdmEngineEntity , Model,GroupEntity {
//  mixin MakeModel;
//
//    @Column("NAME_")
//    string name;
//
//    @Column("TYPE_")
//    string type;
//
//    public Object getPersistentState() {
//        Map!(string, Object) persistentState = new HashMap!(string, Object)();
//        persistentState.put("name", name);
//        persistentState.put("type", type);
//        return persistentState;
//    }
//
//
//    public string getName() {
//        return name;
//    }
//
//
//    public void setName(string name) {
//        this.name = name;
//    }
//
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
//}
