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
module flow.engine.impl.form.DefaultStartFormHandler;


import hunt.collection.List;
import hunt.collection.Map;

import flow.bpmn.model.FormProperty;
import flow.engine.form.StartFormData;
import flow.engine.impl.persistence.entity.DeploymentEntity;
import flow.engine.impl.persistence.entity.ExecutionEntity;
import flow.engine.impl.persistence.entity.ProcessDefinitionEntity;
import flow.engine.repository.ProcessDefinition;
import flow.engine.impl.form.DefaultFormHandler;
import flow.engine.impl.form.StartFormHandler;
import flow.engine.impl.form.StartFormDataImpl;

/**
 * @author Tom Baeyens
 */
class DefaultStartFormHandler : DefaultFormHandler , StartFormHandler {

    override
    public void parseConfiguration(List!FormProperty formProperties, string formKey, DeploymentEntity deployment, ProcessDefinition processDefinition) {
        super.parseConfiguration(formProperties, formKey, deployment, processDefinition);
        if (formKey !is null && formKey.length != 0) {
            (cast(ProcessDefinitionEntity) processDefinition).setStartFormKey(true);
        }
    }

    override
    public StartFormData createStartFormData(ProcessDefinition processDefinition) {
        StartFormDataImpl startFormData = new StartFormDataImpl();
        if (formKey !is null) {
            startFormData.setFormKey(formKey.getExpressionText());
        }
        startFormData.setDeploymentId(deploymentId);
        startFormData.setProcessDefinition(processDefinition);
        initializeFormProperties(startFormData, null);
        return startFormData;
    }

    public ExecutionEntity submitStartFormData(ExecutionEntity processInstance, Map!(string, string) properties) {
        submitFormProperties(properties, processInstance);
        return processInstance;
    }
}
