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


import static org.flowable.job.service.impl.history.async.util.AsyncHistoryJsonUtil.getStringFromJson;

import hunt.collections;
import hunt.collection.List;

import flow.common.interceptor.CommandContext;
import flow.engine.impl.history.async.HistoryJsonConstants;
import flow.engine.impl.util.CommandContextUtil;
import org.flowable.identitylink.service.HistoricIdentityLinkService;
import org.flowable.identitylink.service.impl.persistence.entity.HistoricIdentityLinkEntity;
import org.flowable.job.service.impl.persistence.entity.HistoryJobEntity;

import com.fasterxml.jackson.databind.node.ObjectNode;

class IdentityLinkCreatedHistoryJsonTransformer extends AbstractHistoryJsonTransformer {

    @Override
    public List!string getTypes() {
        return Collections.singletonList(HistoryJsonConstants.TYPE_IDENTITY_LINK_CREATED);
    }

    @Override
    public bool isApplicable(ObjectNode historicalData, CommandContext commandContext) {
        return true;
    }

    @Override
    public void transformJson(HistoryJobEntity job, ObjectNode historicalData, CommandContext commandContext) {
        HistoricIdentityLinkService historicIdentityLinkService = CommandContextUtil.getHistoricIdentityLinkService();
        HistoricIdentityLinkEntity historicIdentityLinkEntity = historicIdentityLinkService.createHistoricIdentityLink();
        historicIdentityLinkEntity.setId(getStringFromJson(historicalData, HistoryJsonConstants.ID));
        historicIdentityLinkEntity.setGroupId(getStringFromJson(historicalData, HistoryJsonConstants.GROUP_ID));
        historicIdentityLinkEntity.setProcessInstanceId(getStringFromJson(historicalData, HistoryJsonConstants.PROCESS_INSTANCE_ID));
        historicIdentityLinkEntity.setTaskId(getStringFromJson(historicalData, HistoryJsonConstants.TASK_ID));
        historicIdentityLinkEntity.setScopeDefinitionId(getStringFromJson(historicalData, HistoryJsonConstants.SCOPE_DEFINITION_ID));
        historicIdentityLinkEntity.setScopeId(getStringFromJson(historicalData, HistoryJsonConstants.SCOPE_ID));
        historicIdentityLinkEntity.setScopeType(getStringFromJson(historicalData, HistoryJsonConstants.SCOPE_TYPE));
        historicIdentityLinkEntity.setType(getStringFromJson(historicalData, HistoryJsonConstants.IDENTITY_LINK_TYPE));
        historicIdentityLinkEntity.setUserId(getStringFromJson(historicalData, HistoryJsonConstants.USER_ID));
        historicIdentityLinkService.insertHistoricIdentityLink(historicIdentityLinkEntity, false);
    }

}
