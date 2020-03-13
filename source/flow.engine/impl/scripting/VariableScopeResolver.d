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


import java.util.Arrays;
import hunt.collection.HashSet;
import hunt.collection.Set;

import flow.common.api.FlowableException;
import flow.common.api.FlowableIllegalArgumentException;
import flow.common.scripting.Resolver;
import flow.engine.impl.cfg.ProcessEngineConfigurationImpl;
import flow.engine.impl.persistence.entity.ExecutionEntity;
import org.flowable.task.service.impl.persistence.entity.TaskEntity;
import flow.variable.service.api.deleg.VariableScope;

/**
 * @author Tom Baeyens
 * @author Joram Barrez
 */
class VariableScopeResolver implements Resolver {

    protected ProcessEngineConfigurationImpl processEngineConfiguration;
    protected VariableScope variableScope;

    protected string variableScopeKey = "execution";

    protected static final string processEngineConfigurationKey = "processEngineConfiguration";
    protected static final string runtimeServiceKey = "runtimeService";
    protected static final string taskServiceKey = "taskService";
    protected static final string repositoryServiceKey = "repositoryService";
    protected static final string managementServiceKey = "managementService";
    protected static final string historyServiceKey = "historyService";
    protected static final string formServiceKey = "formService";
    protected static final string identityServiceKey = "identityServiceKey";

    protected static final Set!string KEYS = new HashSet<>(Arrays.asList(
        processEngineConfigurationKey, runtimeServiceKey, taskServiceKey,
        repositoryServiceKey, managementServiceKey, historyServiceKey, formServiceKey, identityServiceKey));

    public VariableScopeResolver(ProcessEngineConfigurationImpl processEngineConfiguration, VariableScope variableScope) {

        this.processEngineConfiguration = processEngineConfiguration;

        if (variableScope is null) {
            throw new FlowableIllegalArgumentException("variableScope cannot be null");
        }
        if (variableScope instanceof ExecutionEntity) {
            variableScopeKey = "execution";
        } else if (variableScope instanceof TaskEntity) {
            variableScopeKey = "task";
        } else {
            throw new FlowableException("unsupported variable scope type: " + variableScope.getClass().getName());
        }
        this.variableScope = variableScope;
    }

    @Override
    public bool containsKey(Object key) {
        return variableScopeKey.equals(key) || KEYS.contains(key) || variableScope.hasVariable((string) key);
    }

    @Override
    public Object get(Object key) {
        if (variableScopeKey.equals(key)) {
            return variableScope;
        } else if (processEngineConfigurationKey.equals(key)) {
            return processEngineConfiguration;
        } else if (runtimeServiceKey.equals(key)) {
            return processEngineConfiguration.getRuntimeService();
        } else if (taskServiceKey.equals(key)) {
            return processEngineConfiguration.getTaskService();
        } else if (repositoryServiceKey.equals(key)) {
            return processEngineConfiguration.getRepositoryService();
        } else if (managementServiceKey.equals(key)) {
            return processEngineConfiguration.getManagementService();
        } else if (formServiceKey.equals(key)) {
            return processEngineConfiguration.getFormService();
        } else if (identityServiceKey.equals(key)) {
            return processEngineConfiguration.getIdentityService();
        } else if (historyServiceKey.equals(key)) {
            return processEngineConfiguration.getHistoryService();
        }

        return variableScope.getVariable((string) key);
    }
}
