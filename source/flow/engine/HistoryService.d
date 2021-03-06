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

//          Copyright linse 2020.
// Distributed under the Boost Software License, Version 1.0.
//    (See accompanying file LICENSE_1_0.txt or copy at
//          http://www.boost.org/LICENSE_1_0.txt)}

module flow.engine.HistoryService;





import hunt.collection.List;

import flow.engine.history.HistoricActivityInstance;
import flow.engine.history.HistoricActivityInstanceQuery;
import flow.engine.history.HistoricDetail;
import flow.engine.history.HistoricDetailQuery;
import flow.engine.history.HistoricProcessInstance;
import flow.engine.history.HistoricProcessInstanceQuery;
import flow.engine.history.NativeHistoricActivityInstanceQuery;
import flow.engine.history.NativeHistoricDetailQuery;
import flow.engine.history.NativeHistoricProcessInstanceQuery;
import flow.engine.history.ProcessInstanceHistoryLog;
import flow.engine.history.ProcessInstanceHistoryLogQuery;
//import flow.entitylink.service.api.history.HistoricEntityLink;
import flow.identitylink.api.IdentityLink;
//import flow.identitylink.api.history.HistoricIdentityLink;
import flow.task.api.TaskInfo;
import flow.task.api.history.HistoricTaskInstance;
import flow.task.api.history.HistoricTaskInstanceQuery;
import flow.task.api.history.HistoricTaskLogEntry;
import flow.task.api.history.HistoricTaskLogEntryBuilder;
import flow.task.api.history.HistoricTaskLogEntryQuery;
import flow.task.api.history.NativeHistoricTaskLogEntryQuery;
import flow.task.service.history.NativeHistoricTaskInstanceQuery;
import flow.variable.service.api.history.HistoricVariableInstance;
import flow.variable.service.api.history.HistoricVariableInstanceQuery;
import flow.variable.service.api.history.NativeHistoricVariableInstanceQuery;

/**
 * Service exposing information about ongoing and past process instances. This is different from the runtime information in the sense that this runtime information only contains the actual runtime
 * state at any given moment and it is optimized for runtime process execution performance. The history information is optimized for easy querying and remains permanent in the persistent storage.
 *
 * @author Christian Stettler
 * @author Tom Baeyens
 * @author Joram Barrez
 */
interface HistoryService {

    /**
     * Creates a new programmatic query to search for {@link HistoricProcessInstance}s.
     */
    HistoricProcessInstanceQuery createHistoricProcessInstanceQuery();

    /**
     * Creates a new programmatic query to search for {@link HistoricActivityInstance}s.
     */
    HistoricActivityInstanceQuery createHistoricActivityInstanceQuery();

    /**
     * Creates a new programmatic query to search for {@link HistoricTaskInstance}s.
     */
    HistoricTaskInstanceQuery createHistoricTaskInstanceQuery();

    /** Creates a new programmatic query to search for {@link HistoricDetail}s. */
    HistoricDetailQuery createHistoricDetailQuery();

    /**
     * Returns a new {@link flow.common.api.query.NativeQuery} for process definitions.
     */
    NativeHistoricDetailQuery createNativeHistoricDetailQuery();

    /**
     * Creates a new programmatic query to search for {@link HistoricVariableInstance}s.
     */
    HistoricVariableInstanceQuery createHistoricVariableInstanceQuery();

    /**
     * Returns a new {@link flow.common.api.query.NativeQuery} for process definitions.
     */
    NativeHistoricVariableInstanceQuery createNativeHistoricVariableInstanceQuery();

    /**
     * Deletes historic task instance. This might be useful for tasks that are {@link TaskService#newTask() dynamically created} and then {@link TaskService#complete(string) completed}. If the
     * historic task instance doesn't exist, no exception is thrown and the method returns normal.
     */
    void deleteHistoricTaskInstance(string taskId);

    /**
     * Deletes historic process instance. All historic activities, historic task and historic details (variable updates, form properties) are deleted as well.
     */
    void deleteHistoricProcessInstance(string processInstanceId);

    /**
     * Deletes historic task and activity data for removed process instances
     */
    void deleteTaskAndActivityDataOfRemovedHistoricProcessInstances();

    /**
     * Deletes historic identity links, detail info, variable data and entity links for removed process instances
     */
    void deleteRelatedDataOfRemovedHistoricProcessInstances();

    /**
     * creates a native query to search for {@link HistoricProcessInstance}s via SQL
     */
    NativeHistoricProcessInstanceQuery createNativeHistoricProcessInstanceQuery();

    /**
     * creates a native query to search for {@link HistoricTaskInstance}s via SQL
     */
    NativeHistoricTaskInstanceQuery createNativeHistoricTaskInstanceQuery();

    /**
     * creates a native query to search for {@link HistoricActivityInstance}s via SQL
     */
    NativeHistoricActivityInstanceQuery createNativeHistoricActivityInstanceQuery();

    /**
     * Retrieves the {@link HistoricIdentityLink}s associated with the given task. Such an {@link IdentityLink} informs how a certain identity (eg. group or user) is associated with a certain task
     * (eg. as candidate, assignee, etc.), even if the task is completed as opposed to {@link IdentityLink}s which only exist for active tasks.
     */
   // List!HistoricIdentityLink getHistoricIdentityLinksForTask(string taskId);

    /**
     * Retrieves the {@link HistoricIdentityLink}s associated with the given process instance. Such an {@link IdentityLink} informs how a certain identity (eg. group or user) is associated with a
     * certain process instance, even if the instance is completed as opposed to {@link IdentityLink}s which only exist for active instances.
     */
   // List!HistoricIdentityLink getHistoricIdentityLinksForProcessInstance(string processInstanceId);

    /**
     * Retrieves the {@link HistoricEntityLink}s associated with the given process instance.
     */
  //  List!HistoricEntityLink getHistoricEntityLinkChildrenForProcessInstance(string processInstanceId);

    /**
     * Retrieves the {@link HistoricEntityLink}s associated with the given task.
     */
   // List!HistoricEntityLink getHistoricEntityLinkChildrenForTask(string taskId);

    /**
     * Retrieves the {@link HistoricEntityLink}s where the given process instance is referenced.
     */
   // List!HistoricEntityLink getHistoricEntityLinkParentsForProcessInstance(string processInstanceId);

    /**
     * Retrieves the {@link HistoricEntityLink}s where the given task is referenced.
     */
   // List!HistoricEntityLink getHistoricEntityLinkParentsForTask(string taskId);

    /**
     * Allows to retrieve the {@link ProcessInstanceHistoryLog} for one process instance.
     */
    ProcessInstanceHistoryLogQuery createProcessInstanceHistoryLogQuery(string processInstanceId);

    /**
     * Deletes user task log entry by its log number
     *
     * @param logNumber user task log entry identifier
     */
    void deleteHistoricTaskLogEntry(long logNumber);

    /**
     * Create new task log entry builder to the log task event
     *
     * @param task to which is log related to
     */
    HistoricTaskLogEntryBuilder createHistoricTaskLogEntryBuilder(TaskInfo task);

    /**
     * Create new task log entry builder to the log task event without predefined values from the task
     *
     */
    HistoricTaskLogEntryBuilder createHistoricTaskLogEntryBuilder();

    /**
     * Returns a new {@link HistoricTaskLogEntryQuery} that can be used to dynamically query task log entries.
     */
    HistoricTaskLogEntryQuery createHistoricTaskLogEntryQuery();

    /**
     * Returns a new {@link NativeHistoricTaskLogEntryQuery} for {@link HistoricTaskLogEntry}s.
     */
    NativeHistoricTaskLogEntryQuery createNativeHistoricTaskLogEntryQuery();

}
