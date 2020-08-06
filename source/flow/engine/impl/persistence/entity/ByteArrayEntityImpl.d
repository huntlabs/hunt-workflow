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
module flow.engine.impl.persistence.entity.ByteArrayEntityImpl;

import  flow.common.persistence.entity.Entity;
import flow.engine.impl.persistence.entity.AbstractBpmnEngineEntity;
import flow.engine.impl.persistence.entity.ByteArrayEntity;
import hunt.entity;
import hunt.collection.Map;
import hunt.collection.HashMap;
import hunt.String;
/**
 * @author Tom Baeyens
 * @author Marcus Klimstra (CGI)
 * @author Joram Barrez
 */

class PersistentState {

  private  string name;
  private  byte[] bytes;

  this(string name, byte[] bytes) {
    this.name = name;
    this.bytes = bytes;
  }

  override
  public bool opEquals(Object obj) {
    PersistentState other = cast(PersistentState) obj;
    if (other !is null) {
      return (this.name == other.name) && (this.bytes.length == other.bytes.length);
    }
    return false;
  }


  override
  public size_t toHash() {
    return 1;
    //throw new UnsupportedOperationException();
  }

}


@Table("ACT_GE_BYTEARRAY")
class ByteArrayEntityImpl : AbstractBpmnEngineEntity , Model, ByteArrayEntity {

   mixin MakeModel;

     @PrimaryKey
     @Column("ID_")
     string id;

     @Column("NAME_")
     string name;

     @Column("BYTES_")
     byte[] bytes;

     @Column("DEPLOYMENT_ID_")
     string deploymentId;

    this() {

    }

    public string getId() {
        return id;
    }


    public void setId(string id) {
        this.id = id;
    }

    public byte[] getBytes() {
        return bytes;
    }


    public Object getPersistentState() {
        Map!(string,Object) object = new HashMap!(string,Object);
        object.put("name",new String(name));
        object.put("bytes",new String(cast(string)bytes));
        return cast(Object)object;
        //return new PersistentState(name, bytes);
    }

    // getters and setters ////////////////////////////////////////////////////////


    public string getName() {
        return name;
    }


    public void setName(string name) {
        this.name = name;
    }


    public string getDeploymentId() {
        return deploymentId;
    }


    public void setDeploymentId(string deploymentId) {
        this.deploymentId = deploymentId;
    }


    public void setBytes(byte[] bytes) {
        this.bytes = bytes;
    }

    override
    public string toString() {
        return "ByteArrayEntity[id=" ~ id ~ ", name=" ~ name  ~ "]";
    }

  override
  string getIdPrefix()
  {
    return super.getIdPrefix;
  }

  override
  bool isInserted()
  {
    return super.isInserted();
  }

  override
  void setInserted(bool inserted)
  {
    return super.setInserted(inserted);
  }

  override
  bool isUpdated()
  {
    return super.isUpdated;
  }

  override
  void setUpdated(bool updated)
  {
    super.setUpdated(updated);
  }

  override
  bool isDeleted()
  {
    return super.isDeleted;
  }

  override
  void setDeleted(bool deleted)
  {
    super.setDeleted(deleted);
  }

  override
  Object getOriginalPersistentState()
  {
    return super.getOriginalPersistentState;
  }

  override
  void setOriginalPersistentState(Object persistentState)
  {
    super.setOriginalPersistentState(persistentState);
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

    // Wrapper for a byte array, needed to do byte array comparisons
    // See https://activiti.atlassian.net/browse/ACT-1524
  int opCmp(Entity o)
  {
    return cast(int)(hashOf(this.id) - hashOf((cast(ByteArrayEntityImpl)o).getId));
  }
}
