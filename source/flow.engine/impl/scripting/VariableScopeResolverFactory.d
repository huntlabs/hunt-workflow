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


import flow.common.AbstractEngineConfiguration;
import flow.common.scripting.Resolver;
import flow.common.scripting.ResolverFactory;
import flow.engine.impl.cfg.ProcessEngineConfigurationImpl;
import flow.variable.service.api.deleg.VariableScope;

/**
 * @author Tom Baeyens
 * @author Joram Barrez
 */
class VariableScopeResolverFactory implements ResolverFactory {

    override
    public Resolver createResolver(AbstractEngineConfiguration engineConfiguration, VariableScope variableScope) {
        if (variableScope !is null) {
            return new VariableScopeResolver((ProcessEngineConfigurationImpl) engineConfiguration, variableScope);
        }
        return null;
    }

}
