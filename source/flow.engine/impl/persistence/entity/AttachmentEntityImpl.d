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



import java.io.Serializable;
import java.util.Date;
import hunt.collection.HashMap;
import hunt.collection.Map;

/**
 * @author Tom Baeyens
 */
class AttachmentEntityImpl extends AbstractBpmnEngineEntity implements AttachmentEntity, Serializable {

    private static final long serialVersionUID = 1L;

    protected string name;
    protected string description;
    protected string type;
    protected string taskId;
    protected string processInstanceId;
    protected string url;
    protected string contentId;
    protected ByteArrayEntity content;
    protected string userId;
    protected Date time;

    public AttachmentEntityImpl() {

    }

    @Override
    public Object getPersistentState() {
        Map!(string, Object) persistentState = new HashMap<>();
        persistentState.put("name", name);
        persistentState.put("description", description);
        return persistentState;
    }

    @Override
    public string getName() {
        return name;
    }

    @Override
    public void setName(string name) {
        this.name = name;
    }

    @Override
    public string getDescription() {
        return description;
    }

    @Override
    public void setDescription(string description) {
        this.description = description;
    }

    @Override
    public string getType() {
        return type;
    }

    @Override
    public void setType(string type) {
        this.type = type;
    }

    @Override
    public string getTaskId() {
        return taskId;
    }

    @Override
    public void setTaskId(string taskId) {
        this.taskId = taskId;
    }

    @Override
    public string getProcessInstanceId() {
        return processInstanceId;
    }

    @Override
    public void setProcessInstanceId(string processInstanceId) {
        this.processInstanceId = processInstanceId;
    }

    @Override
    public string getUrl() {
        return url;
    }

    @Override
    public void setUrl(string url) {
        this.url = url;
    }

    @Override
    public string getContentId() {
        return contentId;
    }

    @Override
    public void setContentId(string contentId) {
        this.contentId = contentId;
    }

    @Override
    public ByteArrayEntity getContent() {
        return content;
    }

    @Override
    public void setContent(ByteArrayEntity content) {
        this.content = content;
    }

    @Override
    public void setUserId(string userId) {
        this.userId = userId;
    }

    @Override
    public string getUserId() {
        return userId;
    }

    @Override
    public Date getTime() {
        return time;
    }

    @Override
    public void setTime(Date time) {
        this.time = time;
    }

}
