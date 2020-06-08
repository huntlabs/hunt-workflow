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



import flow.engine.impl.persistence.entity.ExecutionEntityImpl;
import flow.engine.impl.persistence.entity.ExecutionEntityManager;
import flow.task.service.InternalTaskVariableScopeResolver;
import flow.task.service.impl.persistence.entity.TaskEntity;
import flow.variable.service.impl.persistence.entity.VariableScopeImpl;

/**
 * @author Tijs Rademakers
 */
class DefaultTaskVariableScopeResolver implements InternalTaskVariableScopeResolver {

    protected ProcessEngineConfigurationImpl processEngineConfiguration;

    public DefaultTaskVariableScopeResolver(ProcessEngineConfigurationImpl processEngineConfiguration) {
        this.processEngineConfiguration = processEngineConfiguration;
    }

    override
    public VariableScopeImpl resolveParentVariableScope(TaskEntity task) {
        if (task.getExecutionId() !is null) {
            return (ExecutionEntityImpl) getExecutionEntityManager().findById(task.getExecutionId());
        }
        return null;
    }

    protected ExecutionEntityManager getExecutionEntityManager() {
        return processEngineConfiguration.getExecutionEntityManager();
    }
}
