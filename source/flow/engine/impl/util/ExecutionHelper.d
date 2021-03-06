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
module flow.engine.impl.util.ExecutionHelper;

import flow.engine.impl.persistence.entity.ExecutionEntity;
import flow.engine.impl.util.CommandContextUtil;

/**
 * @author Tijs Rademakers
 */
class ExecutionHelper {

    public static ExecutionEntity getProcessInstanceExecution(string processInstanceId) {
        return CommandContextUtil.getExecutionEntityManager().findById(processInstanceId);
    }

    public static ExecutionEntity getExecution(string executionId) {
        return CommandContextUtil.getExecutionEntityManager().findById(executionId);
    }
}
