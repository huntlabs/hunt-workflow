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
import flow.engine.history.HistoricProcessInstance;
import flow.engine.history.NativeHistoricProcessInstanceQuery;
import flow.engine.impl.util.CommandContextUtil;

class NativeHistoricProcessInstanceQueryImpl extends AbstractNativeQuery<NativeHistoricProcessInstanceQuery, HistoricProcessInstance> implements NativeHistoricProcessInstanceQuery {

    private static final long serialVersionUID = 1L;

    public NativeHistoricProcessInstanceQueryImpl(CommandContext commandContext) {
        super(commandContext);
    }

    public NativeHistoricProcessInstanceQueryImpl(CommandExecutor commandExecutor) {
        super(commandExecutor);
    }

    // results ////////////////////////////////////////////////////////////////

    @Override
    public List<HistoricProcessInstance> executeList(CommandContext commandContext, Map<string, Object> parameterMap) {
        return CommandContextUtil.getHistoricProcessInstanceEntityManager(commandContext).findHistoricProcessInstancesByNativeQuery(parameterMap);
    }

    @Override
    public long executeCount(CommandContext commandContext, Map<string, Object> parameterMap) {
        return CommandContextUtil.getHistoricProcessInstanceEntityManager(commandContext).findHistoricProcessInstanceCountByNativeQuery(parameterMap);
    }

}
