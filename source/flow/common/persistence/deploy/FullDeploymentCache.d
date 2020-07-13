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
module flow.common.persistence.deploy.FullDeploymentCache;

import hunt.collection;
import hunt.collection.HashMap;
import hunt.collection.Map;
import flow.common.persistence.deploy.DeploymentCache;
/**
 * Default cache: keep everything in memory, without a limit.
 */
class FullDeploymentCache(T) : DeploymentCache!T {

    protected Map!(string, T) cache;

    /** Cache with no limit */
    this() {
         this.cache = new HashMap!(string,T);
        //this.cache = Collections.synchronizedMap(new HashMap<>());
    }


    public T get(string id) {
        return cache.get(id);
    }


    public void add(string id, T obj) {
        cache.put(id, obj);
    }


    public void remove(string id) {
        cache.remove(id);
    }


    public bool contains(string id) {
        return cache.containsKey(id);
    }


    public void clear() {
        cache.clear();
    }


    public Collection!T getAll() {
        return cache.values();
    }


    public int size() {
        return cache.size();
    }

}
