/* Licensed under the Apache License, Version 2.0 (the "License");
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
module flow.engine.impl.cmd.StartProcessInstanceCmd;

import hunt.collection;
import hunt.collection.HashMap;
import hunt.collection.Map;

import flow.bpmn.model.BpmnModel;
import flow.bpmn.model.FlowElement;
import flow.bpmn.model.Process;
import flow.bpmn.model.StartEvent;
import flow.bpmn.model.ValuedDataObject;
import flow.common.api.FlowableIllegalArgumentException;
import flow.common.api.FlowableObjectNotFoundException;
import flow.common.api.scop.ScopeTypes;
import flow.common.interceptor.Command;
import flow.common.interceptor.CommandContext;
import flow.engine.ProcessEngineConfiguration;
import flow.engine.impl.cfg.ProcessEngineConfigurationImpl;
import flow.engine.impl.persistence.entity.ProcessDefinitionEntityManager;
import flow.engine.impl.runtime.ProcessInstanceBuilderImpl;
import flow.engine.impl.util.CommandContextUtil;
import flow.engine.impl.util.ProcessDefinitionUtil;
import flow.engine.impl.util.ProcessInstanceHelper;
import flow.engine.impl.util.TaskHelper;
import flow.engine.repository.ProcessDefinition;
import flow.engine.runtime.ProcessInstance;
import flow.form.api.FormFieldHandler;
import flow.form.api.FormInfo;
import flow.form.api.FormRepositoryService;
import flow.form.api.FormService;
import flow.variable.service.impl.el.NoExecutionVariableScope;

/**
 * @author Tom Baeyens
 * @author Joram Barrez
 */
class StartProcessInstanceCmd : Command!ProcessInstance {

    protected string processDefinitionKey;
    protected string processDefinitionId;
    protected Map!(string, Object) variables;
    protected Map!(string, Object) transientVariables;
    protected string businessKey;
    protected string tenantId;
    protected string overrideDefinitionTenantId;
    protected string predefinedProcessInstanceId;
    protected string processInstanceName;
    protected string callbackId;
    protected string callbackType;
    protected string referenceId;
    protected string referenceType;
    protected string stageInstanceId;
    protected Map!(string, Object) startFormVariables;
    protected string outcome;
    protected bool fallbackToDefaultTenant;
    protected ProcessInstanceHelper processInstanceHelper;

    this(string processDefinitionKey, string processDefinitionId, string businessKey, Map!(string, Object) variables) {
        this.processDefinitionKey = processDefinitionKey;
        this.processDefinitionId = processDefinitionId;
        this.businessKey = businessKey;
        this.variables = variables;
    }

    this(string processDefinitionKey, string processDefinitionId, string businessKey, Map!(string, Object) variables, string tenantId) {
        this(processDefinitionKey, processDefinitionId, businessKey, variables);
        this.tenantId = tenantId;
    }

    this(ProcessInstanceBuilderImpl processInstanceBuilder) {
        this(processInstanceBuilder.getProcessDefinitionKey(),
                processInstanceBuilder.getProcessDefinitionId(),
                processInstanceBuilder.getBusinessKey(),
                processInstanceBuilder.getVariables(),
                processInstanceBuilder.getTenantId());

        this.processInstanceName = processInstanceBuilder.getProcessInstanceName();
        this.overrideDefinitionTenantId = processInstanceBuilder.getOverrideDefinitionTenantId();
        this.predefinedProcessInstanceId = processInstanceBuilder.getPredefinedProcessInstanceId();
        this.transientVariables = processInstanceBuilder.getTransientVariables();
        this.callbackId = processInstanceBuilder.getCallbackId();
        this.callbackType = processInstanceBuilder.getCallbackType();
        this.referenceId = processInstanceBuilder.getReferenceId();
        this.referenceType = processInstanceBuilder.getReferenceType();
        this.stageInstanceId = processInstanceBuilder.getStageInstanceId();
        this.startFormVariables = processInstanceBuilder.getStartFormVariables();
        this.outcome = processInstanceBuilder.getOutcome();
        this.fallbackToDefaultTenant = processInstanceBuilder.isFallbackToDefaultTenant();
    }

    override
    public ProcessInstance execute(CommandContext commandContext) {
        ProcessEngineConfigurationImpl processEngineConfiguration = CommandContextUtil.getProcessEngineConfiguration(commandContext);
        processInstanceHelper = processEngineConfiguration.getProcessInstanceHelper();
        ProcessDefinition processDefinition = getProcessDefinition(processEngineConfiguration);

        ProcessInstance processInstance = null;
        if (hasStartFormData()) {
            processInstance = handleProcessInstanceWithForm(commandContext, processDefinition, processEngineConfiguration);
        } else {
            processInstance = startProcessInstance(processDefinition);
        }

        return processInstance;
    }

    protected ProcessInstance handleProcessInstanceWithForm(CommandContext commandContext, ProcessDefinition processDefinition,
                    ProcessEngineConfigurationImpl processEngineConfiguration) {
        FormInfo formInfo = null;
        Map!(string, Object) processVariables = null;

        if (hasStartFormData()) {

            FormService formService = CommandContextUtil.getFormService(commandContext);
            BpmnModel bpmnModel = ProcessDefinitionUtil.getBpmnModel(processDefinition.getId());
            Process process = bpmnModel.getProcessById(processDefinition.getKey());
            FlowElement startElement = process.getInitialFlowElement();

            if (cast(StartEvent)startElement !is null) {
                StartEvent startEvent = cast(StartEvent) startElement;
                if (startEvent.getFormKey() !is null && startEvent.getFormKey().length != 0) {
                    FormRepositoryService formRepositoryService = CommandContextUtil.getFormRepositoryService(commandContext);

                    if (tenantId is null || ProcessEngineConfiguration.NO_TENANT_ID == (tenantId)) {
                        formInfo = formRepositoryService.getFormModelByKey(startEvent.getFormKey());
                    } else {
                        formInfo = formRepositoryService.getFormModelByKey(startEvent.getFormKey(), tenantId, processEngineConfiguration.isFallbackToDefaultTenant());
                    }

                    if (formInfo !is null) {
                        if (isFormFieldValidationEnabled(processEngineConfiguration, startEvent)) {
                            formService.validateFormFields(formInfo, startFormVariables);
                        }
                        // The processVariables are the variables that should be used when starting the process
                        // the actual variables should instead be used when saving the form instances
                        processVariables = formService.getVariablesFromFormSubmission(formInfo, startFormVariables, outcome);
                        if (processVariables !is null) {
                            if (variables is null) {
                                variables = new HashMap!(string, Object)();
                            }
                            variables.putAll(processVariables);
                        }
                    }
                }
            }

        }

        ProcessInstance processInstance = startProcessInstance(processDefinition);

        if (formInfo !is null) {
            FormService formService = CommandContextUtil.getFormService(commandContext);
            formService.createFormInstance(startFormVariables, formInfo, null, processInstance.getId(),
                            processInstance.getProcessDefinitionId(), processInstance.getTenantId(), outcome);
            FormFieldHandler formFieldHandler = processEngineConfiguration.getFormFieldHandler();
            formFieldHandler.handleFormFieldsOnSubmit(formInfo, null, processInstance.getId(), null, null, variables, processInstance.getTenantId());
        }

        return processInstance;
    }

    protected bool isFormFieldValidationEnabled(ProcessEngineConfigurationImpl processEngineConfiguration, StartEvent startEvent) {
        if (processEngineConfiguration.isFormFieldValidationEnabled()) {
            return TaskHelper.isFormFieldValidationEnabled(NoExecutionVariableScope.getSharedInstance() // process instance does not exist yet
                , processEngineConfiguration, startEvent.getValidateFormFields());
        }
        return false;
    }

    protected ProcessInstance startProcessInstance(ProcessDefinition processDefinition) {
        return processInstanceHelper.createProcessInstance(processDefinition, businessKey, processInstanceName,
            overrideDefinitionTenantId, predefinedProcessInstanceId, variables, transientVariables,
            callbackId, callbackType, referenceId, referenceType, stageInstanceId, true);
    }

    protected bool hasStartFormData() {
        return startFormVariables !is null ||  outcome.length != 0;
    }

    protected ProcessDefinition getProcessDefinition(ProcessEngineConfigurationImpl processEngineConfiguration) {
        ProcessDefinitionEntityManager processDefinitionEntityManager = processEngineConfiguration.getProcessDefinitionEntityManager();

        // Find the process definition
        ProcessDefinition processDefinition = null;
        if (processDefinitionId !is null && processDefinitionId.length != 0) {
            processDefinition = processDefinitionEntityManager.findById(processDefinitionId);
            if (processDefinition is null) {
                throw new FlowableObjectNotFoundException("No process definition found for id = '" ~ processDefinitionId ~ "'");
            }

        } else if (processDefinitionKey !is null  && processDefinitionKey.length != 0 && (tenantId is null || ProcessEngineConfiguration.NO_TENANT_ID == (tenantId))) {

            processDefinition = processDefinitionEntityManager.findLatestProcessDefinitionByKey(processDefinitionKey);
            if (processDefinition is null) {
                throw new FlowableObjectNotFoundException("No process definition found for key '" ~ processDefinitionKey ~ "'");
            }

        } else if (processDefinitionKey !is null &&processDefinitionKey.length != 0 && tenantId !is null && ProcessEngineConfiguration.NO_TENANT_ID != (tenantId)) {
            processDefinition = processDefinitionEntityManager.findLatestProcessDefinitionByKeyAndTenantId(processDefinitionKey, tenantId);
            if (processDefinition is null) {
                if (fallbackToDefaultTenant || processEngineConfiguration.isFallbackToDefaultTenant()) {
                    string defaultTenant = processEngineConfiguration.getDefaultTenantProvider().getDefaultTenant(tenantId, ScopeTypes.BPMN, processDefinitionKey);
                    if (defaultTenant !is null && defaultTenant.length != 0) {
                        processDefinition = processDefinitionEntityManager.findLatestProcessDefinitionByKeyAndTenantId(processDefinitionKey, defaultTenant);
                        if (processDefinition !is null) {
                            overrideDefinitionTenantId = tenantId;
                        }

                    } else {
                        processDefinition = processDefinitionEntityManager.findLatestProcessDefinitionByKey(processDefinitionKey);
                    }

                    if (processDefinition is null) {
                        throw new FlowableObjectNotFoundException("No process definition found for key '" ~ processDefinitionKey ~
                            "'. Fallback to default tenant was also applied.");
                    }
                } else {
                    throw new FlowableObjectNotFoundException("Process definition with key '" ~ processDefinitionKey ~
                        "' and tenantId '"~ tenantId ~"' was not found");
                }
            }

        } else {
            throw new FlowableIllegalArgumentException("processDefinitionKey and processDefinitionId are null");
        }
        return processDefinition;
    }

    protected Map!(string, Object) processDataObjects(Collection!ValuedDataObject dataObjects) {
        Map!(string, Object) variablesMap = new HashMap!(string, Object)();
        // convert data objects to process variables
        if (dataObjects !is null) {
            foreach (ValuedDataObject dataObject ; dataObjects) {
                variablesMap.put(dataObject.getName(), dataObject.getValue());
            }
        }
        return variablesMap;
    }
}
