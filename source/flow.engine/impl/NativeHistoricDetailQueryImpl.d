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


import hunt.collection.List;
import hunt.collection.Map;

import flow.common.query.AbstractNativeQuery;
import flow.common.interceptor.CommandContext;
import flow.common.interceptor.CommandExecutor;
import flow.engine.history.HistoricDetail;
import flow.engine.history.NativeHistoricDetailQuery;
import flow.engine.impl.util.CommandContextUtil;

class NativeHistoricDetailQueryImpl : AbstractNativeQuery!(NativeHistoricDetailQuery, HistoricDetail) implements NativeHistoricDetailQuery {

    private static final long serialVersionUID = 1L;

    public NativeHistoricDetailQueryImpl(CommandContext commandContext) {
        super(commandContext);
    }

    public NativeHistoricDetailQueryImpl(CommandExecutor commandExecutor) {
        super(commandExecutor);
    }

    // results ////////////////////////////////////////////////////////////////

    override
    public List!HistoricDetail executeList(CommandContext commandContext, Map!(string, Object) parameterMap) {
        return CommandContextUtil.getHistoricDetailEntityManager(commandContext).findHistoricDetailsByNativeQuery(parameterMap);
    }

    override
    public long executeCount(CommandContext commandContext, Map!(string, Object) parameterMap) {
        return CommandContextUtil.getHistoricDetailEntityManager(commandContext).findHistoricDetailCountByNativeQuery(parameterMap);
    }

}
