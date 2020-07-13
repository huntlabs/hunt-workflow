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
//module flow.engine.impl.persistence.entity.data.impl.MybatisHistoricDetailDataManager;
//
//import hunt.collection.List;
//import hunt.collection.Map;
//
//import flow.engine.history.HistoricDetail;
//import flow.engine.impl.HistoricDetailQueryImpl;
//import flow.engine.impl.cfg.ProcessEngineConfigurationImpl;
//import flow.engine.impl.persistence.entity.HistoricDetailAssignmentEntity;
//import flow.engine.impl.persistence.entity.HistoricDetailAssignmentEntityImpl;
//import flow.engine.impl.persistence.entity.HistoricDetailEntity;
//import flow.engine.impl.persistence.entity.HistoricDetailEntityImpl;
//import flow.engine.impl.persistence.entity.HistoricDetailVariableInstanceUpdateEntity;
//import flow.engine.impl.persistence.entity.HistoricDetailVariableInstanceUpdateEntityImpl;
//import flow.engine.impl.persistence.entity.HistoricFormPropertyEntity;
//import flow.engine.impl.persistence.entity.HistoricFormPropertyEntityImpl;
//import flow.engine.impl.persistence.entity.data.AbstractProcessDataManager;
//import flow.engine.impl.persistence.entity.data.HistoricDetailDataManager;
//
///**
// * @author Joram Barrez
// */
//class MybatisHistoricDetailDataManager : AbstractProcessDataManager!HistoricDetailEntity implements HistoricDetailDataManager {
//
//    public MybatisHistoricDetailDataManager(ProcessEngineConfigurationImpl processEngineConfiguration) {
//        super(processEngineConfiguration);
//    }
//
//    override
//    class<? : HistoricDetailEntity> getManagedEntityClass() {
//        return HistoricDetailEntityImpl.class;
//    }
//
//    override
//    public HistoricDetailEntity create() {
//        // Superclass is abstract
//        throw new UnsupportedOperationException();
//    }
//
//    override
//    public HistoricDetailAssignmentEntity createHistoricDetailAssignment() {
//        return new HistoricDetailAssignmentEntityImpl();
//    }
//
//    override
//    public HistoricDetailVariableInstanceUpdateEntity createHistoricDetailVariableInstanceUpdate() {
//        return new HistoricDetailVariableInstanceUpdateEntityImpl();
//    }
//
//    override
//    public HistoricFormPropertyEntity createHistoricFormProperty() {
//        return new HistoricFormPropertyEntityImpl();
//    }
//
//    override
//    @SuppressWarnings("unchecked")
//    public List!HistoricDetailEntity findHistoricDetailsByProcessInstanceId(string processInstanceId) {
//        return getDbSqlSession().selectList("selectHistoricDetailByProcessInstanceId", processInstanceId);
//    }
//
//    override
//    @SuppressWarnings("unchecked")
//    public List!HistoricDetailEntity findHistoricDetailsByTaskId(string taskId) {
//        return getDbSqlSession().selectList("selectHistoricDetailByTaskId", taskId);
//    }
//
//    override
//    public long findHistoricDetailCountByQueryCriteria(HistoricDetailQueryImpl historicVariableUpdateQuery) {
//        return (Long) getDbSqlSession().selectOne("selectHistoricDetailCountByQueryCriteria", historicVariableUpdateQuery);
//    }
//
//    override
//    @SuppressWarnings("unchecked")
//    public List!HistoricDetail findHistoricDetailsByQueryCriteria(HistoricDetailQueryImpl historicVariableUpdateQuery) {
//        return getDbSqlSession().selectList("selectHistoricDetailsByQueryCriteria", historicVariableUpdateQuery);
//    }
//
//    override
//    @SuppressWarnings("unchecked")
//    public List!HistoricDetail findHistoricDetailsByNativeQuery(Map!(string, Object) parameterMap) {
//        return getDbSqlSession().selectListWithRawParameter("selectHistoricDetailByNativeQuery", parameterMap);
//    }
//
//    override
//    public long findHistoricDetailCountByNativeQuery(Map!(string, Object) parameterMap) {
//        return (Long) getDbSqlSession().selectOne("selectHistoricDetailCountByNativeQuery", parameterMap);
//    }
//
//    override
//    public void deleteHistoricDetailForNonExistingProcessInstances() {
//        getDbSqlSession().delete("bulkDeleteHistoricDetailForNonExistingProcessInstances", null, HistoricDetailEntity.class);
//    }
//}
