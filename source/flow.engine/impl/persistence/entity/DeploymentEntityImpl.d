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

module flow.engine.impl.persistence.entity.DeploymentEntityImpl;

import hunt.Exceptions;
import hunt.collection.ArrayList;
import hunt.time.LocalDateTime;
import hunt.collection.HashMap;
import hunt.collection.List;
import hunt.collection.Map;

import flow.engine.impl.persistence.entity.ResourceEntity;
import flow.engine.impl.persistence.entity.AbstractBpmnEngineNoRevisionEntity;
import flow.engine.impl.persistence.entity.DeploymentEntity;
import flow.common.api.repository.EngineResource;
import flow.engine.ProcessEngineConfiguration;
import flow.engine.impl.util.CommandContextUtil;
import hunt.entity;
/**
 * @author Tom Baeyens
 * @author Joram Barrez
 */
//@Table("ACT_RE_MODEL")
//class ModelEntityImpl : AbstractBpmnEngineEntity , Model, ModelEntity {
//  mixin MakeModel;
@Table("ACT_RE_DEPLOYMENT")
class DeploymentEntityImpl : AbstractBpmnEngineNoRevisionEntity ,Model, DeploymentEntity {

    mixin MakeModel;

    @PrimaryKey
    @Column("ID_")
    string id;

    @Column("NAME_")
    string name;

    @Column("CATEGORY_")
    string category;

    @Column("KEY_")
    string key;

    @Column("TENANT_ID_")
    string tenantId ;


    @Column("DEPLOY_TIME_")
    long deploymentTime;

    @Column("DERIVED_FROM_")
    string derivedFrom;

    @Column("DERIVED_FROM_ROOT_")
    string derivedFromRoot;

    @Column("PARENT_DEPLOYMENT_ID_")
    string parentDeploymentId;

    // Backwards compatibility
    @Column("ENGINE_VERSION_")
    string engineVersion;

    /**
     * Will only be used during actual deployment to pass deployed artifacts (eg process definitions). Will be null otherwise.
     */
    protected Map!(Object, List!Object) deployedArtifacts;
    protected Map!(string, EngineResource) resources;
    protected bool _isNew;

    this() {
      tenantId = ProcessEngineConfiguration.NO_TENANT_ID;
    }


    override
    public string getId() {
      return id;
    }

    override
    public void setId(string id) {
      this.id = id;
    }

    public void addResource(ResourceEntity resource) {
        if (resources is null) {
            resources = new HashMap!(string, EngineResource);
        }
        resources.put(resource.getName(), resource);
    }

    // lazy loading ///////////////////////////////////////////////////////////////

    public Map!(string, EngineResource) getResources() {
        if (resources is null && id.length != 0) {
            List!ResourceEntity resourcesList = CommandContextUtil.getResourceEntityManager().findResourcesByDeploymentId(id);
            resources = new HashMap!(string, EngineResource);
            foreach (ResourceEntity resource ; resourcesList) {
                resources.put(resource.getName(), resource);
            }
        }
        return resources;
    }

    public Object getPersistentState() {
        implementationMissing(false);
        return null;
        //Map!(string, Object) persistentState = new HashMap!(string, Object);
        //persistentState.put("category", this.category);
        //persistentState.put("key", this.key);
        //persistentState.put("tenantId", tenantId);
        //persistentState.put("parentDeploymentId", parentDeploymentId);
        //return persistentState;
    }

    // Deployed artifacts manipulation ////////////////////////////////////////////

    public void addDeployedArtifact(Object deployedArtifact) {
        if (deployedArtifacts is null) {
            deployedArtifacts = new HashMap!(Object , List!Object);
        }

        List!Object artifacts = deployedArtifacts.get(deployedArtifact);
        if (artifacts is null) {
            artifacts = new ArrayList!Object;
            deployedArtifacts.put(deployedArtifact, artifacts);
        }

        artifacts.add(deployedArtifact);
    }

    //public <T> List!T getDeployedArtifacts(Class!T clazz) {
    //    if (deployedArtifacts is null) {
    //        return null;
    //    }
    //    for (Class<?> deployedArtifactsClass : deployedArtifacts.keySet()) {
    //        if (clazz.isAssignableFrom(deployedArtifactsClass)) {
    //            return (List!T) deployedArtifacts.get(deployedArtifactsClass);
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


    public string getKey() {
        return key;
    }


    public void setKey(string key) {
        this.key = key;
    }


    public string getTenantId() {
        return tenantId;
    }


    public void setTenantId(string tenantId) {
        this.tenantId = tenantId;
    }


    public void setResources(Map!(string, EngineResource) resources) {
        this.resources = resources;
    }


    public Date getDeploymentTime() {
        return Date.ofEpochMilli(deploymentTime);
    }


    public void setDeploymentTime(Date deploymentTime) {
        this.deploymentTime = deploymentTime.toEpochMilli();
    }


    public bool isNew() {
        return _isNew;
    }


    public void setNew(bool isNew) {
        this._isNew = isNew;
    }


    public string getEngineVersion() {
        return engineVersion;
    }


    public void setEngineVersion(string engineVersion) {
        this.engineVersion = engineVersion;
    }


    public string getDerivedFrom() {
        return derivedFrom;
    }


    public void setDerivedFrom(string derivedFrom) {
        this.derivedFrom = derivedFrom;
    }


    public string getDerivedFromRoot() {
        return derivedFromRoot;
    }


    public void setDerivedFromRoot(string derivedFromRoot) {
        this.derivedFromRoot = derivedFromRoot;
    }


    public string getParentDeploymentId() {
        return parentDeploymentId;
    }


    public void setParentDeploymentId(string parentDeploymentId) {
        this.parentDeploymentId = parentDeploymentId;
    }

    // common methods //////////////////////////////////////////////////////////

    override
    public string toString() {
        return "DeploymentEntity[id=" ~ id ~ ", name=" ~ name ~ "]";
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




}
