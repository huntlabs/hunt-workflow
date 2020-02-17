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


import java.util.List;
import java.util.Map;

import flow.common.query.AbstractNativeQuery;
import flow.common.interceptor.CommandContext;
import flow.common.interceptor.CommandExecutor;
import flow.engine.impl.util.CommandContextUtil;
import flow.engine.repository.Model;
import flow.engine.repository.NativeModelQuery;

class NativeModelQueryImpl extends AbstractNativeQuery<NativeModelQuery, Model> implements NativeModelQuery {

    private static final long serialVersionUID = 1L;

    public NativeModelQueryImpl(CommandContext commandContext) {
        super(commandContext);
    }

    public NativeModelQueryImpl(CommandExecutor commandExecutor) {
        super(commandExecutor);
    }

    // results ////////////////////////////////////////////////////////////////

    @Override
    public List<Model> executeList(CommandContext commandContext, Map<string, Object> parameterMap) {
        return CommandContextUtil.getModelEntityManager(commandContext).findModelsByNativeQuery(parameterMap);
    }

    @Override
    public long executeCount(CommandContext commandContext, Map<string, Object> parameterMap) {
        return CommandContextUtil.getModelEntityManager(commandContext).findModelCountByNativeQuery(parameterMap);
    }

}
