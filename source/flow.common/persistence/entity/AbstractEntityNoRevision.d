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

module flow.common.persistence.entity.AbstractEntityNoRevision;

import flow.common.persistence.entity.Entity;
/**
 * Abstract superclass for the common properties of all {@link Entity} implementations.
 *
 * @author Joram Barrez
 */
abstract class AbstractEntityNoRevision : Entity {

    //protected string id;

    protected bool isInserted;
    protected bool isUpdated;
    protected bool isDeleted;

    protected Object originalPersistentState;


    public string getId() {
        return null;
    }


    public void setId(string id) {

    }


    public bool isInserted() {
        return isInserted;
    }


    public void setInserted(bool isInserted) {
        this.isInserted = isInserted;
    }


    public bool isUpdated() {
        return isUpdated;
    }


    public void setUpdated(bool isUpdated) {
        this.isUpdated = isUpdated;
    }


    public bool isDeleted() {
        return isDeleted;
    }


    public void setDeleted(bool isDeleted) {
        this.isDeleted = isDeleted;
    }


    public Object getOriginalPersistentState() {
        return originalPersistentState;
    }


    public void setOriginalPersistentState(Object persistentState) {
        this.originalPersistentState = persistentState;
    }
}
