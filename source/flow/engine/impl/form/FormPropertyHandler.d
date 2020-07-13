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
module flow.engine.impl.form.FormPropertyHandler;

import flow.variable.service.api.deleg.VariableScope;
import hunt.collection.Map;

import flow.common.api.FlowableException;
import flow.common.api.deleg.Expression;
import flow.engine.form.AbstractFormType;
import flow.engine.form.FormProperty;
import flow.engine.impl.persistence.entity.ExecutionEntity;
import flow.variable.service.impl.el.NoExecutionVariableScope;
import flow.engine.impl.form.FormPropertyImpl;
import hunt.String;
/**
 * @author Tom Baeyens
 */
class FormPropertyHandler {

    protected string id;
    protected string name;
    protected AbstractFormType type;
    protected bool _isReadable;
    protected bool _isWritable;
    protected bool _isRequired;
    protected string variableName;
    protected Expression variableExpression;
    protected Expression defaultExpression;

    public FormProperty createFormProperty(ExecutionEntity execution) {
        FormPropertyImpl formProperty = new FormPropertyImpl(this);
        Object modelValue = null;

        if (execution !is null) {
            if (variableName !is null || variableExpression is null) {
               string varName = variableName !is null ? variableName : id;
                if (execution.hasVariable(varName)) {
                    modelValue = execution.getVariable(varName);
                } else if (defaultExpression !is null) {
                    modelValue = defaultExpression.getValue(execution);
                }
            } else {
                modelValue = variableExpression.getValue(execution);
            }
        } else {
            // Execution is null, the form-property is used in a start-form.
            // Default value should be available (ACT-1028) even though no execution is available.
            if (defaultExpression !is null) {
                modelValue = defaultExpression.getValue(NoExecutionVariableScope.getSharedInstance());
            }
        }

        if (cast(String)modelValue !is null) {
            formProperty.setValue((cast(String) modelValue).value);
        } else if (type !is null) {
            string formValue = type.convertModelValueToFormValue(modelValue);
            formProperty.setValue(formValue);
        } else if (modelValue !is null) {
            formProperty.setValue((cast(String)modelValue).value);
        }

        return formProperty;
    }

    public void submitFormProperty(ExecutionEntity execution, Map!(string, string) properties) {
        if (!_isWritable && properties.containsKey(id)) {
            throw new FlowableException("form property '" ~ id ~ "' is not writable");
        }

        if (_isRequired && !properties.containsKey(id) && defaultExpression is null) {
            throw new FlowableException("form property '" ~ id ~ "' is required");
        }
        bool propertyExists = false;
        Object modelValue = null;
        if (properties.containsKey(id)) {
            propertyExists = true;
            string propertyValue = properties.remove(id);
            if (type !is null) {
                modelValue = type.convertFormValueToModelValue(propertyValue);
            } else {
                modelValue = new String(propertyValue);
            }
        } else if (defaultExpression !is null) {
            Object expressionValue = defaultExpression.getValue(execution);
            if (type !is null && expressionValue !is null) {
                modelValue = type.convertFormValueToModelValue((cast(String)expressionValue).value);
            } else if (expressionValue !is null) {
                modelValue = cast(String)expressionValue;
            } else if (_isRequired) {
                throw new FlowableException("form property '" ~ id ~ "' is required");
            }
        }
        if (propertyExists || (modelValue !is null)) {
            if (variableName !is null) {
              (cast(VariableScope)execution).setVariable(variableName, modelValue);
            } else if (variableExpression !is null) {
                variableExpression.setValue(modelValue, execution);
            } else {
              (cast(VariableScope)execution).setVariable(id, modelValue);
            }
        }
    }

    // getters and setters
    // //////////////////////////////////////////////////////

    public string getId() {
        return id;
    }

    public void setId(string id) {
        this.id = id;
    }

    public string getName() {
        return name;
    }

    public void setName(string name) {
        this.name = name;
    }

    public AbstractFormType getType() {
        return type;
    }

    public void setType(AbstractFormType type) {
        this.type = type;
    }

    public bool isReadable() {
        return _isReadable;
    }

    public void setReadable(bool isReadable) {
        this._isReadable = isReadable;
    }

    public bool isRequired() {
        return _isRequired;
    }

    public void setRequired(bool isRequired) {
        this._isRequired = isRequired;
    }

    public string getVariableName() {
        return variableName;
    }

    public void setVariableName(string variableName) {
        this.variableName = variableName;
    }

    public Expression getVariableExpression() {
        return variableExpression;
    }

    public void setVariableExpression(Expression variableExpression) {
        this.variableExpression = variableExpression;
    }

    public Expression getDefaultExpression() {
        return defaultExpression;
    }

    public void setDefaultExpression(Expression defaultExpression) {
        this.defaultExpression = defaultExpression;
    }

    public bool isWritable() {
        return _isWritable;
    }

    public void setWritable(bool isWritable) {
        this._isWritable = isWritable;
    }
}
