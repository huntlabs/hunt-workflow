///* Licensed under the Apache License, Version 2.0 (the "License");
// * you may not use this file except in compliance with the License.
// * You may obtain a copy of the License at
// *
// *      http://www.apache.org/licenses/LICENSE-2.0
// *
// * Unless required by applicable law or agreed to in writing, software
// * distributed under the License is distributed on an "AS IS" BASIS,
// * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// * See the License for the specific language governing permissions and
// * limitations under the License.
// */
//module flow.engine.impl.runtime.MoveExecutionIdContainer;
//
//import hunt.collections;
//import hunt.collection.List;
////import java.util.Optional;
//
///**
// * @author Tijs Rademakers
// */
//class MoveExecutionIdContainer {
//
//    protected List!string executionIds;
//    protected List!string moveToActivityIds;
//    protected Optional!string newAssigneeId;
//
//    public MoveExecutionIdContainer(string singleExecutionId, string moveToActivityId) {
//        this(singleExecutionId, moveToActivityId, null);
//    }
//
//    public MoveExecutionIdContainer(string singleExecutionId, string moveToActivityId, string newAssigneeId) {
//        this.executionIds = Collections.singletonList(singleExecutionId);
//        this.moveToActivityIds = Collections.singletonList(moveToActivityId);
//        this.newAssigneeId = Optional.ofNullable(newAssigneeId);
//    }
//
//    public MoveExecutionIdContainer(List!string executionIds, string moveToActivityId) {
//        this(executionIds, moveToActivityId, null);
//
//    }
//
//    public MoveExecutionIdContainer(List!string executionIds, string moveToActivityId, string newAssigneeId) {
//        this.executionIds = executionIds;
//        this.moveToActivityIds = Collections.singletonList(moveToActivityId);
//        this.newAssigneeId = Optional.ofNullable(newAssigneeId);
//    }
//
//    public MoveExecutionIdContainer(string singleExecutionId, List!string moveToActivityIds) {
//        this(singleExecutionId, moveToActivityIds, null);
//    }
//
//    public MoveExecutionIdContainer(string singleExecutionId, List!string moveToActivityIds, string newAssigneeId) {
//        this.executionIds = Collections.singletonList(singleExecutionId);
//        this.moveToActivityIds = moveToActivityIds;
//        this.newAssigneeId = Optional.ofNullable(newAssigneeId);
//    }
//
//    public List!string getExecutionIds() {
//        return Optional.ofNullable(executionIds).orElse(Collections.emptyList());
//    }
//
//    public List!string getMoveToActivityIds() {
//        return Optional.ofNullable(moveToActivityIds).orElse(Collections.emptyList());
//    }
//
//    public Optional!string getNewAssigneeId() {
//        return newAssigneeId;
//    }
//}
