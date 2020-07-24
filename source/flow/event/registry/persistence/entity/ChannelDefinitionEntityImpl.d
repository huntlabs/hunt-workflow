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
module flow.event.registry.persistence.entity.ChannelDefinitionEntityImpl;

import flow.common.persistence.entity.Entity;
import hunt.time.LocalDateTime;
import hunt.collection.HashMap;
import hunt.collection.Map;
import hunt.entity;
import flow.event.registry.EventRegistryEngineConfiguration;
import flow.event.registry.persistence.entity.AbstractEventRegistryNoRevisionEntity;
import flow.event.registry.persistence.entity.ChannelDefinitionEntity;
import hunt.Exceptions;
/**
 * @author Joram Barrez
 * @author Tijs Rademakers
 */

alias Date = LocalDateTime;

@Table("FLW_CHANNEL_DEFINITION")
class ChannelDefinitionEntityImpl : AbstractEventRegistryNoRevisionEntity , Model, ChannelDefinitionEntity {
    mixin MakeModel;

    @PrimaryKey
    @Column("ID_")
     string id;

    @Column("NAME_")
     string name;

    @Column("DESCRIPTION_")
     string description;

    @Column("KEY_")
     string key;

     @Column("VERSION_")
     int _version;

     @Column("CATEGORY_")
     string category;

     @Column("DEPLOYMENT_ID_")
     string deploymentId;
     private Date createTime;

     @Column("RESOURCE_NAME_")
     string resourceName;
     @Column("TENANT_ID_")
     string tenantId;

    public Object getPersistentState() {
        implementationMissing(false);
        return null;
        //Map!(string, Object) persistentState = new HashMap!(string, Object)();
        //persistentState.put("category", this.category);
        //return persistentState;
    }

    // getters and setters
    // //////////////////////////////////////////////////////

    override
    string getId()
    {
        return id;
    }
    override
    void setId(string id)
    {
        this.id = id;
    }

    public string getKey() {
        return key;
    }


    public void setKey(string key) {
        this.key = key;
    }


    public int getVersion() {
        return _version;
    }


    public void setVersion(int _version) {
        this._version = _version;
    }


    public string getName() {
        return name;
    }


    public void setName(string name) {
        this.name = name;
    }


    public void setDescription(string description) {
        this.description = description;
    }


    public string getDescription() {
        return description;
    }


    public string getDeploymentId() {
        return deploymentId;
    }


    public string getCategory() {
        return category;
    }


    public void setCategory(string category) {
        this.category = category;
    }


    public void setDeploymentId(string deploymentId) {
        this.deploymentId = deploymentId;
    }


    public Date getCreateTime() {
        return createTime;
    }


    public void setCreateTime(Date createTime) {
        this.createTime = createTime;
    }


    public string getResourceName() {
        return resourceName;
    }


    public void setResourceName(string resourceName) {
        this.resourceName = resourceName;
    }


    public string getTenantId() {
        return tenantId;
    }


    public void setTenantId(string tenantId) {
        this.tenantId = tenantId;
    }


    override
    public string toString() {
        return "ChannelDefitionEntity[" ~ id ~ "]";
    }

    override
    string getIdPrefix()
    {
      return super.getIdPrefix;
    }

    override
    bool isInserted()
    {
      return super.isInserted();
    }

    override
    void setInserted(bool inserted)
    {
      return super.setInserted(inserted);
    }

    override
    bool isUpdated()
    {
      return super.isUpdated;
    }

    override
    void setUpdated(bool updated)
    {
      super.setUpdated(updated);
    }

    override
    bool isDeleted()
    {
      return super.isDeleted;
    }

    override
    void setDeleted(bool deleted)
    {
      super.setDeleted(deleted);
    }

    override
    Object getOriginalPersistentState()
    {
      return super.getOriginalPersistentState;
    }

    override
    void setOriginalPersistentState(Object persistentState)
    {
      super.setOriginalPersistentState(persistentState);
    }

    int opCmp(Entity o)
    {
      return cast(int)(hashOf(id) - hashOf((cast(ChannelDefinitionEntityImpl)o).getId));
    }

}
