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

module flow.bpmn.model.BusinessRuleTask;

import flow.bpmn.model.FlowElement;
import flow.bpmn.model.BaseElement;
import flow.bpmn.model.FlowNode;
import hunt.collection.ArrayList;
import hunt.collection.List;
import flow.bpmn.model.Task;
import flow.bpmn.model.Activity;
/**
 * @author Tijs Rademakers
 */
class BusinessRuleTask : Task {

    protected string resultVariableName;
    protected bool exclude;
    protected List!string ruleNames ;// = new ArrayList<>();
    protected List!string inputVariables ;//= new ArrayList<>();
    protected string className;

    alias setValues = BaseElement.setValues;
    alias  setValues = FlowElement.setValues;
    alias setValues = FlowNode.setValues;
    alias setValues = Activity.setValues;

    this()
    {
      ruleNames = new ArrayList!string;
      inputVariables = new ArrayList!string;
    }

    public bool isExclude() {
        return exclude;
    }

    public void setExclude(bool exclude) {
        this.exclude = exclude;
    }

    public string getResultVariableName() {
        return resultVariableName;
    }

    public void setResultVariableName(string resultVariableName) {
        this.resultVariableName = resultVariableName;
    }

    public List!string getRuleNames() {
        return ruleNames;
    }

    public void setRuleNames(List!string ruleNames) {
        this.ruleNames = ruleNames;
    }

    public List!string getInputVariables() {
        return inputVariables;
    }

    public void setInputVariables(List!string inputVariables) {
        this.inputVariables = inputVariables;
    }

    public string getClassName() {
        return className;
    }

    public void setClassName(string className) {
        this.className = className;
    }

    override
    public BusinessRuleTask clone() {
        BusinessRuleTask clone = new BusinessRuleTask();
        clone.setValues(this);
        return clone;
    }

    public void setValues(BusinessRuleTask otherElement) {
        super.setValues(otherElement);
        setResultVariableName(otherElement.getResultVariableName());
        setExclude(otherElement.isExclude());
        setClassName(otherElement.getClassName());
        ruleNames = new ArrayList!string(otherElement.getRuleNames());
        inputVariables = new ArrayList!string(otherElement.getInputVariables());
    }
}
