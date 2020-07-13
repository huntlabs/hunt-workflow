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
//
//import hunt.collection.List;
//
//import flow.engine.impl.cfg.ProcessEngineConfigurationImpl;
//import flow.engine.impl.persistence.entity.AttachmentEntity;
//import flow.engine.impl.persistence.entity.AttachmentEntityImpl;
//import flow.engine.impl.persistence.entity.data.AbstractProcessDataManager;
//import flow.engine.impl.persistence.entity.data.AttachmentDataManager;
//
///**
// * @author Joram Barrez
// */
//class MybatisAttachmentDataManager : AbstractProcessDataManager!AttachmentEntity implements AttachmentDataManager {
//
//    public MybatisAttachmentDataManager(ProcessEngineConfigurationImpl processEngineConfiguration) {
//        super(processEngineConfiguration);
//    }
//
//    override
//    class<? : AttachmentEntity> getManagedEntityClass() {
//        return AttachmentEntityImpl.class;
//    }
//
//    override
//    public AttachmentEntity create() {
//        return new AttachmentEntityImpl();
//    }
//
//    override
//    @SuppressWarnings("unchecked")
//    public List!AttachmentEntity findAttachmentsByProcessInstanceId(string processInstanceId) {
//        return getDbSqlSession().selectList("selectAttachmentsByProcessInstanceId", processInstanceId);
//    }
//
//    override
//    @SuppressWarnings("unchecked")
//    public List!AttachmentEntity findAttachmentsByTaskId(string taskId) {
//        return getDbSqlSession().selectList("selectAttachmentsByTaskId", taskId);
//    }
//
//}
