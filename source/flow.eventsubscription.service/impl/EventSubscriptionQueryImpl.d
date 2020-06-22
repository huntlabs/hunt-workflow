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

module flow.eventsubscription.service.impl.EventSubscriptionQueryImpl;

import hunt.collection.ArrayList;
import hunt.collection;
import hunt.time.LocalDateTime;
import hunt.collection.List;

import flow.common.api.FlowableException;
import flow.common.api.FlowableIllegalArgumentException;
import flow.common.api.query.QueryCacheValues;
import flow.common.interceptor.CommandContext;
import flow.common.interceptor.CommandExecutor;
import flow.common.query.AbstractQuery;
import flow.eventsubscription.service.api.EventSubscription;
import flow.eventsubscription.service.api.EventSubscriptionQuery;
import flow.eventsubscription.service.impl.util.CommandContextUtil;
import flow.eventsubscription.service.impl.EventSubscriptionQueryProperty;

/**
 * @author Daniel Meyer
 */
class EventSubscriptionQueryImpl : AbstractQuery!(EventSubscriptionQuery, EventSubscription) , EventSubscriptionQuery, QueryCacheValues {


    protected string _id;
    protected string _eventType;
    protected string _eventName;
    protected string _executionId;
    protected string _processInstanceId;
    protected string _processDefinitionId;
    protected string _activityId;
    protected string _subScopeId;
    protected string _scopeId;
    protected string _scopeDefinitionId;
    protected string _scopeType;
    protected Date _createdBefore;
    protected Date _createdAfter;
    protected string _tenantId;
    protected Collection!string _tenantIds;
    protected bool _withoutTenantId;
    protected string _configuration;
    protected Collection!string _configurations;
    protected bool _withoutConfiguration;

    protected List!EventSubscriptionQueryImpl orQueryObjects ;// = new ArrayList<>();
    protected EventSubscriptionQueryImpl currentOrQueryObject;
    protected bool inOrStatement;

    this() {
      orQueryObjects = ArrayList!EventSubscriptionQueryImpl;
    }

    this(CommandContext commandContext) {
        super(commandContext);
        orQueryObjects = ArrayList!EventSubscriptionQueryImpl;
    }

    this(CommandExecutor commandExecutor) {
        super(commandExecutor);
        orQueryObjects = ArrayList!EventSubscriptionQueryImpl;
    }


    public EventSubscriptionQueryImpl id(string id) {
        if (id is null) {
            throw new FlowableIllegalArgumentException("Provided event subscription id is null");
        }

        if (inOrStatement) {
            this.currentOrQueryObject.id = id;
        } else {
            this._id = id;
        }

        return this;
    }


    public EventSubscriptionQueryImpl eventType(string eventType) {
        if (eventType is null) {
            throw new FlowableIllegalArgumentException("Provided event type is null");
        }

        if (inOrStatement) {
            this.currentOrQueryObject.eventType = eventType;
        } else {
            this._eventType = eventType;
        }

        return this;
    }


    public EventSubscriptionQueryImpl eventName(string eventName) {
        if (eventName is null) {
            throw new FlowableIllegalArgumentException("Provided event name is null");
        }

        if (inOrStatement) {
            this.currentOrQueryObject.eventName = eventName;
        } else {
            this._eventName = eventName;
        }

        return this;
    }


    public EventSubscriptionQueryImpl executionId(string executionId) {
        if (executionId is null) {
            throw new FlowableIllegalArgumentException("Provided execution id is null");
        }

        if (inOrStatement) {
            this.currentOrQueryObject.executionId = executionId;
        } else {
            this._executionId = executionId;
        }

        return this;
    }


    public EventSubscriptionQueryImpl processInstanceId(string processInstanceId) {
        if (processInstanceId is null) {
            throw new FlowableIllegalArgumentException("Provided process instance id is null");
        }

        if (inOrStatement) {
            this.currentOrQueryObject.processInstanceId = processInstanceId;
        } else {
            this._processInstanceId = processInstanceId;
        }

        return this;
    }


    public EventSubscriptionQueryImpl processDefinitionId(string processDefinitionId) {
        if (processDefinitionId is null) {
            throw new FlowableIllegalArgumentException("Provided process definition id is null");
        }

        if (inOrStatement) {
            this.currentOrQueryObject.processDefinitionId = processDefinitionId;
        } else {
            this._processDefinitionId = processDefinitionId;
        }

        return this;
    }


    public EventSubscriptionQueryImpl activityId(string activityId) {
        if (activityId is null) {
            throw new FlowableIllegalArgumentException("Provided activity id is null");
        }

        if (inOrStatement) {
            this.currentOrQueryObject.activityId = activityId;
        } else {
            this._activityId = activityId;
        }

        return this;
    }


    public EventSubscriptionQueryImpl subScopeId(string subScopeId) {
        if (scopeId is null) {
            throw new FlowableIllegalArgumentException("Provided sub scope id is null");
        }

        if (inOrStatement) {
            this.currentOrQueryObject.subScopeId = subScopeId;
        } else {
            this._subScopeId = subScopeId;
        }

        return this;
    }


    public EventSubscriptionQueryImpl scopeId(string scopeId) {
        if (scopeId is null) {
            throw new FlowableIllegalArgumentException("Provided scope id is null");
        }

        if (inOrStatement) {
            this.currentOrQueryObject.scopeId = scopeId;
        } else {
            this._scopeId = scopeId;
        }

        return this;
    }


    public EventSubscriptionQueryImpl scopeDefinitionId(string scopeDefinitionId) {
        if (scopeDefinitionId is null) {
            throw new FlowableIllegalArgumentException("Provided scope definition id is null");
        }

        if (inOrStatement) {
            this.currentOrQueryObject.scopeDefinitionId = scopeDefinitionId;
        } else {
            this._scopeDefinitionId = scopeDefinitionId;
        }

        return this;
    }


    public EventSubscriptionQueryImpl scopeType(string scopeType) {
        if (scopeType is null) {
            throw new FlowableIllegalArgumentException("Provided scope type is null");
        }

        if (inOrStatement) {
            this.currentOrQueryObject.scopeType = scopeType;
        } else {
            this._scopeType = scopeType;
        }

        return this;
    }


    public EventSubscriptionQueryImpl createdBefore(Date beforeTime) {
        if (beforeTime is null) {
            throw new FlowableIllegalArgumentException("created before time is null");
        }

        if (inOrStatement) {
            this.currentOrQueryObject.createdBefore = createdBefore;
        } else {
            this._createdBefore = createdBefore;
        }

        return this;
    }


    public EventSubscriptionQueryImpl createdAfter(Date afterTime) {
        if (afterTime is null) {
            throw new FlowableIllegalArgumentException("created after time is null");
        }

        if (inOrStatement) {
            this.currentOrQueryObject.createdAfter = createdAfter;
        } else {
            this._createdAfter = createdAfter;
        }

        return this;
    }


    public EventSubscriptionQueryImpl tenantId(string tenantId) {
        if (tenantId is null) {
            throw new FlowableIllegalArgumentException("tenant id is null");
        }

        if (inOrStatement) {
            this.currentOrQueryObject.tenantId = tenantId;
        } else {
            this._tenantId = tenantId;
        }

        return this;
    }


    public EventSubscriptionQuery tenantIds(Collection!string tenantIds) {
        if (tenantIds is null) {
            throw new FlowableIllegalArgumentException("tenant ids is null");
        }

        if (inOrStatement) {
            this.currentOrQueryObject.tenantIds = tenantIds;
        } else {
            this._tenantIds = tenantIds;
        }

        return this;
    }


    public EventSubscriptionQuery withoutTenantId() {
        if (inOrStatement) {
            this.currentOrQueryObject.withoutTenantId = true;
        } else {
            this._withoutTenantId = true;
        }
        return this;
    }


    public EventSubscriptionQueryImpl configuration(string configuration) {
        if (configuration is null) {
            throw new FlowableIllegalArgumentException("configuration is null");
        }

        if (inOrStatement) {
            this.currentOrQueryObject.configuration = configuration;
        } else {
            this._configuration = configuration;
        }

        return this;
    }


    public EventSubscriptionQueryImpl configurations(Collection!string configurations) {
        if (configurations is null) {
            throw new FlowableIllegalArgumentException("configurations are null");
        }

        if (inOrStatement) {
            this.currentOrQueryObject.configurations = configurations;
        } else {
            this._configurations = configurations;
        }

        return this;
    }


    public EventSubscriptionQueryImpl withoutConfiguration() {
        if (inOrStatement) {
            this.currentOrQueryObject.withoutConfiguration = true;
        } else {
            this._withoutConfiguration = true;
        }
        return this;
    }


    public EventSubscriptionQuery or() {
        if (inOrStatement) {
            throw new FlowableException("the query is already in an or statement");
        }

        inOrStatement = true;
        currentOrQueryObject = new EventSubscriptionQueryImpl();
        orQueryObjects.add(currentOrQueryObject);
        return this;
    }


    public EventSubscriptionQuery endOr() {
        if (!inOrStatement) {
            throw new FlowableException("endOr() can only be called after calling or()");
        }

        inOrStatement = false;
        currentOrQueryObject = null;
        return this;
    }


    public EventSubscriptionQuery orderById() {
        return orderBy(EventSubscriptionQueryProperty.ID);
    }


    public EventSubscriptionQuery orderByExecutionId() {
        return orderBy(EventSubscriptionQueryProperty.EXECUTION_ID);
    }


    public EventSubscriptionQuery orderByProcessInstanceId() {
        return orderBy(EventSubscriptionQueryProperty.PROCESS_INSTANCE_ID);
    }


    public EventSubscriptionQuery orderByProcessDefinitionId() {
        return orderBy(EventSubscriptionQueryProperty.PROCESS_DEFINITION_ID);
    }


    public EventSubscriptionQuery orderByCreateDate() {
        return orderBy(EventSubscriptionQueryProperty.CREATED);
    }


    public EventSubscriptionQuery orderByTenantId() {
        return orderBy(EventSubscriptionQueryProperty.TENANT_ID);
    }

    // results //////////////////////////////////////////

    override
    public long executeCount(CommandContext commandContext) {
        return CommandContextUtil.getEventSubscriptionEntityManager(commandContext).findEventSubscriptionCountByQueryCriteria(this);
    }

    override
    public List!EventSubscription executeList(CommandContext commandContext) {
        return CommandContextUtil.getEventSubscriptionEntityManager(commandContext).findEventSubscriptionsByQueryCriteria(this);
    }

    // getters //////////////////////////////////////////


    public string getId() {
        return _id;
    }

    public string getEventType() {
        return _eventType;
    }

    public string getEventName() {
        return _eventName;
    }

    public string getExecutionId() {
        return _executionId;
    }

    public string getProcessInstanceId() {
        return _processInstanceId;
    }

    public string getActivityId() {
        return _activityId;
    }

    public string getProcessDefinitionId() {
        return _processDefinitionId;
    }

    public string getSubScopeId() {
        return _subScopeId;
    }

    public string getScopeId() {
        return _scopeId;
    }

    public string getScopeDefinitionId() {
        return _scopeDefinitionId;
    }

    public string getScopeType() {
        return _scopeType;
    }

    public Date getCreatedBefore() {
        return _createdBefore;
    }

    public Date getCreatedAfter() {
        return _createdAfter;
    }

    public string getTenantId() {
        return _tenantId;
    }

    public Collection!string getTenantIds() {
        return _tenantIds;
    }

    public bool isWithoutTenantId() {
        return _withoutTenantId;
    }

    public string getConfiguration() {
        return _configuration;
    }

    public Collection!string getConfigurations() {
        return _configurations;
    }

    public bool isWithoutConfiguration() {
        return _withoutConfiguration;
    }

    public List!EventSubscriptionQueryImpl getOrQueryObjects() {
        return orQueryObjects;
    }

    public EventSubscriptionQueryImpl getCurrentOrQueryObject() {
        return currentOrQueryObject;
    }

    public bool isInOrStatement() {
        return inOrStatement;
    }

}
