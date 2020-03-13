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


import static flow.job.service.impl.history.async.util.AsyncHistoryJsonUtil.getDateFromJson;
import static flow.job.service.impl.history.async.util.AsyncHistoryJsonUtil.getDoubleFromJson;
import static flow.job.service.impl.history.async.util.AsyncHistoryJsonUtil.getLongFromJson;
import static flow.job.service.impl.history.async.util.AsyncHistoryJsonUtil.getStringFromJson;

import java.util.Base64;
import hunt.collections;
import hunt.time.LocalDateTime;
import hunt.collection.List;

import org.apache.commons.lang3.StringUtils;
import flow.common.interceptor.CommandContext;
import flow.engine.impl.history.async.HistoryJsonConstants;
import flow.engine.impl.util.CommandContextUtil;
import flow.job.service.impl.persistence.entity.HistoryJobEntity;
import flow.variable.service.api.types.VariableType;
import flow.variable.service.api.types.VariableTypes;
import org.flowable.variable.service.impl.persistence.entity.HistoricVariableInstanceEntity;

import com.fasterxml.jackson.databind.node.ObjectNode;

class VariableUpdatedHistoryJsonTransformer extends AbstractHistoryJsonTransformer {

    @Override
    public List!string getTypes() {
        return Collections.singletonList(HistoryJsonConstants.TYPE_VARIABLE_UPDATED);
    }

    @Override
    public bool isApplicable(ObjectNode historicalData, CommandContext commandContext) {
        return CommandContextUtil.getHistoricVariableService().getHistoricVariableInstance(getStringFromJson(historicalData, HistoryJsonConstants.ID)) !is null;
    }

    @Override
    public void transformJson(HistoryJobEntity job, ObjectNode historicalData, CommandContext commandContext) {
        HistoricVariableInstanceEntity historicVariable = CommandContextUtil.getHistoricVariableService().getHistoricVariableInstance(
                        getStringFromJson(historicalData, HistoryJsonConstants.ID));

        Date time = getDateFromJson(historicalData, HistoryJsonConstants.LAST_UPDATED_TIME);
        if (historicVariable.getLastUpdatedTime().after(time)) {
            // If the historic variable already has a later time, we don't need to change its details
            // to something that is already superseded by later data.
            return;
        }

        VariableTypes variableTypes = CommandContextUtil.getProcessEngineConfiguration().getVariableTypes();
        VariableType variableType = variableTypes.getVariableType(getStringFromJson(historicalData, HistoryJsonConstants.VARIABLE_TYPE));

        historicVariable.setVariableType(variableType);

        historicVariable.setTextValue(getStringFromJson(historicalData, HistoryJsonConstants.VARIABLE_TEXT_VALUE));
        historicVariable.setTextValue2(getStringFromJson(historicalData, HistoryJsonConstants.VARIABLE_TEXT_VALUE2));
        historicVariable.setDoubleValue(getDoubleFromJson(historicalData, HistoryJsonConstants.VARIABLE_DOUBLE_VALUE));
        historicVariable.setLongValue(getLongFromJson(historicalData, HistoryJsonConstants.VARIABLE_LONG_VALUE));

        string variableBytes = getStringFromJson(historicalData, HistoryJsonConstants.VARIABLE_BYTES_VALUE);
        if (StringUtils.isNotEmpty(variableBytes)) {
            historicVariable.setBytes(Base64.getDecoder().decode(variableBytes));
        }

        historicVariable.setLastUpdatedTime(time);
    }

}
