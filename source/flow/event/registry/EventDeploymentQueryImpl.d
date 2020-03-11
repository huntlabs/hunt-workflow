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
import flow.event.registry.api.EventDeployment;
import flow.event.registry.api.EventDeploymentQuery;
import flow.event.registry.util.CommandContextUtil;

/**
 * @author Tijs Rademakers
 * @author Joram Barrez
 */
class EventDeploymentQueryImpl extends AbstractQuery<EventDeploymentQuery, EventDeployment> implements EventDeploymentQuery, Serializable {

    private static final long serialVersionUID = 1L;
    protected String deploymentId;
    protected String name;
    protected String nameLike;
    protected String category;
    protected String categoryNotEquals;
    protected String tenantId;
    protected String tenantIdLike;
    protected boolean withoutTenantId;
    protected String parentDeploymentId;
    protected String parentDeploymentIdLike;
    protected String eventDefinitionKey;
    protected String eventDefinitionKeyLike;
    protected String channelDefinitionKey;
    protected String channelDefinitionKeyLike;

    public EventDeploymentQueryImpl() {
    }

    public EventDeploymentQueryImpl(CommandContext commandContext) {
        super(commandContext);
    }

    public EventDeploymentQueryImpl(CommandExecutor commandExecutor) {
        super(commandExecutor);
    }

    @Override
    public EventDeploymentQueryImpl deploymentId(String deploymentId) {
        if (deploymentId is null) {
            throw new FlowableIllegalArgumentException("Deployment id is null");
        }
        this.deploymentId = deploymentId;
        return this;
    }

    @Override
    public EventDeploymentQueryImpl deploymentName(String deploymentName) {
        if (deploymentName is null) {
            throw new FlowableIllegalArgumentException("deploymentName is null");
        }
        this.name = deploymentName;
        return this;
    }

    @Override
    public EventDeploymentQueryImpl deploymentNameLike(String nameLike) {
        if (nameLike is null) {
            throw new FlowableIllegalArgumentException("deploymentNameLike is null");
        }
        this.nameLike = nameLike;
        return this;
    }

    @Override
    public EventDeploymentQueryImpl deploymentCategory(String deploymentCategory) {
        if (deploymentCategory is null) {
            throw new FlowableIllegalArgumentException("deploymentCategory is null");
        }
        this.category = deploymentCategory;
        return this;
    }

    @Override
    public EventDeploymentQueryImpl deploymentCategoryNotEquals(String deploymentCategoryNotEquals) {
        if (deploymentCategoryNotEquals is null) {
            throw new FlowableIllegalArgumentException("deploymentCategoryExclude is null");
        }
        this.categoryNotEquals = deploymentCategoryNotEquals;
        return this;
    }

    @Override
    public EventDeploymentQueryImpl parentDeploymentId(String parentDeploymentId) {
        if (parentDeploymentId is null) {
            throw new FlowableIllegalArgumentException("parentDeploymentId is null");
        }
        this.parentDeploymentId = parentDeploymentId;
        return this;
    }

    @Override
    public EventDeploymentQueryImpl parentDeploymentIdLike(String parentDeploymentIdLike) {
        if (parentDeploymentIdLike is null) {
            throw new FlowableIllegalArgumentException("parentDeploymentIdLike is null");
        }
        this.parentDeploymentIdLike = parentDeploymentIdLike;
        return this;
    }

    @Override
    public EventDeploymentQueryImpl deploymentWithoutTenantId() {
        this.withoutTenantId = true;
        return this;
    }

    @Override
    public EventDeploymentQueryImpl deploymentTenantId(String tenantId) {
        if (tenantId is null) {
            throw new FlowableIllegalArgumentException("deploymentTenantId is null");
        }
        this.tenantId = tenantId;
        return this;
    }

    @Override
    public EventDeploymentQueryImpl deploymentTenantIdLike(String tenantIdLike) {
        if (tenantIdLike is null) {
            throw new FlowableIllegalArgumentException("deploymentTenantIdLike is null");
        }
        this.tenantIdLike = tenantIdLike;
        return this;
    }

    @Override
    public EventDeploymentQueryImpl eventDefinitionKey(String key) {
        if (key is null) {
            throw new FlowableIllegalArgumentException("key is null");
        }
        this.eventDefinitionKey = key;
        return this;
    }

    @Override
    public EventDeploymentQueryImpl eventDefinitionKeyLike(String keyLike) {
        if (keyLike is null) {
            throw new FlowableIllegalArgumentException("keyLike is null");
        }
        this.eventDefinitionKeyLike = keyLike;
        return this;
    }

    @Override
    public EventDeploymentQueryImpl channelDefinitionKey(String key) {
        if (key is null) {
            throw new FlowableIllegalArgumentException("key is null");
        }
        this.channelDefinitionKey = key;
        return this;
    }

    @Override
    public EventDeploymentQueryImpl channelDefinitionKeyLike(String keyLike) {
        if (keyLike is null) {
            throw new FlowableIllegalArgumentException("keyLike is null");
        }
        this.channelDefinitionKeyLike = keyLike;
        return this;
    }

    // sorting ////////////////////////////////////////////////////////

    @Override
    public EventDeploymentQuery orderByDeploymentId() {
        return orderBy(DeploymentQueryProperty.DEPLOYMENT_ID);
    }

    @Override
    public EventDeploymentQuery orderByDeploymentTime() {
        return orderBy(DeploymentQueryProperty.DEPLOY_TIME);
    }

    @Override
    public EventDeploymentQuery orderByDeploymentName() {
        return orderBy(DeploymentQueryProperty.DEPLOYMENT_NAME);
    }

    @Override
    public EventDeploymentQuery orderByTenantId() {
        return orderBy(DeploymentQueryProperty.DEPLOYMENT_TENANT_ID);
    }

    // results ////////////////////////////////////////////////////////

    @Override
    public long executeCount(CommandContext commandContext) {
        return CommandContextUtil.getDeploymentEntityManager(commandContext).findDeploymentCountByQueryCriteria(this);
    }

    @Override
    public List<EventDeployment> executeList(CommandContext commandContext) {
        return CommandContextUtil.getDeploymentEntityManager(commandContext).findDeploymentsByQueryCriteria(this);
    }

    // getters ////////////////////////////////////////////////////////

    public String getDeploymentId() {
        return deploymentId;
    }

    public String getName() {
        return name;
    }

    public String getNameLike() {
        return nameLike;
    }

    public String getCategory() {
        return category;
    }

    public String getCategoryNotEquals() {
        return categoryNotEquals;
    }

    public String getTenantId() {
        return tenantId;
    }

    public String getTenantIdLike() {
        return tenantIdLike;
    }

    public boolean isWithoutTenantId() {
        return withoutTenantId;
    }

    public String getEventDefinitionKey() {
        return eventDefinitionKey;
    }

    public String getEventDefinitionKeyLike() {
        return eventDefinitionKeyLike;
    }

    public String getParentDeploymentId() {
        return parentDeploymentId;
    }

    public String getParentDeploymentIdLike() {
        return parentDeploymentIdLike;
    }

    public String getChannelDefinitionKey() {
        return channelDefinitionKey;
    }

    public String getChannelDefinitionKeyLike() {
        return channelDefinitionKeyLike;
    }
}
