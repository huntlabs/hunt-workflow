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


import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Optional;

import org.flowable.bpmn.model.StartEvent;
import flow.engine.impl.persistence.entity.ExecutionEntity;
import flow.engine.repository.ProcessDefinition;

/**
 * @author Dennis
 */
//Auxiliary class to kick off a changeActivityState / processMigration and store its state
class ProcessInstanceChangeState {

    protected string processInstanceId;
    protected ProcessDefinition processDefinitionToMigrateTo;
    protected Map<string, Object> processVariables = new HashMap<>();
    protected Map<string, Map<string, Object>> localVariables = new HashMap<>();
    protected Map<string, List<ExecutionEntity>> processInstanceActiveEmbeddedExecutions;
    protected List<MoveExecutionEntityContainer> moveExecutionEntityContainers;
    protected HashMap<string, ExecutionEntity> createdEmbeddedSubProcess = new HashMap<>();
    protected HashMap<StartEvent, ExecutionEntity> pendingEventSubProcessesStartEvents = new HashMap<>();

    public ProcessInstanceChangeState() {
    }

    public string getProcessInstanceId() {
        return processInstanceId;
    }

    public ProcessInstanceChangeState setProcessInstanceId(string processInstanceId) {
        this.processInstanceId = processInstanceId;
        return this;
    }

    public Optional<ProcessDefinition> getProcessDefinitionToMigrateTo() {
        return Optional.ofNullable(processDefinitionToMigrateTo);
    }

    public ProcessInstanceChangeState setProcessDefinitionToMigrateTo(ProcessDefinition processDefinitionToMigrateTo) {
        this.processDefinitionToMigrateTo = processDefinitionToMigrateTo;
        return this;
    }

    public bool isMigrateToProcessDefinition() {
        return getProcessDefinitionToMigrateTo().isPresent();
    }

    public Map<string, Object> getProcessInstanceVariables() {
        return processVariables;
    }

    public ProcessInstanceChangeState setProcessInstanceVariables(Map<string, Object> processVariables) {
        this.processVariables = processVariables;
        return this;
    }

    public Map<string, Map<string, Object>> getLocalVariables() {
        return localVariables;
    }

    public ProcessInstanceChangeState setLocalVariables(Map<string, Map<string, Object>> localVariables) {
        this.localVariables = localVariables;
        return this;
    }

    public List<MoveExecutionEntityContainer> getMoveExecutionEntityContainers() {
        return moveExecutionEntityContainers;
    }

    public ProcessInstanceChangeState setMoveExecutionEntityContainers(List<MoveExecutionEntityContainer> moveExecutionEntityContainers) {
        this.moveExecutionEntityContainers = moveExecutionEntityContainers;
        return this;
    }

    public HashMap<string, ExecutionEntity> getCreatedEmbeddedSubProcesses() {
        return createdEmbeddedSubProcess;
    }

    public Optional<ExecutionEntity> getCreatedEmbeddedSubProcessByKey(string key) {
        return Optional.ofNullable(createdEmbeddedSubProcess.get(key));
    }

    public void addCreatedEmbeddedSubProcess(string key, ExecutionEntity executionEntity) {
        this.createdEmbeddedSubProcess.put(key, executionEntity);
    }

    public Map<string, List<ExecutionEntity>> getProcessInstanceActiveEmbeddedExecutions() {
        return processInstanceActiveEmbeddedExecutions;
    }

    public ProcessInstanceChangeState setProcessInstanceActiveEmbeddedExecutions(Map<string, List<ExecutionEntity>> processInstanceActiveEmbeddedExecutions) {
        this.processInstanceActiveEmbeddedExecutions = processInstanceActiveEmbeddedExecutions;
        return this;
    }

    public HashMap<StartEvent, ExecutionEntity> getPendingEventSubProcessesStartEvents() {
        return pendingEventSubProcessesStartEvents;
    }

    public void addPendingEventSubProcessStartEvent(StartEvent startEvent, ExecutionEntity eventSubProcessParent) {
        this.pendingEventSubProcessesStartEvents.put(startEvent, eventSubProcessParent);
    }

}
