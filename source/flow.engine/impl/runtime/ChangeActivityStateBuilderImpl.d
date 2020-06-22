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
module flow.engine.impl.runtime.ChangeActivityStateBuilderImpl;

import hunt.collection.ArrayList;
import hunt.collection.HashMap;
import hunt.collection.List;
import hunt.collection.Map;

import flow.common.api.FlowableException;
import flow.engine.impl.RuntimeServiceImpl;
import flow.engine.runtime.ChangeActivityStateBuilder;
import flow.engine.impl.runtime.MoveActivityIdContainer;
//import flow.engine.impl.runtime.MoveExecutionIdContainer;
import hunt.Exceptions;
/**
 * @author Tijs Rademakers
 */
class ChangeActivityStateBuilderImpl : ChangeActivityStateBuilder {

    protected RuntimeServiceImpl runtimeService;

    protected string processInstanceId;
    //protected List!MoveExecutionIdContainer moveExecutionIdList = new ArrayList<>();
    protected List!MoveActivityIdContainer moveActivityIdList;// = new ArrayList<>();
    protected Map!(string, Object) processVariables ;//= new HashMap();
    protected Map!(string, Map!(string, Object)) localVariables ;//= new HashMap<>();

    this() {
        processVariables = new HashMap!(string, Object);
        moveActivityIdList = new ArrayList!MoveActivityIdContainer;
        localVariables = new HashMap!(string, Map!(string, Object));
    }

    this(RuntimeServiceImpl runtimeService) {
        this.runtimeService = runtimeService;
         processVariables = new HashMap!(string, Object);
        moveActivityIdList = new ArrayList!MoveActivityIdContainer;
        localVariables = new HashMap!(string, Map!(string, Object));
    }


    public ChangeActivityStateBuilder processInstanceId(string processInstanceId) {
        this.processInstanceId = processInstanceId;
        return this;
    }


    public ChangeActivityStateBuilder moveExecutionToActivityId(string executionId, string activityId) {
        return moveExecutionToActivityId(executionId, activityId, null);
    }

    public ChangeActivityStateBuilder moveExecutionToActivityId(string executionId, string activityId, string newAssigneeId) {
       // moveExecutionIdList.add(new MoveExecutionIdContainer(executionId, activityId, newAssigneeId));
        implementationMissing(false);
        return this;
    }


    public ChangeActivityStateBuilder moveExecutionsToSingleActivityId(List!string executionIds, string activityId) {
        return moveExecutionsToSingleActivityId(executionIds, activityId, null);
    }

    public ChangeActivityStateBuilder moveExecutionsToSingleActivityId(List!string executionIds, string activityId, string newAssigneeId) {
        implementationMissing(false);
       //  moveExecutionIdList.add(new MoveExecutionIdContainer(executionIds, activityId, newAssigneeId));
        return this;
    }


    public ChangeActivityStateBuilder moveSingleExecutionToActivityIds(string executionId, List!string activityIds) {
        return moveSingleExecutionToActivityIds(executionId, activityIds, null);
    }

    public ChangeActivityStateBuilder moveSingleExecutionToActivityIds(string executionId, List!string activityIds, string newAssigneeId) {
        implementationMissing(false);
       //moveExecutionIdList.add(new MoveExecutionIdContainer(executionId, activityIds, newAssigneeId));
        return this;
    }


    public ChangeActivityStateBuilder moveActivityIdTo(string currentActivityId, string newActivityId) {
        return moveActivityIdTo(currentActivityId, newActivityId, null);
    }

    public ChangeActivityStateBuilder moveActivityIdTo(string currentActivityId, string newActivityId, string newAssigneeId) {
        moveActivityIdList.add(new MoveActivityIdContainer(currentActivityId, newActivityId, newAssigneeId));
        return this;
    }


    public ChangeActivityStateBuilder moveActivityIdsToSingleActivityId(List!string activityIds, string activityId) {
        return moveActivityIdsToSingleActivityId(activityIds, activityId, null);
    }

    public ChangeActivityStateBuilder moveActivityIdsToSingleActivityId(List!string activityIds, string activityId, string newAssigneeId) {
        moveActivityIdList.add(new MoveActivityIdContainer(activityIds, activityId, newAssigneeId));
        return this;
    }


    public ChangeActivityStateBuilder moveSingleActivityIdToActivityIds(string currentActivityId, List!string newActivityIds) {
        return moveSingleActivityIdToActivityIds(currentActivityId, newActivityIds, null);
    }

    public ChangeActivityStateBuilder moveSingleActivityIdToActivityIds(string currentActivityId, List!string newActivityIds, string newAssigneeId) {
        moveActivityIdList.add(new MoveActivityIdContainer(currentActivityId, newActivityIds, newAssigneeId));
        return this;
    }


    public ChangeActivityStateBuilder moveActivityIdToParentActivityId(string currentActivityId, string newActivityId) {
        return moveActivityIdToParentActivityId(currentActivityId, newActivityId, null);
    }

    public ChangeActivityStateBuilder moveActivityIdToParentActivityId(string currentActivityId, string newActivityId, string newAssigneeId) {
        MoveActivityIdContainer moveActivityIdContainer = new MoveActivityIdContainer(currentActivityId, newActivityId, newAssigneeId);
        moveActivityIdContainer.setMoveToParentProcess(true);
        moveActivityIdList.add(moveActivityIdContainer);
        return this;
    }

    public ChangeActivityStateBuilder moveActivityIdsToParentActivityId(List!string currentActivityIds, string newActivityId, string newAssigneeId) {
        MoveActivityIdContainer moveActivityIdContainer = new MoveActivityIdContainer(currentActivityIds, newActivityId, newAssigneeId);
        moveActivityIdContainer.setMoveToParentProcess(true);
        moveActivityIdList.add(moveActivityIdContainer);
        return this;
    }

    public ChangeActivityStateBuilder moveSingleActivityIdToParentActivityIds(string currentActivityId, List!string newActivityIds) {
        MoveActivityIdContainer moveActivityIdContainer = new MoveActivityIdContainer(currentActivityId, newActivityIds);
        moveActivityIdContainer.setMoveToParentProcess(true);
        moveActivityIdList.add(moveActivityIdContainer);
        return this;
    }


    public ChangeActivityStateBuilder moveActivityIdToSubProcessInstanceActivityId(string currentActivityId, string newActivityId, string callActivityId) {
        return moveActivityIdToSubProcessInstanceActivityId(currentActivityId, newActivityId, callActivityId, null, null);
    }


    public ChangeActivityStateBuilder moveActivityIdToSubProcessInstanceActivityId(string currentActivityId, string newActivityId, string callActivityId, Integer subProcessDefinitionVersion) {
        return moveActivityIdToSubProcessInstanceActivityId(currentActivityId, newActivityId, callActivityId, subProcessDefinitionVersion, null);
    }

    public ChangeActivityStateBuilder moveActivityIdToSubProcessInstanceActivityId(string currentActivityId, string newActivityId, string callActivityId, Integer callActivitySubProcessVersion, string newAssigneeId) {
        MoveActivityIdContainer moveActivityIdContainer = new MoveActivityIdContainer(currentActivityId, newActivityId, newAssigneeId);
        moveActivityIdContainer.setMoveToSubProcessInstance(true);
        moveActivityIdContainer.setCallActivityId(callActivityId);
        moveActivityIdContainer.setCallActivitySubProcessVersion(callActivitySubProcessVersion);
        moveActivityIdList.add(moveActivityIdContainer);
        return this;
    }

    public ChangeActivityStateBuilder moveActivityIdsToSubProcessInstanceActivityId(List!string activityIds, string newActivityId, string callActivityId, Integer callActivitySubProcessVersion, string newAssigneeId) {
        MoveActivityIdContainer moveActivityIdsContainer = new MoveActivityIdContainer(activityIds, newActivityId, newAssigneeId);
        moveActivityIdsContainer.setMoveToSubProcessInstance(true);
        moveActivityIdsContainer.setCallActivityId(callActivityId);
        moveActivityIdsContainer.setCallActivitySubProcessVersion(callActivitySubProcessVersion);
        moveActivityIdList.add(moveActivityIdsContainer);
        return this;
    }

    public ChangeActivityStateBuilder moveSingleActivityIdToSubProcessInstanceActivityIds(string currentActivityId, List!string newActivityIds, string callActivityId, Integer callActivitySubProcessVersion) {
        MoveActivityIdContainer moveActivityIdsContainer = new MoveActivityIdContainer(currentActivityId, newActivityIds);
        moveActivityIdsContainer.setMoveToSubProcessInstance(true);
        moveActivityIdsContainer.setCallActivityId(callActivityId);
        moveActivityIdsContainer.setCallActivitySubProcessVersion(callActivitySubProcessVersion);
        moveActivityIdList.add(moveActivityIdsContainer);
        return this;
    }


    public ChangeActivityStateBuilder processVariable(string processVariableName, Object processVariableValue) {
        if (this.processVariables is null) {
            this.processVariables = new HashMap!(string, Object) ;
        }

        this.processVariables.put(processVariableName, processVariableValue);
        return this;
    }


    public ChangeActivityStateBuilder processVariables(Map!(string, Object) processVariables) {
        this.processVariables = processVariables;
        return this;
    }


    public ChangeActivityStateBuilder localVariable(string startActivityId, string localVariableName, Object localVariableValue) {
        if (this.localVariables is null) {
            this.localVariables = new HashMap!(string, Map!(string, Object));
        }

        Map!(string, Object) localVariableMap = null;
        if (localVariables.containsKey(startActivityId)) {
            localVariableMap = localVariables.get(startActivityId);
        } else {
            localVariableMap = new HashMap!(string, Object);
        }

        localVariableMap.put(localVariableName, localVariableValue);

        this.localVariables.put(startActivityId, localVariableMap);

        return this;
    }


    public ChangeActivityStateBuilder localVariables(string startActivityId, Map!(string, Object) localVariables) {
        if (this.localVariables is null) {
            this.localVariables = new HashMap!(string, Object);
        }

        this.localVariables.put(startActivityId, localVariables);

        return this;
    }


    public void changeState() {
        if (runtimeService is null) {
            throw new FlowableException("RuntimeService cannot be null, Obtain your builder instance from the RuntimService to access this feature");
        }
        runtimeService.changeActivityState(this);
    }

    public string getProcessInstanceId() {
        return processInstanceId;
    }

    //public List!MoveExecutionIdContainer getMoveExecutionIdList() {
    //    return moveExecutionIdList;
    //}

    public List!MoveActivityIdContainer getMoveActivityIdList() {
        return moveActivityIdList;
    }

    public Map!(string, Object) getProcessInstanceVariables() {
        return processVariables;
    }

    public Map!(string, Map!(string, Object)) getLocalVariables() {
        return localVariables;
    }
}
