///* Licensed under the Apache License, Version 2.0 (the "License");
// * you may not use this file except in compliance with the License.
// * You may obtain a copy of the License at
// *
// *      http://www.apache.org/licenses/LICENSE-2.0
// *
// * Unless required by applicable law or agreed to in writing, software
// * distributed under the License is distributed on an "AS IS" BASIS,
// * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// * See the License for the specific language governing permissions and
// * limitations under the License.
// */
//
//module flow.engine.impl.persistence.entity.HistoricDetailEntityManagerImpl;
//
//import hunt.time.LocalDateTime;
//import hunt.collection.List;
//import hunt.collection.Map;
//
//import flow.common.api.FlowableException;
//import flow.common.history.HistoryLevel;
//import flow.engine.history.HistoricDetail;
//import flow.engine.impl.HistoricDetailQueryImpl;
//import flow.engine.impl.cfg.ProcessEngineConfigurationImpl;
//import flow.engine.impl.history.HistoryManager;
//import flow.engine.impl.persistence.entity.data.HistoricDetailDataManager;
//import flow.variable.service.impl.persistence.entity.VariableInstanceEntity;
//import flow.engine.impl.persistence.entity.AbstractProcessEngineEntityManager;
//import flow.engine.impl.persistence.entity.HistoricDetailEntityManager;
//import flow.engine.impl.persistence.entity.HistoricDetailEntity;
//import flow.engine.impl.persistence.entity.ExecutionEntity;
//import flow.engine.impl.persistence.entity.HistoricFormPropertyEntity;
//import flow.engine.impl.persistence.entity.ActivityInstanceEntity;
//import flow.engine.impl.persistence.entity.HistoricDetailVariableInstanceUpdateEntity;
///**
// * @author Tom Baeyens
// * @author Joram Barrez
// */
//class HistoricDetailEntityManagerImpl
//    : AbstractProcessEngineEntityManager!(HistoricDetailEntity, HistoricDetailDataManager)
//    , HistoricDetailEntityManager {
//
//    this(ProcessEngineConfigurationImpl processEngineConfiguration, HistoricDetailDataManager historicDetailDataManager) {
//        super(processEngineConfiguration, historicDetailDataManager);
//    }
//
//    public HistoricFormPropertyEntity insertHistoricFormPropertyEntity(ExecutionEntity execution,
//        string propertyId, string propertyValue, string taskId, Date createTime) {
//
//        HistoricFormPropertyEntity historicFormPropertyEntity = dataManager.createHistoricFormProperty();
//        historicFormPropertyEntity.setProcessInstanceId(execution.getProcessInstanceId());
//        historicFormPropertyEntity.setExecutionId(execution.getId());
//        historicFormPropertyEntity.setTaskId(taskId);
//        historicFormPropertyEntity.setPropertyId(propertyId);
//        historicFormPropertyEntity.setPropertyValue(propertyValue);
//        historicFormPropertyEntity.setTime(createTime);
//
//        ActivityInstanceEntity activityInstance = getActivityInstanceEntityManager().findUnfinishedActivityInstance(execution);
//        string activityInstanceId;
//        if (activityInstance !is null) {
//            activityInstanceId = activityInstance.getId();
//        } else {
//            throw new FlowableException("ActivityInstance not found for execution " ~ execution.getId());
//        }
//        historicFormPropertyEntity.setActivityInstanceId(activityInstanceId);
//
//        insert(historicFormPropertyEntity);
//        return historicFormPropertyEntity;
//    }
//
//
//    public HistoricDetailVariableInstanceUpdateEntity copyAndInsertHistoricDetailVariableInstanceUpdateEntity(VariableInstanceEntity variableInstance,
//        Date createTime) {
//        HistoricDetailVariableInstanceUpdateEntity historicVariableUpdate = dataManager.createHistoricDetailVariableInstanceUpdate();
//        historicVariableUpdate.setProcessInstanceId(variableInstance.getProcessInstanceId());
//        historicVariableUpdate.setExecutionId(variableInstance.getExecutionId());
//        historicVariableUpdate.setTaskId(variableInstance.getTaskId());
//        historicVariableUpdate.setTime(createTime);
//        historicVariableUpdate.setRevision(variableInstance.getRevision());
//        historicVariableUpdate.setName(variableInstance.getName());
//        historicVariableUpdate.setVariableType(variableInstance.getType());
//        historicVariableUpdate.setTextValue(variableInstance.getTextValue());
//        historicVariableUpdate.setTextValue2(variableInstance.getTextValue2());
//        historicVariableUpdate.setDoubleValue(variableInstance.getDoubleValue());
//        historicVariableUpdate.setLongValue(variableInstance.getLongValue());
//
//        if (variableInstance.getBytes() !is null) {
//            historicVariableUpdate.setBytes(variableInstance.getBytes());
//        }
//
//        insert(historicVariableUpdate);
//        return historicVariableUpdate;
//    }
//
//    override
//    public void delete(HistoricDetailEntity entity, bool fireDeleteEvent) {
//        super.delete(entity, fireDeleteEvent);
//
//        if (entity instanceof HistoricDetailVariableInstanceUpdateEntity) {
//            HistoricDetailVariableInstanceUpdateEntity historicDetailVariableInstanceUpdateEntity = ((HistoricDetailVariableInstanceUpdateEntity) entity);
//            if (historicDetailVariableInstanceUpdateEntity.getByteArrayRef() !is null) {
//                historicDetailVariableInstanceUpdateEntity.getByteArrayRef().delete();
//            }
//        }
//    }
//
//    override
//    public void deleteHistoricDetailsByProcessInstanceId(string historicProcessInstanceId) {
//        if (getHistoryManager().isHistoryLevelAtLeast(HistoryLevel.AUDIT)) {
//            List!HistoricDetailEntity historicDetails = dataManager.findHistoricDetailsByProcessInstanceId(historicProcessInstanceId);
//
//            for (HistoricDetailEntity historicDetail : historicDetails) {
//                delete(historicDetail);
//            }
//        }
//    }
//
//    override
//    public long findHistoricDetailCountByQueryCriteria(HistoricDetailQueryImpl historicVariableUpdateQuery) {
//        return dataManager.findHistoricDetailCountByQueryCriteria(historicVariableUpdateQuery);
//    }
//
//    override
//    public List!HistoricDetail findHistoricDetailsByQueryCriteria(HistoricDetailQueryImpl historicVariableUpdateQuery) {
//        return dataManager.findHistoricDetailsByQueryCriteria(historicVariableUpdateQuery);
//    }
//
//    override
//    public void deleteHistoricDetailsByTaskId(string taskId) {
//        if (getHistoryManager().isHistoryLevelAtLeast(HistoryLevel.FULL)) {
//            List!HistoricDetailEntity details = dataManager.findHistoricDetailsByTaskId(taskId);
//            for (HistoricDetail detail : details) {
//                delete((HistoricDetailEntity) detail);
//            }
//        }
//    }
//
//    override
//    public void deleteHistoricDetailForNonExistingProcessInstances() {
//        dataManager.deleteHistoricDetailForNonExistingProcessInstances();
//    }
//
//    override
//    public List!HistoricDetail findHistoricDetailsByNativeQuery(Map!(string, Object) parameterMap) {
//        return dataManager.findHistoricDetailsByNativeQuery(parameterMap);
//    }
//
//    override
//    public long findHistoricDetailCountByNativeQuery(Map!(string, Object) parameterMap) {
//        return dataManager.findHistoricDetailCountByNativeQuery(parameterMap);
//    }
//
//    protected ActivityInstanceEntityManager getActivityInstanceEntityManager() {
//        return engineConfiguration.getActivityInstanceEntityManager();
//    }
//
//    protected HistoryManager getHistoryManager() {
//        return engineConfiguration.getHistoryManager();
//    }
//
//}
