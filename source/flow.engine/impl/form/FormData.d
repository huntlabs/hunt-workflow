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
module flow.engine.impl.form.FormData;

import hunt.collection;
import hunt.collection.Map;
import hunt.collection.Set;

import flow.task.service.impl.persistence.entity.TaskEntity;

/**
 * @author Tom Baeyens
 */
class FormData : Map!(string, Object) {

    TaskEntity task;

    this(TaskEntity task) {
        this.task = task;
    }


    public void clear() {
    }


    public bool containsKey(Object key) {
        return false;
    }


    public bool containsValue(Object value) {
        return false;
    }


    //public Set<Map.Entry!(string, Object)> entrySet() {
    //    return null;
    //}


    public Object get(Object key) {
        return null;
    }


    public bool isEmpty() {
        return false;
    }


    public Set!string keySet() {
        return null;
    }


    public Object put(string key, Object value) {
        return null;
    }


    public void putAll(Map!(string, Object) m) {
    }


    public Object remove(Object key) {
        return null;
    }


    public int size() {
        return 0;
    }


    public Object[] values() {
        return null;
    }

}
