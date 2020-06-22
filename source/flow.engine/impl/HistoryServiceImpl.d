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

module flow.engine.impl.HistoryServiceImpl;

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
//import flow.task.service.impl.NativeHistoricTaskInstanceQueryImpl;
//import flow.task.service.impl.NativeHistoricTaskLogEntryQueryImpl;
import flow.variable.service.api.history.HistoricVariableInstanceQuery;
import flow.variable.service.api.history.NativeHistoricVariableInstanceQuery;
import flow.variable.service.impl.HistoricVariableInstanceQueryImpl;
//import flow.variable.service.impl.NativeHistoricVariableInstanceQueryImpl;
//import flow.engine.impl.NativeHistoricDetailQueryImpl;
//import flow.engine.impl.NativeHistoricProcessInstanceQueryImpl;
//import flow.engine.impl.NativeHistoricActivityInstanceQueryImpl;
import hunt.Exceptions;
/**
 * @author Tom Baeyens
 * @author Bernd Ruecker (camunda)
 * @author Christian Stettler
 */
class HistoryServiceImpl : CommonEngineServiceImpl!ProcessEngineConfigurationImpl , HistoryService {

    this(ProcessEngineConfigurationImpl processEngineConfiguration) {
        super(processEngineConfiguration);
    }


    public HistoricProcessInstanceQuery createHistoricProcessInstanceQuery() {
        implementationMissing(false);
        return null;
       // return new HistoricProcessInstanceQueryImpl(commandExecutor);
    }


    public HistoricActivityInstanceQuery createHistoricActivityInstanceQuery() {
        //return new HistoricActivityInstanceQueryImpl(commandExecutor);
      implementationMissing(false);
        return null;
    }


    public HistoricTaskInstanceQuery createHistoricTaskInstanceQuery() {
        return new HistoricTaskInstanceQueryImpl(commandExecutor, configuration.getDatabaseType());
    }


    public HistoricDetailQuery createHistoricDetailQuery() {
        implementationMissing(false);
        return null;
       // return new HistoricDetailQueryImpl(commandExecutor);
    }


    public NativeHistoricDetailQuery createNativeHistoricDetailQuery() {
        implementationMissing(false);
        return null;
        //return new NativeHistoricDetailQueryImpl(commandExecutor);
    }


    public HistoricVariableInstanceQuery createHistoricVariableInstanceQuery() {
        return new HistoricVariableInstanceQueryImpl(commandExecutor);
    }


    //public NativeHistoricVariableInstanceQuery createNativeHistoricVariableInstanceQuery() {
    //    return new NativeHistoricVariableInstanceQueryImpl(commandExecutor);
    //}


    public void deleteHistoricTaskInstance(string taskId) {
        commandExecutor.execute(new DeleteHistoricTaskInstanceCmd(taskId));
    }


    public void deleteHistoricProcessInstance(string processInstanceId) {
        commandExecutor.execute(new DeleteHistoricProcessInstanceCmd(processInstanceId));
    }


    public void deleteTaskAndActivityDataOfRemovedHistoricProcessInstances() {
        commandExecutor.execute(new DeleteTaskAndActivityDataOfRemovedHistoricProcessInstancesCmd());
    }


    public void deleteRelatedDataOfRemovedHistoricProcessInstances() {
        commandExecutor.execute(new DeleteRelatedDataOfRemovedHistoricProcessInstancesCmd());
    }


    public NativeHistoricProcessInstanceQuery createNativeHistoricProcessInstanceQuery() {
      implementationMissing(false);
       return null;
        //return new NativeHistoricProcessInstanceQueryImpl(commandExecutor);
    }


    //public NativeHistoricTaskInstanceQuery createNativeHistoricTaskInstanceQuery() {
    //    return new NativeHistoricTaskInstanceQueryImpl(commandExecutor);
    //}


    public NativeHistoricActivityInstanceQuery createNativeHistoricActivityInstanceQuery() {
        implementationMissing(false);
        return null;
       // return new NativeHistoricActivityInstanceQueryImpl(commandExecutor);
    }


    public List!HistoricIdentityLink getHistoricIdentityLinksForProcessInstance(string processInstanceId) {
        return commandExecutor.execute(new GetHistoricIdentityLinksForTaskCmd(null, processInstanceId));
    }


    public List!HistoricIdentityLink getHistoricIdentityLinksForTask(string taskId) {
        return commandExecutor.execute(new GetHistoricIdentityLinksForTaskCmd(taskId, null));
    }


    public List!HistoricEntityLink getHistoricEntityLinkChildrenForProcessInstance(string processInstanceId) {
        return commandExecutor.execute(new GetHistoricEntityLinkChildrenForProcessInstanceCmd(processInstanceId));
    }


    public List!HistoricEntityLink getHistoricEntityLinkChildrenForTask(string taskId) {
        return commandExecutor.execute(new GetHistoricEntityLinkChildrenForTaskCmd(taskId));
    }


    public List!HistoricEntityLink getHistoricEntityLinkParentsForProcessInstance(string processInstanceId) {
        return commandExecutor.execute(new GetHistoricEntityLinkParentsForProcessInstanceCmd(processInstanceId));
    }


    public List!HistoricEntityLink getHistoricEntityLinkParentsForTask(string taskId) {
        return commandExecutor.execute(new GetHistoricEntityLinkParentsForTaskCmd(taskId));
    }


    public ProcessInstanceHistoryLogQuery createProcessInstanceHistoryLogQuery(string processInstanceId) {
      implementationMissing(false);
      return null;
       // return new ProcessInstanceHistoryLogQueryImpl(commandExecutor, processInstanceId);
    }


    public void deleteHistoricTaskLogEntry(long logNumber) {
        commandExecutor.execute(new DeleteHistoricTaskLogEntryByLogNumberCmd(logNumber));
    }


    public HistoricTaskLogEntryBuilder createHistoricTaskLogEntryBuilder(TaskInfo task) {
        return new HistoricTaskLogEntryBuilderImpl(commandExecutor, task);
    }


    public HistoricTaskLogEntryBuilder createHistoricTaskLogEntryBuilder() {
        return new HistoricTaskLogEntryBuilderImpl(commandExecutor);
    }


    public HistoricTaskLogEntryQuery createHistoricTaskLogEntryQuery() {
        return new HistoricTaskLogEntryQueryImpl(commandExecutor);
    }


    //public NativeHistoricTaskLogEntryQuery createNativeHistoricTaskLogEntryQuery() {
    //    return new NativeHistoricTaskLogEntryQueryImpl(commandExecutor);
    //}

}
