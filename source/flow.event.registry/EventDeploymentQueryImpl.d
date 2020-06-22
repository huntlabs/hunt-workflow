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

module flow.event.registry.EventDeploymentQueryImpl;

import hunt.collection.List;

import flow.common.api.FlowableIllegalArgumentException;
import flow.common.interceptor.CommandContext;
import flow.common.interceptor.CommandExecutor;
import flow.common.query.AbstractQuery;
import flow.event.registry.api.EventDeployment;
import flow.event.registry.api.EventDeploymentQuery;
import flow.event.registry.util.CommandContextUtil;

/**
 * @author Tijs Rademakers
 * @author Joram Barrez
 */
class EventDeploymentQueryImpl : AbstractQuery!(EventDeploymentQuery, EventDeployment) , EventDeploymentQuery {

    protected string _deploymentId;
    protected string name;
    protected string nameLike;
    protected string category;
    protected string categoryNotEquals;
    protected string tenantId;
    protected string tenantIdLike;
    protected bool withoutTenantId;
    protected string _parentDeploymentId;
    protected string _parentDeploymentIdLike;
    protected string _eventDefinitionKey;
    protected string _eventDefinitionKeyLike;
    protected string _channelDefinitionKey;
    protected string _channelDefinitionKeyLike;

    this() {
    }

    this(CommandContext commandContext) {
        super(commandContext);
    }

    this(CommandExecutor commandExecutor) {
        super(commandExecutor);
    }


    public EventDeploymentQueryImpl deploymentId(string deploymentId) {
        if (deploymentId is null) {
            throw new FlowableIllegalArgumentException("Deployment id is null");
        }
        this._deploymentId = deploymentId;
        return this;
    }


    public EventDeploymentQueryImpl deploymentName(string deploymentName) {
        if (deploymentName is null) {
            throw new FlowableIllegalArgumentException("deploymentName is null");
        }
        this.name = deploymentName;
        return this;
    }


    public EventDeploymentQueryImpl deploymentNameLike(string nameLike) {
        if (nameLike is null) {
            throw new FlowableIllegalArgumentException("deploymentNameLike is null");
        }
        this.nameLike = nameLike;
        return this;
    }


    public EventDeploymentQueryImpl deploymentCategory(string deploymentCategory) {
        if (deploymentCategory is null) {
            throw new FlowableIllegalArgumentException("deploymentCategory is null");
        }
        this.category = deploymentCategory;
        return this;
    }


    public EventDeploymentQueryImpl deploymentCategoryNotEquals(string deploymentCategoryNotEquals) {
        if (deploymentCategoryNotEquals is null) {
            throw new FlowableIllegalArgumentException("deploymentCategoryExclude is null");
        }
        this.categoryNotEquals = deploymentCategoryNotEquals;
        return this;
    }


    public EventDeploymentQueryImpl parentDeploymentId(string parentDeploymentId) {
        if (parentDeploymentId is null) {
            throw new FlowableIllegalArgumentException("parentDeploymentId is null");
        }
        this._parentDeploymentId = parentDeploymentId;
        return this;
    }


    public EventDeploymentQueryImpl parentDeploymentIdLike(string parentDeploymentIdLike) {
        if (parentDeploymentIdLike is null) {
            throw new FlowableIllegalArgumentException("parentDeploymentIdLike is null");
        }
        this._parentDeploymentIdLike = parentDeploymentIdLike;
        return this;
    }


    public EventDeploymentQueryImpl deploymentWithoutTenantId() {
        this.withoutTenantId = true;
        return this;
    }


    public EventDeploymentQueryImpl deploymentTenantId(string tenantId) {
        if (tenantId is null) {
            throw new FlowableIllegalArgumentException("deploymentTenantId is null");
        }
        this.tenantId = tenantId;
        return this;
    }


    public EventDeploymentQueryImpl deploymentTenantIdLike(string tenantIdLike) {
        if (tenantIdLike is null) {
            throw new FlowableIllegalArgumentException("deploymentTenantIdLike is null");
        }
        this.tenantIdLike = tenantIdLike;
        return this;
    }


    public EventDeploymentQueryImpl eventDefinitionKey(string key) {
        if (key is null) {
            throw new FlowableIllegalArgumentException("key is null");
        }
        this._eventDefinitionKey = key;
        return this;
    }


    public EventDeploymentQueryImpl eventDefinitionKeyLike(string keyLike) {
        if (keyLike is null) {
            throw new FlowableIllegalArgumentException("keyLike is null");
        }
        this._eventDefinitionKeyLike = keyLike;
        return this;
    }


    public EventDeploymentQueryImpl channelDefinitionKey(string key) {
        if (key is null) {
            throw new FlowableIllegalArgumentException("key is null");
        }
        this._channelDefinitionKey = key;
        return this;
    }


    public EventDeploymentQueryImpl channelDefinitionKeyLike(string keyLike) {
        if (keyLike is null) {
            throw new FlowableIllegalArgumentException("keyLike is null");
        }
        this._channelDefinitionKeyLike = keyLike;
        return this;
    }

    // sorting ////////////////////////////////////////////////////////


    public EventDeploymentQuery orderByDeploymentId() {
        return orderBy(DeploymentQueryProperty.DEPLOYMENT_ID);
    }


    public EventDeploymentQuery orderByDeploymentTime() {
        return orderBy(DeploymentQueryProperty.DEPLOY_TIME);
    }


    public EventDeploymentQuery orderByDeploymentName() {
        return orderBy(DeploymentQueryProperty.DEPLOYMENT_NAME);
    }


    public EventDeploymentQuery orderByTenantId() {
        return orderBy(DeploymentQueryProperty.DEPLOYMENT_TENANT_ID);
    }

    // results ////////////////////////////////////////////////////////

    override
    public long executeCount(CommandContext commandContext) {
        return CommandContextUtil.getDeploymentEntityManager(commandContext).findDeploymentCountByQueryCriteria(this);
    }

    override
    public List!EventDeployment executeList(CommandContext commandContext) {
        return CommandContextUtil.getDeploymentEntityManager(commandContext).findDeploymentsByQueryCriteria(this);
    }

    // getters ////////////////////////////////////////////////////////

    public string getDeploymentId() {
        return _deploymentId;
    }

    public string getName() {
        return name;
    }

    public string getNameLike() {
        return nameLike;
    }

    public string getCategory() {
        return category;
    }

    public string getCategoryNotEquals() {
        return categoryNotEquals;
    }

    public string getTenantId() {
        return tenantId;
    }

    public string getTenantIdLike() {
        return tenantIdLike;
    }

    public bool isWithoutTenantId() {
        return withoutTenantId;
    }

    public string getEventDefinitionKey() {
        return _eventDefinitionKey;
    }

    public string getEventDefinitionKeyLike() {
        return _eventDefinitionKeyLike;
    }

    public string getParentDeploymentId() {
        return _parentDeploymentId;
    }

    public string getParentDeploymentIdLike() {
        return _parentDeploymentIdLike;
    }

    public string getChannelDefinitionKey() {
        return _channelDefinitionKey;
    }

    public string getChannelDefinitionKeyLike() {
        return _channelDefinitionKeyLike;
    }
}
