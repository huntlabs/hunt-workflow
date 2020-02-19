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


import org.apache.commons.lang3.StringUtils;
import org.apache.commons.lang3.exception.ExceptionUtils;
import flow.common.api.FlowableException;
import flow.common.scripting.ScriptingEngines;
import flow.engine.DynamicBpmnConstants;
import flow.engine.deleg.BpmnError;
import flow.engine.deleg.DelegateExecution;
import flow.engine.impl.bpmn.helper.ErrorPropagation;
import flow.engine.impl.context.BpmnOverrideContext;
import flow.engine.impl.util.CommandContextUtil;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.fasterxml.jackson.databind.node.ObjectNode;

/**
 * Implementation of the BPMN 2.0 script task.
 *
 * @author Joram Barrez
 * @author Christian Stettler
 * @author Falko Menge
 */
class ScriptTaskActivityBehavior extends TaskActivityBehavior {

    private static final long serialVersionUID = 1L;

    private static final Logger LOGGER = LoggerFactory.getLogger(ScriptTaskActivityBehavior.class);

    protected string scriptTaskId;
    protected string script;
    protected string language;
    protected string resultVariable;
    protected bool storeScriptVariables; // see https://activiti.atlassian.net/browse/ACT-1626

    public ScriptTaskActivityBehavior(string script, string language, string resultVariable) {
        this.script = script;
        this.language = language;
        this.resultVariable = resultVariable;
    }

    public ScriptTaskActivityBehavior(string scriptTaskId, string script, string language, string resultVariable, bool storeScriptVariables) {
        this(script, language, resultVariable);
        this.scriptTaskId = scriptTaskId;
        this.storeScriptVariables = storeScriptVariables;
    }

    @Override
    public void execute(DelegateExecution execution) {

        ScriptingEngines scriptingEngines = CommandContextUtil.getProcessEngineConfiguration().getScriptingEngines();

        if (CommandContextUtil.getProcessEngineConfiguration().isEnableProcessDefinitionInfoCache()) {
            ObjectNode taskElementProperties = BpmnOverrideContext.getBpmnOverrideElementProperties(scriptTaskId, execution.getProcessDefinitionId());
            if (taskElementProperties !is null && taskElementProperties.has(DynamicBpmnConstants.SCRIPT_TASK_SCRIPT)) {
                string overrideScript = taskElementProperties.get(DynamicBpmnConstants.SCRIPT_TASK_SCRIPT).asText();
                if (StringUtils.isNotEmpty(overrideScript) && !overrideScript.equals(script)) {
                    script = overrideScript;
                }
            }
        }

        bool noErrors = true;
        try {
            Object result = scriptingEngines.evaluate(script, language, execution, storeScriptVariables);

            if (null != result) {
                if (language.equalsIgnoreCase("juel") && (result instanceof string) && script.equals(result.toString())) {
                    throw new FlowableException("Error in Script");
                }
            }

            if (resultVariable !is null) {
                execution.setVariable(resultVariable, result);
            }

        } catch (FlowableException e) {

            LOGGER.warn("Exception while executing {} : {}", execution.getCurrentFlowElement().getId(), e.getMessage());

            noErrors = false;
            Throwable rootCause = ExceptionUtils.getRootCause(e);
            if (rootCause instanceof BpmnError) {
                ErrorPropagation.propagateError((BpmnError) rootCause, execution);
            } else {
                throw e;
            }
        }
        if (noErrors) {
            leave(execution);
        }
    }

}
