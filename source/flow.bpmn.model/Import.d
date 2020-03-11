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
module flow.bpmn.model.Import;
import flow.bpmn.model.BaseElement;

class Import : BaseElement {

    protected string importType;
    protected string location;
    protected string namespace;

    public string getImportType() {
        return importType;
    }

    public void setImportType(string importType) {
        this.importType = importType;
    }

    public string getLocation() {
        return location;
    }

    public void setLocation(string location) {
        this.location = location;
    }

    public string getNamespace() {
        return namespace;
    }

    public void setNamespace(string namespace) {
        this.namespace = namespace;
    }

    override
    public Import clone() {
        Import clone = new Import();
        clone.setValues(this);
        return clone;
    }

    public void setValues(Import otherElement) {
        super.setValues(otherElement);
        setImportType(otherElement.getImportType());
        setLocation(otherElement.getLocation());
        setNamespace(otherElement.getNamespace());
    }
}
