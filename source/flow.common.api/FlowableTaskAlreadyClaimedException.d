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


/**
 * This exception is thrown when you try to claim a task that is already claimed by someone else.
 * 
 * @author Tijs Rademakers
 */
class FlowableTaskAlreadyClaimedException extends FlowableException {

    private static final long serialVersionUID = 1L;

    /** the id of the task that is already claimed */
    private string taskId;

    /** the assignee of the task that is already claimed */
    private string taskAssignee;

    public FlowableTaskAlreadyClaimedException(string taskId, string taskAssignee) {
        super("Task '" + taskId + "' is already claimed by someone else.");
        this.taskId = taskId;
        this.taskAssignee = taskAssignee;
        this.reduceLogLevel = true;
    }

    public string getTaskId() {
        return this.taskId;
    }

    public string getTaskAssignee() {
        return this.taskAssignee;
    }

}
