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

module flow.bpmn.model.ScriptTask;

import flow.bpmn.model.Task;
import flow.bpmn.model.BaseElement;
import flow.bpmn.model.FlowElement;
import flow.bpmn.model.FlowNode;
import flow.bpmn.model.Activity;

/**
 * @author Tijs Rademakers
 * @author Joram Barrez
 */
class ScriptTask : Task {

    alias setValues = BaseElement.setValues;
    alias setValues = FlowElement.setValues;
    alias setValues = FlowNode.setValues;
    alias setValues = Activity.setValues;

    protected string scriptFormat;
    protected string script;
    protected string resultVariable;
    protected bool autoStoreVariables; // see https://activiti.atlassian.net/browse/ACT-1626

    override
    string getClassType()
    {
      return "scriptTask";
    }
    public string getScriptFormat() {
        return scriptFormat;
    }

    public void setScriptFormat(string scriptFormat) {
        this.scriptFormat = scriptFormat;
    }

    public string getScript() {
        return script;
    }

    public void setScript(string script) {
        this.script = script;
    }

    public string getResultVariable() {
        return resultVariable;
    }

    public void setResultVariable(string resultVariable) {
        this.resultVariable = resultVariable;
    }

    public bool isAutoStoreVariables() {
        return autoStoreVariables;
    }

    public void setAutoStoreVariables(bool autoStoreVariables) {
        this.autoStoreVariables = autoStoreVariables;
    }

    override
    public ScriptTask clone() {
        ScriptTask clone = new ScriptTask();
        clone.setValues(this);
        return clone;
    }

    public void setValues(ScriptTask otherElement) {
        super.setValues(otherElement);
        setScriptFormat(otherElement.getScriptFormat());
        setScript(otherElement.getScript());
        setResultVariable(otherElement.getResultVariable());
        setAutoStoreVariables(otherElement.isAutoStoreVariables());
    }
}
