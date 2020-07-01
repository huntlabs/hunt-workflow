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
module flow.engine.impl.cmd.SetProcessDefinitionVersionCmd;


import hunt.collection;
import hunt.collection.List;

import flow.common.api.FlowableException;
import flow.common.api.FlowableIllegalArgumentException;
import flow.common.api.FlowableObjectNotFoundException;
import flow.common.interceptor.Command;
import flow.common.interceptor.CommandContext;
import flow.common.runtime.Clockm;
import flow.engine.history.HistoricProcessInstance;
import flow.engine.impl.persistence.deploy.DeploymentManager;
import flow.engine.impl.persistence.entity.ExecutionEntity;
import flow.engine.impl.persistence.entity.ExecutionEntityManager;
import flow.engine.impl.util.CommandContextUtil;
//import flow.engine.impl.util.Flowable5Util;
import flow.engine.impl.util.ProcessDefinitionUtil;
import flow.engine.repository.ProcessDefinition;
import flow.engine.runtime.ProcessInstance;
import flow.task.service.impl.persistence.entity.TaskEntity;
import hunt.Object;
import flow.bpmn.model.Process;

/**
 * {@link Command} that changes the process definition version of an existing process instance.
 *
 * Warning: This command will NOT perform any migration magic and simply set the process definition version in the database, assuming that the user knows, what he or she is doing.
 *
 * This is only useful for simple migrations. The new process definition MUST have the exact same activity id to make it still run.
 *
 * Furthermore, activities referenced by sub-executions and jobs that belong to the process instance MUST exist in the new process definition version.
 *
 * The command will fail, if there is already a {@link ProcessInstance} or {@link HistoricProcessInstance} using the new process definition version and the same business key as the
 * {@link ProcessInstance} that is to be migrated.
 *
 * If the process instance is not currently waiting but actively running, then this would be a case for optimistic locking, meaning either the version update or the "real work" wins, i.e., this is a
 * race condition.
 *
 * @see {http://forums.activiti.org/en/viewtopic.php?t=2918}
 * @author Falko Menge
 */
class SetProcessDefinitionVersionCmd : Command!Void {

    private  string processInstanceId;
    private  int processDefinitionVersion;

    this(string processInstanceId, int processDefinitionVersion) {
        if (processInstanceId is null || processInstanceId.length < 1) {
            throw new FlowableIllegalArgumentException("The process instance id is mandatory, but '" ~ processInstanceId ~ "' has been provided.");
        }
        if (processDefinitionVersion < 1) {
            throw new FlowableIllegalArgumentException("The process definition version must be positive, but  ~  has been provided.");
        }
        this.processInstanceId = processInstanceId;
        this.processDefinitionVersion = processDefinitionVersion;
    }

    public Void execute(CommandContext commandContext) {
        // check that the new process definition is just another version of the same
        // process definition that the process instance is using
        ExecutionEntityManager executionManager = CommandContextUtil.getExecutionEntityManager(commandContext);
        ExecutionEntity processInstance = executionManager.findById(processInstanceId);
        if (processInstance is null) {
            throw new FlowableObjectNotFoundException("No process instance found for id = '" ~ processInstanceId ~ "'.");
        } else if (!processInstance.isProcessInstanceType()) {
            //throw new FlowableIllegalArgumentException("A process instance id is required, but the provided id " + "'" + processInstanceId + "' " + "points to a child execution of process instance " + "'"
            //        + processInstance.getProcessInstanceId() + "'. " + "Please invoke the " + getClass().getSimpleName() + " with a root execution id.");
        }

        DeploymentManager deploymentCache = CommandContextUtil.getProcessEngineConfiguration(commandContext).getDeploymentManager();
        ProcessDefinition currentProcessDefinition = deploymentCache.findDeployedProcessDefinitionById(processInstance.getProcessDefinitionId());

        ProcessDefinition newProcessDefinition = deploymentCache
                .findDeployedProcessDefinitionByKeyAndVersionAndTenantId(currentProcessDefinition.getKey(), processDefinitionVersion, currentProcessDefinition.getTenantId());

        //if (Flowable5Util.isFlowable5ProcessDefinition(currentProcessDefinition, commandContext) && !Flowable5Util
        //    .isFlowable5ProcessDefinition(newProcessDefinition, commandContext)) {
        //    throw new FlowableIllegalArgumentException("The current process definition (id = '" + currentProcessDefinition.getId() + "') is a v5 definition."
        //        + " However the new process definition (id = '" + newProcessDefinition.getId() + "') is not a v5 definition.");
        //}

        validateAndSwitchVersionOfExecution(commandContext, processInstance, newProcessDefinition);

        // switch the historic process instance to the new process definition version
        CommandContextUtil.getHistoryManager(commandContext).recordProcessDefinitionChange(processInstanceId, newProcessDefinition.getId());

        // switch all sub-executions of the process instance to the new process definition version
        Collection!ExecutionEntity childExecutions = executionManager.findChildExecutionsByProcessInstanceId(processInstanceId);
        foreach (ExecutionEntity executionEntity ; childExecutions) {
            validateAndSwitchVersionOfExecution(commandContext, executionEntity, newProcessDefinition);
        }

        return null;
    }

    protected void validateAndSwitchVersionOfExecution(CommandContext commandContext, ExecutionEntity execution, ProcessDefinition newProcessDefinition) {
        // check that the new process definition version contains the current activity
        flow.bpmn.model.Process.Process process = ProcessDefinitionUtil.getProcess(newProcessDefinition.getId());
        if (execution.getActivityId() !is null && execution.getActivityId().length != 0 && process.getFlowElement(execution.getActivityId(), true) is null) {
            //throw new FlowableException("The new process definition " + "(key = '" + newProcessDefinition.getKey() + "') " + "does not contain the current activity " + "(id = '"
            //        + execution.getActivityId() + "') " + "of the process instance " + "(id = '" + processInstanceId + "').");
        }

        // switch the process instance to the new process definition version
        execution.setProcessDefinitionId(newProcessDefinition.getId());
        execution.setProcessDefinitionName(newProcessDefinition.getName());
        execution.setProcessDefinitionKey(newProcessDefinition.getKey());

        // and change possible existing tasks (as the process definition id is stored there too)
        List!TaskEntity tasks = CommandContextUtil.getTaskService(commandContext).findTasksByExecutionId(execution.getId());
        Clockm clock = commandContext.getCurrentEngineConfiguration().getClock();
        foreach (TaskEntity taskEntity ; tasks) {
            taskEntity.setProcessDefinitionId(newProcessDefinition.getId());
            CommandContextUtil.getActivityInstanceEntityManager(commandContext).recordTaskInfoChange(taskEntity, clock.getCurrentTime());
        }
    }

}
