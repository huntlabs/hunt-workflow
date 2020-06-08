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



import java.io.Serializable;

import flow.common.api.FlowableIllegalArgumentException;
import flow.common.interceptor.Command;
import flow.common.interceptor.CommandContext;
import flow.engine.impl.HistoricProcessInstanceQueryImpl;
import flow.engine.impl.util.CommandContextUtil;

class DeleteHistoricProcessInstancesCmd implements Command!Object, Serializable {

    private static final long serialVersionUID = 1L;
    protected HistoricProcessInstanceQueryImpl historicProcessInstanceQuery;

    public DeleteHistoricProcessInstancesCmd(HistoricProcessInstanceQueryImpl historicProcessInstanceQuery) {
        this.historicProcessInstanceQuery = historicProcessInstanceQuery;
    }

    override
    public Object execute(CommandContext commandContext) {
        if (historicProcessInstanceQuery is null) {
            throw new FlowableIllegalArgumentException("query is null");
        }

        CommandContextUtil.getHistoricProcessInstanceEntityManager(commandContext).deleteHistoricProcessInstances(historicProcessInstanceQuery);

        return null;
    }

}
