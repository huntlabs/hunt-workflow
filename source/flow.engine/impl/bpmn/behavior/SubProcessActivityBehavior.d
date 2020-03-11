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



import hunt.collection;
import hunt.collection.HashMap;
import hunt.collection.Map;

import flow.bpmn.model.FlowElement;
import flow.bpmn.model.StartEvent;
import flow.bpmn.model.SubProcess;
import flow.bpmn.model.ValuedDataObject;
import flow.common.api.FlowableException;
import flow.common.context.Context;
import flow.common.interceptor.CommandContext;
import flow.common.util.CollectionUtil;
import flow.engine.deleg.DelegateExecution;
import flow.engine.impl.cfg.ProcessEngineConfigurationImpl;
import flow.engine.impl.persistence.entity.ExecutionEntity;
import flow.engine.impl.util.CommandContextUtil;
import flow.engine.impl.util.ProcessInstanceHelper;

/**
 * Implementation of the BPMN 2.0 subprocess (formally known as 'embedded' subprocess): a subprocess defined within another process definition.
 *
 * @author Joram Barrez
 */
class SubProcessActivityBehavior extends AbstractBpmnActivityBehavior {

    private static final long serialVersionUID = 1L;

    protected bool isOnlyNoneStartEventAllowed;

    public SubProcessActivityBehavior() {
        this.isOnlyNoneStartEventAllowed = true;
    }

    @Override
    public void execute(DelegateExecution execution) {
        SubProcess subProcess = getSubProcessFromExecution(execution);

        FlowElement startElement = getStartElement(subProcess);

        if (startElement is null) {
            throw new FlowableException("No initial activity found for subprocess " + subProcess.getId());
        }

        ExecutionEntity executionEntity = (ExecutionEntity) execution;
        executionEntity.setScope(true);

        ProcessEngineConfigurationImpl processEngineConfiguration = CommandContextUtil.getProcessEngineConfiguration();

        // initialize the template-defined data objects as variables
        Map!(string, Object) dataObjectVars = processDataObjects(subProcess.getDataObjects());
        if (dataObjectVars !is null) {
            executionEntity.setVariablesLocal(dataObjectVars);
        }

        CommandContext commandContext = Context.getCommandContext();
        ProcessInstanceHelper processInstanceHelper = processEngineConfiguration.getProcessInstanceHelper();
        processInstanceHelper.processAvailableEventSubProcesses(executionEntity, subProcess, commandContext);

        ExecutionEntity startSubProcessExecution = CommandContextUtil.getExecutionEntityManager(commandContext).createChildExecution(executionEntity);
        startSubProcessExecution.setCurrentFlowElement(startElement);
        CommandContextUtil.getAgenda().planContinueProcessOperation(startSubProcessExecution);
    }

    protected FlowElement getStartElement(SubProcess subProcess) {
        if (CollectionUtil.isNotEmpty(subProcess.getFlowElements())) {
            for (FlowElement subElement : subProcess.getFlowElements()) {
                if (subElement instanceof StartEvent) {
                    StartEvent startEvent = (StartEvent) subElement;
                    if (isOnlyNoneStartEventAllowed) {
                        if (CollectionUtil.isEmpty(startEvent.getEventDefinitions())) {
                            return startEvent;
                        }

                    } else {
                        return startEvent;
                    }
                }
            }
        }
        return null;
    }

    protected SubProcess getSubProcessFromExecution(DelegateExecution execution) {
        FlowElement flowElement = execution.getCurrentFlowElement();
        SubProcess subProcess = null;
        if (flowElement instanceof SubProcess) {
            subProcess = (SubProcess) flowElement;
        } else {
            throw new FlowableException("Programmatic error: sub process behaviour can only be applied" + " to a SubProcess instance, but got an instance of " + flowElement);
        }
        return subProcess;
    }

    protected Map!(string, Object) processDataObjects(Collection<ValuedDataObject> dataObjects) {
        Map!(string, Object) variablesMap = new HashMap<>();
        // convert data objects to process variables
        if (dataObjects !is null) {
            for (ValuedDataObject dataObject : dataObjects) {
                variablesMap.put(dataObject.getName(), dataObject.getValue());
            }
        }
        return variablesMap;
    }
}
