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

module flow.bpmn.model.CallActivity;

import flow.bpmn.model.BaseElement;
import hunt.collection.ArrayList;
import hunt.collection.List;
import flow.bpmn.model.Activity;
import flow.bpmn.model.IOParameter;
import flow.bpmn.model.FlowElement;
import flow.bpmn.model.FlowNode;

/**
 * @author Tijs Rademakers
 * @author Joram Barrez
 */
class CallActivity : Activity {

    protected string calledElement;
    protected string calledElementType;
    protected bool inheritVariables;
    protected bool sameDeployment;
    protected List!IOParameter inParameters ;// = new ArrayList<>();
    protected List!IOParameter outParameters ;// = new ArrayList<>();
    protected string processInstanceName;
    protected string businessKey;
    protected bool inheritBusinessKey;
    protected bool useLocalScopeForOutParameters;
    protected bool completeAsync;
    protected bool fallbackToDefaultTenant;
    protected string processInstanceIdVariableName;

    alias setValues = BaseElement.setValues;
    alias setValues = FlowElement.setValues;
    alias setValues = FlowNode.setValues;
    alias setValues = Activity.setValues;
  this()
    {
        inParameters = new ArrayList!IOParameter;
        outParameters = new ArrayList!IOParameter;
    }

    public string getCalledElement() {
        return calledElement;
    }

    public void setCalledElement(string calledElement) {
        this.calledElement = calledElement;
    }

    public bool isInheritVariables() {
        return inheritVariables;
    }

    public void setInheritVariables(bool inheritVariables) {
        this.inheritVariables = inheritVariables;
    }

    public bool isSameDeployment() {
        return sameDeployment;
    }

    public void setSameDeployment(bool sameDeployment) {
        this.sameDeployment = sameDeployment;
    }

    public List!IOParameter getInParameters() {
        return inParameters;
    }

    public void setInParameters(List!IOParameter inParameters) {
        this.inParameters = inParameters;
    }

    public List!IOParameter getOutParameters() {
        return outParameters;
    }

    public void setOutParameters(List!IOParameter outParameters) {
        this.outParameters = outParameters;
    }

    public string getProcessInstanceName() {
        return processInstanceName;
    }

    public void setProcessInstanceName(string processInstanceName) {
        this.processInstanceName = processInstanceName;
    }

    public string getBusinessKey() {
        return businessKey;
    }

    public void setBusinessKey(string businessKey) {
        this.businessKey = businessKey;
    }

    public bool isInheritBusinessKey() {
        return inheritBusinessKey;
    }

    public void setInheritBusinessKey(bool inheritBusinessKey) {
        this.inheritBusinessKey = inheritBusinessKey;
    }

    public bool isUseLocalScopeForOutParameters() {
        return useLocalScopeForOutParameters;
    }

    public void setUseLocalScopeForOutParameters(bool useLocalScopeForOutParameters) {
        this.useLocalScopeForOutParameters = useLocalScopeForOutParameters;
    }

    public bool isCompleteAsync() {
        return completeAsync;
    }

    public void setCompleteAsync(bool completeAsync) {
        this.completeAsync = completeAsync;
    }

    public bool getFallbackToDefaultTenant() {
        return fallbackToDefaultTenant;
    }

    public void setFallbackToDefaultTenant(bool fallbackToDefaultTenant) {
        this.fallbackToDefaultTenant = fallbackToDefaultTenant;
    }

    override
    public CallActivity clone() {
        CallActivity clone = new CallActivity();
        clone.setValues(this);
        return clone;
    }

    public void setValues(CallActivity otherElement) {
        super.setValues(otherElement);
        setCalledElement(otherElement.getCalledElement());
        setCalledElementType(otherElement.getCalledElementType());
        setBusinessKey(otherElement.getBusinessKey());
        setInheritBusinessKey(otherElement.isInheritBusinessKey());
        setInheritVariables(otherElement.isInheritVariables());
        setSameDeployment(otherElement.isSameDeployment());
        setUseLocalScopeForOutParameters(otherElement.isUseLocalScopeForOutParameters());
        setCompleteAsync(otherElement.isCompleteAsync());
        setFallbackToDefaultTenant(otherElement.getFallbackToDefaultTenant());

        inParameters = new ArrayList!IOParameter();
        if (otherElement.getInParameters() !is null && !otherElement.getInParameters().isEmpty()) {
            foreach (IOParameter parameter ; otherElement.getInParameters()) {
                inParameters.add(parameter.clone());
            }
        }

        outParameters = new ArrayList!IOParameter();
        if (otherElement.getOutParameters() !is null && !otherElement.getOutParameters().isEmpty()) {
            foreach (IOParameter parameter ; otherElement.getOutParameters()) {
                outParameters.add(parameter.clone());
            }
        }
    }

    public void setCalledElementType(string calledElementType) {
        this.calledElementType = calledElementType;
    }

    public string getCalledElementType() {
        return calledElementType;
    }

    public string getProcessInstanceIdVariableName() {
        return processInstanceIdVariableName;
    }

    public void setProcessInstanceIdVariableName(string processInstanceIdVariableName) {
        this.processInstanceIdVariableName = processInstanceIdVariableName;
    }

}
