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
module flow.idm.engine.impl.persistence.entity.IdmPropertyEntityImpl;

import flow.common.persistence.entity.Entity;
import hunt.String;
import flow.common.api.FlowableException;
import flow.idm.engine.impl.persistence.entity.AbstractIdmEngineEntity;
import flow.idm.engine.impl.persistence.entity.IdmPropertyEntity;
import hunt.entity;
/**
 * @author Tijs Rademakers
 * @author Joram Barrez
 */
@Table("ACT_ID_PROPERTY")
class IdmPropertyEntityImpl : AbstractIdmEngineEntity , Model, IdmPropertyEntity {
    mixin MakeModel;

    @PrimaryKey
    @Column("NAME_")
     string name;

    @Column("VALUE_")
     string value;

     @Column("REV_")
     int rev;



    public string getName() {
        return name;
    }


    public void setName(string name) {
        this.name = name;
    }


    public string getValue() {
        return value;
    }


    public void setValue(string value) {
        this.value = value;
    }


    public string getId() {
        return name;
    }


    public Object getPersistentState() {
        return new String(value);
    }


    public void setId(string id) {
        throw new FlowableException("only provided id generation allowed for properties");
    }

    // common methods //////////////////////////////////////////////////////////


    override
    public string toString() {
        return "PropertyEntity[name=" ~ name ~ ", value=" ~ value ~ "]";
    }


    override
    void setRevision(int revision)
    {
      super.setRevision(revision);
    }

    override
    int getRevision()
    {
      return super.getRevision;
    }


    override
    int getRevisionNext()
    {
      return super.getRevisionNext;
    }

    int opCmp(Entity o)
    {
      return cast(int)(hashOf(this.name) - hashOf((cast(IdmPropertyEntityImpl)o).getName));
    }
}
