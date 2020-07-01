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

module flow.engine.impl.persistence.entity.ModelEntityImpl;

import hunt.time.LocalDateTime;
import hunt.collection.HashMap;
import hunt.collection.Map;
import flow.engine.impl.persistence.entity.ModelEntity;
import hunt.entity;
import flow.engine.ProcessEngineConfiguration;
import flow.engine.impl.persistence.entity.AbstractBpmnEngineEntity;
alias Date = LocalDateTime;

/**
 * @author Tijs Rademakers
 * @author Joram Barrez
 */
@Table("ACT_RE_MODEL")
class ModelEntityImpl : AbstractBpmnEngineEntity , Model, ModelEntity {
  mixin MakeModel;

   @PrimaryKey
   @Column("ID_")
    string id;

    @Column("NAME_")
    string name;

  @Column("KEY_")
    string key;

  @Column("CATEGORY_")
    string category;

  @Column("CREATE_TIME_")
    long createTime;

  @Column("LAST_UPDATE_TIME_")
    long lastUpdateTime;

  @Column("VERSION_")
    int ver  ;//= 1;

  @Column("META_INFO_")
    string metaInfo;

  @Column("DEPLOYMENT_ID_")
    string deploymentId;

  @Column("EDITOR_SOURCE_VALUE_ID_")
    string editorSourceValueId;

  @Column("EDITOR_SOURCE_EXTRA_VALUE_ID_")
    string editorSourceExtraValueId;

  @Column("TENANT_ID_")
    string tenantId  ;//= ProcessEngineConfiguration.NO_TENANT_ID;

    this() {
        tenantId = ProcessEngineConfiguration.NO_TENANT_ID;
        ver  = 1;
    }

    public Object getPersistentState() {
        return this;
        //Map!(string, Object) persistentState = new HashMap<>();
        //persistentState.put("name", this.name);
        //persistentState.put("key", key);
        //persistentState.put("category", this.category);
        //persistentState.put("createTime", this.createTime);
        //persistentState.put("lastUpdateTime", lastUpdateTime);
        //persistentState.put("version", this.version);
        //persistentState.put("metaInfo", this.metaInfo);
        //persistentState.put("deploymentId", deploymentId);
        //persistentState.put("editorSourceValueId", this.editorSourceValueId);
        //persistentState.put("editorSourceExtraValueId", this.editorSourceExtraValueId);
        //persistentState.put("tenantId", this.tenantId);
        //return persistentState;
    }

    // getters and setters ////////////////////////////////////////////////////////


    public string getName() {
        return name;
    }


    public void setName(string name) {
        this.name = name;
    }


    public string getKey() {
        return key;
    }


    public void setKey(string key) {
        this.key = key;
    }


    public string getCategory() {
        return category;
    }


    public void setCategory(string category) {
        this.category = category;
    }


    public Date getCreateTime() {
        return Date.ofEpochMilli(createTime);
    }


    public void setCreateTime(Date createTime) {
        this.createTime = createTime.toEpochMilli();
    }


    public Date getLastUpdateTime() {
        return Date.ofEpochMilli(lastUpdateTime);
    }


    public void setLastUpdateTime(Date lastUpdateTime) {
        this.lastUpdateTime = lastUpdateTime.toEpochMilli;
    }


    public int getVersion() {
        return ver;
    }


    public void setVersion(int ver) {
        this.ver = ver;
    }


    public string getMetaInfo() {
        return metaInfo;
    }


    public void setMetaInfo(string metaInfo) {
        this.metaInfo = metaInfo;
    }


    public string getDeploymentId() {
        return deploymentId;
    }


    public void setDeploymentId(string deploymentId) {
        this.deploymentId = deploymentId;
    }


    public string getEditorSourceValueId() {
        return editorSourceValueId;
    }


    public void setEditorSourceValueId(string editorSourceValueId) {
        this.editorSourceValueId = editorSourceValueId;
    }


    public string getEditorSourceExtraValueId() {
        return editorSourceExtraValueId;
    }


    public void setEditorSourceExtraValueId(string editorSourceExtraValueId) {
        this.editorSourceExtraValueId = editorSourceExtraValueId;
    }


    public string getTenantId() {
        return tenantId;
    }


    public void setTenantId(string tenantId) {
        this.tenantId = tenantId;
    }


    public bool hasEditorSource() {
        return this.editorSourceValueId !is null;
    }


    public bool hasEditorSourceExtra() {
        return this.editorSourceExtraValueId !is null;
    }

}
