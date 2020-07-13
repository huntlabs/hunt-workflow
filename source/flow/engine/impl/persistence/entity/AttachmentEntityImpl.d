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
//module flow.engine.impl.persistence.entity.AttachmentEntityImpl;
//
//import hunt.time.LocalDateTime;
//import hunt.collection.HashMap;
//import hunt.collection.Map;
//
///**
// * @author Tom Baeyens
// */
//class AttachmentEntityImpl : AbstractBpmnEngineEntity implements AttachmentEntity, Serializable {
//
//    private static final long serialVersionUID = 1L;
//
//    protected string name;
//    protected string description;
//    protected string type;
//    protected string taskId;
//    protected string processInstanceId;
//    protected string url;
//    protected string contentId;
//    protected ByteArrayEntity content;
//    protected string userId;
//    protected Date time;
//
//    public AttachmentEntityImpl() {
//
//    }
//
//    override
//    public Object getPersistentState() {
//        Map!(string, Object) persistentState = new HashMap<>();
//        persistentState.put("name", name);
//        persistentState.put("description", description);
//        return persistentState;
//    }
//
//    override
//    public string getName() {
//        return name;
//    }
//
//    override
//    public void setName(string name) {
//        this.name = name;
//    }
//
//    override
//    public string getDescription() {
//        return description;
//    }
//
//    override
//    public void setDescription(string description) {
//        this.description = description;
//    }
//
//    override
//    public string getType() {
//        return type;
//    }
//
//    override
//    public void setType(string type) {
//        this.type = type;
//    }
//
//    override
//    public string getTaskId() {
//        return taskId;
//    }
//
//    override
//    public void setTaskId(string taskId) {
//        this.taskId = taskId;
//    }
//
//    override
//    public string getProcessInstanceId() {
//        return processInstanceId;
//    }
//
//    override
//    public void setProcessInstanceId(string processInstanceId) {
//        this.processInstanceId = processInstanceId;
//    }
//
//    override
//    public string getUrl() {
//        return url;
//    }
//
//    override
//    public void setUrl(string url) {
//        this.url = url;
//    }
//
//    override
//    public string getContentId() {
//        return contentId;
//    }
//
//    override
//    public void setContentId(string contentId) {
//        this.contentId = contentId;
//    }
//
//    override
//    public ByteArrayEntity getContent() {
//        return content;
//    }
//
//    override
//    public void setContent(ByteArrayEntity content) {
//        this.content = content;
//    }
//
//    override
//    public void setUserId(string userId) {
//        this.userId = userId;
//    }
//
//    override
//    public string getUserId() {
//        return userId;
//    }
//
//    override
//    public Date getTime() {
//        return time;
//    }
//
//    override
//    public void setTime(Date time) {
//        this.time = time;
//    }
//
//}
