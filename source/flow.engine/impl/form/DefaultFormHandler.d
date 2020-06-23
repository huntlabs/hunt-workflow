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

module flow.engine.impl.form.DefaultFormHandler;

import hunt.collection.ArrayList;
import hunt.collection.HashMap;
import hunt.collection.List;
import hunt.collection.Map;

import flow.common.api.deleg.Expression;
import flow.common.el.ExpressionManager;
import flow.engine.form.AbstractFormType;
import flow.engine.form.FormProperty;
import flow.engine.impl.persistence.entity.DeploymentEntity;
import flow.engine.impl.persistence.entity.ExecutionEntity;
import flow.engine.impl.util.CommandContextUtil;
import flow.engine.repository.ProcessDefinition;
import flow.engine.impl.form.FormHandler;
import flow.engine.impl.form.FormPropertyHandler;
import flow.bpmn.model.FormProperty;
import flow.engine.impl.form.FormTypes;
import flow.engine.impl.form.FormDataImpl;
/**
 * @author Tom Baeyens
 */
class DefaultFormHandler : FormHandler {

    protected Expression formKey;
    protected string deploymentId;
    protected List!FormPropertyHandler formPropertyHandlers ;// = new ArrayList<>();

    this()
    {
      formPropertyHandlers = new ArrayList!FormPropertyHandler;
    }

    override
    public void parseConfiguration(List!(flow.bpmn.model.FormProperty.FormProperty) formProperties, string formKey, DeploymentEntity deployment, ProcessDefinition processDefinition) {
        this.deploymentId = deployment.getId();

        ExpressionManager expressionManager = CommandContextUtil.getProcessEngineConfiguration().getExpressionManager();

        if (formKey !is null && formKey.length != 0) {
            this.formKey = expressionManager.createExpression(formKey);
        }

        FormTypes formTypes = CommandContextUtil.getProcessEngineConfiguration().getFormTypes();

        foreach (flow.bpmn.model.FormProperty formProperty ; formProperties) {
            FormPropertyHandler formPropertyHandler = new FormPropertyHandler();
            formPropertyHandler.setId(formProperty.getId());
            formPropertyHandler.setName(formProperty.getName());

            AbstractFormType type = formTypes.parseFormPropertyType(formProperty);
            formPropertyHandler.setType(type);
            formPropertyHandler.setRequired(formProperty.isRequired());
            formPropertyHandler.setReadable(formProperty.isReadable());
            formPropertyHandler.setWritable(formProperty.isWriteable());
            formPropertyHandler.setVariableName(formProperty.getVariable());

            if (formProperty.getExpression() !is null && formProperty.getExpression().length != 0) {
                Expression expression = expressionManager.createExpression(formProperty.getExpression());
                formPropertyHandler.setVariableExpression(expression);
            }

            if (formProperty.getDefaultExpression() !is null && formProperty.getDefaultExpression().length != 0) {
                Expression defaultExpression = expressionManager.createExpression(formProperty.getDefaultExpression());
                formPropertyHandler.setDefaultExpression(defaultExpression);
            }

            formPropertyHandlers.add(formPropertyHandler);
        }
    }

    protected void initializeFormProperties(FormDataImpl formData, ExecutionEntity execution) {
        List!FormProperty formProperties = new ArrayList!FormProperty();
        foreach (FormPropertyHandler formPropertyHandler ; formPropertyHandlers) {
            if (formPropertyHandler.isReadable()) {
                FormProperty formProperty = formPropertyHandler.createFormProperty(execution);
                formProperties.add(formProperty);
            }
        }
        formData.setFormProperties(formProperties);
    }

    override
    public void submitFormProperties(Map!(string, string) properties, ExecutionEntity execution) {
        Map!(string, string) propertiesCopy = new HashMap!(string, string)(properties);
        foreach (FormPropertyHandler formPropertyHandler ; formPropertyHandlers) {
            // submitFormProperty will remove all the keys which it takes care
            // of
            formPropertyHandler.submitFormProperty(execution, propertiesCopy);
        }
        foreach (MapEntry!(string,string) propertyId ; propertiesCopy) {
            execution.setVariable(propertyId.getKey(), propertiesCopy.get(propertyId.getKey()));
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

    public List!FormPropertyHandler getFormPropertyHandlers() {
        return formPropertyHandlers;
    }

    public void setFormPropertyHandlers(List!FormPropertyHandler formPropertyHandlers) {
        this.formPropertyHandlers = formPropertyHandlers;
    }
}
