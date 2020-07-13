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
module flow.engine.impl.ProcessInstanceHistoryLogQueryImpl;

import hunt.collection.List;

import flow.common.api.history.HistoricData;
import flow.common.interceptor.Command;
import flow.common.interceptor.CommandContext;
import flow.common.interceptor.CommandExecutor;
import flow.engine.history.HistoricActivityInstance;
import flow.engine.history.HistoricVariableUpdate;
import flow.engine.history.ProcessInstanceHistoryLog;
import flow.engine.history.ProcessInstanceHistoryLogQuery;
import flow.engine.impl.persistence.entity.HistoricProcessInstanceEntity;
import flow.engine.impl.util.CommandContextUtil;
import flow.task.service.impl.HistoricTaskInstanceQueryImpl;
import flow.variable.service.api.history.HistoricVariableInstance;
import flow.variable.service.impl.HistoricVariableInstanceQueryImpl;
import flow.variable.service.impl.persistence.entity.HistoricVariableInstanceEntity;
import flow.variable.service.impl.types.CacheableVariable;
//import flow.variable.service.impl.types.JPAEntityListVariableType;
//import flow.variable.service.impl.types.JPAEntityVariableType;
import flow.engine.impl.ProcessInstanceHistoryLogImpl;
import flow.engine.impl.HistoricActivityInstanceQueryImpl;
import  flow.engine.impl.HistoricDetailQueryImpl;
import hunt.Exceptions;
import flow.task.api.history.HistoricTaskInstance;
import hunt.collection.ArrayList;
import flow.engine.task.Comment;
import flow.engine.history.HistoricDetail;
/**
 * @author Joram Barrez
 */
class ProcessInstanceHistoryLogQueryImpl : ProcessInstanceHistoryLogQuery, Command!ProcessInstanceHistoryLog {

    protected CommandExecutor commandExecutor;

    protected string processInstanceId;
    protected bool _includeTasks;
    protected bool _includeActivities;
    protected bool _includeVariables;
    protected bool _includeComments;
    protected bool _includeVariableUpdates;
    protected bool _includeFormProperties;

    this(CommandExecutor commandExecutor, string processInstanceId) {
        this.commandExecutor = commandExecutor;
        this.processInstanceId = processInstanceId;
    }


    public ProcessInstanceHistoryLogQuery includeTasks() {
        this._includeTasks = true;
        return this;
    }


    public ProcessInstanceHistoryLogQuery includeComments() {
        this._includeComments = true;
        return this;
    }


    public ProcessInstanceHistoryLogQuery includeActivities() {
        this._includeActivities = true;
        return this;
    }


    public ProcessInstanceHistoryLogQuery includeVariables() {
        this._includeVariables = true;
        return this;
    }


    public ProcessInstanceHistoryLogQuery includeVariableUpdates() {
        this._includeVariableUpdates = true;
        return this;
    }


    public ProcessInstanceHistoryLogQuery includeFormProperties() {
        this._includeFormProperties = true;
        return this;
    }


    public ProcessInstanceHistoryLog singleResult() {
        return cast(ProcessInstanceHistoryLog)(commandExecutor.execute(this));
    }


    public ProcessInstanceHistoryLog execute(CommandContext commandContext) {

        // Fetch historic process instance
        HistoricProcessInstanceEntity historicProcessInstance = CommandContextUtil.getHistoricProcessInstanceEntityManager(commandContext).findById(processInstanceId);

        if (historicProcessInstance is null) {
            return null;
        }

        // Create a log using this historic process instance
        ProcessInstanceHistoryLogImpl processInstanceHistoryLog = new ProcessInstanceHistoryLogImpl(historicProcessInstance);

        // Add events, based on query settings

        // Tasks
        if (_includeTasks) {
            auto tasks = CommandContextUtil.getHistoricTaskService().findHistoricTaskInstancesByQueryCriteria(
                            new HistoricTaskInstanceQueryImpl(commandExecutor).processInstanceId(processInstanceId));

            List!HistoricData cst = new ArrayList!HistoricData;

            foreach (HistoricTaskInstance h ; tasks)
            {
                  cst.add(cast(HistoricData)h);
            }

            processInstanceHistoryLog.addHistoricData(cst); //HistoricData
        }

        // Activities
        if (_includeActivities) {
            List!HistoricActivityInstance activities = CommandContextUtil.getHistoricActivityInstanceEntityManager(commandContext).findHistoricActivityInstancesByQueryCriteria(
                    new HistoricActivityInstanceQueryImpl(commandExecutor).processInstanceId(processInstanceId));

            List!HistoricData cst = new ArrayList!HistoricData;

            foreach (HistoricActivityInstance h; activities)
            {
                cst.add(cast(HistoricData)h);
            }

            processInstanceHistoryLog.addHistoricData(cst);
        }

        // Variables
        if (_includeVariables) {
            List!HistoricVariableInstance variables = CommandContextUtil.getHistoricVariableService().findHistoricVariableInstancesByQueryCriteria(
                    new HistoricVariableInstanceQueryImpl(commandExecutor).processInstanceId(processInstanceId));
            implementationMissing(false);
            // Make sure all variables values are fetched (similar to the HistoricVariableInstance query)
            //foreach (HistoricVariableInstance historicVariableInstance ; variables) {
            //    historicVariableInstance.getValue();
            //
            //    // make sure JPA entities are cached for later retrieval
            //    HistoricVariableInstanceEntity variableEntity = cast(HistoricVariableInstanceEntity) historicVariableInstance;
            //    if (JPAEntityVariableType.TYPE_NAME.equals(variableEntity.getVariableType().getTypeName()) || JPAEntityListVariableType.TYPE_NAME.equals(variableEntity.getVariableType().getTypeName())) {
            //        ((CacheableVariable) variableEntity.getVariableType()).setForceCacheable(true);
            //    }
            //}
            List!HistoricData cst = new ArrayList!HistoricData;

            foreach(HistoricVariableInstance h ; variables)
            {
                cst.add(cast(HistoricData)h);
            }

            processInstanceHistoryLog.addHistoricData(cst);
        }

        // Comment
        if (_includeComments) {
            auto comments = CommandContextUtil.getCommentEntityManager(commandContext).findCommentsByProcessInstanceId(processInstanceId);

            List!HistoricData cst = new ArrayList!HistoricData;

            foreach(Comment c ; comments)
            {
                cst.add(cast(HistoricData)c);
            }

            processInstanceHistoryLog.addHistoricData(cst);
        }

        // Details: variables
        if (_includeVariableUpdates) {
            auto variableUpdates = CommandContextUtil.getHistoricDetailEntityManager(commandContext).findHistoricDetailsByQueryCriteria(
                    new HistoricDetailQueryImpl(commandExecutor).variableUpdates());


            List!HistoricData cst = new ArrayList!HistoricData;
            // Make sure all variables values are fetched (similar to the HistoricVariableInstance query)
            foreach (HistoricDetail historicData ; variableUpdates) {
                HistoricVariableUpdate variableUpdate = cast(HistoricVariableUpdate) historicData;
                variableUpdate.getValue();
                cst.add(cast(HistoricData)historicData);
            }

            processInstanceHistoryLog.addHistoricData(cst);
        }

        // Details: form properties
        if (_includeFormProperties) {
            auto formProperties = CommandContextUtil.getHistoricDetailEntityManager(commandContext).findHistoricDetailsByQueryCriteria(
                    new HistoricDetailQueryImpl(commandExecutor).formProperties());

            List!HistoricData cst = new ArrayList!HistoricData;

            foreach(HistoricDetail h; formProperties)
            {
                cst.add(cast(HistoricData)h);
            }

            processInstanceHistoryLog.addHistoricData(cst);
        }

        // All events collected. Sort them by date.
        processInstanceHistoryLog.orderHistoricData();

        return processInstanceHistoryLog;
    }

}
