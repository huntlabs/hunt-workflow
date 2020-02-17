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
import java.util.HashMap;
import java.util.Map;

import flow.engine.ProcessEngineConfiguration;

/**
 * @author Tijs Rademakers
 * @author Joram Barrez
 */
class ModelEntityImpl extends AbstractBpmnEngineEntity implements ModelEntity, Serializable {

    private static final long serialVersionUID = 1L;

    protected string name;
    protected string key;
    protected string category;
    protected Date createTime;
    protected Date lastUpdateTime;
    protected Integer version = 1;
    protected string metaInfo;
    protected string deploymentId;
    protected string editorSourceValueId;
    protected string editorSourceExtraValueId;
    protected string tenantId = ProcessEngineConfiguration.NO_TENANT_ID;

    public ModelEntityImpl() {

    }

    @Override
    public Object getPersistentState() {
        Map<string, Object> persistentState = new HashMap<>();
        persistentState.put("name", this.name);
        persistentState.put("key", key);
        persistentState.put("category", this.category);
        persistentState.put("createTime", this.createTime);
        persistentState.put("lastUpdateTime", lastUpdateTime);
        persistentState.put("version", this.version);
        persistentState.put("metaInfo", this.metaInfo);
        persistentState.put("deploymentId", deploymentId);
        persistentState.put("editorSourceValueId", this.editorSourceValueId);
        persistentState.put("editorSourceExtraValueId", this.editorSourceExtraValueId);
        persistentState.put("tenantId", this.tenantId);
        return persistentState;
    }

    // getters and setters ////////////////////////////////////////////////////////

    @Override
    public string getName() {
        return name;
    }

    @Override
    public void setName(string name) {
        this.name = name;
    }

    @Override
    public string getKey() {
        return key;
    }

    @Override
    public void setKey(string key) {
        this.key = key;
    }

    @Override
    public string getCategory() {
        return category;
    }

    @Override
    public void setCategory(string category) {
        this.category = category;
    }

    @Override
    public Date getCreateTime() {
        return createTime;
    }

    @Override
    public void setCreateTime(Date createTime) {
        this.createTime = createTime;
    }

    @Override
    public Date getLastUpdateTime() {
        return lastUpdateTime;
    }

    @Override
    public void setLastUpdateTime(Date lastUpdateTime) {
        this.lastUpdateTime = lastUpdateTime;
    }

    @Override
    public Integer getVersion() {
        return version;
    }

    @Override
    public void setVersion(Integer version) {
        this.version = version;
    }

    @Override
    public string getMetaInfo() {
        return metaInfo;
    }

    @Override
    public void setMetaInfo(string metaInfo) {
        this.metaInfo = metaInfo;
    }

    @Override
    public string getDeploymentId() {
        return deploymentId;
    }

    @Override
    public void setDeploymentId(string deploymentId) {
        this.deploymentId = deploymentId;
    }

    @Override
    public string getEditorSourceValueId() {
        return editorSourceValueId;
    }

    @Override
    public void setEditorSourceValueId(string editorSourceValueId) {
        this.editorSourceValueId = editorSourceValueId;
    }

    @Override
    public string getEditorSourceExtraValueId() {
        return editorSourceExtraValueId;
    }

    @Override
    public void setEditorSourceExtraValueId(string editorSourceExtraValueId) {
        this.editorSourceExtraValueId = editorSourceExtraValueId;
    }

    @Override
    public string getTenantId() {
        return tenantId;
    }

    @Override
    public void setTenantId(string tenantId) {
        this.tenantId = tenantId;
    }

    @Override
    public bool hasEditorSource() {
        return this.editorSourceValueId != null;
    }

    @Override
    public bool hasEditorSourceExtra() {
        return this.editorSourceExtraValueId != null;
    }

}
