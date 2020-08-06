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
module flow.engine.impl.persistence.entity.ResourceEntityImpl;

import flow.common.persistence.entity.Entity;
import flow.engine.impl.persistence.entity.AbstractBpmnEngineNoRevisionEntity;
import flow.engine.impl.persistence.entity.ResourceEntity;
import hunt.entity;
import hunt.String;
import hunt.Boolean;
import hunt.Integer;
import hunt.collection.Map;
import hunt.collection.HashMap;
/**
 * @author Tom Baeyens
 * @author Joram Barrez
 */

@Table("ACT_GE_BYTEARRAY")
class ResourceEntityImpl : AbstractBpmnEngineNoRevisionEntity , Model, ResourceEntity {
    mixin MakeModel;

    @PrimaryKey
    @Column("ID_")
    string id;

    @Column("NAME_")
    string name;

    @Column("BYTES_")
    string bytes;

    @Column("DEPLOYMENT_ID_")
    string deploymentId;

    @Column("GENERATED_")
    bool generated;

    @Column("REV_")
    int rev;

    this() {
        rev = 1;
    }

    override
    public string getId() {
      return id;
    }

    override
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
        return cast(byte[])bytes;
    }


    public void setBytes(byte[] bytes) {
        this.bytes = cast(string)bytes;
    }


    public string getDeploymentId() {
        return deploymentId;
    }


    public void setDeploymentId(string deploymentId) {
        this.deploymentId = deploymentId;
    }


    public Object getPersistentState() {
        Map!(string,Object) object = new HashMap!(string,Object);
        object.put("id", new String(id));
        object.put("name", new String(name));
        object.put("bytes", new String(bytes));
        object.put("deploymentId", new String(deploymentId));
        object.put("generated", new Boolean(generated));
        object.put("rev", new Integer(rev));
        return cast(Object)object;
    }


    public void setGenerated(bool generated) {
        this.generated = generated;
    }

    /**
     * Indicated whether or not the resource has been generated while deploying rather than being actual part of the deployment.
     */

    public bool isGenerated() {
        return generated;
    }

    // common methods //////////////////////////////////////////////////////////

    override
    public string toString() {
        return "ResourceEntity[id=" ~ id ~ ", name=" ~ name ~ "]";
    }

    int opCmp(Entity o)
    {
        return cast(int)(hashOf(this.id) - hashOf((cast(ResourceEntityImpl)o).getId));
    }
}
