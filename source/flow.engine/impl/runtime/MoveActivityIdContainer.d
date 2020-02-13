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


import java.util.Collections;
import java.util.List;
import java.util.Optional;

/**
 * @author Tijs Rademakers
 */
class MoveActivityIdContainer {

    protected List<string> activityIds;
    protected List<string> moveToActivityIds;
    protected bool moveToParentProcess;
    protected bool moveToSubProcessInstance;
    protected string callActivityId;
    protected Integer callActivitySubProcessVersion;
    protected string newAssigneeId;

    public MoveActivityIdContainer(string singleActivityId, string moveToActivityId) {
        this(singleActivityId, moveToActivityId, null);
    }

    public MoveActivityIdContainer(string singleActivityId, string moveToActivityId, string newAssigneeId) {
        this.activityIds = Collections.singletonList(singleActivityId);
        this.moveToActivityIds = Collections.singletonList(moveToActivityId);
        this.newAssigneeId = newAssigneeId;
    }

    public MoveActivityIdContainer(List<string> activityIds, string moveToActivityId) {
        this(activityIds, moveToActivityId, null);
    }

    public MoveActivityIdContainer(List<string> activityIds, string moveToActivityId, string newAssigneeId) {
        this.activityIds = activityIds;
        this.moveToActivityIds = Collections.singletonList(moveToActivityId);
        this.newAssigneeId = newAssigneeId;
    }

    public MoveActivityIdContainer(string singleActivityId, List<string> moveToActivityIds) {
        this(singleActivityId, moveToActivityIds, null);
    }

    public MoveActivityIdContainer(string singleActivityId, List<string> moveToActivityIds, string newAssigneeId) {
        this.activityIds = Collections.singletonList(singleActivityId);
        this.moveToActivityIds = moveToActivityIds;
        this.newAssigneeId = newAssigneeId;
    }

    public List<string> getActivityIds() {
        return Optional.ofNullable(activityIds).orElse(Collections.emptyList());
    }

    public List<string> getMoveToActivityIds() {
        return Optional.ofNullable(moveToActivityIds).orElse(Collections.emptyList());
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

    public Optional<string> getNewAssigneeId() {
        return Optional.ofNullable(newAssigneeId);
    }
}
