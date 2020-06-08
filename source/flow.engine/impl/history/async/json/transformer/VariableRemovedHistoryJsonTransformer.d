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


import static flow.job.service.impl.history.async.util.AsyncHistoryJsonUtil.getStringFromJson;

import hunt.collections;
import hunt.collection.List;

import flow.common.interceptor.CommandContext;
import flow.engine.impl.history.async.HistoryJsonConstants;
import flow.engine.impl.util.CommandContextUtil;
import flow.job.service.impl.persistence.entity.HistoryJobEntity;
import flow.variable.service.HistoricVariableService;
import flow.variable.service.impl.persistence.entity.HistoricVariableInstanceEntity;

import com.fasterxml.jackson.databind.node.ObjectNode;

class VariableRemovedHistoryJsonTransformer : AbstractHistoryJsonTransformer {

    override
    public List!string getTypes() {
        return Collections.singletonList(HistoryJsonConstants.TYPE_VARIABLE_REMOVED);
    }

    override
    public bool isApplicable(ObjectNode historicalData, CommandContext commandContext) {
        return CommandContextUtil.getHistoricVariableService().getHistoricVariableInstance(getStringFromJson(historicalData, HistoryJsonConstants.ID)) !is null;
    }

    override
    public void transformJson(HistoryJobEntity job, ObjectNode historicalData, CommandContext commandContext) {
        HistoricVariableService historicVariableService = CommandContextUtil.getHistoricVariableService();
        HistoricVariableInstanceEntity historicVariable = historicVariableService.getHistoricVariableInstance(getStringFromJson(historicalData, HistoryJsonConstants.ID));

        if (historicVariable !is null) {
            historicVariableService.deleteHistoricVariableInstance(historicVariable);
        }
    }

}
