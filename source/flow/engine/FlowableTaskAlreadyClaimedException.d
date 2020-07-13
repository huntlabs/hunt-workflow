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
module flow.engine.FlowableTaskAlreadyClaimedException;

import flow.common.api.FlowableTaskAlreadyClaimedException;
/**
 * This exception is thrown when you try to claim a task that is already claimed by someone else.
 *
 * @author Jorg Heymans
 * @author Falko Menge
 * @deprecated use {@link flow.common.api.FlowableTaskAlreadyClaimedException}
 */
class FlowableTaskAlreadyClaimedException : flow.common.api.FlowableTaskAlreadyClaimedException.FlowableTaskAlreadyClaimedException {


    this(string taskId, string taskAssignee) {
        super(taskId, taskAssignee);
    }
}
