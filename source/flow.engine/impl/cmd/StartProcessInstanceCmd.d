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


import java.io.Serializable;
import java.util.Collection;
import java.util.HashMap;
import java.util.Map;

import org.apache.commons.lang3.StringUtils;
import org.flowable.bpmn.model.BpmnModel;
import org.flowable.bpmn.model.FlowElement;
import org.flowable.bpmn.model.Process;
import org.flowable.bpmn.model.StartEvent;
import org.flowable.bpmn.model.ValuedDataObject;
import flow.common.api.FlowableIllegalArgumentException;
import flow.common.api.FlowableObjectNotFoundException;
import flow.common.api.scope.ScopeTypes;
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
import org.flowable.form.api.FormFieldHandler;
import org.flowable.form.api.FormInfo;
import org.flowable.form.api.FormRepositoryService;
import org.flowable.form.api.FormService;
import org.flowable.variable.service.impl.el.NoExecutionVariableScope;

/**
 * @author Tom Baeyens
 * @author Joram Barrez
 */
class StartProcessInstanceCmd<T> implements Command<ProcessInstance>, Serializable {

    private static final long serialVersionUID = 1L;
    protected string processDefinitionKey;
    protected string processDefinitionId;
    protected Map<string, Object> variables;
    protected Map<string, Object> transientVariables;
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
    protected Map<string, Object> startFormVariables;
    protected string outcome;
    protected boolean fallbackToDefaultTenant;
    protected ProcessInstanceHelper processInstanceHelper;

    public StartProcessInstanceCmd(string processDefinitionKey, string processDefinitionId, string businessKey, Map<string, Object> variables) {
        this.processDefinitionKey = processDefinitionKey;
        this.processDefinitionId = processDefinitionId;
        this.businessKey = businessKey;
        this.variables = variables;
    }

    public StartProcessInstanceCmd(string processDefinitionKey, string processDefinitionId, string businessKey, Map<string, Object> variables, string tenantId) {
        this(processDefinitionKey, processDefinitionId, businessKey, variables);
        this.tenantId = tenantId;
    }

    public StartProcessInstanceCmd(ProcessInstanceBuilderImpl processInstanceBuilder) {
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

    @Override
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
        Map<string, Object> processVariables = null;

        if (hasStartFormData()) {

            FormService formService = CommandContextUtil.getFormService(commandContext);
            BpmnModel bpmnModel = ProcessDefinitionUtil.getBpmnModel(processDefinition.getId());
            Process process = bpmnModel.getProcessById(processDefinition.getKey());
            FlowElement startElement = process.getInitialFlowElement();

            if (startElement instanceof StartEvent) {
                StartEvent startEvent = (StartEvent) startElement;
                if (StringUtils.isNotEmpty(startEvent.getFormKey())) {
                    FormRepositoryService formRepositoryService = CommandContextUtil.getFormRepositoryService(commandContext);

                    if (tenantId == null || ProcessEngineConfiguration.NO_TENANT_ID.equals(tenantId)) {
                        formInfo = formRepositoryService.getFormModelByKey(startEvent.getFormKey());
                    } else {
                        formInfo = formRepositoryService.getFormModelByKey(startEvent.getFormKey(), tenantId, processEngineConfiguration.isFallbackToDefaultTenant());
                    }

                    if (formInfo != null) {
                        if (isFormFieldValidationEnabled(processEngineConfiguration, startEvent)) {
                            formService.validateFormFields(formInfo, startFormVariables);
                        }
                        // The processVariables are the variables that should be used when starting the process
                        // the actual variables should instead be used when saving the form instances
                        processVariables = formService.getVariablesFromFormSubmission(formInfo, startFormVariables, outcome);
                        if (processVariables != null) {
                            if (variables == null) {
                                variables = new HashMap<>();
                            }
                            variables.putAll(processVariables);
                        }
                    }
                }
            }

        }

        ProcessInstance processInstance = startProcessInstance(processDefinition);

        if (formInfo != null) {
            FormService formService = CommandContextUtil.getFormService(commandContext);
            formService.createFormInstance(startFormVariables, formInfo, null, processInstance.getId(),
                            processInstance.getProcessDefinitionId(), processInstance.getTenantId(), outcome);
            FormFieldHandler formFieldHandler = processEngineConfiguration.getFormFieldHandler();
            formFieldHandler.handleFormFieldsOnSubmit(formInfo, null, processInstance.getId(), null, null, variables, processInstance.getTenantId());
        }

        return processInstance;
    }

    protected boolean isFormFieldValidationEnabled(ProcessEngineConfigurationImpl processEngineConfiguration, StartEvent startEvent) {
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

    protected boolean hasStartFormData() {
        return startFormVariables != null || outcome != null;
    }

    protected ProcessDefinition getProcessDefinition(ProcessEngineConfigurationImpl processEngineConfiguration) {
        ProcessDefinitionEntityManager processDefinitionEntityManager = processEngineConfiguration.getProcessDefinitionEntityManager();

        // Find the process definition
        ProcessDefinition processDefinition = null;
        if (processDefinitionId != null) {
            processDefinition = processDefinitionEntityManager.findById(processDefinitionId);
            if (processDefinition == null) {
                throw new FlowableObjectNotFoundException("No process definition found for id = '" + processDefinitionId + "'", ProcessDefinition.class);
            }

        } else if (processDefinitionKey != null && (tenantId == null || ProcessEngineConfiguration.NO_TENANT_ID.equals(tenantId))) {

            processDefinition = processDefinitionEntityManager.findLatestProcessDefinitionByKey(processDefinitionKey);
            if (processDefinition == null) {
                throw new FlowableObjectNotFoundException("No process definition found for key '" + processDefinitionKey + "'", ProcessDefinition.class);
            }

        } else if (processDefinitionKey != null && tenantId != null && !ProcessEngineConfiguration.NO_TENANT_ID.equals(tenantId)) {
            processDefinition = processDefinitionEntityManager.findLatestProcessDefinitionByKeyAndTenantId(processDefinitionKey, tenantId);
            if (processDefinition == null) {
                if (fallbackToDefaultTenant || processEngineConfiguration.isFallbackToDefaultTenant()) {
                    string defaultTenant = processEngineConfiguration.getDefaultTenantProvider().getDefaultTenant(tenantId, ScopeTypes.BPMN, processDefinitionKey);
                    if (StringUtils.isNotEmpty(defaultTenant)) {
                        processDefinition = processDefinitionEntityManager.findLatestProcessDefinitionByKeyAndTenantId(processDefinitionKey, defaultTenant);
                        if (processDefinition != null) {
                            overrideDefinitionTenantId = tenantId;
                        }
                        
                    } else {
                        processDefinition = processDefinitionEntityManager.findLatestProcessDefinitionByKey(processDefinitionKey);
                    }
                    
                    if (processDefinition == null) {
                        throw new FlowableObjectNotFoundException("No process definition found for key '" + processDefinitionKey +
                            "'. Fallback to default tenant was also applied.", ProcessDefinition.class);
                    }
                } else {
                    throw new FlowableObjectNotFoundException("Process definition with key '" + processDefinitionKey +
                        "' and tenantId '"+ tenantId +"' was not found", ProcessDefinition.class);
                }
            }

        } else {
            throw new FlowableIllegalArgumentException("processDefinitionKey and processDefinitionId are null");
        }
        return processDefinition;
    }

    protected Map<string, Object> processDataObjects(Collection<ValuedDataObject> dataObjects) {
        Map<string, Object> variablesMap = new HashMap<>();
        // convert data objects to process variables
        if (dataObjects != null) {
            for (ValuedDataObject dataObject : dataObjects) {
                variablesMap.put(dataObject.getName(), dataObject.getValue());
            }
        }
        return variablesMap;
    }
}
