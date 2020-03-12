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

module flow.identitylink.service.impl.persistence.AbstractManager;

import flow.common.api.deleg.event.FlowableEventDispatcher;
import flow.common.context.Context;
import flow.common.interceptor.CommandContext;
import flow.common.runtime.Clock;
import flow.identitylink.service.IdentityLinkServiceConfiguration;
import flow.identitylink.service.impl.persistence.entity.HistoricIdentityLinkEntityManager;
import flow.identitylink.service.impl.persistence.entity.IdentityLinkEntityManager;

/**
 * @author Tijs Rademakers
 */
abstract class AbstractManager {

    protected IdentityLinkServiceConfiguration identityLinkServiceConfiguration;

    this(IdentityLinkServiceConfiguration identityLinkServiceConfiguration) {
        this.identityLinkServiceConfiguration = identityLinkServiceConfiguration;
    }

    // Command scoped

    protected CommandContext getCommandContext() {
        return Context.getCommandContext();
    }

    //protected <T> T getSession(Class<T> sessionClass) {
    //    return getCommandContext().getSession(sessionClass);
    //}

    // Engine scoped

    protected IdentityLinkServiceConfiguration getIdentityLinkServiceConfiguration() {
        return identityLinkServiceConfiguration;
    }

    protected Clock getClock() {
        return getIdentityLinkServiceConfiguration().getClock();
    }

    protected FlowableEventDispatcher getEventDispatcher() {
        return getIdentityLinkServiceConfiguration().getEventDispatcher();
    }

    protected IdentityLinkEntityManager getIdentityLinkEntityManager() {
        return getIdentityLinkServiceConfiguration().getIdentityLinkEntityManager();
    }

    protected HistoricIdentityLinkEntityManager getHistoricIdentityLinkEntityManager() {
        return getIdentityLinkServiceConfiguration().getHistoricIdentityLinkEntityManager();
    }
}
