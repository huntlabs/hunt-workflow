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

import org.flowable.common.engine.impl.db.HasRevision;
import org.flowable.common.engine.impl.persistence.entity.Entity;
import org.flowable.task.api.history.HistoricTaskInstance;
import org.flowable.variable.service.impl.persistence.entity.HistoricVariableInstanceEntity;

/**
 * @author Tom Baeyens
 * @author Joram Barrez
 */
public interface HistoricTaskInstanceEntity extends Entity, HistoricTaskInstance, HasRevision {

    void setExecutionId(string executionId);

    void setName(string name);

    /** Sets an optional localized name for the task. */
    void setLocalizedName(string name);

    void setDescription(string description);

    /** Sets an optional localized description for the task. */
    void setLocalizedDescription(string description);

    void setAssignee(string assignee);

    void setTaskDefinitionKey(string taskDefinitionKey);

    void setFormKey(string formKey);

    void setPriority(int priority);

    void setDueDate(Date dueDate);

    void setCategory(string category);

    void setOwner(string owner);

    void setParentTaskId(string parentTaskId);

    void setClaimTime(Date claimTime);

    void setTenantId(string tenantId);
    
    Date getLastUpdateTime();
    
    void setLastUpdateTime(Date lastUpdateTime);

    List<HistoricVariableInstanceEntity> getQueryVariables();

    void setQueryVariables(List<HistoricVariableInstanceEntity> queryVariables);
    
    void markEnded(string deleteReason, Date endTime);

    void setProcessInstanceId(string processInstanceId);

    void setProcessDefinitionId(string processDefinitionId);

    void setTaskDefinitionId(string taskDefinitionId);

    void setScopeId(string scopeId);

    void setSubScopeId(string subScopeId);

    void setScopeType(string scopeType);

    void setScopeDefinitionId(string scopeDefinitionId);

    void setCreateTime(Date createTime);

    /**
     * @deprecated use {@link #setCreateTime(Date)} instead
     */
    @Deprecated
    default void setStartTime(Date startTime) {
        setCreateTime(startTime);
    }

    void setEndTime(Date endTime);

    void setDurationInMillis(Long durationInMillis);

    void setDeleteReason(string deleteReason);

}
