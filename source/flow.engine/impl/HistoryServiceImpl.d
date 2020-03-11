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
import org.flowable.entitylink.api.history.HistoricEntityLink;
import flow.identitylink.api.history.HistoricIdentityLink;
import flow.task.api.TaskInfo;
import flow.task.api.history.HistoricTaskInstanceQuery;
import flow.task.api.history.HistoricTaskLogEntryBuilder;
import flow.task.api.history.HistoricTaskLogEntryQuery;
import flow.task.api.history.NativeHistoricTaskLogEntryQuery;
import org.flowable.task.service.history.NativeHistoricTaskInstanceQuery;
import org.flowable.task.service.impl.HistoricTaskInstanceQueryImpl;
import org.flowable.task.service.impl.HistoricTaskLogEntryBuilderImpl;
import org.flowable.task.service.impl.HistoricTaskLogEntryQueryImpl;
import org.flowable.task.service.impl.NativeHistoricTaskInstanceQueryImpl;
import org.flowable.task.service.impl.NativeHistoricTaskLogEntryQueryImpl;
import flow.variable.service.api.history.HistoricVariableInstanceQuery;
import flow.variable.service.api.history.NativeHistoricVariableInstanceQuery;
import org.flowable.variable.service.impl.HistoricVariableInstanceQueryImpl;
import org.flowable.variable.service.impl.NativeHistoricVariableInstanceQueryImpl;

/**
 * @author Tom Baeyens
 * @author Bernd Ruecker (camunda)
 * @author Christian Stettler
 */
class HistoryServiceImpl extends CommonEngineServiceImpl<ProcessEngineConfigurationImpl> implements HistoryService {

    public HistoryServiceImpl(ProcessEngineConfigurationImpl processEngineConfiguration) {
        super(processEngineConfiguration);
    }

    @Override
    public HistoricProcessInstanceQuery createHistoricProcessInstanceQuery() {
        return new HistoricProcessInstanceQueryImpl(commandExecutor);
    }

    @Override
    public HistoricActivityInstanceQuery createHistoricActivityInstanceQuery() {
        return new HistoricActivityInstanceQueryImpl(commandExecutor);
    }

    @Override
    public HistoricTaskInstanceQuery createHistoricTaskInstanceQuery() {
        return new HistoricTaskInstanceQueryImpl(commandExecutor, configuration.getDatabaseType());
    }

    @Override
    public HistoricDetailQuery createHistoricDetailQuery() {
        return new HistoricDetailQueryImpl(commandExecutor);
    }

    @Override
    public NativeHistoricDetailQuery createNativeHistoricDetailQuery() {
        return new NativeHistoricDetailQueryImpl(commandExecutor);
    }

    @Override
    public HistoricVariableInstanceQuery createHistoricVariableInstanceQuery() {
        return new HistoricVariableInstanceQueryImpl(commandExecutor);
    }

    @Override
    public NativeHistoricVariableInstanceQuery createNativeHistoricVariableInstanceQuery() {
        return new NativeHistoricVariableInstanceQueryImpl(commandExecutor);
    }

    @Override
    public void deleteHistoricTaskInstance(string taskId) {
        commandExecutor.execute(new DeleteHistoricTaskInstanceCmd(taskId));
    }

    @Override
    public void deleteHistoricProcessInstance(string processInstanceId) {
        commandExecutor.execute(new DeleteHistoricProcessInstanceCmd(processInstanceId));
    }

    @Override
    public void deleteTaskAndActivityDataOfRemovedHistoricProcessInstances() {
        commandExecutor.execute(new DeleteTaskAndActivityDataOfRemovedHistoricProcessInstancesCmd());
    }

    @Override
    public void deleteRelatedDataOfRemovedHistoricProcessInstances() {
        commandExecutor.execute(new DeleteRelatedDataOfRemovedHistoricProcessInstancesCmd());
    }

    @Override
    public NativeHistoricProcessInstanceQuery createNativeHistoricProcessInstanceQuery() {
        return new NativeHistoricProcessInstanceQueryImpl(commandExecutor);
    }

    @Override
    public NativeHistoricTaskInstanceQuery createNativeHistoricTaskInstanceQuery() {
        return new NativeHistoricTaskInstanceQueryImpl(commandExecutor);
    }

    @Override
    public NativeHistoricActivityInstanceQuery createNativeHistoricActivityInstanceQuery() {
        return new NativeHistoricActivityInstanceQueryImpl(commandExecutor);
    }

    @Override
    public List<HistoricIdentityLink> getHistoricIdentityLinksForProcessInstance(string processInstanceId) {
        return commandExecutor.execute(new GetHistoricIdentityLinksForTaskCmd(null, processInstanceId));
    }

    @Override
    public List<HistoricIdentityLink> getHistoricIdentityLinksForTask(string taskId) {
        return commandExecutor.execute(new GetHistoricIdentityLinksForTaskCmd(taskId, null));
    }

    @Override
    public List<HistoricEntityLink> getHistoricEntityLinkChildrenForProcessInstance(string processInstanceId) {
        return commandExecutor.execute(new GetHistoricEntityLinkChildrenForProcessInstanceCmd(processInstanceId));
    }

    @Override
    public List<HistoricEntityLink> getHistoricEntityLinkChildrenForTask(string taskId) {
        return commandExecutor.execute(new GetHistoricEntityLinkChildrenForTaskCmd(taskId));
    }

    @Override
    public List<HistoricEntityLink> getHistoricEntityLinkParentsForProcessInstance(string processInstanceId) {
        return commandExecutor.execute(new GetHistoricEntityLinkParentsForProcessInstanceCmd(processInstanceId));
    }

    @Override
    public List<HistoricEntityLink> getHistoricEntityLinkParentsForTask(string taskId) {
        return commandExecutor.execute(new GetHistoricEntityLinkParentsForTaskCmd(taskId));
    }

    @Override
    public ProcessInstanceHistoryLogQuery createProcessInstanceHistoryLogQuery(string processInstanceId) {
        return new ProcessInstanceHistoryLogQueryImpl(commandExecutor, processInstanceId);
    }

    @Override
    public void deleteHistoricTaskLogEntry(long logNumber) {
        commandExecutor.execute(new DeleteHistoricTaskLogEntryByLogNumberCmd(logNumber));
    }

    @Override
    public HistoricTaskLogEntryBuilder createHistoricTaskLogEntryBuilder(TaskInfo task) {
        return new HistoricTaskLogEntryBuilderImpl(commandExecutor, task);
    }

    @Override
    public HistoricTaskLogEntryBuilder createHistoricTaskLogEntryBuilder() {
        return new HistoricTaskLogEntryBuilderImpl(commandExecutor);
    }

    @Override
    public HistoricTaskLogEntryQuery createHistoricTaskLogEntryQuery() {
        return new HistoricTaskLogEntryQueryImpl(commandExecutor);
    }

    @Override
    public NativeHistoricTaskLogEntryQuery createNativeHistoricTaskLogEntryQuery() {
        return new NativeHistoricTaskLogEntryQueryImpl(commandExecutor);
    }

}
