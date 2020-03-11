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

module flow.engine.history.HistoricDetailQuery;

import flow.common.api.query.Query;
import flow.engine.runtime.Execution;
import flow.task.api.history.HistoricTaskInstance;
import flow.engine.history.HistoricDetail;
/**
 * Programmatic querying for {@link HistoricDetail}s.
 *
 * @author Tom Baeyens
 */
interface HistoricDetailQuery : Query!(HistoricDetailQuery, HistoricDetail) {

    /** Only select historic info with the given id. */
    HistoricDetailQuery id(string id);

    /**
     * Only select historic variable updates with the given process instance. {@link ProcessInstance) ids and {@link HistoricProcessInstance} ids match.
     */
    HistoricDetailQuery processInstanceId(string processInstanceId);

    /**
     * Only select historic variable updates with the given execution. Note that {@link Execution} ids are not stored in the history as first class citizen, only process instances are.
     */
    HistoricDetailQuery executionId(string executionId);

    /**
     * Only select historic variable updates associated to the given {@link HistoricActivityInstance activity instance}.
     */
    HistoricDetailQuery activityInstanceId(string activityInstanceId);

    /**
     * Only select historic variable updates associated to the given {@link HistoricTaskInstance historic task instance}.
     */
    HistoricDetailQuery taskId(string taskId);

    /** Only select {@link HistoricFormProperty}s. */
    HistoricDetailQuery formProperties();

    /** Only select {@link HistoricVariableUpdate}s. */
    HistoricDetailQuery variableUpdates();

    /**
     * Exclude all task-related {@link HistoricDetail}s, so only items which have no task-id set will be selected. When used together with {@link #taskId(string)}, this call is ignored task details
     * are NOT excluded.
     */
    HistoricDetailQuery excludeTaskDetails();

    HistoricDetailQuery orderByProcessInstanceId();

    HistoricDetailQuery orderByVariableName();

    HistoricDetailQuery orderByFormPropertyId();

    HistoricDetailQuery orderByVariableType();

    HistoricDetailQuery orderByVariableRevision();

    HistoricDetailQuery orderByTime();
}
