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

module flow.identitylink.service.impl.util.CommandContextUtil;
import flow.common.context.Context;
//import flow.common.db.DbSqlSession;
import flow.common.interceptor.CommandContext;
import flow.common.interceptor.EngineConfigurationConstants;
import flow.identitylink.service.IdentityLinkServiceConfiguration;
import flow.identitylink.service.impl.persistence.entity.HistoricIdentityLinkEntityManager;
import flow.identitylink.service.impl.persistence.entity.IdentityLinkEntityManager;

class CommandContextUtil {

    public static IdentityLinkServiceConfiguration getIdentityLinkServiceConfiguration() {
        return getIdentityLinkServiceConfiguration(getCommandContext());
    }

    public static IdentityLinkServiceConfiguration getIdentityLinkServiceConfiguration(CommandContext commandContext) {
        if (commandContext !is null) {
            return cast(IdentityLinkServiceConfiguration) commandContext.getCurrentEngineConfiguration().getServiceConfigurations()
                            .get(EngineConfigurationConstants.KEY_IDENTITY_LINK_SERVICE_CONFIG);
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

    public static IdentityLinkEntityManager getIdentityLinkEntityManager() {
        return getIdentityLinkEntityManager(getCommandContext());
    }

    public static IdentityLinkEntityManager getIdentityLinkEntityManager(CommandContext commandContext) {
        return getIdentityLinkServiceConfiguration(commandContext).getIdentityLinkEntityManager();
    }

    public static HistoricIdentityLinkEntityManager getHistoricIdentityLinkEntityManager() {
        return getHistoricIdentityLinkEntityManager(getCommandContext());
    }

    public static HistoricIdentityLinkEntityManager getHistoricIdentityLinkEntityManager(CommandContext commandContext) {
        return getIdentityLinkServiceConfiguration(commandContext).getHistoricIdentityLinkEntityManager();
    }

    public static CommandContext getCommandContext() {
        return Context.getCommandContext();
    }

}
