/*
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *       http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
module flow.engine.impl.persistence.entity.HistoricProcessInstanceEntity;


import hunt.collection.List;

import flow.common.db.HasRevision;
import flow.engine.history.HistoricProcessInstance;
import flow.variable.service.impl.persistence.entity.HistoricVariableInstanceEntity;
import flow.engine.impl.persistence.entity.HistoricScopeInstanceEntity;
/**
 * @author Joram Barrez
 */
interface HistoricProcessInstanceEntity : HistoricScopeInstanceEntity, HistoricProcessInstance, HasRevision {

    void setEndActivityId(string endActivityId);

    void setBusinessKey(string businessKey);

    void setStartUserId(string startUserId);

    void setStartActivityId(string startUserId);

    void setSuperProcessInstanceId(string superProcessInstanceId);

    void setTenantId(string tenantId);

    void setName(string name);

    void setLocalizedName(string localizedName);

    void setDescription(string description);

    void setLocalizedDescription(string localizedDescription);

    void setProcessDefinitionKey(string processDefinitionKey);

    void setProcessDefinitionName(string processDefinitionName);

    void setProcessDefinitionVersion(int processDefinitionVersion);

    void setDeploymentId(string deploymentId);

    void setCallbackId(string callbackId);

    void setCallbackType(string callbackType);

    void setReferenceId(string referenceId);

    void setReferenceType(string referenceType);

    List!HistoricVariableInstanceEntity getQueryVariables();

    void setQueryVariables(List!HistoricVariableInstanceEntity queryVariables);

}
