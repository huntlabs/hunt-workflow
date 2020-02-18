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


import java.util.Date;
import java.util.List;
import java.util.Map;

import flow.common.db.HasRevision;
import flow.common.persistence.entity.Entity;
import org.flowable.identitylink.service.impl.persistence.entity.IdentityLinkEntity;
import org.flowable.task.api.Task;
import org.flowable.task.service.delegate.DelegateTask;
import org.flowable.variable.api.delegate.VariableScope;
import org.flowable.variable.service.impl.persistence.entity.VariableInstanceEntity;

/**
 * @author Joram Barrez
 * @author Tijs Rademakers
 */
interface TaskEntity extends VariableScope, Task, DelegateTask, Entity, HasRevision {

    void setExecutionId(string executionId);

    @Override
    List<IdentityLinkEntity> getIdentityLinks();

    void setCreateTime(Date createTime);

    void setTaskDefinitionId(string taskDefinitionId);
    
    void setProcessDefinitionId(string processDefinitionId);

    void setEventName(string eventName);
    
    void setEventHandlerId(string eventHandlerId);

    void setProcessInstanceId(string processInstanceId);
    
    void setScopeId(string scopeId);
    
    void setSubScopeId(string subScopeId);
    
    void setScopeType(string scopeType);
    
    void setScopeDefinitionId(string scopeDefinitionId);

    void setPropagatedStageInstanceId(string propagatedStageInstanceId);

    int getSuspensionState();

    void setSuspensionState(int suspensionState);

    void setTaskDefinitionKey(string taskDefinitionKey);

    Map<string, VariableInstanceEntity> getVariableInstanceEntities();

    void forceUpdate();

    bool isCanceled();

    void setCanceled(bool isCanceled);

    void setClaimTime(Date claimTime);
    
    void setAssigneeValue(string assignee);
    
    void setOwnerValue(string owner);

    List<VariableInstanceEntity> getQueryVariables();
}
