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
module flow.engine.impl.persistence.entity.ProcessDefinitionEntityImpl;

import  flow.common.persistence.entity.Entity;
import hunt.collection.ArrayList;
import hunt.collection.HashMap;
import hunt.collection.List;
import hunt.collection.Map;

import flow.common.db.SuspensionState;
import flow.engine.ProcessEngineConfiguration;
//import flow.engine.impl.bpmn.data.IOSpecification;
import flow.engine.impl.util.CommandContextUtil;
import flow.identitylink.service.impl.persistence.entity.IdentityLinkEntity;
import flow.engine.impl.persistence.entity.AbstractBpmnEngineEntity;
import flow.engine.impl.persistence.entity.ProcessDefinitionEntity;
import hunt.Exceptions;
import hunt.entity;
import std.conv: to;
/**
 * @author Joram Barrez
 * @author Tijs Rademakers
 */
@Table("ACT_RE_PROCDEF")
class ProcessDefinitionEntityImpl : AbstractBpmnEngineEntity , Model, ProcessDefinitionEntity {

    mixin MakeModel;

    @PrimaryKey
    @Column("ID_")
    string id;

    @Column("REV_")
    string rev;

    @Column("NAME_")
    string name;

    @Column("DESCRIPTION_")
    string description;

    @Column("KEY_")
    string key;

    @Column("VERSION_")
    int ver;

    @Column("CATEGORY_")
    string category;

    @Column("DEPLOYMENT_ID_")
    string deploymentId;

    @Column("RESOURCE_NAME_")
    string resourceName;

    @Column("TENANT_ID_")
    string tenantId ;//= ProcessEngineConfiguration.NO_TENANT_ID;

    @Column("DGRM_RESOURCE_NAME_")
    string diagramResourceName;

    @Column("HAS_GRAPHICAL_NOTATION_")
    byte _isGraphicalNotationDefined;

    @Column("HAS_START_FORM_KEY_")
    byte _hasStartFormKey;

    @Column("SUSPENSION_STATE_")
    int suspensionState ;


    @Column("DERIVED_FROM_")
    string derivedFrom;

    @Column("DERIVED_FROM_ROOT_")
    string derivedFromRoot;

    @Column("DERIVED_VERSION_")
    int derivedVersion;

    // Backwards compatibility
    @Column("ENGINE_VERSION_")
    string engineVersion;

    private string localizedName;
    private string localizedDescription;
    private int historyLevel;
    private Map!(string, Object) variables;
    private bool isIdentityLinksInitialized;
    private List!IdentityLinkEntity definitionIdentityLinkEntities;
    //protected IOSpecification ioSpecification;

    this()
    {
      definitionIdentityLinkEntities = new ArrayList!IdentityLinkEntity();
      suspensionState = ACTIVE.getStateCode();
      tenantId = ProcessEngineConfiguration.NO_TENANT_ID;
      rev = "1";
    }

    public Object getPersistentState() {
        implementationMissing(false);
        return null;
        //Map!(string, Object) persistentState = new HashMap!(string, Object)();
        //persistentState.put("suspensionState", this.suspensionState);
        //persistentState.put("category", this.category);
        //return persistentState;
    }

    // getters and setters
    // //////////////////////////////////////////////////////


    public List!IdentityLinkEntity getIdentityLinks() {
        if (!isIdentityLinksInitialized) {
            definitionIdentityLinkEntities = CommandContextUtil.getIdentityLinkService().findIdentityLinksByProcessDefinitionId(id);
            isIdentityLinksInitialized = true;
        }

        return definitionIdentityLinkEntities;
    }

    public string getId() {
        return id;
    }


    public void setId(string id) {
        this.id = id;
    }

    public string getKey() {
        return key;
    }


    public void setKey(string key) {
        this.key = key;
    }


    public string getName() {
        if(localizedName.length > 0) {
            return localizedName;
        }
        return name;
    }


    public void setName(string name) {
        this.name = name;
    }

    public string getLocalizedName() {
        return localizedName;
    }


    public void setLocalizedName(string localizedName) {
        this.localizedName = localizedName;
    }


    public void setDescription(string description) {
        this.description = description;
    }


    public string getDescription() {
        if(localizedDescription.length > 0) {
            return localizedDescription;
        }
        return description;
    }

    public string getLocalizedDescription() {
        return localizedDescription;
    }


    public void setLocalizedDescription(string localizedDescription) {
        this.localizedDescription = localizedDescription;
    }


    public string getDeploymentId() {
        return deploymentId;
    }


    public void setDeploymentId(string deploymentId) {
        this.deploymentId = deploymentId;
    }


    public int getVersion() {
        return ver;
    }


    public void setVersion(int ver) {
        this.ver = ver;
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


    public int getHistoryLevel() {
        return historyLevel;
    }


    public void setHistoryLevel(int historyLevel) {
        this.historyLevel = historyLevel;
    }

    public Map!(string, Object) getVariables() {
        return variables;
    }

    public void setVariables(Map!(string, Object) variables) {
        this.variables = variables;
    }


    public string getCategory() {
        return category;
    }


    public void setCategory(string category) {
        this.category = category;
    }


    public string getDiagramResourceName() {
        return diagramResourceName;
    }


    public void setDiagramResourceName(string diagramResourceName) {
        this.diagramResourceName = diagramResourceName;
    }


    public bool hasStartFormKey() {
        return to!bool(_hasStartFormKey);
    }


    public bool getHasStartFormKey() {
        return to!bool(_hasStartFormKey);
    }


    public void setStartFormKey(bool hasStartFormKey) {
        this._hasStartFormKey = to!byte(hasStartFormKey);
    }


    public void setHasStartFormKey(bool hasStartFormKey) {
        this._hasStartFormKey = to!byte(hasStartFormKey);
    }


    public bool isGraphicalNotationDefined() {
        return to!bool(_isGraphicalNotationDefined);
    }


    public bool hasGraphicalNotation() {
        return to!bool(_isGraphicalNotationDefined);
    }


    public void setGraphicalNotationDefined(bool isGraphicalNotationDefined) {
        this._isGraphicalNotationDefined = to!byte(isGraphicalNotationDefined);
    }


    public int getSuspensionState() {
        return suspensionState;
    }


    public void setSuspensionState(int suspensionState) {
        this.suspensionState = suspensionState;
    }


    public bool isSuspended() {
        return suspensionState == SUSPENDED.getStateCode();
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


    public int getDerivedVersion() {
        return derivedVersion;
    }


    public void setDerivedVersion(int derivedVersion) {
        this.derivedVersion = derivedVersion;
    }


    public string getEngineVersion() {
        return engineVersion;
    }


    public void setEngineVersion(string engineVersion) {
        this.engineVersion = engineVersion;
    }

    //public IOSpecification getIoSpecification() {
    //    return ioSpecification;
    //}
    //
    //public void setIoSpecification(IOSpecification ioSpecification) {
    //    this.ioSpecification = ioSpecification;
    //}

    override
    public string toString() {
        return "ProcessDefinitionEntity[" ~ id ~ "]";
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

  override
  void setRevision(int revision)
  {
    super.setRevision(revision);
  }

  override
  int getRevision()
  {
    return super.getRevision;
  }


  override
  int getRevisionNext()
  {
    return super.getRevisionNext;
  }


  int opCmp(ProcessDefinitionEntity o)
  {
    return cast(int)(hashOf(id) - hashOf((cast(ProcessDefinitionEntityImpl)o).getId));
  }

  //int opCmp(Entity o)
  //{
  //    return cast(int)(hashOf(id) - hashOf((cast(ProcessDefinitionEntityImpl)o).getId));
  //}


}
