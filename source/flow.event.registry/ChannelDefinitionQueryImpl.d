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

module flow.event.registry.ChannelDefinitionQueryImpl;

import hunt.time.LocalDateTime;
import hunt.collection.List;
import hunt.collection.Set;

import flow.common.api.FlowableIllegalArgumentException;
import flow.common.interceptor.CommandContext;
import flow.common.interceptor.CommandExecutor;
import flow.common.query.AbstractQuery;
import flow.event.registry.api.ChannelDefinition;
import flow.event.registry.api.ChannelDefinitionQuery;
import flow.event.registry.util.CommandContextUtil;
import flow.event.registry.ChannelDefinitionQueryProperty;

alias Date = LocalDateTime;
/**
 * @author Tijs Rademakers
 */
class ChannelDefinitionQueryImpl : AbstractQuery!(ChannelDefinitionQuery, ChannelDefinition) , ChannelDefinitionQuery {

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
    protected Date createTime;
    protected Date createTimeAfter;
    protected Date createTimeBefore;
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


    public ChannelDefinitionQueryImpl channelDefinitionId(string channelDefinitionId) {
        this.id = channelDefinitionId;
        return this;
    }


    public ChannelDefinitionQueryImpl channelDefinitionIds(Set!string channelDefinitionIds) {
        this.ids = channelDefinitionIds;
        return this;
    }


    public ChannelDefinitionQueryImpl channelCategory(string category) {
        if (category is null) {
            throw new FlowableIllegalArgumentException("category is null");
        }
        this.category = category;
        return this;
    }


    public ChannelDefinitionQueryImpl channelCategoryLike(string categoryLike) {
        if (categoryLike is null) {
            throw new FlowableIllegalArgumentException("categoryLike is null");
        }
        this.categoryLike = categoryLike;
        return this;
    }


    public ChannelDefinitionQueryImpl channelCategoryNotEquals(string categoryNotEquals) {
        if (categoryNotEquals is null) {
            throw new FlowableIllegalArgumentException("categoryNotEquals is null");
        }
        this.categoryNotEquals = categoryNotEquals;
        return this;
    }


    public ChannelDefinitionQueryImpl channelDefinitionName(string name) {
        if (name is null) {
            throw new FlowableIllegalArgumentException("name is null");
        }
        this.name = name;
        return this;
    }


    public ChannelDefinitionQueryImpl channelDefinitionNameLike(string nameLike) {
        if (nameLike is null) {
            throw new FlowableIllegalArgumentException("nameLike is null");
        }
        this.nameLike = nameLike;
        return this;
    }


    public ChannelDefinitionQueryImpl deploymentId(string deploymentId) {
        if (deploymentId is null) {
            throw new FlowableIllegalArgumentException("id is null");
        }
        this._deploymentId = deploymentId;
        return this;
    }


    public ChannelDefinitionQueryImpl deploymentIds(Set!string deploymentIds) {
        if (deploymentIds is null) {
            throw new FlowableIllegalArgumentException("ids are null");
        }
        this._deploymentIds = deploymentIds;
        return this;
    }


    public ChannelDefinitionQueryImpl channelDefinitionKey(string key) {
        if (key is null) {
            throw new FlowableIllegalArgumentException("key is null");
        }
        this.key = key;
        return this;
    }


    public ChannelDefinitionQueryImpl channelDefinitionKeyLike(string keyLike) {
        if (keyLike is null) {
            throw new FlowableIllegalArgumentException("keyLike is null");
        }
        this.keyLike = keyLike;
        return this;
    }


    public ChannelDefinitionQueryImpl channelVersion(int _version) {
        checkVersion(_version);
        this._version = _version;
        return this;
    }


    public ChannelDefinitionQueryImpl channelVersionGreaterThan(int channelVersion) {
        checkVersion(channelVersion);
        this.versionGt = channelVersion;
        return this;
    }


    public ChannelDefinitionQueryImpl channelVersionGreaterThanOrEquals(int channelVersion) {
        checkVersion(channelVersion);
        this.versionGte = channelVersion;
        return this;
    }


    public ChannelDefinitionQueryImpl channelVersionLowerThan(int channelVersion) {
        checkVersion(channelVersion);
        this.versionLt = channelVersion;
        return this;
    }


    public ChannelDefinitionQueryImpl channelVersionLowerThanOrEquals(int channelVersion) {
        checkVersion(channelVersion);
        this.versionLte = channelVersion;
        return this;
    }

    protected void checkVersion(int _version) {
        if (_version is null) {
            throw new FlowableIllegalArgumentException("_version is null");
        } else if (_version <= 0) {
            throw new FlowableIllegalArgumentException("_version must be positive");
        }
    }


    public ChannelDefinitionQueryImpl latestVersion() {
        this.latest = true;
        return this;
    }


    public ChannelDefinitionQueryImpl channelCreateTime(Date createTime) {
        this.createTime = createTime;
        return this;
    }


    public ChannelDefinitionQueryImpl channelCreateTimeAfter(Date createTimeAfter) {
        this.createTimeAfter = createTimeAfter;
        return this;
    }


    public ChannelDefinitionQueryImpl channelCreateTimeBefore(Date createTimeBefore) {
        this.createTimeBefore = createTimeBefore;
        return this;
    }


    public ChannelDefinitionQueryImpl channelDefinitionResourceName(string resourceName) {
        if (resourceName is null) {
            throw new FlowableIllegalArgumentException("resourceName is null");
        }
        this.resourceName = resourceName;
        return this;
    }


    public ChannelDefinitionQueryImpl channelDefinitionResourceNameLike(string resourceNameLike) {
        if (resourceNameLike is null) {
            throw new FlowableIllegalArgumentException("resourceNameLike is null");
        }
        this.resourceNameLike = resourceNameLike;
        return this;
    }


    public ChannelDefinitionQueryImpl tenantId(string tenantId) {
        if (tenantId is null) {
            throw new FlowableIllegalArgumentException("form tenantId is null");
        }
        this._tenantId = tenantId;
        return this;
    }


    public ChannelDefinitionQueryImpl tenantIdLike(string tenantIdLike) {
        if (tenantIdLike is null) {
            throw new FlowableIllegalArgumentException("form tenantId is null");
        }
        this._tenantIdLike = tenantIdLike;
        return this;
    }


    public ChannelDefinitionQueryImpl withoutTenantId() {
        this._withoutTenantId = true;
        return this;
    }

    // sorting ////////////////////////////////////////////


    public ChannelDefinitionQuery orderByDeploymentId() {
        return orderBy(ChannelDefinitionQueryProperty.DEPLOYMENT_ID);
    }


    public ChannelDefinitionQuery orderByChannelDefinitionKey() {
        return orderBy(ChannelDefinitionQueryProperty.KEY);
    }


    public ChannelDefinitionQuery orderByChannelDefinitionCategory() {
        return orderBy(ChannelDefinitionQueryProperty.CATEGORY);
    }


    public ChannelDefinitionQuery orderByChannelDefinitionId() {
        return orderBy(ChannelDefinitionQueryProperty.ID);
    }


    public ChannelDefinitionQuery orderByChannelDefinitionName() {
        return orderBy(ChannelDefinitionQueryProperty.NAME);
    }


    public ChannelDefinitionQuery orderByCreateTime() {
        return orderBy(ChannelDefinitionQueryProperty.CREATE_TIME);
    }


    public ChannelDefinitionQuery orderByTenantId() {
        return orderBy(ChannelDefinitionQueryProperty.TENANT_ID);
    }

    // results ////////////////////////////////////////////

    override
    public long executeCount(CommandContext commandContext) {
        return CommandContextUtil.getChannelDefinitionEntityManager(commandContext).findChannelDefinitionCountByQueryCriteria(this);
    }

    override
    public List!ChannelDefinition executeList(CommandContext commandContext) {
        return CommandContextUtil.getChannelDefinitionEntityManager(commandContext).findChannelDefinitionsByQueryCriteria(this);
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

    public int getVersion() {
        return _version;
    }

    public int getVersionGt() {
        return versionGt;
    }

    public int getVersionGte() {
        return versionGte;
    }

    public int getVersionLt() {
        return versionLt;
    }

    public int getVersionLte() {
        return versionLte;
    }

    public bool isLatest() {
        return latest;
    }

    public Date getCreateTime() {
        return createTime;
    }

    public Date getCreateTimeAfter() {
        return createTimeAfter;
    }

    public Date getCreateTimeBefore() {
        return createTimeBefore;
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
