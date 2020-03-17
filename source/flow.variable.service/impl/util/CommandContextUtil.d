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


import flow.common.api.FlowableException;
import flow.common.AbstractEngineConfiguration;
import flow.common.HasExpressionManagerEngineConfiguration;
import flow.common.context.Context;
import flow.common.db.DbSqlSession;
import flow.common.el.ExpressionManager;
import flow.common.interceptor.CommandContext;
import flow.common.interceptor.EngineConfigurationConstants;
import flow.variable.service.VariableServiceConfiguration;
import flow.variable.service.impl.persistence.entity.HistoricVariableInstanceEntityManager;
import flow.variable.service.impl.persistence.entity.VariableByteArrayEntityManager;
import flow.variable.service.impl.persistence.entity.VariableInstanceEntityManager;

class CommandContextUtil {

    public static VariableServiceConfiguration getVariableServiceConfiguration() {
        return getVariableServiceConfiguration(getCommandContext());
    }

    public static VariableServiceConfiguration getVariableServiceConfiguration(CommandContext commandContext) {
        if (commandContext !is null) {
            return (VariableServiceConfiguration) commandContext.getCurrentEngineConfiguration().getServiceConfigurations()
                            .get(EngineConfigurationConstants.KEY_VARIABLE_SERVICE_CONFIG);
        }
        return null;
    }

    public static DbSqlSession getDbSqlSession() {
        return getDbSqlSession(getCommandContext());
    }

    public static DbSqlSession getDbSqlSession(CommandContext commandContext) {
        return commandContext.getSession(DbSqlSession.class);
    }

    public static VariableInstanceEntityManager getVariableInstanceEntityManager() {
        return getVariableInstanceEntityManager(getCommandContext());
    }

    public static VariableInstanceEntityManager getVariableInstanceEntityManager(CommandContext commandContext) {
        return getVariableServiceConfiguration(commandContext).getVariableInstanceEntityManager();
    }

    public static VariableByteArrayEntityManager getByteArrayEntityManager() {
        return getByteArrayEntityManager(getCommandContext());
    }

    public static VariableByteArrayEntityManager getByteArrayEntityManager(CommandContext commandContext) {
        return getVariableServiceConfiguration(commandContext).getByteArrayEntityManager();
    }

    public static HistoricVariableInstanceEntityManager getHistoricVariableInstanceEntityManager() {
        return getHistoricVariableInstanceEntityManager(getCommandContext());
    }

    public static HistoricVariableInstanceEntityManager getHistoricVariableInstanceEntityManager(CommandContext commandContext) {
        return getVariableServiceConfiguration(commandContext).getHistoricVariableInstanceEntityManager();
    }

    public static CommandContext getCommandContext() {
        return Context.getCommandContext();
    }

    public static ExpressionManager getExpressionManager() {
        AbstractEngineConfiguration currentEngineConfiguration = getCommandContext().getCurrentEngineConfiguration();
        if (currentEngineConfiguration instanceof HasExpressionManagerEngineConfiguration) {
            return ((HasExpressionManagerEngineConfiguration) currentEngineConfiguration).getExpressionManager();
        }
        throw new FlowableException("Unable to obtain expression manager from the current engine configuration: " + currentEngineConfiguration);
    }
}
