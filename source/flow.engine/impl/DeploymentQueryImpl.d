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



import java.io.Serializable;
import hunt.collection.List;

import flow.common.api.FlowableIllegalArgumentException;
import flow.common.interceptor.CommandContext;
import flow.common.interceptor.CommandExecutor;
import flow.common.query.AbstractQuery;
import flow.engine.impl.util.CommandContextUtil;
import flow.engine.repository.Deployment;
import flow.engine.repository.DeploymentQuery;

/**
 * @author Tom Baeyens
 * @author Joram Barrez
 */
class DeploymentQueryImpl extends AbstractQuery<DeploymentQuery, Deployment> implements DeploymentQuery, Serializable {

    private static final long serialVersionUID = 1L;
    protected string deploymentId;
    protected List!string deploymentIds;
    protected string name;
    protected string nameLike;
    protected string category;
    protected string categoryLike;
    protected string categoryNotEquals;
    protected string key;
    protected string keyLike;
    protected string tenantId;
    protected string tenantIdLike;
    protected bool withoutTenantId;
    protected string engineVersion;
    protected string derivedFrom;
    protected string parentDeploymentId;
    protected string parentDeploymentIdLike;
    protected List!string parentDeploymentIds;
    protected string processDefinitionKey;
    protected string processDefinitionKeyLike;
    protected bool latest;

    public DeploymentQueryImpl() {
    }

    public DeploymentQueryImpl(CommandContext commandContext) {
        super(commandContext);
    }

    public DeploymentQueryImpl(CommandExecutor commandExecutor) {
        super(commandExecutor);
    }

    @Override
    public DeploymentQueryImpl deploymentId(string deploymentId) {
        if (deploymentId is null) {
            throw new FlowableIllegalArgumentException("Deployment id is null");
        }
        this.deploymentId = deploymentId;
        return this;
    }

    @Override
    public DeploymentQueryImpl deploymentIds(List!string deploymentIds) {
        if (deploymentIds is null) {
            throw new FlowableIllegalArgumentException("Deployment ids is null");
        }
        this.deploymentIds = deploymentIds;
        return this;
    }

    @Override
    public DeploymentQueryImpl deploymentName(string deploymentName) {
        if (deploymentName is null) {
            throw new FlowableIllegalArgumentException("deploymentName is null");
        }
        this.name = deploymentName;
        return this;
    }

    @Override
    public DeploymentQueryImpl deploymentNameLike(string nameLike) {
        if (nameLike is null) {
            throw new FlowableIllegalArgumentException("deploymentNameLike is null");
        }
        this.nameLike = nameLike;
        return this;
    }

    @Override
    public DeploymentQueryImpl deploymentCategory(string deploymentCategory) {
        if (deploymentCategory is null) {
            throw new FlowableIllegalArgumentException("deploymentCategory is null");
        }
        this.category = deploymentCategory;
        return this;
    }

    @Override
    public DeploymentQueryImpl deploymentCategoryLike(string categoryLike) {
        if (categoryLike is null) {
            throw new FlowableIllegalArgumentException("deploymentCategoryLike is null");
        }
        this.categoryLike = categoryLike;
        return this;
    }

    @Override
    public DeploymentQueryImpl deploymentCategoryNotEquals(string deploymentCategoryNotEquals) {
        if (deploymentCategoryNotEquals is null) {
            throw new FlowableIllegalArgumentException("deploymentCategoryExclude is null");
        }
        this.categoryNotEquals = deploymentCategoryNotEquals;
        return this;
    }

    @Override
    public DeploymentQueryImpl deploymentKey(string deploymentKey) {
        if (deploymentKey is null) {
            throw new FlowableIllegalArgumentException("deploymentKey is null");
        }
        this.key = deploymentKey;
        return this;
    }

    @Override
    public DeploymentQueryImpl deploymentKeyLike(string deploymentKeyLike) {
        if (deploymentKeyLike is null) {
            throw new FlowableIllegalArgumentException("deploymentKeyLike is null");
        }
        this.keyLike = deploymentKeyLike;
        return this;
    }

    @Override
    public DeploymentQueryImpl deploymentTenantId(string tenantId) {
        if (tenantId is null) {
            throw new FlowableIllegalArgumentException("deploymentTenantId is null");
        }
        this.tenantId = tenantId;
        return this;
    }

    @Override
    public DeploymentQueryImpl deploymentTenantIdLike(string tenantIdLike) {
        if (tenantIdLike is null) {
            throw new FlowableIllegalArgumentException("deploymentTenantIdLike is null");
        }
        this.tenantIdLike = tenantIdLike;
        return this;
    }

    @Override
    public DeploymentQueryImpl deploymentWithoutTenantId() {
        this.withoutTenantId = true;
        return this;
    }

    @Override
    public DeploymentQueryImpl deploymentEngineVersion(string engineVersion) {
        this.engineVersion = engineVersion;
        return this;
    }

    @Override
    public DeploymentQuery deploymentDerivedFrom(string deploymentId) {
        this.derivedFrom = deploymentId;
        return this;
    }

    @Override
    public DeploymentQuery parentDeploymentId(string parentDeploymentId) {
        this.parentDeploymentId = parentDeploymentId;
        return this;
    }

    @Override
    public DeploymentQuery parentDeploymentIdLike(string parentDeploymentIdLike) {
        this.parentDeploymentIdLike = parentDeploymentIdLike;
        return this;
    }

    @Override
    public DeploymentQuery parentDeploymentIds(List!string parentDeploymentIds) {
        if (parentDeploymentIds is null) {
            throw new FlowableIllegalArgumentException("parentDeploymentIds is null");
        }
        this.parentDeploymentIds = parentDeploymentIds;
        return this;
    }

    @Override
    public DeploymentQueryImpl processDefinitionKey(string key) {
        if (key is null) {
            throw new FlowableIllegalArgumentException("key is null");
        }
        this.processDefinitionKey = key;
        return this;
    }

    @Override
    public DeploymentQueryImpl processDefinitionKeyLike(string keyLike) {
        if (keyLike is null) {
            throw new FlowableIllegalArgumentException("keyLike is null");
        }
        this.processDefinitionKeyLike = keyLike;
        return this;
    }

    @Override
    public DeploymentQueryImpl latest() {
        if (key is null) {
            throw new FlowableIllegalArgumentException("latest can only be used together with a deployment key");
        }

        this.latest = true;
        return this;
    }

    // sorting ////////////////////////////////////////////////////////

    @Override
    public DeploymentQuery orderByDeploymentId() {
        return orderBy(DeploymentQueryProperty.DEPLOYMENT_ID);
    }

    @Override
    public DeploymentQuery orderByDeploymentTime() {
        return orderBy(DeploymentQueryProperty.DEPLOY_TIME);
    }

    @Override
    public DeploymentQuery orderByDeploymentName() {
        return orderBy(DeploymentQueryProperty.DEPLOYMENT_NAME);
    }

    @Override
    public DeploymentQuery orderByTenantId() {
        return orderBy(DeploymentQueryProperty.DEPLOYMENT_TENANT_ID);
    }

    // results ////////////////////////////////////////////////////////

    @Override
    public long executeCount(CommandContext commandContext) {
        return CommandContextUtil.getDeploymentEntityManager(commandContext).findDeploymentCountByQueryCriteria(this);
    }

    @Override
    public List<Deployment> executeList(CommandContext commandContext) {
        return CommandContextUtil.getDeploymentEntityManager(commandContext).findDeploymentsByQueryCriteria(this);
    }

    // getters ////////////////////////////////////////////////////////

    public string getDeploymentId() {
        return deploymentId;
    }

    public List!string getDeploymentIds() {
        return deploymentIds;
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

    public string getEngineVersion() {
        return engineVersion;
    }

    public string getDerivedFrom() {
        return derivedFrom;
    }

    public string getParentDeploymentId() {
        return parentDeploymentId;
    }

    public string getProcessDefinitionKey() {
        return processDefinitionKey;
    }

    public string getProcessDefinitionKeyLike() {
        return processDefinitionKeyLike;
    }
}
