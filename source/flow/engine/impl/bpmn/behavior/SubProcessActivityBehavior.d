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
module flow.engine.impl.bpmn.behavior.SubProcessActivityBehavior;


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
import flow.engine.deleg.DelegateExecution;
import flow.engine.impl.cfg.ProcessEngineConfigurationImpl;
import flow.engine.impl.persistence.entity.ExecutionEntity;
import flow.engine.impl.util.CommandContextUtil;
import flow.engine.impl.util.ProcessInstanceHelper;
import flow.engine.impl.bpmn.behavior.AbstractBpmnActivityBehavior;

/**
 * Implementation of the BPMN 2.0 subprocess (formally known as 'embedded' subprocess): a subprocess defined within another process definition.
 *
 * @author Joram Barrez
 */
class SubProcessActivityBehavior : AbstractBpmnActivityBehavior {

    protected bool isOnlyNoneStartEventAllowed;

    this() {
        this.isOnlyNoneStartEventAllowed = true;
    }

    override
    public void execute(DelegateExecution execution) {
        SubProcess subProcess = getSubProcessFromExecution(execution);

        FlowElement startElement = getStartElement(subProcess);

        if (startElement is null) {
            throw new FlowableException("No initial activity found for subprocess " ~ subProcess.getId());
        }

        ExecutionEntity executionEntity = cast(ExecutionEntity) execution;
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
        if (subProcess.getFlowElements() !is null && !subProcess.getFlowElements().isEmpty()) {
            foreach (FlowElement subElement ; subProcess.getFlowElements()) {
                if (cast(StartEvent)subElement !is null) {
                    StartEvent startEvent = cast(StartEvent) subElement;
                    if (isOnlyNoneStartEventAllowed) {
                        if (startEvent.getEventDefinitions() is null || startEvent.getEventDefinitions().isEmpty()) {
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
        if (cast(SubProcess)flowElement !is null) {
            subProcess = cast(SubProcess) flowElement;
        } else {
            throw new FlowableException("Programmatic error: sub process behaviour can only be applied" ~ " to a SubProcess instance, but got an instance of ");
        }
        return subProcess;
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
