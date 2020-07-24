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

module flow.event.registry.persistence.entity.EventDeploymentEntityImpl;

import flow.common.persistence.entity.Entity;
import hunt.String;
import hunt.collection.ArrayList;
import hunt.time.LocalDateTime;
import hunt.collection.HashMap;
import hunt.collection.List;
import hunt.collection.Map;
import flow.event.registry.persistence.entity.AbstractEventRegistryNoRevisionEntity;
import flow.event.registry.EventRegistryEngineConfiguration;
import flow.event.registry.persistence.entity.EventDeploymentEntity;
import hunt.entity;
import flow.event.registry.persistence.entity.EventResourceEntity;
import hunt.Exceptions;
/**
 * @author Tijs Rademakers
 * @author Joram Barrez
 */
@Table("FLW_EVENT_DEPLOYMENT")
class EventDeploymentEntityImpl : AbstractEventRegistryNoRevisionEntity , Model,EventDeploymentEntity {
    mixin MakeModel;

    @PrimaryKey
    @Column("ID_")
     string id;

    @Column("NAME_")
     string name;

    @Column("CATEGORY_")
     string category;

     @Column("TENANT_ID_")
     string tenantId;

     @Column("PARENT_DEPLOYMENT_ID_")
     string parentDeploymentId;


     private Map!(string, EventResourceEntity) resources;
     private Date deploymentTime;
     private bool _isNew;

    /**
     * Will only be used during actual deployment to pass deployed artifacts (eg form definitions). Will be null otherwise.
     */
    //protected Map<Class<?>, List<Object>> deployedArtifacts;

    this() {

    }

  override
    public string getId() {
    return id;
  }


    override
    public void setId(string id) {
    this.id = id;
  }


    public void addResource(EventResourceEntity resource) {
        if (resources is null) {
            resources = new HashMap!(string, EventResourceEntity)();
        }
        resources.put(resource.getName(), resource);
    }


    public Map!(string, EventResourceEntity) getResources() {
        return resources;
    }


    public Object getPersistentState() {
        Map!(string, Object) persistentState = new HashMap!(string, Object)();
        persistentState.put("category", new String(this.category));
        persistentState.put("tenantId", new String(tenantId));
        persistentState.put("parentDeploymentId", new String(parentDeploymentId));
        return cast(Object)persistentState;
    }

    // Deployed artifacts manipulation ////////////////////////////////////////////


    public void addDeployedArtifact(Object deployedArtifact) {
        implementationMissing(false);
        //if (deployedArtifacts is null) {
        //    deployedArtifacts = new HashMap<>();
        //}
        //
        //Class<?> clazz = deployedArtifact.getClass();
        //List<Object> artifacts = deployedArtifacts.get(clazz);
        //if (artifacts is null) {
        //    artifacts = new ArrayList<>();
        //    deployedArtifacts.put(clazz, artifacts);
        //}
        //
        //artifacts.add(deployedArtifact);
    }


    //public <T> List<T> getDeployedArtifacts(Class<T> clazz) {
    //    for (Class<?> deployedArtifactsClass : deployedArtifacts.keySet()) {
    //        if (clazz.isAssignableFrom(deployedArtifactsClass)) {
    //            return (List<T>) deployedArtifacts.get(deployedArtifactsClass);
    //        }
    //    }
    //    return null;
    //}

    // getters and setters ////////////////////////////////////////////////////////


    public string getName() {
        return name;
    }


    public void setName(string name) {
        this.name = name;
    }


    public string getCategory() {
        return category;
    }


    public void setCategory(string category) {
        this.category = category;
    }


    public string getTenantId() {
        return tenantId;
    }


    public void setTenantId(string tenantId) {
        this.tenantId = tenantId;
    }


    public string getParentDeploymentId() {
        return parentDeploymentId;
    }


    public void setParentDeploymentId(string parentDeploymentId) {
        this.parentDeploymentId = parentDeploymentId;
    }


    public void setResources(Map!(string, EventResourceEntity) resources) {
        this.resources = resources;
    }


    public Date getDeploymentTime() {
        return deploymentTime;
    }


    public void setDeploymentTime(Date deploymentTime) {
        this.deploymentTime = deploymentTime;
    }


    public bool isNew() {
        return _isNew;
    }


    public void setNew(bool isNew) {
        this._isNew = isNew;
    }

    // common methods //////////////////////////////////////////////////////////


    override
    public string toString() {
        return "EventDeploymentEntity[id=" ~ id ~ ", name=" ~ name ~ "]";
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
      return cast(int)(hashOf(id) - hashOf((cast(EventDeploymentEntityImpl)o).getId));
    }
}
