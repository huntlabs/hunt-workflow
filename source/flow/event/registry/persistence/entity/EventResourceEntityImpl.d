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

module flow.event.registry.persistence.entity.EventResourceEntityImpl;

import flow.event.registry.persistence.entity.EventResourceEntity;
import flow.event.registry.persistence.entity.AbstractEventRegistryNoRevisionEntity;
/**
 * @author Tijs Rademakers
 */
import hunt.entity;

@Table("FLW_EVENT_RESOURCE")
class EventResourceEntityImpl : AbstractEventRegistryNoRevisionEntity , Model, EventResourceEntity {
  mixin MakeModel;

    @PrimaryKey
    @Column("ID_")
     string id;

    @Column("NAME_")
     string name;

    @Column("RESOURCE_BYTES_")
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

    public string getName() {
        return name;
    }


    public void setName(string name) {
        this.name = name;
    }


    public byte[] getBytes() {
        return bytes;
    }


    public void setBytes(byte[] bytes) {
        this.bytes = bytes;
    }


    public string getDeploymentId() {
        return deploymentId;
    }


    public void setDeploymentId(string deploymentId) {
        this.deploymentId = deploymentId;
    }


    public Object getPersistentState() {
        return this;
    }

    // common methods //////////////////////////////////////////////////////////

    override
    public string toString() {
        return "ResourceEntity[id=" ~ id ~ ", name=" ~ name ~ "]";
    }
}
