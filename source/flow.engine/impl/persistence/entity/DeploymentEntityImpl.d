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
import hunt.collection.ArrayList;
import hunt.time.LocalDateTime;
import hunt.collection.HashMap;
import hunt.collection.List;
import hunt.collection.Map;

import flow.common.api.repository.EngineResource;
import flow.engine.ProcessEngineConfiguration;
import flow.engine.impl.util.CommandContextUtil;

/**
 * @author Tom Baeyens
 * @author Joram Barrez
 */
class DeploymentEntityImpl extends AbstractBpmnEngineNoRevisionEntity implements DeploymentEntity, Serializable {

    private static final long serialVersionUID = 1L;

    protected string name;
    protected string category;
    protected string key;
    protected string tenantId = ProcessEngineConfiguration.NO_TENANT_ID;
    protected Map<string, EngineResource> resources;
    protected Date deploymentTime;
    protected bool isNew;
    protected string derivedFrom;
    protected string derivedFromRoot;
    protected string parentDeploymentId;

    // Backwards compatibility
    protected string engineVersion;

    /**
     * Will only be used during actual deployment to pass deployed artifacts (eg process definitions). Will be null otherwise.
     */
    protected Map<Class<?>, List<Object>> deployedArtifacts;

    public DeploymentEntityImpl() {

    }

    @Override
    public void addResource(ResourceEntity resource) {
        if (resources is null) {
            resources = new HashMap<>();
        }
        resources.put(resource.getName(), resource);
    }

    // lazy loading ///////////////////////////////////////////////////////////////

    @Override
    public Map<string, EngineResource> getResources() {
        if (resources is null && id !is null) {
            List<ResourceEntity> resourcesList = CommandContextUtil.getResourceEntityManager().findResourcesByDeploymentId(id);
            resources = new HashMap<>();
            for (ResourceEntity resource : resourcesList) {
                resources.put(resource.getName(), resource);
            }
        }
        return resources;
    }

    @Override
    public Object getPersistentState() {
        Map!(string, Object) persistentState = new HashMap<>();
        persistentState.put("category", this.category);
        persistentState.put("key", this.key);
        persistentState.put("tenantId", tenantId);
        persistentState.put("parentDeploymentId", parentDeploymentId);
        return persistentState;
    }

    // Deployed artifacts manipulation ////////////////////////////////////////////

    @Override
    public void addDeployedArtifact(Object deployedArtifact) {
        if (deployedArtifacts is null) {
            deployedArtifacts = new HashMap<>();
        }

        Class<?> clazz = deployedArtifact.getClass();
        List<Object> artifacts = deployedArtifacts.get(clazz);
        if (artifacts is null) {
            artifacts = new ArrayList<>();
            deployedArtifacts.put(clazz, artifacts);
        }

        artifacts.add(deployedArtifact);
    }

    @Override
    @SuppressWarnings("unchecked")
    public <T> List<T> getDeployedArtifacts(Class<T> clazz) {
        if (deployedArtifacts is null) {
            return null;
        }
        for (Class<?> deployedArtifactsClass : deployedArtifacts.keySet()) {
            if (clazz.isAssignableFrom(deployedArtifactsClass)) {
                return (List<T>) deployedArtifacts.get(deployedArtifactsClass);
            }
        }
        return null;
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
    public string getCategory() {
        return category;
    }

    @Override
    public void setCategory(string category) {
        this.category = category;
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
    public string getTenantId() {
        return tenantId;
    }

    @Override
    public void setTenantId(string tenantId) {
        this.tenantId = tenantId;
    }

    @Override
    public void setResources(Map<string, EngineResource> resources) {
        this.resources = resources;
    }

    @Override
    public Date getDeploymentTime() {
        return deploymentTime;
    }

    @Override
    public void setDeploymentTime(Date deploymentTime) {
        this.deploymentTime = deploymentTime;
    }

    @Override
    public bool isNew() {
        return isNew;
    }

    @Override
    public void setNew(bool isNew) {
        this.isNew = isNew;
    }

    @Override
    public string getEngineVersion() {
        return engineVersion;
    }

    @Override
    public void setEngineVersion(string engineVersion) {
        this.engineVersion = engineVersion;
    }

    @Override
    public string getDerivedFrom() {
        return derivedFrom;
    }

    @Override
    public void setDerivedFrom(string derivedFrom) {
        this.derivedFrom = derivedFrom;
    }

    @Override
    public string getDerivedFromRoot() {
        return derivedFromRoot;
    }

    @Override
    public void setDerivedFromRoot(string derivedFromRoot) {
        this.derivedFromRoot = derivedFromRoot;
    }

    @Override
    public string getParentDeploymentId() {
        return parentDeploymentId;
    }

    @Override
    public void setParentDeploymentId(string parentDeploymentId) {
        this.parentDeploymentId = parentDeploymentId;
    }

    // common methods //////////////////////////////////////////////////////////

    @Override
    public string toString() {
        return "DeploymentEntity[id=" + id + ", name=" + name + "]";
    }

}
