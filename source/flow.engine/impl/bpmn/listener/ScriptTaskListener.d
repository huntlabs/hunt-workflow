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

module flow.engine.impl.bpmn.listener.ScriptTaskListener;

import flow.engine.deleg.TaskListener;
import flow.engine.impl.util.CommandContextUtil;
import flow.task.service.deleg.DelegateTask;
import flow.common.api.deleg.Expression;
//import flow.common.scripting.ScriptingEngines;
import hunt.Exceptions;
/**
 * @author Rich Kroll
 * @author Joram Barrez
 */
class ScriptTaskListener : TaskListener {


    protected Expression script;

    protected Expression language;

    protected Expression resultVariable;

    protected bool autoStoreVariables;

    public void notify(DelegateTask delegateTask) {
        implementationMissing(false);
        //validateParameters();
        //
        //ScriptingEngines scriptingEngines = CommandContextUtil.getProcessEngineConfiguration().getScriptingEngines();
        //Object result = scriptingEngines.evaluate(script.getExpressionText(), language.getExpressionText(), delegateTask, autoStoreVariables);
        //
        //if (resultVariable !is null) {
        //    delegateTask.setVariable(resultVariable.getExpressionText(), result);
        //}
    }

    protected void validateParameters() {
        if (script is null) {
            throw new IllegalArgumentException("The field 'script' should be set on the TaskListener");
        }

        if (language is null) {
            throw new IllegalArgumentException("The field 'language' should be set on the TaskListener");
        }
    }

    public void setScript(Expression script) {
        this.script = script;
    }

    public void setLanguage(Expression language) {
        this.language = language;
    }

    public void setResultVariable(Expression resultVariable) {
        this.resultVariable = resultVariable;
    }

    public void setAutoStoreVariables(bool autoStoreVariables) {
        this.autoStoreVariables = autoStoreVariables;
    }

}
