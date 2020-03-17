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


import hunt.collection;
import hunt.collection.Map;
import hunt.collection.Set;

import flow.task.service.impl.persistence.entity.TaskEntity;

/**
 * @author Tom Baeyens
 */
class FormData implements Map!(string, Object) {

    TaskEntity task;

    public FormData(TaskEntity task) {
        this.task = task;
    }

    @Override
    public void clear() {
    }

    @Override
    public bool containsKey(Object key) {
        return false;
    }

    @Override
    public bool containsValue(Object value) {
        return false;
    }

    @Override
    public Set<Map.Entry<string, Object>> entrySet() {
        return null;
    }

    @Override
    public Object get(Object key) {
        return null;
    }

    @Override
    public bool isEmpty() {
        return false;
    }

    @Override
    public Set!string keySet() {
        return null;
    }

    @Override
    public Object put(string key, Object value) {
        return null;
    }

    @Override
    public void putAll(Map<? extends string, ? extends Object> m) {
    }

    @Override
    public Object remove(Object key) {
        return null;
    }

    @Override
    public int size() {
        return 0;
    }

    @Override
    public Collection<Object> values() {
        return null;
    }

}
