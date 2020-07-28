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
module flow.common.persistence.cache.EntityCacheImpl;

import hunt.collection.ArrayList;
import hunt.collection;
import hunt.collection.Collections;
import hunt.collection.HashMap;
import hunt.collection.List;
import hunt.collection.Map;
import flow.common.persistence.cache.EntityCache;
import flow.common.persistence.entity.Entity;
import flow.common.persistence.cache.CachedEntity;
/**
 * @author Joram Barrez
 */
class EntityCacheImpl : EntityCache {

    this()
    {
        cachedObjects = new HashMap!(TypeInfo, Map!(string, CachedEntity));
    }

    protected Map!(TypeInfo, Map!(string, CachedEntity)) cachedObjects  ;//= new HashMap<>();


    public CachedEntity put(Entity entity, bool storeState ,TypeInfo type) {
        Map!(string, CachedEntity) classCache = cachedObjects.get(type);
        if (classCache is null) {
            classCache = new HashMap!(string, CachedEntity);
            cachedObjects.put(type, classCache);
        }
        CachedEntity cachedObject = new CachedEntity(entity, storeState);
        classCache.put(entity.getId(), cachedObject);
        return cachedObject;
    }



    public Entity findInCache(TypeInfo entityClass, string id) {
        CachedEntity cachedObject = null;
        Map!(string, CachedEntity) classCache = cachedObjects.get(entityClass);

        if (classCache is null) {
            classCache = findClassCacheByCheckingSubclasses(entityClass);
        }

        if (classCache !is null) {
            cachedObject = classCache.get(id);
        }

        if (cachedObject !is null) {
            return cachedObject.getEntity();
        }

        return null;
    }

    protected Map!(string, CachedEntity) findClassCacheByCheckingSubclasses(TypeInfo entityClass) {
        return cachedObjects.get(entityClass);
        //for (Class<?> clazz : cachedObjects.keySet()) {
        //    if (entityClass.isAssignableFrom(clazz)) {
        //        return cachedObjects.get(clazz);
        //    }
        //}
        //return null;
    }


    public void cacheRemove(TypeInfo entityClass, string entityId) {
        Map!(string, CachedEntity) classCache = cachedObjects.get(entityClass);
        if (classCache is null) {
            return;
        }
        classCache.remove(entityId);
    }


    public Collection!CachedEntity findInCacheAsCachedObjects(TypeInfo entityClass) {
        Map!(string, CachedEntity) classCache = cachedObjects.get(entityClass);
        if (classCache !is null) {
            return new ArrayList!CachedEntity(classCache.values());
        }
        return null;
    }



    public List!Entity findInCache(TypeInfo entityClass) {
        Map!(string, CachedEntity) classCache = cachedObjects.get(entityClass);

        if (classCache is null) {
            classCache = findClassCacheByCheckingSubclasses(entityClass);
        }

        if (classCache !is null) {
            List!Entity entities = new ArrayList!Entity(classCache.size());
            foreach (CachedEntity cachedObject ; classCache.values()) {
                entities.add(cachedObject.getEntity());
            }
            return entities;
        }

        return Collections.emptyList!Entity();
    }


    public Map!(TypeInfo, Map!(string, CachedEntity)) getAllCachedEntities() {
        return cachedObjects;
    }


    public void close() {

    }


    public void flush() {

    }
}
