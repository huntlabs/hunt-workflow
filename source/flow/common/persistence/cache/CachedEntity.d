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
module flow.common.persistence.cache.CachedEntity;

import hunt.collection.HashMap;

import flow.common.persistence.entity.Entity;
import flow.common.api.DataManger;
import hunt.collection.Map;
/**
 * @author Joram Barrez
 */
class CachedEntity {

    /**
     * The actual {@link Entity} instance.
     */
    protected Entity entity;
    protected DataManger db;
    /**
     * Represents the 'persistence state' at the moment this {@link CachedEntity} instance was created. It is used later on to determine if a {@link Entity} has been updated, by comparing the
     * 'persistent state' at that moment with this instance here.
     */
    protected Object originalPersistentState;

    this(Entity entity, bool storeState , DataManger db) {
        this.entity = entity;
        this.db = db;
        if (storeState) {
            this.originalPersistentState = entity.getPersistentState();
            entity.setOriginalPersistentState(originalPersistentState);
        } else if (entity.getOriginalPersistentState() is null){
            entity.setOriginalPersistentState(new HashMap!(string,Object));
        }
    }

    public Entity getEntity() {
        return entity;
    }

    public DataManger getDataManager()
    {
        return db;
    }

    public void setEntity(Entity entity) {
        this.entity = entity;
    }

    public Object getOriginalPersistentState() {
        return originalPersistentState;
    }

    public void setOriginalPersistentState(Object originalPersistentState) {
        this.originalPersistentState = originalPersistentState;
    }

    public bool hasChanged() {
        return entity.getPersistentState() !is null && cast(Map!(string,Object))(entity.getPersistentState()) != (cast(Map!(string,Object))originalPersistentState);
    }

}
