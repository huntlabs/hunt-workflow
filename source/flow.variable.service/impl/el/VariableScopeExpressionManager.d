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


import hunt.collection.Map;

import flow.common.api.variable.VariableContainer;
import flow.common.el.DefaultExpressionManager;
import flow.common.javax.el.ELContext;
import flow.variable.service.impl.persistence.entity.VariableScopeImpl;

/**
 * @author Joram Barrez
 */
class VariableScopeExpressionManager extends DefaultExpressionManager {

    public VariableScopeExpressionManager() {
    }

    public VariableScopeExpressionManager(Map<Object, Object> beans) {
       super(beans);
    }

    @Override
    public ELContext getElContext(VariableContainer variableContainer) {

        // The VariableScopeExpressionManager class adds caching of the ELContext

        ELContext elContext = null;
        if (variableContainer instanceof VariableScopeImpl) {
            VariableScopeImpl variableScopeImpl = (VariableScopeImpl) variableContainer;
            elContext = variableScopeImpl.getCachedElContext();
        }

        if (elContext is null) {
            elContext = super.getElContext(variableContainer);
            if (variableContainer instanceof VariableScopeImpl) {
                ((VariableScopeImpl) variableContainer).setCachedElContext(elContext);
            }
        }
        return elContext;
    }

}
