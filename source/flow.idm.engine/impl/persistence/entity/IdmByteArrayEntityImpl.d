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

module flow.idm.engine.impl.persistence.entity.IdmByteArrayEntityImpl;
import hunt.entity;
import flow.idm.engine.impl.persistence.entity.AbstractIdmEngineEntity;
import flow.idm.engine.impl.persistence.entity.IdmByteArrayEntity;
/**
 * @author Tijs Rademakers
 * @author Marcus Klimstra (CGI)
 * @author Joram Barrez
 */
@Table("ACT_ID_BYTEARRAY")
class IdmByteArrayEntityImpl : AbstractIdmEngineEntity , Model, IdmByteArrayEntity {
    mixin MakeModel;

     @PrimaryKey
     @Column("ID_")
     string id;

     @Column("NAME_")
     string name;

     @Column("BYTES_")
     byte[] bytes;

    this() {

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

    public void setBytes(byte[] bytes) {
        this.bytes = bytes;
    }

    override
    public string toString() {
        return "ByteArrayEntity[id=" ~ id ~ ", name=" ~ name ~ ", size=" ~ (bytes !is null ? bytes.length : 0) ~ "]";
    }

    // Wrapper for a byte array, needed to do byte array comparisons
    // See https://activiti.atlassian.net/browse/ACT-1524
    class PersistentState {

        private  string name;
        private  byte[] bytes;

        this(string name, byte[] bytes) {
            this.name = name;
            this.bytes = bytes;
        }

        override
        public bool opEquals(Object obj) {
            if (cast(PersistentState)obj !is null) {
                PersistentState other = cast(PersistentState) obj;
                return this.name == other.name && this.bytes ==  other.bytes;
            }
            return false;
        }

        override
        public size_t toHash() {
            throw new UnsupportedOperationException();
        }

    }

}
