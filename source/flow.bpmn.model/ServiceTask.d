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


import java.util.ArrayList;
import java.util.List;

/**
 * @author Tijs Rademakers
 */
class ServiceTask extends TaskWithFieldExtensions {

    public static final string DMN_TASK = "dmn";
    public static final string MAIL_TASK = "mail";
    public static final string HTTP_TASK = "http";
    public static final string SHELL_TASK = "shell";
    public static final string CASE_TASK = "case";
    public static final string SEND_EVENT_TASK = "send-event";

    protected string implementation;
    protected string implementationType;
    protected string resultVariableName;
    protected string type;
    protected string operationRef;
    protected string extensionId;
    protected List<CustomProperty> customProperties = new ArrayList<>();
    protected string skipExpression;
    protected boolean useLocalScopeForResultVariable;
    protected boolean triggerable;

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

    public List<CustomProperty> getCustomProperties() {
        return customProperties;
    }

    public void setCustomProperties(List<CustomProperty> customProperties) {
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

    public boolean isExtended() {
        return extensionId != null && !extensionId.isEmpty();
    }

    public string getSkipExpression() {
        return skipExpression;
    }

    public void setSkipExpression(string skipExpression) {
        this.skipExpression = skipExpression;
    }

    public boolean isUseLocalScopeForResultVariable() {
        return useLocalScopeForResultVariable;
    }

    public void setUseLocalScopeForResultVariable(boolean useLocalScopeForResultVariable) {
        this.useLocalScopeForResultVariable = useLocalScopeForResultVariable;
    }

    public boolean isTriggerable() {
        return triggerable;
    }

    public void setTriggerable(boolean triggerable) {
        this.triggerable = triggerable;
    }

    @Override
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

        fieldExtensions = new ArrayList<>();
        if (otherElement.getFieldExtensions() != null && !otherElement.getFieldExtensions().isEmpty()) {
            for (FieldExtension extension : otherElement.getFieldExtensions()) {
                fieldExtensions.add(extension.clone());
            }
        }

        customProperties = new ArrayList<>();
        if (otherElement.getCustomProperties() != null && !otherElement.getCustomProperties().isEmpty()) {
            for (CustomProperty property : otherElement.getCustomProperties()) {
                customProperties.add(property.clone());
            }
        }
    }
}
