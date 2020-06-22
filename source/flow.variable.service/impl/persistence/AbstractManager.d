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

module flow.variable.service.impl.persistence.AbstractManager;

import flow.common.api.deleg.event.FlowableEventDispatcher;
import flow.common.context.Context;
import flow.common.interceptor.CommandContext;
import flow.common.runtime.Clockm;
import flow.variable.service.VariableServiceConfiguration;
import flow.variable.service.impl.persistence.entity.HistoricVariableInstanceEntityManager;
import flow.variable.service.impl.persistence.entity.VariableInstanceEntityManager;

/**
 * @author Tijs Rademakers
 */
abstract class AbstractManager {

    protected VariableServiceConfiguration variableServiceConfiguration;

    this(VariableServiceConfiguration variableServiceConfiguration) {
        this.variableServiceConfiguration = variableServiceConfiguration;
    }

    // Command scoped

    protected CommandContext getCommandContext() {
        return Context.getCommandContext();
    }

    //protected <T> T getSession(Class<T> sessionClass) {
    //    return getCommandContext().getSession(sessionClass);
    //}

    // Engine scoped

    protected VariableServiceConfiguration getVariableServiceConfiguration() {
        return variableServiceConfiguration;
    }

    protected Clockm getClock() {
        return getVariableServiceConfiguration().getClock();
    }

    protected FlowableEventDispatcher getEventDispatcher() {
        return getVariableServiceConfiguration().getEventDispatcher();
    }

    protected VariableInstanceEntityManager getVariableInstanceEntityManager() {
        return getVariableServiceConfiguration().getVariableInstanceEntityManager();
    }

    protected HistoricVariableInstanceEntityManager getHistoricVariableInstanceEntityManager() {
        return getVariableServiceConfiguration().getHistoricVariableInstanceEntityManager();
    }
}
