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
module flow.engine.impl.cmd.AbstractSetProcessDefinitionStateCmd;

import hunt.collection.ArrayList;
import hunt.collection.Collections;
import hunt.time.LocalDateTime;
import hunt.collection.List;

import flow.common.api.FlowableException;
import flow.common.api.FlowableIllegalArgumentException;
import flow.common.api.FlowableObjectNotFoundException;
import flow.common.db.SuspensionState;
import flow.common.interceptor.Command;
import flow.common.interceptor.CommandContext;
import flow.engine.ProcessEngineConfiguration;
import flow.engine.compatibility.Flowable5CompatibilityHandler;
import flow.engine.impl.ProcessDefinitionQueryImpl;
import flow.engine.impl.ProcessInstanceQueryImpl;
//import flow.engine.impl.jobexecutor.TimerChangeProcessDefinitionSuspensionStateJobHandler;
import flow.engine.impl.persistence.entity.ProcessDefinitionEntity;
import flow.engine.impl.persistence.entity.ProcessDefinitionEntityManager;
import flow.engine.impl.persistence.entity.SuspensionStateUtil;
import flow.engine.impl.util.CommandContextUtil;
//import flow.engine.impl.util.Flowable5Util;
import flow.engine.repository.ProcessDefinition;
import flow.engine.runtime.ProcessInstance;
import flow.job.service.JobHandler;
import flow.job.service.TimerJobService;
import flow.job.service.impl.persistence.entity.JobEntity;
import flow.job.service.impl.persistence.entity.TimerJobEntity;
import hunt.Object;
import hunt.Exceptions;
import flow.engine.impl.cmd.AbstractSetProcessInstanceStateCmd;
/**
 * @author Daniel Meyer
 * @author Joram Barrez
 */
abstract class AbstractSetProcessDefinitionStateCmd : Command!Void {

    protected string processDefinitionId;
    protected string processDefinitionKey;
    protected ProcessDefinitionEntity processDefinitionEntity;
    protected bool includeProcessInstances;
    protected Date executionDate;
    protected string tenantId;

    this(ProcessDefinitionEntity processDefinitionEntity, bool includeProcessInstances, Date executionDate, string tenantId) {
        this.processDefinitionEntity = processDefinitionEntity;
        this.includeProcessInstances = includeProcessInstances;
        this.executionDate = executionDate;
        this.tenantId = tenantId;
    }

    this(string processDefinitionId, string processDefinitionKey, bool includeProcessInstances, Date executionDate, string tenantId) {
        this.processDefinitionId = processDefinitionId;
        this.processDefinitionKey = processDefinitionKey;
        this.includeProcessInstances = includeProcessInstances;
        this.executionDate = executionDate;
        this.tenantId = tenantId;
    }

    override
    public Void execute(CommandContext commandContext) {

        List!ProcessDefinitionEntity processDefinitions = findProcessDefinition(commandContext);
        bool hasV5ProcessDefinitions = false;
        //for (ProcessDefinitionEntity processDefinitionEntity : processDefinitions) {
        //    if (Flowable5Util.isFlowable5ProcessDefinition(processDefinitionEntity, commandContext)) {
        //        hasV5ProcessDefinitions = true;
        //        break;
        //    }
        //}
        //
        //if (hasV5ProcessDefinitions) {
        //    Flowable5CompatibilityHandler compatibilityHandler = Flowable5Util.getFlowable5CompatibilityHandler();
        //    if (getProcessDefinitionSuspensionState() == SuspensionState.ACTIVE) {
        //        compatibilityHandler.activateProcessDefinition(processDefinitionId, processDefinitionKey, includeProcessInstances, executionDate, tenantId);
        //    } else if (getProcessDefinitionSuspensionState() == SuspensionState.SUSPENDED) {
        //        compatibilityHandler.suspendProcessDefinition(processDefinitionId, processDefinitionKey, includeProcessInstances, executionDate, tenantId);
        //    }
        //    return null;
        //}
        implementationMissing(false);
        if (executionDate !is null) { // Process definition state change is delayed
            createTimerForDelayedExecution(commandContext, processDefinitions);
        } else { // Process definition state is changed now
            changeProcessDefinitionState(commandContext, processDefinitions);
        }

        return null;
    }

    protected List!ProcessDefinitionEntity findProcessDefinition(CommandContext commandContext) {

        // If process definition is already provided (eg. when command is called through the DeployCmd)
        // we don't need to do an extra database fetch and we can simply return it, wrapped in a list
        if (processDefinitionEntity !is null) {
            return Collections.singletonList(processDefinitionEntity);
        }

        // Validation of input parameters
        if (processDefinitionId is null && processDefinitionKey is null) {
            throw new FlowableIllegalArgumentException("Process definition id or key cannot be null");
        }

        List!ProcessDefinitionEntity processDefinitionEntities = new ArrayList!ProcessDefinitionEntity();
        ProcessDefinitionEntityManager processDefinitionManager = CommandContextUtil.getProcessDefinitionEntityManager(commandContext);

        if (processDefinitionId !is null && processDefinitionId.length != 0) {

            ProcessDefinitionEntity processDefinitionEntity = processDefinitionManager.findById(processDefinitionId);
            if (processDefinitionEntity is null) {
                throw new FlowableObjectNotFoundException("Cannot find process definition for id '" ~ processDefinitionId ~ "'");
            }
            processDefinitionEntities.add(processDefinitionEntity);

        } else {

            ProcessDefinitionQueryImpl query = new ProcessDefinitionQueryImpl(commandContext).processDefinitionKey(processDefinitionKey);

            if (tenantId is null || ProcessEngineConfiguration.NO_TENANT_ID == (tenantId)) {
                query.processDefinitionWithoutTenantId();
            } else {
                query.processDefinitionTenantId(tenantId);
            }

            List!ProcessDefinition processDefinitions = query.list();
            if (processDefinitions.isEmpty()) {
                throw new FlowableException("Cannot find process definition for key '" ~ processDefinitionKey ~ "'");
            }

            foreach (ProcessDefinition processDefinition ; processDefinitions) {
                processDefinitionEntities.add(cast(ProcessDefinitionEntity) processDefinition);
            }

        }
        return processDefinitionEntities;
    }

    protected void createTimerForDelayedExecution(CommandContext commandContext, List!ProcessDefinitionEntity processDefinitions) {
        foreach (ProcessDefinitionEntity processDefinition ; processDefinitions) {

            //if (Flowable5Util.isFlowable5ProcessDefinition(processDefinition, commandContext))
            //    continue;

            TimerJobService timerJobService = CommandContextUtil.getTimerJobService(commandContext);
            TimerJobEntity timer = timerJobService.createTimerJob();
            timer.setJobType(JobEntity.JOB_TYPE_TIMER);
            timer.setProcessDefinitionId(processDefinition.getId());

            // Inherit tenant identifier (if applicable)
            if (processDefinition.getTenantId() !is null) {
                timer.setTenantId(processDefinition.getTenantId());
            }

            timer.setDuedate(executionDate);
            timer.setJobHandlerType(getDelayedExecutionJobHandlerType());
            timer.setJobHandlerConfiguration(TimerChangeProcessDefinitionSuspensionStateJobHandler.createJobHandlerConfiguration(includeProcessInstances));
            timerJobService.scheduleTimerJob(timer);
        }
    }

    protected void changeProcessDefinitionState(CommandContext commandContext, List!ProcessDefinitionEntity processDefinitions) {
        foreach (ProcessDefinitionEntity processDefinition ; processDefinitions) {

            //if (Flowable5Util.isFlowable5ProcessDefinition(processDefinition, commandContext))
            //    continue;

            SuspensionStateUtil.setSuspensionState(processDefinition, getProcessDefinitionSuspensionState());

            // Evict cache
            CommandContextUtil.getProcessEngineConfiguration(commandContext).getDeploymentManager().getProcessDefinitionCache().remove(processDefinition.getId());

            // Suspend process instances (if needed)
            if (includeProcessInstances) {

                int currentStartIndex = 0;
                List!ProcessInstance processInstances = fetchProcessInstancesPage(commandContext, processDefinition, currentStartIndex);
                while (!processInstances.isEmpty()) {

                    foreach (ProcessInstance processInstance ; processInstances) {
                        AbstractSetProcessInstanceStateCmd processInstanceCmd = getProcessInstanceChangeStateCmd(processInstance);
                        processInstanceCmd.execute(commandContext);
                    }

                    // Fetch new batch of process instances
                    currentStartIndex += processInstances.size();
                    processInstances = fetchProcessInstancesPage(commandContext, processDefinition, currentStartIndex);
                }
            }
        }
    }

    protected List!ProcessInstance fetchProcessInstancesPage(CommandContext commandContext, ProcessDefinition processDefinition, int currentPageStartIndex) {

        if (SuspensionState.ACTIVE == (getProcessDefinitionSuspensionState())) {
            return new ProcessInstanceQueryImpl(commandContext).processDefinitionId(processDefinition.getId()).suspended()
                    .listPage(currentPageStartIndex, CommandContextUtil.getProcessEngineConfiguration(commandContext).getBatchSizeProcessInstances());
        } else {
            return new ProcessInstanceQueryImpl(commandContext).processDefinitionId(processDefinition.getId()).active()
                    .listPage(currentPageStartIndex, CommandContextUtil.getProcessEngineConfiguration(commandContext).getBatchSizeProcessInstances());
        }
    }

    // ABSTRACT METHODS
    // ////////////////////////////////////////////////////////////////////

    /**
     * Subclasses should return the wanted {@link SuspensionState} here.
     */
    protected abstract SuspensionState getProcessDefinitionSuspensionState();

    /**
     * Subclasses should return the type of the {@link JobHandler} here. it will be used when the user provides an execution date on which the actual state change will happen.
     */
    protected abstract string getDelayedExecutionJobHandlerType();

    /**
     * Subclasses should return a {@link Command} implementation that matches the process definition state change.
     */
    protected abstract AbstractSetProcessInstanceStateCmd getProcessInstanceChangeStateCmd(ProcessInstance processInstance);

}
