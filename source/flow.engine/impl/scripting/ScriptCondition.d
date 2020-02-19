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


import flow.common.api.FlowableException;
import flow.common.scripting.ScriptingEngines;
import flow.engine.deleg.DelegateExecution;
import flow.engine.impl.Condition;
import flow.engine.impl.util.CommandContextUtil;

/**
 * @author Tom Baeyens
 */
class ScriptCondition implements Condition {

    private final string expression;
    private final string language;

    public ScriptCondition(string expression, string language) {
        this.expression = expression;
        this.language = language;
    }

    @Override
    public bool evaluate(string sequenceFlowId, DelegateExecution execution) {
        ScriptingEngines scriptingEngines = CommandContextUtil.getProcessEngineConfiguration().getScriptingEngines();

        Object result = scriptingEngines.evaluate(expression, language, execution);
        if (result is null) {
            throw new FlowableException("condition script returns null: " + expression);
        }
        if (!(result instanceof bool)) {
            throw new FlowableException("condition script returns non-bool: " + result + " (" + result.getClass().getName() + ")");
        }
        return (bool) result;
    }

}
