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

module flow.bpmn.model.CaseServiceTask;

import flow.bpmn.model.ServiceTask;
import hunt.collection.ArrayList;
import hunt.collection.List;
import flow.bpmn.model.IOParameter;
import flow.bpmn.model.BaseElement;
import flow.bpmn.model.FlowElement;
import flow.bpmn.model.FlowNode;
import flow.bpmn.model.Activity;

/**
 * @author Tijs Rademakers
 */
class CaseServiceTask : ServiceTask {

   alias setValues = BaseElement.setValues;
   alias setValues = FlowElement.setValues;
    alias setValues = FlowNode.setValues;
    alias setValues = Activity.setValues;
  alias setValues = ServiceTask.setValues;

    protected string caseDefinitionKey;
    protected string caseInstanceName;
    protected bool sameDeployment;
    protected string businessKey;
    protected bool inheritBusinessKey;
    protected bool fallbackToDefaultTenant;
    protected string caseInstanceIdVariableName;

    protected List!IOParameter inParameters ;//= new ArrayList<>();
    protected List!IOParameter outParameters ;//= new ArrayList<>();

    this()
    {
         inParameters = new ArrayList!IOParameter;
         outParameters = new ArrayList!IOParameter;
    }

    override
    string getClassType()
    {
      return "caseServiceTask";
    }


  public string getCaseDefinitionKey() {
        return caseDefinitionKey;
    }

    public void setCaseDefinitionKey(string caseDefinitionKey) {
        this.caseDefinitionKey = caseDefinitionKey;
    }

    public string getCaseInstanceName() {
        return caseInstanceName;
    }

    public void setCaseInstanceName(string caseInstanceName) {
        this.caseInstanceName = caseInstanceName;
    }

    public bool isSameDeployment() {
        return sameDeployment;
    }

    public void setSameDeployment(bool sameDeployment) {
        this.sameDeployment = sameDeployment;
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

    public bool isFallbackToDefaultTenant() {
        return fallbackToDefaultTenant;
    }

    public void setFallbackToDefaultTenant(bool fallbackToDefaultTenant) {
        this.fallbackToDefaultTenant = fallbackToDefaultTenant;
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

    public string getCaseInstanceIdVariableName() {
        return caseInstanceIdVariableName;
    }

    public void setCaseInstanceIdVariableName(string caseInstanceIdVariableName) {
        this.caseInstanceIdVariableName = caseInstanceIdVariableName;
    }

    override
    public CaseServiceTask clone() {
        CaseServiceTask clone = new CaseServiceTask();
        clone.setValues(this);
        return clone;
    }

    public void setValues(CaseServiceTask otherElement) {
        super.setValues(otherElement);

        setCaseDefinitionKey(otherElement.getCaseDefinitionKey());
        setCaseInstanceName(otherElement.getCaseInstanceName());
        setBusinessKey(otherElement.getBusinessKey());
        setInheritBusinessKey(otherElement.isInheritBusinessKey());
        setSameDeployment(otherElement.isSameDeployment());
        setFallbackToDefaultTenant(otherElement.isFallbackToDefaultTenant());
        setCaseInstanceIdVariableName(otherElement.getCaseInstanceIdVariableName());

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
}
