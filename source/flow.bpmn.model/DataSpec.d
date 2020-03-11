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
module flow.bpmn.model.DataSpec;

import flow.bpmn.model.BaseElement;

class DataSpec : BaseElement {

    protected string name;
    protected string itemSubjectRef;
    protected bool isCollection;

    public string getName() {
        return name;
    }

    public void setName(string name) {
        this.name = name;
    }

    public string getItemSubjectRef() {
        return itemSubjectRef;
    }

    public void setItemSubjectRef(string itemSubjectRef) {
        this.itemSubjectRef = itemSubjectRef;
    }

    public bool isCollection() {
        return isCollection;
    }

    public void setCollection(bool isCollection) {
        this.isCollection = isCollection;
    }

    override
    public DataSpec clone() {
        DataSpec clone = new DataSpec();
        clone.setValues(this);
        return clone;
    }

    public void setValues(DataSpec otherDataSpec) {
        setName(otherDataSpec.getName());
        setItemSubjectRef(otherDataSpec.getItemSubjectRef());
        setCollection(otherDataSpec.isCollection());
    }
}
