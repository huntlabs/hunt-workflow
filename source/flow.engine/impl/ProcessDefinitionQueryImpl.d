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

/**
 * @author Tom Baeyens
 * @author Joram Barrez
 * @author Daniel Meyer
 * @author Saeid Mirzaei
 */
class ProcessDefinitionQueryImpl extends AbstractQuery<ProcessDefinitionQuery, ProcessDefinition> implements ProcessDefinitionQuery {

    private static final long serialVersionUID = 1L;
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
    protected Integer version;
    protected Integer versionGt;
    protected Integer versionGte;
    protected Integer versionLt;
    protected Integer versionLte;
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

    public ProcessDefinitionQueryImpl() {
    }

    public ProcessDefinitionQueryImpl(CommandContext commandContext) {
        super(commandContext);
    }

    public ProcessDefinitionQueryImpl(CommandExecutor commandExecutor) {
        super(commandExecutor);
    }

    @Override
    public ProcessDefinitionQueryImpl processDefinitionId(string processDefinitionId) {
        this.id = processDefinitionId;
        return this;
    }

    @Override
    public ProcessDefinitionQuery processDefinitionIds(Set!string processDefinitionIds) {
        this.ids = processDefinitionIds;
        return this;
    }

    @Override
    public ProcessDefinitionQueryImpl processDefinitionCategory(string category) {
        if (category is null) {
            throw new FlowableIllegalArgumentException("category is null");
        }
        this.category = category;
        return this;
    }

    @Override
    public ProcessDefinitionQueryImpl processDefinitionCategoryLike(string categoryLike) {
        if (categoryLike is null) {
            throw new FlowableIllegalArgumentException("categoryLike is null");
        }
        this.categoryLike = categoryLike;
        return this;
    }

    @Override
    public ProcessDefinitionQueryImpl processDefinitionCategoryNotEquals(string categoryNotEquals) {
        if (categoryNotEquals is null) {
            throw new FlowableIllegalArgumentException("categoryNotEquals is null");
        }
        this.categoryNotEquals = categoryNotEquals;
        return this;
    }

    @Override
    public ProcessDefinitionQueryImpl processDefinitionName(string name) {
        if (name is null) {
            throw new FlowableIllegalArgumentException("name is null");
        }
        this.name = name;
        return this;
    }

    @Override
    public ProcessDefinitionQueryImpl processDefinitionNameLike(string nameLike) {
        if (nameLike is null) {
            throw new FlowableIllegalArgumentException("nameLike is null");
        }
        this.nameLike = nameLike;
        return this;
    }

    @Override
    public ProcessDefinitionQueryImpl deploymentId(string deploymentId) {
        if (deploymentId is null) {
            throw new FlowableIllegalArgumentException("id is null");
        }
        this.deploymentId = deploymentId;
        return this;
    }

    @Override
    public ProcessDefinitionQueryImpl deploymentIds(Set!string deploymentIds) {
        if (deploymentIds is null) {
            throw new FlowableIllegalArgumentException("ids are null");
        }
        this.deploymentIds = deploymentIds;
        return this;
    }

    @Override
    public ProcessDefinitionQueryImpl processDefinitionKey(string key) {
        if (key is null) {
            throw new FlowableIllegalArgumentException("key is null");
        }
        this.key = key;
        return this;
    }

    @Override
    public ProcessDefinitionQueryImpl processDefinitionKeyLike(string keyLike) {
        if (keyLike is null) {
            throw new FlowableIllegalArgumentException("keyLike is null");
        }
        this.keyLike = keyLike;
        return this;
    }

    @Override
    public ProcessDefinitionQueryImpl processDefinitionResourceName(string resourceName) {
        if (resourceName is null) {
            throw new FlowableIllegalArgumentException("resourceName is null");
        }
        this.resourceName = resourceName;
        return this;
    }

    @Override
    public ProcessDefinitionQueryImpl processDefinitionResourceNameLike(string resourceNameLike) {
        if (resourceNameLike is null) {
            throw new FlowableIllegalArgumentException("resourceNameLike is null");
        }
        this.resourceNameLike = resourceNameLike;
        return this;
    }

    @Override
    public ProcessDefinitionQueryImpl processDefinitionVersion(Integer version) {
        checkVersion(version);
        this.version = version;
        return this;
    }

    @Override
    public ProcessDefinitionQuery processDefinitionVersionGreaterThan(Integer processDefinitionVersion) {
        checkVersion(processDefinitionVersion);
        this.versionGt = processDefinitionVersion;
        return this;
    }

    @Override
    public ProcessDefinitionQuery processDefinitionVersionGreaterThanOrEquals(Integer processDefinitionVersion) {
        checkVersion(processDefinitionVersion);
        this.versionGte = processDefinitionVersion;
        return this;
    }

    @Override
    public ProcessDefinitionQuery processDefinitionVersionLowerThan(Integer processDefinitionVersion) {
        checkVersion(processDefinitionVersion);
        this.versionLt = processDefinitionVersion;
        return this;
    }

    @Override
    public ProcessDefinitionQuery processDefinitionVersionLowerThanOrEquals(Integer processDefinitionVersion) {
        checkVersion(processDefinitionVersion);
        this.versionLte = processDefinitionVersion;
        return this;
    }

    protected void checkVersion(Integer version) {
        if (version is null) {
            throw new FlowableIllegalArgumentException("version is null");
        } else if (version <= 0) {
            throw new FlowableIllegalArgumentException("version must be positive");
        }
    }

    @Override
    public ProcessDefinitionQueryImpl latestVersion() {
        this.latest = true;
        return this;
    }

    @Override
    public ProcessDefinitionQuery active() {
        this.suspensionState = SuspensionState.ACTIVE;
        return this;
    }

    @Override
    public ProcessDefinitionQuery suspended() {
        this.suspensionState = SuspensionState.SUSPENDED;
        return this;
    }

    @Override
    public ProcessDefinitionQuery processDefinitionTenantId(string tenantId) {
        if (tenantId is null) {
            throw new FlowableIllegalArgumentException("processDefinition tenantId is null");
        }
        this.tenantId = tenantId;
        return this;
    }

    @Override
    public ProcessDefinitionQuery processDefinitionTenantIdLike(string tenantIdLike) {
        if (tenantIdLike is null) {
            throw new FlowableIllegalArgumentException("process definition tenantId is null");
        }
        this.tenantIdLike = tenantIdLike;
        return this;
    }

    @Override
    public ProcessDefinitionQuery processDefinitionWithoutTenantId() {
        this.withoutTenantId = true;
        return this;
    }

    @Override
    public ProcessDefinitionQuery processDefinitionEngineVersion(string engineVersion) {
        this.engineVersion = engineVersion;
        return this;
    }

    public ProcessDefinitionQuery messageEventSubscription(string messageName) {
        return eventSubscription("message", messageName);
    }

    @Override
    public ProcessDefinitionQuery messageEventSubscriptionName(string messageName) {
        return eventSubscription("message", messageName);
    }

    @Override
    public ProcessDefinitionQuery locale(string locale) {
        this.locale = locale;
        return this;
    }

    @Override
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

    @Override
    public ProcessDefinitionQueryImpl startableByUser(string userId) {
        if (userId is null) {
            throw new FlowableIllegalArgumentException("userId is null");
        }
        this.authorizationUserId = userId;
        return this;
    }

    @Override
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

    @Override
    public ProcessDefinitionQuery orderByDeploymentId() {
        return orderBy(ProcessDefinitionQueryProperty.DEPLOYMENT_ID);
    }

    @Override
    public ProcessDefinitionQuery orderByProcessDefinitionKey() {
        return orderBy(ProcessDefinitionQueryProperty.PROCESS_DEFINITION_KEY);
    }

    @Override
    public ProcessDefinitionQuery orderByProcessDefinitionCategory() {
        return orderBy(ProcessDefinitionQueryProperty.PROCESS_DEFINITION_CATEGORY);
    }

    @Override
    public ProcessDefinitionQuery orderByProcessDefinitionId() {
        return orderBy(ProcessDefinitionQueryProperty.PROCESS_DEFINITION_ID);
    }

    @Override
    public ProcessDefinitionQuery orderByProcessDefinitionVersion() {
        return orderBy(ProcessDefinitionQueryProperty.PROCESS_DEFINITION_VERSION);
    }

    @Override
    public ProcessDefinitionQuery orderByProcessDefinitionName() {
        return orderBy(ProcessDefinitionQueryProperty.PROCESS_DEFINITION_NAME);
    }

    @Override
    public ProcessDefinitionQuery orderByTenantId() {
        return orderBy(ProcessDefinitionQueryProperty.PROCESS_DEFINITION_TENANT_ID);
    }

    // results ////////////////////////////////////////////

    @Override
    public long executeCount(CommandContext commandContext) {
        return CommandContextUtil.getProcessDefinitionEntityManager(commandContext).findProcessDefinitionCountByQueryCriteria(this);
    }

    @Override
    public List<ProcessDefinition> executeList(CommandContext commandContext) {
        ProcessEngineConfigurationImpl processEngineConfiguration = CommandContextUtil.getProcessEngineConfiguration(commandContext);

        List<ProcessDefinition> processDefinitions = CommandContextUtil.getProcessDefinitionEntityManager(commandContext).findProcessDefinitionsByQueryCriteria(this);

        if (processDefinitions !is null && processEngineConfiguration.getPerformanceSettings().isEnableLocalization() && processEngineConfiguration.getInternalProcessDefinitionLocalizationManager() !is null) {
            for (ProcessDefinition processDefinition : processDefinitions) {
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

    public Integer getVersion() {
        return version;
    }

    public Integer getVersionGt() {
        return versionGt;
    }

    public Integer getVersionGte() {
        return versionGte;
    }

    public Integer getVersionLt() {
        return versionLt;
    }

    public Integer getVersionLte() {
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
