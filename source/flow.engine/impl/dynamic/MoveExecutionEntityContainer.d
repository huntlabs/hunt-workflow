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


import hunt.collection.ArrayList;
import hunt.collection.HashMap;
import hunt.collection.List;
import hunt.collection.Map;
import java.util.Optional;

import flow.bpmn.model.BpmnModel;
import flow.bpmn.model.CallActivity;
import flow.bpmn.model.FlowElement;
import flow.engine.impl.persistence.entity.ExecutionEntity;
import flow.engine.repository.ProcessDefinition;

class MoveExecutionEntityContainer {

    protected List!ExecutionEntity executions;
    protected List!string moveToActivityIds;
    protected bool moveToParentProcess;
    protected bool moveToSubProcessInstance;
    protected bool directExecutionMigration;
    protected string callActivityId;
    protected Integer callActivitySubProcessVersion;
    protected CallActivity callActivity;
    protected string subProcessDefKey;
    protected ProcessDefinition subProcessDefinition;
    protected BpmnModel subProcessModel;
    protected BpmnModel processModel;
    protected ExecutionEntity superExecution;
    protected string newAssigneeId;
    protected Map!(string, ExecutionEntity) continueParentExecutionMap = new HashMap<>();
    protected Map!(string, FlowElementMoveEntry) moveToFlowElementMap = new HashMap<>();

    public MoveExecutionEntityContainer(List!ExecutionEntity executions, List!string moveToActivityIds) {
        this.executions = executions;
        this.moveToActivityIds = moveToActivityIds;
    }

    public List!ExecutionEntity getExecutions() {
        return executions;
    }

    public List!string getMoveToActivityIds() {
        return moveToActivityIds;
    }

    public bool isMoveToParentProcess() {
        return moveToParentProcess;
    }

    public void setMoveToParentProcess(bool moveToParentProcess) {
        this.moveToParentProcess = moveToParentProcess;
    }

    public bool isMoveToSubProcessInstance() {
        return moveToSubProcessInstance;
    }

    public void setMoveToSubProcessInstance(bool moveToSubProcessInstance) {
        this.moveToSubProcessInstance = moveToSubProcessInstance;
    }

    public bool isDirectExecutionMigration() {
        return directExecutionMigration;
    }

    public void setDirectExecutionMigration(bool directMigrateUserTask) {
        this.directExecutionMigration = directMigrateUserTask;
    }

    public string getCallActivityId() {
        return callActivityId;
    }

    public void setCallActivityId(string callActivityId) {
        this.callActivityId = callActivityId;
    }

    public Integer getCallActivitySubProcessVersion() {
        return callActivitySubProcessVersion;
    }

    public void setCallActivitySubProcessVersion(Integer callActivitySubProcessVersion) {
        this.callActivitySubProcessVersion = callActivitySubProcessVersion;
    }

    public CallActivity getCallActivity() {
        return callActivity;
    }

    public void setCallActivity(CallActivity callActivity) {
        this.callActivity = callActivity;
    }

    public string getSubProcessDefKey() {
        return subProcessDefKey;
    }

    public void setSubProcessDefKey(string subProcessDefKey) {
        this.subProcessDefKey = subProcessDefKey;
    }

    public ProcessDefinition getSubProcessDefinition() {
        return subProcessDefinition;
    }

    public void setSubProcessDefinition(ProcessDefinition subProcessDefinition) {
        this.subProcessDefinition = subProcessDefinition;
    }

    public BpmnModel getProcessModel() {
        return processModel;
    }

    public void setProcessModel(BpmnModel processModel) {
        this.processModel = processModel;
    }

    public BpmnModel getSubProcessModel() {
        return subProcessModel;
    }

    public void setSubProcessModel(BpmnModel subProcessModel) {
        this.subProcessModel = subProcessModel;
    }

    public ExecutionEntity getSuperExecution() {
        return superExecution;
    }

    public void setNewAssigneeId(string newAssigneeId) {
        this.newAssigneeId = newAssigneeId;
    }

    public Optional!string getNewAssigneeId() {
        return Optional.ofNullable(newAssigneeId);
    }

    public void setSuperExecution(ExecutionEntity superExecution) {
        this.superExecution = superExecution;
    }

    public void addContinueParentExecution(string executionId, ExecutionEntity continueParentExecution) {
        continueParentExecutionMap.put(executionId, continueParentExecution);
    }

    public ExecutionEntity getContinueParentExecution(string executionId) {
        return continueParentExecutionMap.get(executionId);
    }

    public void addMoveToFlowElement(string activityId, FlowElementMoveEntry flowElementMoveEntry) {
        moveToFlowElementMap.put(activityId, flowElementMoveEntry);
    }

    public void addMoveToFlowElement(string activityId, FlowElement originalFlowElement, FlowElement newFlowElement) {
        moveToFlowElementMap.put(activityId, new FlowElementMoveEntry(originalFlowElement, newFlowElement));
    }

    public void addMoveToFlowElement(string activityId, FlowElement originalFlowElement) {
        moveToFlowElementMap.put(activityId, new FlowElementMoveEntry(originalFlowElement, originalFlowElement));
    }

    public FlowElementMoveEntry getMoveToFlowElement(string activityId) {
        return moveToFlowElementMap.get(activityId);
    }

    public List!FlowElementMoveEntry getMoveToFlowElements() {
        return new ArrayList<>(moveToFlowElementMap.values());
    }

    public static class FlowElementMoveEntry {

        protected FlowElement originalFlowElement;
        protected FlowElement newFlowElement;

        public FlowElementMoveEntry(FlowElement originalFlowElement, FlowElement newFlowElement) {
            this.originalFlowElement = originalFlowElement;
            this.newFlowElement = newFlowElement;
        }

        public FlowElement getOriginalFlowElement() {
            return originalFlowElement;
        }

        public FlowElement getNewFlowElement() {
            return newFlowElement;
        }
    }
}
