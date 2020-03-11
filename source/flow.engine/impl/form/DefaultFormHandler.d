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



import hunt.collection.ArrayList;
import hunt.collection.HashMap;
import hunt.collection.List;
import hunt.collection.Map;

import org.apache.commons.lang3.StringUtils;
import flow.common.api.deleg.Expression;
import flow.common.el.ExpressionManager;
import flow.engine.form.AbstractFormType;
import flow.engine.form.FormProperty;
import flow.engine.impl.persistence.entity.DeploymentEntity;
import flow.engine.impl.persistence.entity.ExecutionEntity;
import flow.engine.impl.util.CommandContextUtil;
import flow.engine.repository.ProcessDefinition;

/**
 * @author Tom Baeyens
 */
class DefaultFormHandler implements FormHandler {

    protected Expression formKey;
    protected string deploymentId;
    protected List<FormPropertyHandler> formPropertyHandlers = new ArrayList<>();

    @Override
    public void parseConfiguration(List<flow.bpmn.model.FormProperty> formProperties, string formKey, DeploymentEntity deployment, ProcessDefinition processDefinition) {
        this.deploymentId = deployment.getId();

        ExpressionManager expressionManager = CommandContextUtil.getProcessEngineConfiguration().getExpressionManager();

        if (StringUtils.isNotEmpty(formKey)) {
            this.formKey = expressionManager.createExpression(formKey);
        }

        FormTypes formTypes = CommandContextUtil.getProcessEngineConfiguration().getFormTypes();

        for (flow.bpmn.model.FormProperty formProperty : formProperties) {
            FormPropertyHandler formPropertyHandler = new FormPropertyHandler();
            formPropertyHandler.setId(formProperty.getId());
            formPropertyHandler.setName(formProperty.getName());

            AbstractFormType type = formTypes.parseFormPropertyType(formProperty);
            formPropertyHandler.setType(type);
            formPropertyHandler.setRequired(formProperty.isRequired());
            formPropertyHandler.setReadable(formProperty.isReadable());
            formPropertyHandler.setWritable(formProperty.isWriteable());
            formPropertyHandler.setVariableName(formProperty.getVariable());

            if (StringUtils.isNotEmpty(formProperty.getExpression())) {
                Expression expression = expressionManager.createExpression(formProperty.getExpression());
                formPropertyHandler.setVariableExpression(expression);
            }

            if (StringUtils.isNotEmpty(formProperty.getDefaultExpression())) {
                Expression defaultExpression = expressionManager.createExpression(formProperty.getDefaultExpression());
                formPropertyHandler.setDefaultExpression(defaultExpression);
            }

            formPropertyHandlers.add(formPropertyHandler);
        }
    }

    protected void initializeFormProperties(FormDataImpl formData, ExecutionEntity execution) {
        List<FormProperty> formProperties = new ArrayList<>();
        for (FormPropertyHandler formPropertyHandler : formPropertyHandlers) {
            if (formPropertyHandler.isReadable()) {
                FormProperty formProperty = formPropertyHandler.createFormProperty(execution);
                formProperties.add(formProperty);
            }
        }
        formData.setFormProperties(formProperties);
    }

    @Override
    public void submitFormProperties(Map!(string, string) properties, ExecutionEntity execution) {
        Map!(string, string) propertiesCopy = new HashMap<>(properties);
        for (FormPropertyHandler formPropertyHandler : formPropertyHandlers) {
            // submitFormProperty will remove all the keys which it takes care
            // of
            formPropertyHandler.submitFormProperty(execution, propertiesCopy);
        }
        for (string propertyId : propertiesCopy.keySet()) {
            execution.setVariable(propertyId, propertiesCopy.get(propertyId));
        }
    }

    // getters and setters
    // //////////////////////////////////////////////////////

    public Expression getFormKey() {
        return formKey;
    }

    public void setFormKey(Expression formKey) {
        this.formKey = formKey;
    }

    public string getDeploymentId() {
        return deploymentId;
    }

    public void setDeploymentId(string deploymentId) {
        this.deploymentId = deploymentId;
    }

    public List<FormPropertyHandler> getFormPropertyHandlers() {
        return formPropertyHandlers;
    }

    public void setFormPropertyHandlers(List<FormPropertyHandler> formPropertyHandlers) {
        this.formPropertyHandlers = formPropertyHandlers;
    }
}
