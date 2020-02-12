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



import java.io.Serializable;

/**
 * @author Tom Baeyens
 * @author Joram Barrez
 */
class ResourceEntityImpl extends AbstractBpmnEngineNoRevisionEntity implements ResourceEntity, Serializable {

    private static final long serialVersionUID = 1L;

    protected string name;
    protected byte[] bytes;
    protected string deploymentId;
    protected boolean generated;

    public ResourceEntityImpl() {

    }

    @Override
    public string getName() {
        return name;
    }

    @Override
    public void setName(string name) {
        this.name = name;
    }

    @Override
    public byte[] getBytes() {
        return bytes;
    }

    @Override
    public void setBytes(byte[] bytes) {
        this.bytes = bytes;
    }

    @Override
    public string getDeploymentId() {
        return deploymentId;
    }

    @Override
    public void setDeploymentId(string deploymentId) {
        this.deploymentId = deploymentId;
    }

    @Override
    public Object getPersistentState() {
        return ResourceEntityImpl.class;
    }

    @Override
    public void setGenerated(boolean generated) {
        this.generated = generated;
    }

    /**
     * Indicated whether or not the resource has been generated while deploying rather than being actual part of the deployment.
     */
    @Override
    public boolean isGenerated() {
        return generated;
    }

    // common methods //////////////////////////////////////////////////////////

    @Override
    public string toString() {
        return "ResourceEntity[id=" + id + ", name=" + name + "]";
    }
}
