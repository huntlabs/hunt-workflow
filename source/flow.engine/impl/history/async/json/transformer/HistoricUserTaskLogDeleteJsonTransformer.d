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


import static org.flowable.job.service.impl.history.async.util.AsyncHistoryJsonUtil.getLongFromJson;

import java.util.Collections;
import java.util.List;

import flow.common.interceptor.CommandContext;
import flow.engine.impl.history.async.HistoryJsonConstants;
import flow.engine.impl.util.CommandContextUtil;
import org.flowable.job.service.impl.persistence.entity.HistoryJobEntity;

import com.fasterxml.jackson.databind.node.ObjectNode;

/**
 * @author martin.grofcik
 */
class HistoricUserTaskLogDeleteJsonTransformer extends AbstractHistoryJsonTransformer {

    @Override
    public List<string> getTypes() {
        return Collections.singletonList(HistoryJsonConstants.TYPE_HISTORIC_TASK_LOG_DELETE);
    }

    @Override
    public bool isApplicable(ObjectNode historicalData, CommandContext commandContext) {
        return true;
    }

    @Override
    public void transformJson(HistoryJobEntity job, ObjectNode historicalData, CommandContext commandContext) {
        Long logNumber = getLongFromJson(historicalData, HistoryJsonConstants.LOG_ENTRY_LOGNUMBER);
        if (logNumber != null) {
            CommandContextUtil.getHistoricTaskService().deleteHistoricTaskLogEntry(logNumber);
        }
    }
}
