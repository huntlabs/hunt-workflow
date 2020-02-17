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
class BusinessRuleTask extends Task {

    protected string resultVariableName;
    protected boolean exclude;
    protected List<string> ruleNames = new ArrayList<>();
    protected List<string> inputVariables = new ArrayList<>();
    protected string className;

    public boolean isExclude() {
        return exclude;
    }

    public void setExclude(boolean exclude) {
        this.exclude = exclude;
    }

    public string getResultVariableName() {
        return resultVariableName;
    }

    public void setResultVariableName(string resultVariableName) {
        this.resultVariableName = resultVariableName;
    }

    public List<string> getRuleNames() {
        return ruleNames;
    }

    public void setRuleNames(List<string> ruleNames) {
        this.ruleNames = ruleNames;
    }

    public List<string> getInputVariables() {
        return inputVariables;
    }

    public void setInputVariables(List<string> inputVariables) {
        this.inputVariables = inputVariables;
    }

    public string getClassName() {
        return className;
    }

    public void setClassName(string className) {
        this.className = className;
    }

    @Override
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
        ruleNames = new ArrayList<>(otherElement.getRuleNames());
        inputVariables = new ArrayList<>(otherElement.getInputVariables());
    }
}
