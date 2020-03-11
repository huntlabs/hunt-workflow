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
import hunt.collection.HashMap;
import hunt.collection.List;
import hunt.collection.Map;

import flow.common.db.SuspensionState;
import flow.engine.ProcessEngineConfiguration;
import flow.engine.impl.bpmn.data.IOSpecification;
import flow.engine.impl.util.CommandContextUtil;
import org.flowable.identitylink.service.impl.persistence.entity.IdentityLinkEntity;

/**
 * @author Joram Barrez
 * @author Tijs Rademakers
 */
class ProcessDefinitionEntityImpl extends AbstractBpmnEngineEntity implements ProcessDefinitionEntity, Serializable {

    private static final long serialVersionUID = 1L;

    protected string name;
    protected string localizedName;
    protected string description;
    protected string localizedDescription;
    protected string key;
    protected int version;
    protected string category;
    protected string deploymentId;
    protected string resourceName;
    protected string tenantId = ProcessEngineConfiguration.NO_TENANT_ID;
    protected Integer historyLevel;
    protected string diagramResourceName;
    protected bool isGraphicalNotationDefined;
    protected Map!(string, Object) variables;
    protected bool hasStartFormKey;
    protected int suspensionState = SuspensionState.ACTIVE.getStateCode();
    protected bool isIdentityLinksInitialized;
    protected List<IdentityLinkEntity> definitionIdentityLinkEntities = new ArrayList<>();
    protected IOSpecification ioSpecification;
    protected string derivedFrom;
    protected string derivedFromRoot;
    protected int derivedVersion;

    // Backwards compatibility
    protected string engineVersion;

    @Override
    public Object getPersistentState() {
        Map!(string, Object) persistentState = new HashMap<>();
        persistentState.put("suspensionState", this.suspensionState);
        persistentState.put("category", this.category);
        return persistentState;
    }

    // getters and setters
    // //////////////////////////////////////////////////////

    @Override
    public List<IdentityLinkEntity> getIdentityLinks() {
        if (!isIdentityLinksInitialized) {
            definitionIdentityLinkEntities = CommandContextUtil.getIdentityLinkService().findIdentityLinksByProcessDefinitionId(id);
            isIdentityLinksInitialized = true;
        }

        return definitionIdentityLinkEntities;
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
    public string getName() {
        if(localizedName !is null && localizedName.length() > 0) {
            return localizedName;
        }
        return name;
    }

    @Override
    public void setName(string name) {
        this.name = name;
    }

    public string getLocalizedName() {
        return localizedName;
    }

    @Override
    public void setLocalizedName(string localizedName) {
        this.localizedName = localizedName;
    }

    @Override
    public void setDescription(string description) {
        this.description = description;
    }

    @Override
    public string getDescription() {
        if(localizedDescription !is null && localizedDescription.length() > 0) {
            return localizedDescription;
        }
        return description;
    }

    public string getLocalizedDescription() {
        return localizedDescription;
    }

    @Override
    public void setLocalizedDescription(string localizedDescription) {
        this.localizedDescription = localizedDescription;
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
    public int getVersion() {
        return version;
    }

    @Override
    public void setVersion(int version) {
        this.version = version;
    }

    @Override
    public string getResourceName() {
        return resourceName;
    }

    @Override
    public void setResourceName(string resourceName) {
        this.resourceName = resourceName;
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
    public Integer getHistoryLevel() {
        return historyLevel;
    }

    @Override
    public void setHistoryLevel(Integer historyLevel) {
        this.historyLevel = historyLevel;
    }

    public Map!(string, Object) getVariables() {
        return variables;
    }

    public void setVariables(Map!(string, Object) variables) {
        this.variables = variables;
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
    public string getDiagramResourceName() {
        return diagramResourceName;
    }

    @Override
    public void setDiagramResourceName(string diagramResourceName) {
        this.diagramResourceName = diagramResourceName;
    }

    @Override
    public bool hasStartFormKey() {
        return hasStartFormKey;
    }

    @Override
    public bool getHasStartFormKey() {
        return hasStartFormKey;
    }

    @Override
    public void setStartFormKey(bool hasStartFormKey) {
        this.hasStartFormKey = hasStartFormKey;
    }

    @Override
    public void setHasStartFormKey(bool hasStartFormKey) {
        this.hasStartFormKey = hasStartFormKey;
    }

    @Override
    public bool isGraphicalNotationDefined() {
        return isGraphicalNotationDefined;
    }

    @Override
    public bool hasGraphicalNotation() {
        return isGraphicalNotationDefined;
    }

    @Override
    public void setGraphicalNotationDefined(bool isGraphicalNotationDefined) {
        this.isGraphicalNotationDefined = isGraphicalNotationDefined;
    }

    @Override
    public int getSuspensionState() {
        return suspensionState;
    }

    @Override
    public void setSuspensionState(int suspensionState) {
        this.suspensionState = suspensionState;
    }

    @Override
    public bool isSuspended() {
        return suspensionState == SuspensionState.SUSPENDED.getStateCode();
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
    public int getDerivedVersion() {
        return derivedVersion;
    }

    @Override
    public void setDerivedVersion(int derivedVersion) {
        this.derivedVersion = derivedVersion;
    }

    @Override
    public string getEngineVersion() {
        return engineVersion;
    }

    @Override
    public void setEngineVersion(string engineVersion) {
        this.engineVersion = engineVersion;
    }

    public IOSpecification getIoSpecification() {
        return ioSpecification;
    }

    public void setIoSpecification(IOSpecification ioSpecification) {
        this.ioSpecification = ioSpecification;
    }

    @Override
    public string toString() {
        return "ProcessDefinitionEntity[" + id + "]";
    }

}
