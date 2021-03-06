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

module flow.engine.impl.cmd.SubmitStartFormCmd;

import hunt.String;
import hunt.collection.HashMap;
import hunt.collection.Map;

import flow.common.interceptor.CommandContext;
import flow.engine.compatibility.Flowable5CompatibilityHandler;
import flow.engine.impl.form.FormHandlerHelper;
import flow.engine.impl.form.StartFormHandler;
import flow.engine.impl.persistence.entity.ExecutionEntity;
import flow.engine.impl.persistence.entity.ProcessDefinitionEntity;
import flow.engine.impl.util.CommandContextUtil;
//import flow.engine.impl.util.Flowable5Util;
import flow.engine.impl.util.ProcessInstanceHelper;
import flow.engine.runtime.ProcessInstance;
import flow.engine.impl.cmd.NeedsActiveProcessDefinitionCmd;
/**
 * @author Tom Baeyens
 * @author Joram Barrez
 */
class SubmitStartFormCmd : NeedsActiveProcessDefinitionCmd!ProcessInstance {


    protected  string businessKey;
    protected Map!(string, string) properties;

    this(string processDefinitionId, string businessKey, Map!(string, string) properties) {
        super(processDefinitionId);
        this.businessKey = businessKey;
        this.properties = properties;
    }

    override
    protected ProcessInstance execute(CommandContext commandContext, ProcessDefinitionEntity processDefinition) {
        //if (Flowable5Util.isFlowable5ProcessDefinition(processDefinition, commandContext)) {
        //    Flowable5CompatibilityHandler compatibilityHandler = Flowable5Util.getFlowable5CompatibilityHandler();
        //    return compatibilityHandler.submitStartFormData(processDefinition.getId(), businessKey, properties);
        //}

        ExecutionEntity processInstance = null;
        ProcessInstanceHelper processInstanceHelper = CommandContextUtil.getProcessEngineConfiguration(commandContext).getProcessInstanceHelper();

        // TODO: backwards compatibility? Only create the process instance and not start it? How?
        if (businessKey !is null && businessKey.length != 0) {
            processInstance = cast(ExecutionEntity) processInstanceHelper.createProcessInstance(processDefinition, businessKey, null, null, null);
        } else {
            processInstance = cast(ExecutionEntity) processInstanceHelper.createProcessInstance(processDefinition, null, null, null, null);
        }

        CommandContextUtil.getHistoryManager(commandContext).recordFormPropertiesSubmitted(processInstance.getExecutionEntities().get(0), properties, null,
            commandContext.getCurrentEngineConfiguration().getClock().getCurrentTime());

        FormHandlerHelper formHandlerHelper = CommandContextUtil.getProcessEngineConfiguration(commandContext).getFormHandlerHelper();
        StartFormHandler startFormHandler = formHandlerHelper.getStartFormHandler(commandContext, processDefinition);
        startFormHandler.submitFormProperties(properties, processInstance);

        processInstanceHelper.startProcessInstance(processInstance, commandContext, convertPropertiesToVariablesMap());

        return processInstance;
    }

    protected Map!(string, Object) convertPropertiesToVariablesMap() {
        Map!(string, Object) vars = new HashMap!(string, Object)(properties.size());
        foreach (MapEntry!(string, string) key ; properties) {
            vars.put(key.getKey(), new String(properties.get(key.getKey())));
        }
        return vars;
    }

}
