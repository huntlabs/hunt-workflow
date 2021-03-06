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
//module flow.engine.impl.persistence.entity.data.impl.MybatisCommentDataManager;
//
//import hunt.collection.HashMap;
//import hunt.collection.List;
//import hunt.collection.Map;
//
//import flow.engine.impl.cfg.ProcessEngineConfigurationImpl;
//import flow.engine.impl.persistence.entity.CommentEntity;
//import flow.engine.impl.persistence.entity.CommentEntityImpl;
//import flow.engine.impl.persistence.entity.data.AbstractProcessDataManager;
//import flow.engine.impl.persistence.entity.data.CommentDataManager;
//import flow.engine.task.Comment;
//import flow.engine.task.Event;
//
///**
// * @author Joram Barrez
// */
//class MybatisCommentDataManager : AbstractProcessDataManager!CommentEntity implements CommentDataManager {
//
//    public MybatisCommentDataManager(ProcessEngineConfigurationImpl processEngineConfiguration) {
//        super(processEngineConfiguration);
//    }
//
//    override
//    class<? : CommentEntity> getManagedEntityClass() {
//        return CommentEntityImpl.class;
//    }
//
//    override
//    public CommentEntity create() {
//        return new CommentEntityImpl();
//    }
//
//    override
//    @SuppressWarnings("unchecked")
//    public List!Comment findCommentsByTaskId(string taskId) {
//        return getDbSqlSession().selectList("selectCommentsByTaskId", taskId);
//    }
//
//    override
//    @SuppressWarnings("unchecked")
//    public List!Comment findCommentsByTaskIdAndType(string taskId, string type) {
//        Map!(string, Object) params = new HashMap<>();
//        params.put("taskId", taskId);
//        params.put("type", type);
//        return getDbSqlSession().selectListWithRawParameter("selectCommentsByTaskIdAndType", params);
//    }
//
//    override
//    @SuppressWarnings("unchecked")
//    public List!Comment findCommentsByType(string type) {
//        return getDbSqlSession().selectList("selectCommentsByType", type);
//    }
//
//    override
//    @SuppressWarnings("unchecked")
//    public List!Event findEventsByTaskId(string taskId) {
//        return getDbSqlSession().selectList("selectEventsByTaskId", taskId);
//    }
//
//    override
//    @SuppressWarnings("unchecked")
//    public List!Event findEventsByProcessInstanceId(string processInstanceId) {
//        return getDbSqlSession().selectList("selectEventsByProcessInstanceId", processInstanceId);
//    }
//
//    override
//    public void deleteCommentsByTaskId(string taskId) {
//        getDbSqlSession().delete("deleteCommentsByTaskId", taskId, CommentEntityImpl.class);
//    }
//
//    override
//    public void deleteCommentsByProcessInstanceId(string processInstanceId) {
//        getDbSqlSession().delete("deleteCommentsByProcessInstanceId", processInstanceId, CommentEntityImpl.class);
//    }
//
//    override
//    @SuppressWarnings("unchecked")
//    public List!Comment findCommentsByProcessInstanceId(string processInstanceId) {
//        return getDbSqlSession().selectList("selectCommentsByProcessInstanceId", processInstanceId);
//    }
//
//    override
//    @SuppressWarnings("unchecked")
//    public List!Comment findCommentsByProcessInstanceId(string processInstanceId, string type) {
//        Map!(string, Object) params = new HashMap<>();
//        params.put("processInstanceId", processInstanceId);
//        params.put("type", type);
//        return getDbSqlSession().selectListWithRawParameter("selectCommentsByProcessInstanceIdAndType", params);
//    }
//
//    override
//    public Comment findComment(string commentId) {
//        return findById(commentId);
//    }
//
//    override
//    public Event findEvent(string commentId) {
//        return findById(commentId);
//    }
//
//}
