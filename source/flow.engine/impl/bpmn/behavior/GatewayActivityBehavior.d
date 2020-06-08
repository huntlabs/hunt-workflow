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
module flow.engine.impl.bpmn.behavior.GatewayActivityBehavior;

import flow.engine.deleg.DelegateExecution;
import flow.engine.impl.persistence.entity.ExecutionEntity;
import flow.engine.impl.persistence.entity.ExecutionEntityManager;
import flow.engine.impl.util.CommandContextUtil;
import flow.engine.impl.bpmn.behavior.FlowNodeActivityBehavior;

/**
 * Super class for all gateway activity implementations.
 *
 * @author Joram Barrez
 */
abstract class GatewayActivityBehavior : FlowNodeActivityBehavior {

    protected void lockFirstParentScope(DelegateExecution execution) {

        ExecutionEntityManager executionEntityManager = CommandContextUtil.getExecutionEntityManager();

        bool found = false;
        ExecutionEntity parentScopeExecution = null;
        ExecutionEntity currentExecution = cast(ExecutionEntity) execution;
        while (!found && currentExecution !is null && currentExecution.getParentId() !is null && currentExecution.getParentId().length != 0) {
            parentScopeExecution = executionEntityManager.findById(currentExecution.getParentId());
            if (parentScopeExecution !is null && parentScopeExecution.isScope()) {
                found = true;
            }
            currentExecution = parentScopeExecution;
        }

        parentScopeExecution.forceUpdate();
    }

}
