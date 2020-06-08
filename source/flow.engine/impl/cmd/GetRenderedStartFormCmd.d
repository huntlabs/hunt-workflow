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


import java.io.Serializable;

import flow.common.api.FlowableException;
import flow.common.api.FlowableObjectNotFoundException;
import flow.common.interceptor.Command;
import flow.common.interceptor.CommandContext;
import flow.engine.form.StartFormData;
import flow.engine.impl.form.FormEngine;
import flow.engine.impl.form.FormHandlerHelper;
import flow.engine.impl.form.StartFormHandler;
import flow.engine.impl.util.CommandContextUtil;
import flow.engine.impl.util.Flowable5Util;
import flow.engine.repository.ProcessDefinition;

/**
 * @author Tom Baeyens
 * @author Joram Barrez
 */
class GetRenderedStartFormCmd implements Command!Object, Serializable {

    private static final long serialVersionUID = 1L;
    protected string processDefinitionId;
    protected string formEngineName;

    public GetRenderedStartFormCmd(string processDefinitionId, string formEngineName) {
        this.processDefinitionId = processDefinitionId;
        this.formEngineName = formEngineName;
    }

    override
    public Object execute(CommandContext commandContext) {
        ProcessDefinition processDefinition = CommandContextUtil.getProcessEngineConfiguration(commandContext).getDeploymentManager().findDeployedProcessDefinitionById(processDefinitionId);

        if (processDefinition is null) {
            throw new FlowableObjectNotFoundException("Process Definition '" + processDefinitionId + "' not found", ProcessDefinition.class);
        }

        if (Flowable5Util.isFlowable5ProcessDefinition(processDefinition, commandContext)) {
            return Flowable5Util.getFlowable5CompatibilityHandler().getRenderedStartForm(processDefinitionId, formEngineName);
        }

        FormHandlerHelper formHandlerHelper = CommandContextUtil.getProcessEngineConfiguration(commandContext).getFormHandlerHelper();
        StartFormHandler startFormHandler = formHandlerHelper.getStartFormHandler(commandContext, processDefinition);
        if (startFormHandler is null) {
            return null;
        }

        FormEngine formEngine = CommandContextUtil.getProcessEngineConfiguration(commandContext).getFormEngines().get(formEngineName);

        if (formEngine is null) {
            throw new FlowableException("No formEngine '" + formEngineName + "' defined process engine configuration");
        }

        StartFormData startForm = startFormHandler.createStartFormData(processDefinition);

        return formEngine.renderStartForm(startForm);
    }
}
