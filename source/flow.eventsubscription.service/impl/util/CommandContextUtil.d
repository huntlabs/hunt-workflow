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
module flow.eventsubscription.service.impl.util.CommandContextUtil;

import flow.common.context.Context;
import flow.common.db.DbSqlSession;
import flow.common.interceptor.CommandContext;
import flow.common.interceptor.EngineConfigurationConstants;
import flow.eventsubscription.service.EventSubscriptionServiceConfiguration;
import flow.eventsubscription.service.impl.persistence.entity.EventSubscriptionEntityManager;

class CommandContextUtil {

    public static EventSubscriptionServiceConfiguration getEventSubscriptionServiceConfiguration() {
        return getEventSubscriptionServiceConfiguration(getCommandContext());
    }

    public static EventSubscriptionServiceConfiguration getEventSubscriptionServiceConfiguration(CommandContext commandContext) {
        if (commandContext !is null) {
            return cast(EventSubscriptionServiceConfiguration) commandContext.getCurrentEngineConfiguration()
                            .getServiceConfigurations().get(EngineConfigurationConstants.KEY_EVENT_SUBSCRIPTION_SERVICE_CONFIG);
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

    public static EventSubscriptionEntityManager getEventSubscriptionEntityManager() {
        return getEventSubscriptionEntityManager(getCommandContext());
    }

    public static EventSubscriptionEntityManager getEventSubscriptionEntityManager(CommandContext commandContext) {
        return getEventSubscriptionServiceConfiguration(commandContext).getEventSubscriptionEntityManager();
    }

    public static CommandContext getCommandContext() {
        return Context.getCommandContext();
    }

}
