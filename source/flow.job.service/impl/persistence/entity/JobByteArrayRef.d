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
module flow.job.service.impl.persistence.entity.JobByteArrayRef;


import flow.job.service.impl.util.CommandContextUtil;

/**
 * <p>
 * Encapsulates the logic for transparently working with {@link JobByteArrayEntity} .
 * </p>
 *
 * @author Marcus Klimstra (CGI)
 */
class JobByteArrayRef {

    private string id;
    private string name;
    private JobByteArrayEntity entity;
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

    /**
     * Returns the byte array from the {@link #getBytes()} method as {@link StandardCharsets#UTF_8} {@link string}.
     *
     * @return the byte array as {@link StandardCharsets#UTF_8} {@link string}
     */
    public string asString() {
        byte[] bytes = getBytes();
        if (bytes is null) {
            return null;
        }

        return cast(string)(bytes);
    }

    public void setValue(string name, byte[] bytes) {
        this.name = name;
        setBytes(bytes);
    }

    /**
     * Set the specified {@link string} as the value of the byte array reference. It uses the
     * {@link StandardCharsets#UTF_8} charset to convert the {@link string} to the byte array.
     *
     * @param name the name of the byte array reference
     * @param value the value of the byte array reference
     */
    public void setValue(string name, string value) {
        this.name = name;
        if (value !is null) {
            setBytes(cast(byte[])value);
        }
    }

    private void setBytes(byte[] bytes) {
        if (id is null) {
            if (bytes !is null) {
                JobByteArrayEntityManager byteArrayEntityManager = CommandContextUtil.getJobByteArrayEntityManager();
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

    public JobByteArrayEntity getEntity() {
        ensureInitialized();
        return entity;
    }

    public void dele() {
        if (!deleted && id !is null) {
            if (entity !is null) {
                // if the entity has been loaded already,
                // we might as well use the safer optimistic locking delete.
                CommandContextUtil.getJobByteArrayEntityManager().dele(entity);
            } else {
                CommandContextUtil.getJobByteArrayEntityManager().deleteByteArrayById(id);
            }
            entity = null;
            id = null;
            deleted = true;
        }
    }

    private void ensureInitialized() {
        if (id !is null && entity is null) {
            entity = CommandContextUtil.getJobByteArrayEntityManager().findById(id);
            name = entity.getName();
        }
    }

    public bool isDeleted() {
        return deleted;
    }

    /**
     * This makes a copy of this {@link JobByteArrayRef}: a new
     * {@link JobByteArrayRef} instance will be created, however with the same id,
     * name and {@link JobByteArrayEntity} instances.
     */
    public JobByteArrayRef copy() {
        JobByteArrayRef copy = new JobByteArrayRef();
        copy.id = id;
        copy.name = name;
        copy.entity = entity;
        copy.deleted = deleted;
        return copy;
    }

    override
    public string toString() {
        return "ByteArrayRef[id=" ~ id ~ ", name=" ~ name ~ ", entity=" ~ entity ~ (deleted ? ", deleted]" : "]");
    }
}
