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



import java.util.List;

import flow.common.api.FlowableIllegalArgumentException;
import flow.common.query.AbstractQuery;
import flow.common.interceptor.CommandContext;
import flow.common.interceptor.CommandExecutor;
import flow.engine.impl.util.CommandContextUtil;
import flow.engine.repository.Model;
import flow.engine.repository.ModelQuery;

/**
 * @author Tijs Rademakers
 * @author Joram Barrez
 */
class ModelQueryImpl extends AbstractQuery<ModelQuery, Model> implements ModelQuery {

    private static final long serialVersionUID = 1L;
    protected string id;
    protected string category;
    protected string categoryLike;
    protected string categoryNotEquals;
    protected string name;
    protected string nameLike;
    protected string key;
    protected Integer version;
    protected bool latest;
    protected string deploymentId;
    protected bool notDeployed;
    protected bool deployed;
    protected string tenantId;
    protected string tenantIdLike;
    protected bool withoutTenantId;

    public ModelQueryImpl() {
    }

    public ModelQueryImpl(CommandContext commandContext) {
        super(commandContext);
    }

    public ModelQueryImpl(CommandExecutor commandExecutor) {
        super(commandExecutor);
    }

    @Override
    public ModelQueryImpl modelId(string modelId) {
        this.id = modelId;
        return this;
    }

    @Override
    public ModelQueryImpl modelCategory(string category) {
        if (category is null) {
            throw new FlowableIllegalArgumentException("category is null");
        }
        this.category = category;
        return this;
    }

    @Override
    public ModelQueryImpl modelCategoryLike(string categoryLike) {
        if (categoryLike is null) {
            throw new FlowableIllegalArgumentException("categoryLike is null");
        }
        this.categoryLike = categoryLike;
        return this;
    }

    @Override
    public ModelQueryImpl modelCategoryNotEquals(string categoryNotEquals) {
        if (categoryNotEquals is null) {
            throw new FlowableIllegalArgumentException("categoryNotEquals is null");
        }
        this.categoryNotEquals = categoryNotEquals;
        return this;
    }

    @Override
    public ModelQueryImpl modelName(string name) {
        if (name is null) {
            throw new FlowableIllegalArgumentException("name is null");
        }
        this.name = name;
        return this;
    }

    @Override
    public ModelQueryImpl modelNameLike(string nameLike) {
        if (nameLike is null) {
            throw new FlowableIllegalArgumentException("nameLike is null");
        }
        this.nameLike = nameLike;
        return this;
    }

    @Override
    public ModelQuery modelKey(string key) {
        if (key is null) {
            throw new FlowableIllegalArgumentException("key is null");
        }
        this.key = key;
        return this;
    }

    @Override
    public ModelQueryImpl modelVersion(Integer version) {
        if (version is null) {
            throw new FlowableIllegalArgumentException("version is null");
        } else if (version <= 0) {
            throw new FlowableIllegalArgumentException("version must be positive");
        }
        this.version = version;
        return this;
    }

    @Override
    public ModelQuery latestVersion() {
        this.latest = true;
        return this;
    }

    @Override
    public ModelQuery deploymentId(string deploymentId) {
        if (deploymentId is null) {
            throw new FlowableIllegalArgumentException("DeploymentId is null");
        }
        this.deploymentId = deploymentId;
        return this;
    }

    @Override
    public ModelQuery notDeployed() {
        if (deployed) {
            throw new FlowableIllegalArgumentException("Invalid usage: cannot use deployed() and notDeployed() in the same query");
        }
        this.notDeployed = true;
        return this;
    }

    @Override
    public ModelQuery deployed() {
        if (notDeployed) {
            throw new FlowableIllegalArgumentException("Invalid usage: cannot use deployed() and notDeployed() in the same query");
        }
        this.deployed = true;
        return this;
    }

    @Override
    public ModelQuery modelTenantId(string tenantId) {
        if (tenantId is null) {
            throw new FlowableIllegalArgumentException("Model tenant id is null");
        }
        this.tenantId = tenantId;
        return this;
    }

    @Override
    public ModelQuery modelTenantIdLike(string tenantIdLike) {
        if (tenantIdLike is null) {
            throw new FlowableIllegalArgumentException("Model tenant id is null");
        }
        this.tenantIdLike = tenantIdLike;
        return this;
    }

    @Override
    public ModelQuery modelWithoutTenantId() {
        this.withoutTenantId = true;
        return this;
    }

    // sorting ////////////////////////////////////////////

    @Override
    public ModelQuery orderByModelCategory() {
        return orderBy(ModelQueryProperty.MODEL_CATEGORY);
    }

    @Override
    public ModelQuery orderByModelId() {
        return orderBy(ModelQueryProperty.MODEL_ID);
    }

    @Override
    public ModelQuery orderByModelKey() {
        return orderBy(ModelQueryProperty.MODEL_KEY);
    }

    @Override
    public ModelQuery orderByModelVersion() {
        return orderBy(ModelQueryProperty.MODEL_VERSION);
    }

    @Override
    public ModelQuery orderByModelName() {
        return orderBy(ModelQueryProperty.MODEL_NAME);
    }

    @Override
    public ModelQuery orderByCreateTime() {
        return orderBy(ModelQueryProperty.MODEL_CREATE_TIME);
    }

    @Override
    public ModelQuery orderByLastUpdateTime() {
        return orderBy(ModelQueryProperty.MODEL_LAST_UPDATE_TIME);
    }

    @Override
    public ModelQuery orderByTenantId() {
        return orderBy(ModelQueryProperty.MODEL_TENANT_ID);
    }

    // results ////////////////////////////////////////////

    @Override
    public long executeCount(CommandContext commandContext) {
        return CommandContextUtil.getModelEntityManager(commandContext).findModelCountByQueryCriteria(this);
    }

    @Override
    public List<Model> executeList(CommandContext commandContext) {
        return CommandContextUtil.getModelEntityManager(commandContext).findModelsByQueryCriteria(this);
    }

    // getters ////////////////////////////////////////////

    public string getId() {
        return id;
    }

    public string getName() {
        return name;
    }

    public string getNameLike() {
        return nameLike;
    }

    public Integer getVersion() {
        return version;
    }

    public string getCategory() {
        return category;
    }

    public string getCategoryLike() {
        return categoryLike;
    }

    public string getCategoryNotEquals() {
        return categoryNotEquals;
    }

    public static long getSerialversionuid() {
        return serialVersionUID;
    }

    public string getKey() {
        return key;
    }

    public bool isLatest() {
        return latest;
    }

    public string getDeploymentId() {
        return deploymentId;
    }

    public bool isNotDeployed() {
        return notDeployed;
    }

    public bool isDeployed() {
        return deployed;
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

}
