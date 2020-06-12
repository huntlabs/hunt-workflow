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
module flow.engine.impl.cmd.GetStartFormModelCmd;

import flow.bpmn.model.BpmnModel;
import flow.bpmn.model.FlowElement;
import flow.bpmn.model.Process;
import flow.bpmn.model.StartEvent;
import flow.common.api.FlowableIllegalArgumentException;
import flow.common.api.FlowableObjectNotFoundException;
import flow.common.interceptor.Command;
import flow.common.interceptor.CommandContext;
import flow.engine.impl.cfg.ProcessEngineConfigurationImpl;
import flow.engine.impl.util.CommandContextUtil;
import flow.engine.impl.util.ProcessDefinitionUtil;
import flow.engine.repository.Deployment;
import flow.engine.repository.ProcessDefinition;
import flow.form.api.FormFieldHandler;
import flow.form.api.FormInfo;
import flow.form.api.FormService;

/**
 * @author Tijs Rademakers
 */
class GetStartFormModelCmd : Command!FormInfo {

    protected string processDefinitionId;
    protected string processInstanceId;

    this(string processDefinitionId, string processInstanceId) {
        this.processDefinitionId = processDefinitionId;
        this.processInstanceId = processInstanceId;
    }

    public FormInfo execute(CommandContext commandContext) {
        ProcessEngineConfigurationImpl processEngineConfiguration = CommandContextUtil.getProcessEngineConfiguration(commandContext);
        FormService formService = CommandContextUtil.getFormService(commandContext);
        if (formService is null) {
            throw new FlowableIllegalArgumentException("Form engine is not initialized");
        }

        FormInfo formInfo = null;
        ProcessDefinition processDefinition = ProcessDefinitionUtil.getProcessDefinition(processDefinitionId);
        BpmnModel bpmnModel = ProcessDefinitionUtil.getBpmnModel(processDefinitionId);
        Process process = bpmnModel.getProcessById(processDefinition.getKey());
        FlowElement startElement = process.getInitialFlowElement();
        if (cast(StartEvent)startElement !is null) {
            StartEvent startEvent = cast(StartEvent) startElement;
            if (startEvent.getFormKey() !is null && startEvent.getFormKey().length != 0) {
                Deployment deployment = CommandContextUtil.getDeploymentEntityManager(commandContext).findById(processDefinition.getDeploymentId());
                formInfo = formService.getFormInstanceModelByKeyAndParentDeploymentId(startEvent.getFormKey(), deployment.getParentDeploymentId(),
                                null, processInstanceId, null, processDefinition.getTenantId(), processEngineConfiguration.isFallbackToDefaultTenant());
            }
        }

        // If form does not exists, we don't want to leak out this info to just anyone
        if (formInfo is null) {
            throw new FlowableObjectNotFoundException("Form model for process definition " ~ processDefinitionId ~ " cannot be found");
        }

        FormFieldHandler formFieldHandler = processEngineConfiguration.getFormFieldHandler();
        formFieldHandler.enrichFormFields(formInfo);

        return formInfo;
    }

}
