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
module flow.task.service.impl.persistence.entity.AbstractTaskServiceEntity;

import flow.common.persistence.entity.AbstractEntity;
import flow.task.service.impl.persistence.entity.TaskServiceEntityConstants;

abstract class AbstractTaskServiceEntity : AbstractEntity {

    public string getIdPrefix() {
        return TaskServiceEntityConstants.TASK_SERVICE_ID_PREFIX;
    }
}
