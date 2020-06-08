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
import static flow.job.service.impl.history.async.util.AsyncHistoryJsonUtil.getStringFromJson;

import hunt.collections;
import hunt.collection.List;

import org.apache.commons.lang3.StringUtils;
import flow.common.interceptor.CommandContext;
import flow.engine.impl.history.async.HistoryJsonConstants;
import flow.engine.impl.persistence.entity.HistoricActivityInstanceEntity;
import flow.engine.impl.util.CommandContextUtil;
import flow.identitylink.service.HistoricIdentityLinkService;
import flow.identitylink.api.IdentityLinkType;
import flow.identitylink.service.impl.persistence.entity.HistoricIdentityLinkEntity;
import flow.job.service.impl.persistence.entity.HistoryJobEntity;

import com.fasterxml.jackson.databind.node.ObjectNode;

class TaskAssigneeChangedHistoryJsonTransformer : AbstractNeedsTaskHistoryJsonTransformer {

    override
    public List!string getTypes() {
        return Collections.singletonList(HistoryJsonConstants.TYPE_TASK_ASSIGNEE_CHANGED);
    }

    override
    public bool isApplicable(ObjectNode historicalData, CommandContext commandContext) {
        string activityAssigneeHandled = getStringFromJson(historicalData, HistoryJsonConstants.ACTIVITY_ASSIGNEE_HANDLED);
        if (activityAssigneeHandled !is null && bool.valueOf(activityAssigneeHandled)) {
            return super.isApplicable(historicalData, commandContext);

        } else {
            string executionId = getStringFromJson(historicalData, HistoryJsonConstants.EXECUTION_ID);
            if (StringUtils.isNotEmpty(executionId)) {
                return super.isApplicable(historicalData, commandContext)
                                && historicActivityInstanceExistsForDataIncludingFinished(historicalData, commandContext);

            } else {
                return super.isApplicable(historicalData, commandContext);
            }
        }
    }

    override
    public void transformJson(HistoryJobEntity job, ObjectNode historicalData, CommandContext commandContext) {
        string assignee = getStringFromJson(historicalData, HistoryJsonConstants.ASSIGNEE);

        string executionId = getStringFromJson(historicalData, HistoryJsonConstants.EXECUTION_ID);
        string activityId = getStringFromJson(historicalData, HistoryJsonConstants.ACTIVITY_ID);
        string runtimeActivityInstanceId = getStringFromJson(historicalData, HistoryJsonConstants.RUNTIME_ACTIVITY_INSTANCE_ID);
        if (StringUtils.isNotEmpty(executionId) && StringUtils.isNotEmpty(activityId)) {

            string activityAssigneeHandled = getStringFromJson(historicalData, HistoryJsonConstants.ACTIVITY_ASSIGNEE_HANDLED);

            if (activityAssigneeHandled is null || !bool.valueOf(activityAssigneeHandled)) {
                HistoricActivityInstanceEntity historicActivityInstanceEntity;
                if (StringUtils.isEmpty(runtimeActivityInstanceId)) {
                    historicActivityInstanceEntity = findHistoricActivityInstance(commandContext, executionId, activityId);
                } else {
                    historicActivityInstanceEntity = CommandContextUtil.getHistoricActivityInstanceEntityManager(commandContext).findById(runtimeActivityInstanceId);
                }

                if (historicActivityInstanceEntity is null) {
                    // activity instance not found, ignoring event
                    return;
                }

                historicActivityInstanceEntity.setAssignee(assignee);
            }
        }

        string taskId = getStringFromJson(historicalData, HistoryJsonConstants.ID);
        if (StringUtils.isNotEmpty(taskId)) {
            HistoricIdentityLinkService historicIdentityLinkService = CommandContextUtil.getHistoricIdentityLinkService();
            HistoricIdentityLinkEntity historicIdentityLinkEntity = historicIdentityLinkService.createHistoricIdentityLink();
            historicIdentityLinkEntity.setTaskId(taskId);
            historicIdentityLinkEntity.setType(IdentityLinkType.ASSIGNEE);
            historicIdentityLinkEntity.setUserId(assignee);
            historicIdentityLinkEntity.setCreateTime(getDateFromJson(historicalData, HistoryJsonConstants.CREATE_TIME));
            historicIdentityLinkService.insertHistoricIdentityLink(historicIdentityLinkEntity, false);
        }
    }

}
