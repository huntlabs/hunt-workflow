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

module flow.engine.impl.ModelQueryImpl;

import hunt.collection.List;

import flow.common.api.FlowableIllegalArgumentException;
import flow.common.query.AbstractQuery;
import flow.common.interceptor.CommandContext;
import flow.common.interceptor.CommandExecutor;
import flow.engine.impl.util.CommandContextUtil;
import flow.engine.repository.Model;
import flow.engine.repository.ModelQuery;
import flow.engine.impl.ModelQueryProperty;
/**
 * @author Tijs Rademakers
 * @author Joram Barrez
 */
class ModelQueryImpl : AbstractQuery!(ModelQuery, Model) , ModelQuery {

    protected string id;
    protected string category;
    protected string categoryLike;
    protected string categoryNotEquals;
    protected string name;
    protected string nameLike;
    protected string key;
    protected int ver;
    protected bool latest;
    protected string _deploymentId;
    protected bool _notDeployed;
    protected bool _deployed;
    protected string tenantId;
    protected string tenantIdLike;
    protected bool withoutTenantId;

    this() {
    }

    this(CommandContext commandContext) {
        super(commandContext);
    }

    this(CommandExecutor commandExecutor) {
        super(commandExecutor);
    }


    public ModelQueryImpl modelId(string modelId) {
        this.id = modelId;
        return this;
    }


    public ModelQueryImpl modelCategory(string category) {
        if (category is null) {
            throw new FlowableIllegalArgumentException("category is null");
        }
        this.category = category;
        return this;
    }


    public ModelQueryImpl modelCategoryLike(string categoryLike) {
        if (categoryLike is null) {
            throw new FlowableIllegalArgumentException("categoryLike is null");
        }
        this.categoryLike = categoryLike;
        return this;
    }


    public ModelQueryImpl modelCategoryNotEquals(string categoryNotEquals) {
        if (categoryNotEquals is null) {
            throw new FlowableIllegalArgumentException("categoryNotEquals is null");
        }
        this.categoryNotEquals = categoryNotEquals;
        return this;
    }


    public ModelQueryImpl modelName(string name) {
        if (name is null) {
            throw new FlowableIllegalArgumentException("name is null");
        }
        this.name = name;
        return this;
    }


    public ModelQueryImpl modelNameLike(string nameLike) {
        if (nameLike is null) {
            throw new FlowableIllegalArgumentException("nameLike is null");
        }
        this.nameLike = nameLike;
        return this;
    }


    public ModelQuery modelKey(string key) {
        if (key is null) {
            throw new FlowableIllegalArgumentException("key is null");
        }
        this.key = key;
        return this;
    }


    public ModelQueryImpl modelVersion(int ver) {
        //if (version is null) {
        //    throw new FlowableIllegalArgumentException("version is null");
        //} else if (version <= 0) {
        //    throw new FlowableIllegalArgumentException("version must be positive");
        //}
        this.ver = ver;
        return this;
    }


    public ModelQuery latestVersion() {
        this.latest = true;
        return this;
    }


    public ModelQuery deploymentId(string deploymentId) {
        if (deploymentId is null) {
            throw new FlowableIllegalArgumentException("DeploymentId is null");
        }
        this._deploymentId = deploymentId;
        return this;
    }


    public ModelQuery notDeployed() {
        if (_deployed) {
            throw new FlowableIllegalArgumentException("Invalid usage: cannot use deployed() and notDeployed() in the same query");
        }
        this._notDeployed = true;
        return this;
    }


    public ModelQuery deployed() {
        if (_notDeployed) {
            throw new FlowableIllegalArgumentException("Invalid usage: cannot use deployed() and notDeployed() in the same query");
        }
        this._deployed = true;
        return this;
    }


    public ModelQuery modelTenantId(string tenantId) {
        if (tenantId is null) {
            throw new FlowableIllegalArgumentException("Model tenant id is null");
        }
        this.tenantId = tenantId;
        return this;
    }


    public ModelQuery modelTenantIdLike(string tenantIdLike) {
        if (tenantIdLike is null) {
            throw new FlowableIllegalArgumentException("Model tenant id is null");
        }
        this.tenantIdLike = tenantIdLike;
        return this;
    }


    public ModelQuery modelWithoutTenantId() {
        this.withoutTenantId = true;
        return this;
    }

    // sorting ////////////////////////////////////////////


    public ModelQuery orderByModelCategory() {
        return orderBy(ModelQueryProperty.MODEL_CATEGORY);
    }


    public ModelQuery orderByModelId() {
        return orderBy(ModelQueryProperty.MODEL_ID);
    }


    public ModelQuery orderByModelKey() {
        return orderBy(ModelQueryProperty.MODEL_KEY);
    }


    public ModelQuery orderByModelVersion() {
        return orderBy(ModelQueryProperty.MODEL_VERSION);
    }


    public ModelQuery orderByModelName() {
        return orderBy(ModelQueryProperty.MODEL_NAME);
    }


    public ModelQuery orderByCreateTime() {
        return orderBy(ModelQueryProperty.MODEL_CREATE_TIME);
    }


    public ModelQuery orderByLastUpdateTime() {
        return orderBy(ModelQueryProperty.MODEL_LAST_UPDATE_TIME);
    }


    public ModelQuery orderByTenantId() {
        return orderBy(ModelQueryProperty.MODEL_TENANT_ID);
    }

    // results ////////////////////////////////////////////

    override
    public long executeCount(CommandContext commandContext) {
        return CommandContextUtil.getModelEntityManager(commandContext).findModelCountByQueryCriteria(this);
    }

    override
    public List!Model executeList(CommandContext commandContext) {
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

    public int getVersion() {
        return ver;
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
      return 0;
    }

    public string getKey() {
        return key;
    }

    public bool isLatest() {
        return latest;
    }

    public string getDeploymentId() {
        return _deploymentId;
    }

    public bool isNotDeployed() {
        return _notDeployed;
    }

    public bool isDeployed() {
        return _deployed;
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
