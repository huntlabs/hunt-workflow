/*
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *       http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */



import hunt.collection.List;

import flow.common.service.CommonEngineServiceImpl;
import flow.engine.HistoryService;
import flow.engine.history.HistoricActivityInstanceQuery;
import flow.engine.history.HistoricDetailQuery;
import flow.engine.history.HistoricProcessInstanceQuery;
import flow.engine.history.NativeHistoricActivityInstanceQuery;
import flow.engine.history.NativeHistoricDetailQuery;
import flow.engine.history.NativeHistoricProcessInstanceQuery;
import flow.engine.history.ProcessInstanceHistoryLogQuery;
import flow.engine.impl.cfg.ProcessEngineConfigurationImpl;
import flow.engine.impl.cmd.DeleteHistoricProcessInstanceCmd;
import flow.engine.impl.cmd.DeleteHistoricTaskInstanceCmd;
import flow.engine.impl.cmd.DeleteHistoricTaskLogEntryByLogNumberCmd;
import flow.engine.impl.cmd.DeleteRelatedDataOfRemovedHistoricProcessInstancesCmd;
import flow.engine.impl.cmd.DeleteTaskAndActivityDataOfRemovedHistoricProcessInstancesCmd;
import flow.engine.impl.cmd.GetHistoricEntityLinkChildrenForProcessInstanceCmd;
import flow.engine.impl.cmd.GetHistoricEntityLinkChildrenForTaskCmd;
import flow.engine.impl.cmd.GetHistoricEntityLinkParentsForProcessInstanceCmd;
import flow.engine.impl.cmd.GetHistoricEntityLinkParentsForTaskCmd;
import flow.engine.impl.cmd.GetHistoricIdentityLinksForTaskCmd;
import flow.entitylink.service.api.history.HistoricEntityLink;
import flow.identitylink.api.history.HistoricIdentityLink;
import flow.task.api.TaskInfo;
import flow.task.api.history.HistoricTaskInstanceQuery;
import flow.task.api.history.HistoricTaskLogEntryBuilder;
import flow.task.api.history.HistoricTaskLogEntryQuery;
import flow.task.api.history.NativeHistoricTaskLogEntryQuery;
import flow.task.service.history.NativeHistoricTaskInstanceQuery;
import flow.task.service.impl.HistoricTaskInstanceQueryImpl;
import flow.task.service.impl.HistoricTaskLogEntryBuilderImpl;
import flow.task.service.impl.HistoricTaskLogEntryQueryImpl;
import flow.task.service.impl.NativeHistoricTaskInstanceQueryImpl;
import flow.task.service.impl.NativeHistoricTaskLogEntryQueryImpl;
import flow.variable.service.api.history.HistoricVariableInstanceQuery;
import flow.variable.service.api.history.NativeHistoricVariableInstanceQuery;
import flow.variable.service.impl.HistoricVariableInstanceQueryImpl;
import flow.variable.service.impl.NativeHistoricVariableInstanceQueryImpl;

/**
 * @author Tom Baeyens
 * @author Bernd Ruecker (camunda)
 * @author Christian Stettler
 */
class HistoryServiceImpl : CommonEngineServiceImpl!ProcessEngineConfigurationImpl implements HistoryService {

    public HistoryServiceImpl(ProcessEngineConfigurationImpl processEngineConfiguration) {
        super(processEngineConfiguration);
    }

    override
    public HistoricProcessInstanceQuery createHistoricProcessInstanceQuery() {
        return new HistoricProcessInstanceQueryImpl(commandExecutor);
    }

    override
    public HistoricActivityInstanceQuery createHistoricActivityInstanceQuery() {
        return new HistoricActivityInstanceQueryImpl(commandExecutor);
    }

    override
    public HistoricTaskInstanceQuery createHistoricTaskInstanceQuery() {
        return new HistoricTaskInstanceQueryImpl(commandExecutor, configuration.getDatabaseType());
    }

    override
    public HistoricDetailQuery createHistoricDetailQuery() {
        return new HistoricDetailQueryImpl(commandExecutor);
    }

    override
    public NativeHistoricDetailQuery createNativeHistoricDetailQuery() {
        return new NativeHistoricDetailQueryImpl(commandExecutor);
    }

    override
    public HistoricVariableInstanceQuery createHistoricVariableInstanceQuery() {
        return new HistoricVariableInstanceQueryImpl(commandExecutor);
    }

    override
    public NativeHistoricVariableInstanceQuery createNativeHistoricVariableInstanceQuery() {
        return new NativeHistoricVariableInstanceQueryImpl(commandExecutor);
    }

    override
    public void deleteHistoricTaskInstance(string taskId) {
        commandExecutor.execute(new DeleteHistoricTaskInstanceCmd(taskId));
    }

    override
    public void deleteHistoricProcessInstance(string processInstanceId) {
        commandExecutor.execute(new DeleteHistoricProcessInstanceCmd(processInstanceId));
    }

    override
    public void deleteTaskAndActivityDataOfRemovedHistoricProcessInstances() {
        commandExecutor.execute(new DeleteTaskAndActivityDataOfRemovedHistoricProcessInstancesCmd());
    }

    override
    public void deleteRelatedDataOfRemovedHistoricProcessInstances() {
        commandExecutor.execute(new DeleteRelatedDataOfRemovedHistoricProcessInstancesCmd());
    }

    override
    public NativeHistoricProcessInstanceQuery createNativeHistoricProcessInstanceQuery() {
        return new NativeHistoricProcessInstanceQueryImpl(commandExecutor);
    }

    override
    public NativeHistoricTaskInstanceQuery createNativeHistoricTaskInstanceQuery() {
        return new NativeHistoricTaskInstanceQueryImpl(commandExecutor);
    }

    override
    public NativeHistoricActivityInstanceQuery createNativeHistoricActivityInstanceQuery() {
        return new NativeHistoricActivityInstanceQueryImpl(commandExecutor);
    }

    override
    public List!HistoricIdentityLink getHistoricIdentityLinksForProcessInstance(string processInstanceId) {
        return commandExecutor.execute(new GetHistoricIdentityLinksForTaskCmd(null, processInstanceId));
    }

    override
    public List!HistoricIdentityLink getHistoricIdentityLinksForTask(string taskId) {
        return commandExecutor.execute(new GetHistoricIdentityLinksForTaskCmd(taskId, null));
    }

    override
    public List!HistoricEntityLink getHistoricEntityLinkChildrenForProcessInstance(string processInstanceId) {
        return commandExecutor.execute(new GetHistoricEntityLinkChildrenForProcessInstanceCmd(processInstanceId));
    }

    override
    public List!HistoricEntityLink getHistoricEntityLinkChildrenForTask(string taskId) {
        return commandExecutor.execute(new GetHistoricEntityLinkChildrenForTaskCmd(taskId));
    }

    override
    public List!HistoricEntityLink getHistoricEntityLinkParentsForProcessInstance(string processInstanceId) {
        return commandExecutor.execute(new GetHistoricEntityLinkParentsForProcessInstanceCmd(processInstanceId));
    }

    override
    public List!HistoricEntityLink getHistoricEntityLinkParentsForTask(string taskId) {
        return commandExecutor.execute(new GetHistoricEntityLinkParentsForTaskCmd(taskId));
    }

    override
    public ProcessInstanceHistoryLogQuery createProcessInstanceHistoryLogQuery(string processInstanceId) {
        return new ProcessInstanceHistoryLogQueryImpl(commandExecutor, processInstanceId);
    }

    override
    public void deleteHistoricTaskLogEntry(long logNumber) {
        commandExecutor.execute(new DeleteHistoricTaskLogEntryByLogNumberCmd(logNumber));
    }

    override
    public HistoricTaskLogEntryBuilder createHistoricTaskLogEntryBuilder(TaskInfo task) {
        return new HistoricTaskLogEntryBuilderImpl(commandExecutor, task);
    }

    override
    public HistoricTaskLogEntryBuilder createHistoricTaskLogEntryBuilder() {
        return new HistoricTaskLogEntryBuilderImpl(commandExecutor);
    }

    override
    public HistoricTaskLogEntryQuery createHistoricTaskLogEntryQuery() {
        return new HistoricTaskLogEntryQueryImpl(commandExecutor);
    }

    override
    public NativeHistoricTaskLogEntryQuery createNativeHistoricTaskLogEntryQuery() {
        return new NativeHistoricTaskLogEntryQueryImpl(commandExecutor);
    }

}
