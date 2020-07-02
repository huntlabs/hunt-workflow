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
module flow.job.service.impl.persistence.entity.JobByteArrayEntityImpl;

import flow.job.service.impl.persistence.entity.AbstractJobServiceEntity;
import flow.job.service.impl.persistence.entity.JobByteArrayEntity;
import hunt.entity;
import std.conv : to;
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
    return 0 ;
    //throw new UnsupportedOperationException();
  }

}


@Table("ACT_GE_BYTEARRAY")
class JobByteArrayEntityImpl : AbstractJobServiceEntity , Model, JobByteArrayEntity {

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

    @Column("REV_")
    int rev;

    this() {
      rev = 1;
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
        return new PersistentState(name, bytes);
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
        return "ByteArrayEntity[id=" ~ id ~ ", name=" ~ name ~ ", size=" ~ to!string(bytes !is null ? bytes.length : 0) ~ "]";
    }

    // Wrapper for a byte array, needed to do byte array comparisons
    // See https://activiti.atlassian.net/browse/ACT-1524

}
