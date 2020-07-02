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
module flow.idm.engine.impl.persistence.entity.ByteArrayRef;

import flow.idm.engine.impl.persistence.entity.ByteArrayEntityManager;
import flow.idm.engine.impl.util.CommandContextUtil;
import flow.idm.engine.impl.persistence.entity.IdmByteArrayEntity;
/**
 * <p>
 * Encapsulates the logic for transparently working with {@link IdmByteArrayEntity} .
 * </p>
 *
 * @author Marcus Klimstra (CGI)
 */
class ByteArrayRef {


    private string id;
    private string name;
    private IdmByteArrayEntity entity;
    protected bool deleted;

    this() {
    }

    // Only intended to be used by ByteArrayRefTypeHandler
    this(string id) {
        this.id = id;
    }

    public string getId() {
        return id;
    }

    public string getName() {
        return name;
    }

    public byte[] getBytes() {
        ensureInitialized();
        return (entity !is null ? entity.getBytes() : null);
    }

    public void setValue(string name, byte[] bytes) {
        this.name = name;
        setBytes(bytes);
    }

    private void setBytes(byte[] bytes) {
        if (id is null) {
            if (bytes !is null) {
                ByteArrayEntityManager byteArrayEntityManager = CommandContextUtil.getByteArrayEntityManager();
                entity = byteArrayEntityManager.create();
                entity.setName(name);
                entity.setBytes(bytes);
                byteArrayEntityManager.insert(entity);
                id = entity.getId();
            }
        } else {
            ensureInitialized();
            entity.setBytes(bytes);
        }
    }

    public IdmByteArrayEntity getEntity() {
        ensureInitialized();
        return entity;
    }

    public void dele() {
        if (!deleted && id !is null) {
            if (entity !is null) {
                // if the entity has been loaded already,
                // we might as well use the safer optimistic locking delete.
                CommandContextUtil.getByteArrayEntityManager().dele(entity);
            } else {
                CommandContextUtil.getByteArrayEntityManager().deleteByteArrayById(id);
            }
            entity = null;
            id = null;
            deleted = true;
        }
    }

    private void ensureInitialized() {
        if (id !is null && entity is null) {
            entity = CommandContextUtil.getByteArrayEntityManager().findById(id);
            name = entity.getName();
        }
    }

    public bool isDeleted() {
        return deleted;
    }

    override
    public string toString() {
        return "ByteArrayRef[id=" ~ id ~ ", name=" ~ name ~ (deleted ? ", deleted]" : "]");
    }
}
