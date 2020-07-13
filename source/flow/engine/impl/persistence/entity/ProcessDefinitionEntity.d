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
module flow.engine.impl.persistence.entity.ProcessDefinitionEntity;

import hunt.collection.List;

import flow.common.db.HasRevision;
import flow.common.persistence.entity.Entity;
import flow.engine.repository.ProcessDefinition;
import flow.identitylink.service.impl.persistence.entity.IdentityLinkEntity;

/**
 * @author Joram Barrez
 * @author Tijs Rademakers
 */
interface ProcessDefinitionEntity : ProcessDefinition, Entity, HasRevision {

    void setKey(string key);

    void setName(string name);

    void setLocalizedName(string name);

    void setDescription(string description);

    void setLocalizedDescription(string description);

    void setDeploymentId(string deploymentId);

    void setVersion(int ver);

    void setResourceName(string resourceName);

    void setTenantId(string tenantId);

    int getHistoryLevel();

    void setHistoryLevel(int historyLevel);

    void setCategory(string category);

    void setDiagramResourceName(string diagramResourceName);

    bool getHasStartFormKey();

    void setStartFormKey(bool hasStartFormKey);

    void setHasStartFormKey(bool hasStartFormKey);

    bool isGraphicalNotationDefined();

    void setGraphicalNotationDefined(bool isGraphicalNotationDefined);

    int getSuspensionState();

    void setSuspensionState(int suspensionState);

    void setDerivedFrom(string derivedFrom);

    void setDerivedFromRoot(string derivedFromRoot);

    void setDerivedVersion(int derivedVersion);

    string getEngineVersion();

    void setEngineVersion(string engineVersion);

    List!IdentityLinkEntity getIdentityLinks();

    int opCmp(ProcessDefinitionEntity o);
}
