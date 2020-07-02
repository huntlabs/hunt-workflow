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

module flow.event.registry.EventDefinitionQueryImpl;

import hunt.collection.List;
import hunt.collection.Set;
import flow.event.registry.EventDefinitionQueryProperty;
import flow.common.api.FlowableIllegalArgumentException;
import flow.common.interceptor.CommandContext;
import flow.common.interceptor.CommandExecutor;
import flow.common.query.AbstractQuery;
import flow.event.registry.api.EventDefinition;
import flow.event.registry.api.EventDefinitionQuery;
import flow.event.registry.util.CommandContextUtil;

/**
 * @author Tijs Rademakers
 * @author Joram Barrez
 */
class EventDefinitionQueryImpl : AbstractQuery!(EventDefinitionQuery, EventDefinition) , EventDefinitionQuery {

    protected string id;
    protected Set!string ids;
    protected string category;
    protected string categoryLike;
    protected string categoryNotEquals;
    protected string name;
    protected string nameLike;
    protected string _deploymentId;
    protected Set!string _deploymentIds;
    protected string key;
    protected string keyLike;
    protected int _version;
    protected int versionGt;
    protected int versionGte;
    protected int versionLt;
    protected int versionLte;
    protected bool latest;
    protected string resourceName;
    protected string resourceNameLike;
    protected string _tenantId;
    protected string _tenantIdLike;
    protected bool _withoutTenantId;

    this() {
    }

    this(CommandContext commandContext) {
        super(commandContext);
    }

    this(CommandExecutor commandExecutor) {
        super(commandExecutor);
    }


    public EventDefinitionQueryImpl eventDefinitionId(string eventDefinitionId) {
        this.id = eventDefinitionId;
        return this;
    }


    public EventDefinitionQueryImpl eventDefinitionIds(Set!string eventDefinitionIds) {
        this.ids = eventDefinitionIds;
        return this;
    }


    public EventDefinitionQueryImpl eventCategory(string category) {
        if (category is null) {
            throw new FlowableIllegalArgumentException("category is null");
        }
        this.category = category;
        return this;
    }


    public EventDefinitionQueryImpl eventCategoryLike(string categoryLike) {
        if (categoryLike is null) {
            throw new FlowableIllegalArgumentException("categoryLike is null");
        }
        this.categoryLike = categoryLike;
        return this;
    }


    public EventDefinitionQueryImpl eventCategoryNotEquals(string categoryNotEquals) {
        if (categoryNotEquals is null) {
            throw new FlowableIllegalArgumentException("categoryNotEquals is null");
        }
        this.categoryNotEquals = categoryNotEquals;
        return this;
    }


    public EventDefinitionQueryImpl eventDefinitionName(string name) {
        if (name is null) {
            throw new FlowableIllegalArgumentException("name is null");
        }
        this.name = name;
        return this;
    }


    public EventDefinitionQueryImpl eventDefinitionNameLike(string nameLike) {
        if (nameLike is null) {
            throw new FlowableIllegalArgumentException("nameLike is null");
        }
        this.nameLike = nameLike;
        return this;
    }


    public EventDefinitionQueryImpl deploymentId(string deploymentId) {
        if (deploymentId is null) {
            throw new FlowableIllegalArgumentException("id is null");
        }
        this._deploymentId = deploymentId;
        return this;
    }


    public EventDefinitionQueryImpl deploymentIds(Set!string deploymentIds) {
        if (deploymentIds is null) {
            throw new FlowableIllegalArgumentException("ids are null");
        }
        this._deploymentIds = deploymentIds;
        return this;
    }


    public EventDefinitionQueryImpl eventDefinitionKey(string key) {
        if (key is null) {
            throw new FlowableIllegalArgumentException("key is null");
        }
        this.key = key;
        return this;
    }


    public EventDefinitionQueryImpl eventDefinitionKeyLike(string keyLike) {
        if (keyLike is null) {
            throw new FlowableIllegalArgumentException("keyLike is null");
        }
        this.keyLike = keyLike;
        return this;
    }


    public EventDefinitionQueryImpl eventVersion(int _version) {
        checkVersion(_version);
        this._version = _version;
        return this;
    }


    public EventDefinitionQueryImpl eventVersionGreaterThan(int eventVersion) {
        checkVersion(eventVersion);
        this.versionGt = eventVersion;
        return this;
    }


    public EventDefinitionQueryImpl eventVersionGreaterThanOrEquals(int eventVersion) {
        checkVersion(eventVersion);
        this.versionGte = eventVersion;
        return this;
    }


    public EventDefinitionQueryImpl eventVersionLowerThan(int eventVersion) {
        checkVersion(eventVersion);
        this.versionLt = eventVersion;
        return this;
    }


    public EventDefinitionQueryImpl eventVersionLowerThanOrEquals(int eventVersion) {
        checkVersion(eventVersion);
        this.versionLte = eventVersion;
        return this;
    }

    protected void checkVersion(int _version) {
        //if (_version is null) {
        //    throw new FlowableIllegalArgumentException("_version is null");
        //} else if (_version <= 0) {
        //    throw new FlowableIllegalArgumentException("_version must be positive");
        //}
    }


    public EventDefinitionQueryImpl latestVersion() {
        this.latest = true;
        return this;
    }


    public EventDefinitionQueryImpl eventDefinitionResourceName(string resourceName) {
        if (resourceName is null) {
            throw new FlowableIllegalArgumentException("resourceName is null");
        }
        this.resourceName = resourceName;
        return this;
    }


    public EventDefinitionQueryImpl eventDefinitionResourceNameLike(string resourceNameLike) {
        if (resourceNameLike is null) {
            throw new FlowableIllegalArgumentException("resourceNameLike is null");
        }
        this.resourceNameLike = resourceNameLike;
        return this;
    }


    public EventDefinitionQueryImpl tenantId(string tenantId) {
        if (tenantId is null) {
            throw new FlowableIllegalArgumentException("form tenantId is null");
        }
        this._tenantId = tenantId;
        return this;
    }


    public EventDefinitionQueryImpl tenantIdLike(string tenantIdLike) {
        if (tenantIdLike is null) {
            throw new FlowableIllegalArgumentException("form tenantId is null");
        }
        this._tenantIdLike = tenantIdLike;
        return this;
    }


    public EventDefinitionQueryImpl withoutTenantId() {
        this._withoutTenantId = true;
        return this;
    }

    // sorting ////////////////////////////////////////////


    public EventDefinitionQuery orderByDeploymentId() {
        return orderBy(EventDefinitionQueryProperty.DEPLOYMENT_ID);
    }


    public EventDefinitionQuery orderByEventDefinitionKey() {
        return orderBy(EventDefinitionQueryProperty.KEY);
    }


    public EventDefinitionQuery orderByEventDefinitionCategory() {
        return orderBy(EventDefinitionQueryProperty.CATEGORY);
    }


    public EventDefinitionQuery orderByEventDefinitionId() {
        return orderBy(EventDefinitionQueryProperty.ID);
    }


    public EventDefinitionQuery orderByEventDefinitionName() {
        return orderBy(EventDefinitionQueryProperty.NAME);
    }


    public EventDefinitionQuery orderByTenantId() {
        return orderBy(EventDefinitionQueryProperty.TENANT_ID);
    }

    // results ////////////////////////////////////////////

    override
    public long executeCount(CommandContext commandContext) {
        return CommandContextUtil.getEventDefinitionEntityManager(commandContext).findEventDefinitionCountByQueryCriteria(this);
    }

    override
    public List!EventDefinition executeList(CommandContext commandContext) {
        return CommandContextUtil.getEventDefinitionEntityManager(commandContext).findEventDefinitionsByQueryCriteria(this);
    }

    // getters ////////////////////////////////////////////

    public string getDeploymentId() {
        return _deploymentId;
    }

    public Set!string getDeploymentIds() {
        return _deploymentIds;
    }

    public string getId() {
        return id;
    }

    public Set!string getIds() {
        return ids;
    }

    public string getName() {
        return name;
    }

    public string getNameLike() {
        return nameLike;
    }

    public string getKey() {
        return key;
    }

    public string getKeyLike() {
        return keyLike;
    }

    public string getCategory() {
        return category;
    }

    public string getCategoryLike() {
        return categoryLike;
    }

    public string getResourceName() {
        return resourceName;
    }

    public string getResourceNameLike() {
        return resourceNameLike;
    }

    public string getCategoryNotEquals() {
        return categoryNotEquals;
    }

    public string getTenantId() {
        return _tenantId;
    }

    public string getTenantIdLike() {
        return _tenantIdLike;
    }

    public bool isWithoutTenantId() {
        return _withoutTenantId;
    }
}
