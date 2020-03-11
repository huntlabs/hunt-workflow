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

import hunt.collection.List;

import org.apache.commons.lang3.StringUtils;
import flow.common.api.deleg.event.FlowableEvent;
import flow.common.api.deleg.event.FlowableEventDispatcher;
import flow.common.interceptor.CommandContext;
import flow.engine.ProcessEngineConfiguration;
import flow.engine.impl.history.async.HistoryJsonConstants;
import flow.engine.impl.persistence.entity.HistoricActivityInstanceEntity;
import flow.engine.impl.persistence.entity.HistoricActivityInstanceEntityManager;
import flow.engine.impl.util.CommandContextUtil;
import org.flowable.job.service.impl.history.async.transformer.HistoryJsonTransformer;

import com.fasterxml.jackson.databind.node.ObjectNode;

abstract class AbstractHistoryJsonTransformer implements HistoryJsonTransformer {

    protected void dispatchEvent(CommandContext commandContext, FlowableEvent event) {
        FlowableEventDispatcher eventDispatcher = CommandContextUtil.getProcessEngineConfiguration(commandContext).getEventDispatcher();
        if (eventDispatcher !is null && eventDispatcher.isEnabled()) {
            eventDispatcher.dispatchEvent(event);
        }
    }

    public bool historicActivityInstanceExistsForData(ObjectNode historicalData, CommandContext commandContext) {
        string runtimeActivityInstanceId = getStringFromJson(historicalData, HistoryJsonConstants.RUNTIME_ACTIVITY_INSTANCE_ID);
        if (runtimeActivityInstanceId !is null) {
            return CommandContextUtil.getHistoricActivityInstanceEntityManager(commandContext).findById(runtimeActivityInstanceId) !is null;
        } else {
            string executionId = getStringFromJson(historicalData, HistoryJsonConstants.EXECUTION_ID);
            if (StringUtils.isNotEmpty(executionId)) {
                string activityId = getStringFromJson(historicalData, HistoryJsonConstants.ACTIVITY_ID);

                if (StringUtils.isNotEmpty(activityId)) {
                    HistoricActivityInstanceEntity historicActivityInstanceEntity = findUnfinishedHistoricActivityInstance(commandContext, executionId,
                        activityId);
                    return historicActivityInstanceEntity !is null;
                }
            }
        }
        return false;
    }

    public bool historicActivityInstanceExistsForDataIncludingFinished(ObjectNode historicalData, CommandContext commandContext) {
        string runtimeActivityInstanceId = getStringFromJson(historicalData, HistoryJsonConstants.RUNTIME_ACTIVITY_INSTANCE_ID);
        if (StringUtils.isNotEmpty(runtimeActivityInstanceId)) {
            HistoricActivityInstanceEntity historicActivityInstanceEntity = CommandContextUtil.getHistoricActivityInstanceEntityManager(commandContext).findById(runtimeActivityInstanceId);
            return historicActivityInstanceEntity !is null;
        } else {
            string executionId = getStringFromJson(historicalData, HistoryJsonConstants.EXECUTION_ID);
            if (StringUtils.isNotEmpty(executionId)) {
                string activityId = getStringFromJson(historicalData, HistoryJsonConstants.ACTIVITY_ID);

                if (StringUtils.isNotEmpty(activityId)) {
                    HistoricActivityInstanceEntity historicActivityInstanceEntity = findHistoricActivityInstance(commandContext, executionId, activityId);
                    return historicActivityInstanceEntity !is null;
                }
            }
            return false;
        }
    }

    protected HistoricActivityInstanceEntity findUnfinishedHistoricActivityInstance(CommandContext commandContext, string executionId, string activityId) {
        if (executionId is null || activityId is null) {
            return null;
        }

        HistoricActivityInstanceEntity historicActivityInstanceEntity = getUnfinishedHistoricActivityInstanceFromCache(commandContext, executionId, activityId);
        if (historicActivityInstanceEntity is null) {
            List<HistoricActivityInstanceEntity> historicActivityInstances = CommandContextUtil.getHistoricActivityInstanceEntityManager(commandContext)
                            .findUnfinishedHistoricActivityInstancesByExecutionAndActivityId(executionId, activityId);
            if (!historicActivityInstances.isEmpty()) {
                historicActivityInstanceEntity = historicActivityInstances.get(0);
            }
        }
        return historicActivityInstanceEntity;
    }

    protected HistoricActivityInstanceEntity getUnfinishedHistoricActivityInstanceFromCache(CommandContext commandContext,
                    string executionId, string activityId) {

        List<HistoricActivityInstanceEntity> cachedHistoricActivityInstances = CommandContextUtil.getEntityCache(commandContext).findInCache(HistoricActivityInstanceEntity.class);
        for (HistoricActivityInstanceEntity cachedHistoricActivityInstance : cachedHistoricActivityInstances) {
            if (activityId !is null
                            && activityId.equals(cachedHistoricActivityInstance.getActivityId())
                            && cachedHistoricActivityInstance.getEndTime() is null
                            && executionId.equals(cachedHistoricActivityInstance.getExecutionId())) {

                return cachedHistoricActivityInstance;
            }
        }
        return null;
    }

    protected HistoricActivityInstanceEntity findHistoricActivityInstance(CommandContext commandContext, string executionId, string activityId) {
        if (executionId is null || activityId is null) {
            return null;
        }

        HistoricActivityInstanceEntity historicActivityInstanceEntity = getHistoricActivityInstanceFromCache(commandContext, executionId, activityId);
        if (historicActivityInstanceEntity is null) {
            List<HistoricActivityInstanceEntity> historicActivityInstances = CommandContextUtil.getHistoricActivityInstanceEntityManager(commandContext)
                            .findHistoricActivityInstancesByExecutionAndActivityId(executionId, activityId);
            if (!historicActivityInstances.isEmpty()) {
                historicActivityInstanceEntity = historicActivityInstances.get(0);
            }
        }
        return historicActivityInstanceEntity;
    }

    protected HistoricActivityInstanceEntity getHistoricActivityInstanceFromCache(CommandContext commandContext,
                    string executionId, string activityId) {

        List<HistoricActivityInstanceEntity> cachedHistoricActivityInstances = CommandContextUtil.getEntityCache(commandContext).findInCache(HistoricActivityInstanceEntity.class);
        for (HistoricActivityInstanceEntity cachedHistoricActivityInstance : cachedHistoricActivityInstances) {
            if (activityId !is null
                            && activityId.equals(cachedHistoricActivityInstance.getActivityId())
                            && executionId.equals(cachedHistoricActivityInstance.getExecutionId())) {

                return cachedHistoricActivityInstance;
            }
        }
        return null;
    }

    protected HistoricActivityInstanceEntity createHistoricActivityInstanceEntity(ObjectNode historicalData, CommandContext commandContext,
        HistoricActivityInstanceEntityManager historicActivityInstanceEntityManager) {
        string runtimeActivityId = getStringFromJson(historicalData, HistoryJsonConstants.RUNTIME_ACTIVITY_INSTANCE_ID);
        HistoricActivityInstanceEntity historicActivityInstanceEntity = historicActivityInstanceEntityManager.create();
        if (StringUtils.isEmpty(runtimeActivityId)) {
            ProcessEngineConfiguration processEngineConfiguration = CommandContextUtil.getProcessEngineConfiguration(commandContext);
            if (processEngineConfiguration.isUsePrefixId()) {
                historicActivityInstanceEntity.setId(historicActivityInstanceEntity.getIdPrefix() + processEngineConfiguration.getIdGenerator().getNextId());
            } else {
                historicActivityInstanceEntity.setId(processEngineConfiguration.getIdGenerator().getNextId());
            }
        } else {
            historicActivityInstanceEntity.setId(runtimeActivityId);
        }
        return historicActivityInstanceEntity;
    }

}
