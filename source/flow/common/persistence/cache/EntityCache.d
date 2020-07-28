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
module flow.common.persistence.cache.EntityCache;
//
import hunt.collection;
import hunt.collection.List;
import hunt.collection.Map;

import flow.common.interceptor.Command;
import flow.common.interceptor.Session;
import flow.common.persistence.entity.Entity;
import flow.common.persistence.cache.CachedEntity;
/**
 * This is a cache for {@link Entity} instances during the execution of one {@link Command}.
 *
 * @author Joram Barrez
 */
interface EntityCache : Session {

    /**
     * Returns all cached {@link Entity} instances as a map with following structure: { entityClassName, {entityId, entity} }
     */
    Map!(TypeInfo, Map!(string, CachedEntity)) getAllCachedEntities();

    /**
     * Adds the gives {@link Entity} to the cache.
     *
     * @param entity
     *            The {@link Entity} instance
     * @param storeState
     *            If true, the current state {@link Entity#getPersistentState()} will be stored for future diffing. Note that, if false, the {@link Entity} will always be seen as changed.
     * @return Returns a {@link CachedEntity} instance, which can be enriched later on.
     */
    CachedEntity put(Entity entity, bool storeState ,TypeInfo type);

    /**
     * Returns the cached {@link Entity} instance of the given class with the provided id. Returns null if such a {@link Entity} cannot be found.
     */
    Entity findInCache(TypeInfo entityClass, string id);

    /**
     * Returns all cached {@link Entity} instances of a given type. Returns an empty list if no instances of the given type exist.
     */
    List!Entity findInCache(TypeInfo entityClass);

    /**
     * Returns all {@link CachedEntity} instances for the given type. The difference with {@link #findInCache(Class)} is that here the whole {@link CachedEntity} is returned, which gives access to the
     * persistent state at the moment of putting it in the cache.
     */
    Collection!CachedEntity findInCacheAsCachedObjects(TypeInfo entityClass);

    /**
     * Removes the {@link Entity} of the given type with the given id from the cache.
     */
    void cacheRemove(TypeInfo entityClass, string entityId);
}
