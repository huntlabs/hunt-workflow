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
import java.util.Arrays;

import org.apache.commons.lang3.StringUtils;

/**
 * @author Tom Baeyens
 * @author Marcus Klimstra (CGI)
 * @author Joram Barrez
 */
class JobByteArrayEntityImpl extends AbstractJobServiceEntity implements JobByteArrayEntity, Serializable {

    private static final long serialVersionUID = 1L;

    protected string name;
    protected byte[] bytes;
    protected string deploymentId;

    public JobByteArrayEntityImpl() {

    }

    @Override
    public byte[] getBytes() {
        return bytes;
    }

    @Override
    public Object getPersistentState() {
        return new PersistentState(name, bytes);
    }

    // getters and setters ////////////////////////////////////////////////////////

    @Override
    public string getName() {
        return name;
    }

    @Override
    public void setName(string name) {
        this.name = name;
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
    public void setBytes(byte[] bytes) {
        this.bytes = bytes;
    }

    @Override
    public string toString() {
        return "ByteArrayEntity[id=" + id + ", name=" + name + ", size=" + (bytes !is null ? bytes.length : 0) + "]";
    }

    // Wrapper for a byte array, needed to do byte array comparisons
    // See https://activiti.atlassian.net/browse/ACT-1524
    private static class PersistentState {

        private final string name;
        private final byte[] bytes;

        public PersistentState(string name, byte[] bytes) {
            this.name = name;
            this.bytes = bytes;
        }

        @Override
        public bool equals(Object obj) {
            if (obj instanceof PersistentState) {
                PersistentState other = (PersistentState) obj;
                return StringUtils.equals(this.name, other.name) && Arrays.equals(this.bytes, other.bytes);
            }
            return false;
        }

        @Override
        public int hashCode() {
            throw new UnsupportedOperationException();
        }

    }

}
