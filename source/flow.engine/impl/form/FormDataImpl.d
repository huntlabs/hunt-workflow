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



import java.io.Serializable;
import hunt.collection.ArrayList;
import hunt.collection.List;

import flow.engine.form.FormData;
import flow.engine.form.FormProperty;

/**
 * @author Tom Baeyens
 */
abstract class FormDataImpl implements FormData, Serializable {

    private static final long serialVersionUID = 1L;

    protected string formKey;
    protected string deploymentId;
    protected List!FormProperty formProperties = new ArrayList<>();

    // getters and setters
    // //////////////////////////////////////////////////////

    override
    public string getFormKey() {
        return formKey;
    }

    override
    public string getDeploymentId() {
        return deploymentId;
    }

    override
    public List!FormProperty getFormProperties() {
        return formProperties;
    }

    public void setFormKey(string formKey) {
        this.formKey = formKey;
    }

    public void setDeploymentId(string deploymentId) {
        this.deploymentId = deploymentId;
    }

    public void setFormProperties(List!FormProperty formProperties) {
        this.formProperties = formProperties;
    }

}
