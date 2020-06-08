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

import flow.common.interceptor.CommandContext;
import flow.engine.impl.history.async.HistoryJsonConstants;
import flow.engine.impl.util.CommandContextUtil;
import flow.entitylink.service.api.history.HistoricEntityLinkService;
import org.flowable.entitylink.service.impl.persistence.entity.HistoricEntityLinkEntity;
import flow.job.service.impl.persistence.entity.HistoryJobEntity;

import com.fasterxml.jackson.databind.node.ObjectNode;

class EntityLinkCreatedHistoryJsonTransformer : AbstractHistoryJsonTransformer {

    override
    public List!string getTypes() {
        return Collections.singletonList(HistoryJsonConstants.TYPE_ENTITY_LINK_CREATED);
    }

    override
    public bool isApplicable(ObjectNode historicalData, CommandContext commandContext) {
        return true;
    }

    override
    public void transformJson(HistoryJobEntity job, ObjectNode historicalData, CommandContext commandContext) {
        HistoricEntityLinkService historicEntityLinkService = CommandContextUtil.getHistoricEntityLinkService();
        HistoricEntityLinkEntity historicEntityLinkEntity = (HistoricEntityLinkEntity) historicEntityLinkService.createHistoricEntityLink();
        historicEntityLinkEntity.setId(getStringFromJson(historicalData, HistoryJsonConstants.ID));
        historicEntityLinkEntity.setLinkType(getStringFromJson(historicalData, HistoryJsonConstants.ENTITY_LINK_TYPE));
        historicEntityLinkEntity.setCreateTime(getDateFromJson(historicalData, HistoryJsonConstants.CREATE_TIME));
        historicEntityLinkEntity.setScopeId(getStringFromJson(historicalData, HistoryJsonConstants.SCOPE_ID));
        historicEntityLinkEntity.setScopeType(getStringFromJson(historicalData, HistoryJsonConstants.SCOPE_TYPE));
        historicEntityLinkEntity.setScopeDefinitionId(getStringFromJson(historicalData, HistoryJsonConstants.SCOPE_DEFINITION_ID));
        historicEntityLinkEntity.setReferenceScopeId(getStringFromJson(historicalData, HistoryJsonConstants.REF_SCOPE_ID));
        historicEntityLinkEntity.setReferenceScopeType(getStringFromJson(historicalData, HistoryJsonConstants.REF_SCOPE_TYPE));
        historicEntityLinkEntity.setReferenceScopeDefinitionId(getStringFromJson(historicalData, HistoryJsonConstants.REF_SCOPE_DEFINITION_ID));
        historicEntityLinkEntity.setHierarchyType(getStringFromJson(historicalData, HistoryJsonConstants.HIERARCHY_TYPE));
        historicEntityLinkService.insertHistoricEntityLink(historicEntityLinkEntity, false);
    }

}
