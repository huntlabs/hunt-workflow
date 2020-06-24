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

module flow.bpmn.model.ServiceTask;

import hunt.collection.ArrayList;
import hunt.collection.List;
import flow.bpmn.model.TaskWithFieldExtensions;
import flow.bpmn.model.CustomProperty;
import flow.bpmn.model.FieldExtension;
/**
 * @author Tijs Rademakers
 */
class ServiceTask : TaskWithFieldExtensions {

    public static  string DMN_TASK = "dmn";
    public static  string MAIL_TASK = "mail";
    public static  string HTTP_TASK = "http";
    public static  string SHELL_TASK = "shell";
    public static  string CASE_TASK = "case";
    public static  string SEND_EVENT_TASK = "send-event";

    protected string implementation;
    protected string implementationType;
    protected string resultVariableName;
    protected string type;
    protected string operationRef;
    protected string extensionId;
    protected List!CustomProperty customProperties ;//= new ArrayList<>();
    protected string skipExpression;
    protected bool useLocalScopeForResultVariable;
    protected bool triggerable;

    this()
    {
      customProperties = new ArrayList!CustomProperty;
    }

    public string getImplementation() {
        return implementation;
    }

    public void setImplementation(string implementation) {
        this.implementation = implementation;
    }

    public string getImplementationType() {
        return implementationType;
    }

    public void setImplementationType(string implementationType) {
        this.implementationType = implementationType;
    }

    public string getResultVariableName() {
        return resultVariableName;
    }

    public void setResultVariableName(string resultVariableName) {
        this.resultVariableName = resultVariableName;
    }

    public string getType() {
        return type;
    }

    public void setType(string type) {
        this.type = type;
    }

    public List!CustomProperty getCustomProperties() {
        return customProperties;
    }

    public void setCustomProperties(List!CustomProperty customProperties) {
        this.customProperties = customProperties;
    }

    public string getOperationRef() {
        return operationRef;
    }

    public void setOperationRef(string operationRef) {
        this.operationRef = operationRef;
    }

    public string getExtensionId() {
        return extensionId;
    }

    public void setExtensionId(string extensionId) {
        this.extensionId = extensionId;
    }

    public bool isExtended() {
        return extensionId !is null && extensionId.length != 0;
    }

    public string getSkipExpression() {
        return skipExpression;
    }

    public void setSkipExpression(string skipExpression) {
        this.skipExpression = skipExpression;
    }

    public bool isUseLocalScopeForResultVariable() {
        return useLocalScopeForResultVariable;
    }

    public void setUseLocalScopeForResultVariable(bool useLocalScopeForResultVariable) {
        this.useLocalScopeForResultVariable = useLocalScopeForResultVariable;
    }

    public bool isTriggerable() {
        return triggerable;
    }

    public void setTriggerable(bool triggerable) {
        this.triggerable = triggerable;
    }

    override
    public ServiceTask clone() {
        ServiceTask clone = new ServiceTask();
        clone.setValues(this);
        return clone;
    }

    public void setValues(ServiceTask otherElement) {
        super.setValues(otherElement);
        setImplementation(otherElement.getImplementation());
        setImplementationType(otherElement.getImplementationType());
        setResultVariableName(otherElement.getResultVariableName());
        setType(otherElement.getType());
        setOperationRef(otherElement.getOperationRef());
        setExtensionId(otherElement.getExtensionId());
        setSkipExpression(otherElement.getSkipExpression());
        setUseLocalScopeForResultVariable(otherElement.isUseLocalScopeForResultVariable());
        setTriggerable(otherElement.isTriggerable());

        fieldExtensions = new ArrayList!FieldExtension();
        if (otherElement.getFieldExtensions() !is null && !otherElement.getFieldExtensions().isEmpty()) {
            foreach (FieldExtension extension ; otherElement.getFieldExtensions()) {
                fieldExtensions.add(extension.clone());
            }
        }

        customProperties = new ArrayList!CustomProperty();
        if (otherElement.getCustomProperties() !is null && !otherElement.getCustomProperties().isEmpty()) {
            foreach (CustomProperty property ; otherElement.getCustomProperties()) {
                customProperties.add(property.clone());
            }
        }
    }
}
