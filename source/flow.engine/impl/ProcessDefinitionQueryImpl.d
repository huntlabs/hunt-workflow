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

module flow.engine.impl.ProcessDefinitionQueryImpl;

import flow.common.api.FlowableException;
import flow.common.api.FlowableIllegalArgumentException;
import flow.common.db.SuspensionState;
import flow.common.interceptor.CommandContext;
import flow.common.interceptor.CommandExecutor;
import flow.common.query.AbstractQuery;
import flow.engine.impl.cfg.ProcessEngineConfigurationImpl;
import flow.engine.impl.util.CommandContextUtil;
import flow.engine.repository.ProcessDefinition;
import flow.engine.repository.ProcessDefinitionQuery;

import hunt.collection;
import hunt.collection.List;
import hunt.collection.Set;
import flow.engine.impl.ProcessDefinitionQueryProperty;



/**
 * @author Tom Baeyens
 * @author Joram Barrez
 * @author Daniel Meyer
 * @author Saeid Mirzaei
 */
class ProcessDefinitionQueryImpl : AbstractQuery!(ProcessDefinitionQuery, ProcessDefinition) , ProcessDefinitionQuery {

    protected string id;
    protected Set!string ids;
    protected string category;
    protected string categoryLike;
    protected string categoryNotEquals;
    protected string name;
    protected string nameLike;
    protected string deploymentId;
    protected Set!string deploymentIds;
    protected string key;
    protected string keyLike;
    protected string resourceName;
    protected string resourceNameLike;
    protected int ver;
    protected int versionGt;
    protected int versionGte;
    protected int versionLt;
    protected int versionLte;
    protected bool latest;
    protected SuspensionState suspensionState;
    protected string authorizationUserId;
    protected Collection!string authorizationGroups;
    protected bool authorizationGroupsSet;
    protected string procDefId;
    protected string tenantId;
    protected string tenantIdLike;
    protected bool withoutTenantId;
    protected string engineVersion;
    protected string locale;
    protected bool withLocalizationFallback;

    protected string eventSubscriptionName;
    protected string eventSubscriptionType;

    this() {
    }

    this(CommandContext commandContext) {
        super(commandContext);
    }

    this(CommandExecutor commandExecutor) {
        super(commandExecutor);
    }


    public ProcessDefinitionQueryImpl processDefinitionId(string processDefinitionId) {
        this.id = processDefinitionId;
        return this;
    }


    public ProcessDefinitionQuery processDefinitionIds(Set!string processDefinitionIds) {
        this.ids = processDefinitionIds;
        return this;
    }


    public ProcessDefinitionQueryImpl processDefinitionCategory(string category) {
        if (category is null) {
            throw new FlowableIllegalArgumentException("category is null");
        }
        this.category = category;
        return this;
    }


    public ProcessDefinitionQueryImpl processDefinitionCategoryLike(string categoryLike) {
        if (categoryLike is null) {
            throw new FlowableIllegalArgumentException("categoryLike is null");
        }
        this.categoryLike = categoryLike;
        return this;
    }


    public ProcessDefinitionQueryImpl processDefinitionCategoryNotEquals(string categoryNotEquals) {
        if (categoryNotEquals is null) {
            throw new FlowableIllegalArgumentException("categoryNotEquals is null");
        }
        this.categoryNotEquals = categoryNotEquals;
        return this;
    }


    public ProcessDefinitionQueryImpl processDefinitionName(string name) {
        if (name is null) {
            throw new FlowableIllegalArgumentException("name is null");
        }
        this.name = name;
        return this;
    }


    public ProcessDefinitionQueryImpl processDefinitionNameLike(string nameLike) {
        if (nameLike is null) {
            throw new FlowableIllegalArgumentException("nameLike is null");
        }
        this.nameLike = nameLike;
        return this;
    }


    public ProcessDefinitionQueryImpl deploymentId(string deploymentId) {
        if (deploymentId is null) {
            throw new FlowableIllegalArgumentException("id is null");
        }
        this.deploymentId = deploymentId;
        return this;
    }


    public ProcessDefinitionQueryImpl deploymentIds(Set!string deploymentIds) {
        if (deploymentIds is null) {
            throw new FlowableIllegalArgumentException("ids are null");
        }
        this.deploymentIds = deploymentIds;
        return this;
    }


    public ProcessDefinitionQueryImpl processDefinitionKey(string key) {
        if (key is null) {
            throw new FlowableIllegalArgumentException("key is null");
        }
        this.key = key;
        return this;
    }


    public ProcessDefinitionQueryImpl processDefinitionKeyLike(string keyLike) {
        if (keyLike is null) {
            throw new FlowableIllegalArgumentException("keyLike is null");
        }
        this.keyLike = keyLike;
        return this;
    }


    public ProcessDefinitionQueryImpl processDefinitionResourceName(string resourceName) {
        if (resourceName is null) {
            throw new FlowableIllegalArgumentException("resourceName is null");
        }
        this.resourceName = resourceName;
        return this;
    }


    public ProcessDefinitionQueryImpl processDefinitionResourceNameLike(string resourceNameLike) {
        if (resourceNameLike is null) {
            throw new FlowableIllegalArgumentException("resourceNameLike is null");
        }
        this.resourceNameLike = resourceNameLike;
        return this;
    }


    public ProcessDefinitionQueryImpl processDefinitionVersion(int ver) {
        checkVersion(ver);
        this.ver = ver;
        return this;
    }


    public ProcessDefinitionQuery processDefinitionVersionGreaterThan(int processDefinitionVersion) {
        checkVersion(processDefinitionVersion);
        this.versionGt = processDefinitionVersion;
        return this;
    }


    public ProcessDefinitionQuery processDefinitionVersionGreaterThanOrEquals(int processDefinitionVersion) {
        checkVersion(processDefinitionVersion);
        this.versionGte = processDefinitionVersion;
        return this;
    }


    public ProcessDefinitionQuery processDefinitionVersionLowerThan(int processDefinitionVersion) {
        checkVersion(processDefinitionVersion);
        this.versionLt = processDefinitionVersion;
        return this;
    }


    public ProcessDefinitionQuery processDefinitionVersionLowerThanOrEquals(int processDefinitionVersion) {
        checkVersion(processDefinitionVersion);
        this.versionLte = processDefinitionVersion;
        return this;
    }

    protected void checkVersion(int ver) {
        if (ver is null) {
            throw new FlowableIllegalArgumentException("version is null");
        } else if (ver <= 0) {
            throw new FlowableIllegalArgumentException("version must be positive");
        }
    }


    public ProcessDefinitionQueryImpl latestVersion() {
        this.latest = true;
        return this;
    }


    public ProcessDefinitionQuery active() {
        this.suspensionState = SuspensionState.ACTIVE;
        return this;
    }


    public ProcessDefinitionQuery suspended() {
        this.suspensionState = SuspensionState.SUSPENDED;
        return this;
    }


    public ProcessDefinitionQuery processDefinitionTenantId(string tenantId) {
        if (tenantId is null) {
            throw new FlowableIllegalArgumentException("processDefinition tenantId is null");
        }
        this.tenantId = tenantId;
        return this;
    }


    public ProcessDefinitionQuery processDefinitionTenantIdLike(string tenantIdLike) {
        if (tenantIdLike is null) {
            throw new FlowableIllegalArgumentException("process definition tenantId is null");
        }
        this.tenantIdLike = tenantIdLike;
        return this;
    }


    public ProcessDefinitionQuery processDefinitionWithoutTenantId() {
        this.withoutTenantId = true;
        return this;
    }


    public ProcessDefinitionQuery processDefinitionEngineVersion(string engineVersion) {
        this.engineVersion = engineVersion;
        return this;
    }

    public ProcessDefinitionQuery messageEventSubscription(string messageName) {
        return eventSubscription("message", messageName);
    }


    public ProcessDefinitionQuery messageEventSubscriptionName(string messageName) {
        return eventSubscription("message", messageName);
    }


    public ProcessDefinitionQuery locale(string locale) {
        this.locale = locale;
        return this;
    }


    public ProcessDefinitionQuery withLocalizationFallback() {
        this.withLocalizationFallback = true;
        return this;
    }

    public ProcessDefinitionQuery processDefinitionStarter(string procDefId) {
        this.procDefId = procDefId;
        return this;
    }

    public ProcessDefinitionQuery eventSubscription(string eventType, string eventName) {
        if (eventName is null) {
            throw new FlowableIllegalArgumentException("event name is null");
        }
        if (eventType is null) {
            throw new FlowableException("event type is null");
        }
        this.eventSubscriptionType = eventType;
        this.eventSubscriptionName = eventName;
        return this;
    }

    public Collection!string getAuthorizationGroups() {
        if (authorizationGroupsSet) {
            // if authorizationGroupsSet is true then startableByUserOrGroups was called
            // and the groups passed in that methods have precedence
            return authorizationGroups;
        } else if (authorizationUserId is null) {
            return null;
        }
        return CommandContextUtil.getProcessEngineConfiguration().getCandidateManager().getGroupsForCandidateUser(authorizationUserId);
    }


    public ProcessDefinitionQueryImpl startableByUser(string userId) {
        if (userId is null) {
            throw new FlowableIllegalArgumentException("userId is null");
        }
        this.authorizationUserId = userId;
        return this;
    }


    public ProcessDefinitionQuery startableByUserOrGroups(string userId, Collection!string groups) {
        if (userId is null && (groups is null || groups.isEmpty())) {
            throw new FlowableIllegalArgumentException("userId is null and groups are null or empty");
        }
        this.authorizationUserId = userId;
        this.authorizationGroups = groups;
        this.authorizationGroupsSet = true;
        return this;
    }

    // sorting ////////////////////////////////////////////


    public ProcessDefinitionQuery orderByDeploymentId() {
        return orderBy(ProcessDefinitionQueryProperty.DEPLOYMENT_ID);
    }


    public ProcessDefinitionQuery orderByProcessDefinitionKey() {
        return orderBy(ProcessDefinitionQueryProperty.PROCESS_DEFINITION_KEY);
    }


    public ProcessDefinitionQuery orderByProcessDefinitionCategory() {
        return orderBy(ProcessDefinitionQueryProperty.PROCESS_DEFINITION_CATEGORY);
    }


    public ProcessDefinitionQuery orderByProcessDefinitionId() {
        return orderBy(ProcessDefinitionQueryProperty.PROCESS_DEFINITION_ID);
    }


    public ProcessDefinitionQuery orderByProcessDefinitionVersion() {
        return orderBy(ProcessDefinitionQueryProperty.PROCESS_DEFINITION_VERSION);
    }


    public ProcessDefinitionQuery orderByProcessDefinitionName() {
        return orderBy(ProcessDefinitionQueryProperty.PROCESS_DEFINITION_NAME);
    }


    public ProcessDefinitionQuery orderByTenantId() {
        return orderBy(ProcessDefinitionQueryProperty.PROCESS_DEFINITION_TENANT_ID);
    }

    // results ////////////////////////////////////////////


    public long executeCount(CommandContext commandContext) {
        return CommandContextUtil.getProcessDefinitionEntityManager(commandContext).findProcessDefinitionCountByQueryCriteria(this);
    }


    public List!ProcessDefinition executeList(CommandContext commandContext) {
        ProcessEngineConfigurationImpl processEngineConfiguration = CommandContextUtil.getProcessEngineConfiguration(commandContext);

        List!ProcessDefinition processDefinitions = CommandContextUtil.getProcessDefinitionEntityManager(commandContext).findProcessDefinitionsByQueryCriteria(this);

        if (processDefinitions !is null && processEngineConfiguration.getPerformanceSettings().isEnableLocalization() && processEngineConfiguration.getInternalProcessDefinitionLocalizationManager() !is null) {
            foreach (ProcessDefinition processDefinition ; processDefinitions) {
                processEngineConfiguration.getInternalProcessDefinitionLocalizationManager().localize(processDefinition, locale, withLocalizationFallback);
            }
        }

        return processDefinitions;
    }

    // getters ////////////////////////////////////////////

    public string getDeploymentId() {
        return deploymentId;
    }

    public Set!string getDeploymentIds() {
        return deploymentIds;
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

    public int getVersion() {
        return ver;
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

    public SuspensionState getSuspensionState() {
        return suspensionState;
    }

    public void setSuspensionState(SuspensionState suspensionState) {
        this.suspensionState = suspensionState;
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

    public string getEngineVersion() {
        return engineVersion;
    }

    public string getAuthorizationUserId() {
        return authorizationUserId;
    }

    public string getProcDefId() {
        return procDefId;
    }

    public string getEventSubscriptionName() {
        return eventSubscriptionName;
    }

    public string getEventSubscriptionType() {
        return eventSubscriptionType;
    }

    public bool isIncludeAuthorization() {
        return authorizationUserId !is null || (authorizationGroups !is null && !authorizationGroups.isEmpty());
    }
}
