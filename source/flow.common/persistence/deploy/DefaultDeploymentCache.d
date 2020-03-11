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


//import hunt.collection;
//import hunt.collections;
//import hunt.collection.HashMap;
//import hunt.collection.LinkedHashMap;
//import hunt.collection.Map;
//
//import org.slf4j.Logger;
//import org.slf4j.LoggerFactory;
//
///**
// * Default cache: keep everything in memory, unless a limit is set.
// *
// * @author Joram Barrez
// */
//class DefaultDeploymentCache<T> implements DeploymentCache<T> {
//
//    private static final Logger LOGGER = LoggerFactory.getLogger(DefaultDeploymentCache.class);
//
//    protected Map<string, T> cache;
//
//    /** Cache with no limit */
//    public DefaultDeploymentCache() {
//        this.cache = Collections.synchronizedMap(new HashMap<>());
//    }
//
//    /**
//     * Cache which has a hard limit: no more elements will be cached than the limit.
//     */
//    public DefaultDeploymentCache(final int limit) {
//        this.cache = Collections.synchronizedMap(new LinkedHashMap<string, T>(limit + 1, 0.75f, true) { // +1 is needed, because the entry is inserted first, before it is removed
//            // 0.75 is the default (see javadocs)
//            // true will keep the 'access-order', which is needed to have a real LRU cache
//            private static final long serialVersionUID = 1L;
//
//            @Override
//            protected bool removeEldestEntry(Map.Entry<string, T> eldest) {
//                bool removeEldest = size() > limit;
//                if (removeEldest && LOGGER.isTraceEnabled()) {
//                    LOGGER.trace("Cache limit is reached, {} will be evicted", eldest.getKey());
//                }
//                return removeEldest;
//            }
//
//        });
//    }
//
//    @Override
//    public T get(string id) {
//        return cache.get(id);
//    }
//
//    @Override
//    public void add(string id, T obj) {
//        cache.put(id, obj);
//    }
//
//    @Override
//    public void remove(string id) {
//        cache.remove(id);
//    }
//
//    @Override
//    public bool contains(string id) {
//        return cache.containsKey(id);
//    }
//
//    @Override
//    public void clear() {
//        cache.clear();
//    }
//
//    @Override
//    public Collection<T> getAll() {
//        return cache.values();
//    }
//
//    @Override
//    public int size() {
//        return cache.size();
//    }
//
//}
