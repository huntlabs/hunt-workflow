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

module flow.eventsubscription.service.impl.persistence.entity.EventSubscriptionEntityImpl;

import hunt.time.LocalDateTime;
import hunt.collection.HashMap;

import flow.eventsubscription.service.impl.util.CommandContextUtil;
import flow.eventsubscription.service.impl.persistence.entity.AbstractEventSubscriptionEntity;
import flow.eventsubscription.service.impl.persistence.entity.EventSubscriptionEntity;
import hunt.entity;
alias Date = LocalDateTime;

/**
 * @author Joram Barrez
 * @author Tijs Rademakers
 */
@Table("ACT_RU_EVENT_SUBSCR")
class EventSubscriptionEntityImpl : AbstractEventSubscriptionEntity , Model, EventSubscriptionEntity {
    mixin MakeModel;

    @PrimaryKey
    @Column("ID_")
    string id;

    // persistent state ///////////////////////////
  @Column("EVENT_TYPE_")
    string eventType;
  @Column("EVENT_NAME_")
    string eventName;
  @Column("EXECUTION_ID_")
    string executionId;
  @Column("PROC_INST_ID_")
    string processInstanceId;
  @Column("ACTIVITY_ID_")
    string activityId;
  @Column("CONFIGURATION_")
    string configuration;
  @Column("CREATED_")
    long created;
  @Column("PROC_DEF_ID_")
    string processDefinitionId;
  @Column("SUB_SCOPE_ID_")
    string subScopeId;
  @Column("SCOPE_ID_")
    string scopeId;
  @Column("SCOPE_DEFINITION_ID_")
    string scopeDefinitionId;
  @Column("SCOPE_TYPE_")
    string scopeType;
  @Column("TENANT_ID_")
    string tenantId;

    this() {
        this.created = CommandContextUtil.getEventSubscriptionServiceConfiguration().getClock().getCurrentTime();
    }

    public string getId() {
        return id;
    }


    public void setId(string id) {
        this.id = id;
    }

    public Object getPersistentState() {
        return this;
        //HashMap<string, Object> persistentState = new HashMap<>();
        //persistentState.put("eventName", this.eventName);
        //persistentState.put("executionId", this.executionId);
        //persistentState.put("processInstanceId", this.processInstanceId);
        //persistentState.put("activityId", this.activityId);
        //persistentState.put("created", this.created);
        //persistentState.put("configuration", this.configuration);
        //persistentState.put("subScopeId", this.subScopeId);
        //persistentState.put("scopeId", this.scopeId);
        //persistentState.put("scopeDefinitionId", this.scopeDefinitionId);
        //persistentState.put("scopeType", this.scopeType);
        //persistentState.put("tenantId", this.tenantId);
        //return persistentState;
    }

    // getters & setters ////////////////////////////


    public string getEventType() {
        return eventType;
    }


    public void setEventType(string eventType) {
        this.eventType = eventType;
    }


    public string getEventName() {
        return eventName;
    }


    public void setEventName(string eventName) {
        this.eventName = eventName;
    }


    public string getExecutionId() {
        return executionId;
    }


    public void setExecutionId(string executionId) {
        this.executionId = executionId;
    }


    public string getProcessInstanceId() {
        return processInstanceId;
    }


    public void setProcessInstanceId(string processInstanceId) {
        this.processInstanceId = processInstanceId;
    }


    public string getConfiguration() {
        return configuration;
    }


    public void setConfiguration(string configuration) {
        this.configuration = configuration;
    }


    public string getActivityId() {
        return activityId;
    }


    public void setActivityId(string activityId) {
        this.activityId = activityId;
    }


    public Date getCreated() {
        return created;
    }


    public void setCreated(Date created) {
        this.created = created;
    }


    public string getProcessDefinitionId() {
        return processDefinitionId;
    }


    public void setProcessDefinitionId(string processDefinitionId) {
        this.processDefinitionId = processDefinitionId;
    }


    public string getSubScopeId() {
        return subScopeId;
    }


    public void setSubScopeId(string subScopeId) {
        this.subScopeId = subScopeId;
    }


    public string getScopeId() {
        return scopeId;
    }


    public void setScopeId(string scopeId) {
        this.scopeId = scopeId;
    }


    public string getScopeDefinitionId() {
        return scopeDefinitionId;
    }


    public void setScopeDefinitionId(string scopeDefinitionId) {
        this.scopeDefinitionId = scopeDefinitionId;
    }


    public string getScopeType() {
        return scopeType;
    }


    public void setScopeType(string scopeType) {
        this.scopeType = scopeType;
    }


    public string getTenantId() {
        return tenantId;
    }


    public void setTenantId(string tenantId) {
        this.tenantId = tenantId;
    }


    override
    public size_t toHash() {
        size_t prime = 31;
        size_t result = 1;
        result = prime * result + ((id is null) ? 0 : hashOf!string(id));
        return result;
    }

    override
    public bool opEquals(Object obj) {
        if (this == obj)
            return true;
        if (obj is null)
            return false;
        EventSubscriptionEntityImpl other = cast(EventSubscriptionEntityImpl) obj;
        if (other is null)
        {
            return false;
        }
        if (id is null) {
            if (other.id !is null)
                return false;
        } else if (id != (other.id))
            return false;
        return true;
    }

}
