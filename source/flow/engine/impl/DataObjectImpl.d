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

module flow.engine.impl.DataObjectImpl;

import flow.engine.runtime.DataObject;

class DataObjectImpl : DataObject {
    protected string id;
    protected string processInstanceId;
    protected string executionId;
    protected string name;
    protected Object value;
    protected string description;
    protected string localizedName;
    protected string localizedDescription;
    protected string dataObjectDefinitionKey;

    private string type;

    this(string id, string processInstanceId, string executionId, string name, Object value, string description, string type, string localizedName,
            string localizedDescription, string dataObjectDefinitionKey) {

        this.id = id;
        this.processInstanceId = processInstanceId;
        this.executionId = executionId;
        this.name = name;
        this.value = value;
        this.type = type;
        this.description = description;
        this.localizedName = localizedName;
        this.localizedDescription = localizedDescription;
        this.dataObjectDefinitionKey = dataObjectDefinitionKey;
    }

    public void setId(string id) {
        this.id = id;
    }


    public string getId() {
        return id;
    }

    public void setProcessInstanceId(string processInstanceId) {
        this.processInstanceId = processInstanceId;
    }


    public string getProcessInstanceId() {
        return processInstanceId;
    }

    public void setExecutionId(string executionId) {
        this.executionId = executionId;
    }


    public string getExecutionId() {
        return executionId;
    }


    public string getName() {
        return name;
    }

    public void setName(string name) {
        this.name = name;
    }


    public string getLocalizedName() {
        if (localizedName !is null && localizedName.length > 0) {
            return localizedName;
        } else {
            return name;
        }
    }

    public void setLocalizedName(string localizedName) {
        this.localizedName = localizedName;
    }


    public string getDescription() {
        if (localizedDescription !is null && localizedDescription.length > 0) {
            return localizedDescription;
        } else {
            return description;
        }
    }

    public void setDescription(string description) {
        this.description = description;
    }


    public Object getValue() {
        return value;
    }

    public void setValue(Object value) {
        this.value = value;
    }


    public string getType() {
        return type;
    }

    public void setType(string type) {
        this.type = type;
    }


    public string getDataObjectDefinitionKey() {
        return dataObjectDefinitionKey;
    }

    public void setDataObjectDefinitionKey(string dataObjectDefinitionKey) {
        this.dataObjectDefinitionKey = dataObjectDefinitionKey;
    }
}
