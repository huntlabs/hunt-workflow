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

module flow.batch.service.impl.util.CommandContextUtil;

import flow.batch.service.BatchServiceConfiguration;
import flow.batch.service.impl.persistence.entity.BatchByteArrayEntityManager;
import flow.batch.service.impl.persistence.entity.BatchEntityManager;
import flow.batch.service.impl.persistence.entity.BatchPartEntityManager;
import flow.common.context.Context;
import flow.common.db.DbSqlSession;
import flow.common.interceptor.CommandContext;
import flow.common.interceptor.EngineConfigurationConstants;

class CommandContextUtil {

    public static BatchServiceConfiguration getBatchServiceConfiguration() {
        return getBatchServiceConfiguration(getCommandContext());
    }

    public static BatchServiceConfiguration getBatchServiceConfiguration(CommandContext commandContext) {
        if (commandContext !is null) {
            return cast(BatchServiceConfiguration) commandContext.getCurrentEngineConfiguration().getServiceConfigurations()
                            .get(EngineConfigurationConstants.KEY_BATCH_SERVICE_CONFIG);
        }
        return null;
    }

    //public static DbSqlSession getDbSqlSession() {
    //    return getDbSqlSession(getCommandContext());
    //}
    //
    //public static DbSqlSession getDbSqlSession(CommandContext commandContext) {
    //    return commandContext.getSession(DbSqlSession.class);
    //}

    public static BatchEntityManager getBatchEntityManager() {
        return getBatchEntityManager(getCommandContext());
    }

    public static BatchEntityManager getBatchEntityManager(CommandContext commandContext) {
        return getBatchServiceConfiguration(commandContext).getBatchEntityManager();
    }

    public static BatchPartEntityManager getBatchPartEntityManager() {
        return getBatchPartEntityManager(getCommandContext());
    }

    public static BatchPartEntityManager getBatchPartEntityManager(CommandContext commandContext) {
        return getBatchServiceConfiguration(commandContext).getBatchPartEntityManager();
    }

    public static BatchByteArrayEntityManager getBatchByteArrayEntityManager() {
        return getBatchByteArrayEntityManager(getCommandContext());
    }

    public static BatchByteArrayEntityManager getBatchByteArrayEntityManager(CommandContext commandContext) {
        return getBatchServiceConfiguration(commandContext).getBatchByteArrayEntityManager();
    }

    public static CommandContext getCommandContext() {
        return Context.getCommandContext();
    }

}
