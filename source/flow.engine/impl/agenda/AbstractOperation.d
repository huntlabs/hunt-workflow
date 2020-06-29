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
module flow.engine.impl.agenda.AbstractOperation;

import flow.bpmn.model.FlowElement;
import flow.bpmn.model.HasExecutionListeners;
import flow.common.interceptor.Command;
import flow.common.interceptor.CommandContext;
import flow.engine.FlowableEngineAgenda;
import flow.engine.deleg.ExecutionListener;
import flow.engine.impl.persistence.entity.ExecutionEntity;
import flow.engine.impl.persistence.entity.ExecutionEntityManager;
import flow.engine.impl.util.CommandContextUtil;
import flow.engine.impl.util.ProcessDefinitionUtil;
import hunt.util.Common;
import hunt.util.Runnable;
import flow.bpmn.model.Process;
/**
 * Abstract superclass for all operation interfaces (which are {@link Runnable} instances), exposing some shared helper methods and member fields to subclasses.
 *
 * An operations is a {@link Runnable} instance that is put on the {@link FlowableEngineAgenda} during the execution of a {@link Command}.
 *
 * @author Joram Barrez
 */
abstract class AbstractOperation : Runnable {

    protected CommandContext commandContext;
    protected FlowableEngineAgenda agenda;
    protected ExecutionEntity execution;

    this() {

    }

    this(CommandContext commandContext, ExecutionEntity execution) {
        this.commandContext = commandContext;
        this.execution = execution;
        this.agenda = CommandContextUtil.getAgenda(commandContext);
    }

    /**
     * Helper method to match the activityId of an execution with a FlowElement of the process definition referenced by the execution.
     */
    protected FlowElement getCurrentFlowElement(ExecutionEntity execution) {
        if (execution.getCurrentFlowElement() !is null) {
            return execution.getCurrentFlowElement();
        } else if (execution.getCurrentActivityId() !is null && execution.getCurrentActivityId().length != 0) {
            string processDefinitionId = execution.getProcessDefinitionId();
            flow.bpmn.model.Process.Process process = ProcessDefinitionUtil.getProcess(processDefinitionId);
            string activityId = execution.getCurrentActivityId();
            FlowElement currentFlowElement = process.getFlowElement(activityId, true);
            return currentFlowElement;
        }
        return null;
    }

    /**
     * Executes the execution listeners defined on the given element, with the given event type. Uses the {@link #execution} of this operation instance as argument for the execution listener.
     */
    protected void executeExecutionListeners(HasExecutionListeners elementWithExecutionListeners, string eventType) {
        executeExecutionListeners(elementWithExecutionListeners, execution, eventType);
    }

    /**
     * Executes the execution listeners defined on the given element, with the given event type, and passing the provided execution to the {@link ExecutionListener} instances.
     */
    protected void executeExecutionListeners(HasExecutionListeners elementWithExecutionListeners,
            ExecutionEntity executionEntity, string eventType) {
        CommandContextUtil.getProcessEngineConfiguration(commandContext).getListenerNotificationHelper()
                .executeExecutionListeners(elementWithExecutionListeners, executionEntity, eventType);
    }

    /**
     * Returns the first parent execution of the provided execution that is a scope.
     */
    protected ExecutionEntity findFirstParentScopeExecution(ExecutionEntity executionEntity) {
        ExecutionEntityManager executionEntityManager = CommandContextUtil.getExecutionEntityManager(commandContext);
        ExecutionEntity parentScopeExecution = null;
        ExecutionEntity currentlyExaminedExecution = executionEntityManager.findById(executionEntity.getParentId());
        while (currentlyExaminedExecution !is null && parentScopeExecution is null) {
            if (currentlyExaminedExecution.isScope()) {
                parentScopeExecution = currentlyExaminedExecution;
            } else {
                currentlyExaminedExecution = executionEntityManager.findById(currentlyExaminedExecution.getParentId());
            }
        }
        return parentScopeExecution;
    }

    public CommandContext getCommandContext() {
        return commandContext;
    }

    public void setCommandContext(CommandContext commandContext) {
        this.commandContext = commandContext;
    }

    public FlowableEngineAgenda getAgenda() {
        return agenda;
    }

    public void setAgenda(FlowableEngineAgenda agenda) {
        this.agenda = agenda;
    }

    public ExecutionEntity getExecution() {
        return execution;
    }

    public void setExecution(ExecutionEntity execution) {
        this.execution = execution;
    }

}
