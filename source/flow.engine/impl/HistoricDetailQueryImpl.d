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



import hunt.collection.List;

import flow.common.query.AbstractQuery;
import flow.common.interceptor.CommandContext;
import flow.common.interceptor.CommandExecutor;
import flow.engine.history.HistoricDetail;
import flow.engine.history.HistoricDetailQuery;
import flow.engine.impl.persistence.entity.HistoricDetailVariableInstanceUpdateEntity;
import flow.engine.impl.util.CommandContextUtil;
import flow.variable.service.impl.types.HistoricJPAEntityListVariableType;
import flow.variable.service.impl.types.HistoricJPAEntityVariableType;
import flow.variable.service.impl.types.JPAEntityListVariableType;
import flow.variable.service.impl.types.JPAEntityVariableType;

/**
 * @author Tom Baeyens
 * @author Joram Barrez
 */
class HistoricDetailQueryImpl : AbstractQuery!(HistoricDetailQuery, HistoricDetail) implements HistoricDetailQuery {

    private static final long serialVersionUID = 1L;
    protected string id;
    protected string taskId;
    protected string processInstanceId;
    protected string executionId;
    protected string activityId;
    protected string activityInstanceId;
    protected string type;
    protected bool excludeTaskRelated;

    public HistoricDetailQueryImpl() {
    }

    public HistoricDetailQueryImpl(CommandContext commandContext) {
        super(commandContext);
    }

    public HistoricDetailQueryImpl(CommandExecutor commandExecutor) {
        super(commandExecutor);
    }

    override
    public HistoricDetailQueryImpl id(string id) {
        this.id = id;
        return this;
    }

    override
    public HistoricDetailQueryImpl processInstanceId(string processInstanceId) {
        this.processInstanceId = processInstanceId;
        return this;
    }

    override
    public HistoricDetailQueryImpl executionId(string executionId) {
        this.executionId = executionId;
        return this;
    }

    public HistoricDetailQueryImpl activityId(string activityId) {
        this.activityId = activityId;
        return this;
    }

    override
    public HistoricDetailQueryImpl activityInstanceId(string activityInstanceId) {
        this.activityInstanceId = activityInstanceId;
        return this;
    }

    override
    public HistoricDetailQueryImpl taskId(string taskId) {
        this.taskId = taskId;
        return this;
    }

    override
    public HistoricDetailQueryImpl formProperties() {
        this.type = "FormProperty";
        return this;
    }

    override
    public HistoricDetailQueryImpl variableUpdates() {
        this.type = "VariableUpdate";
        return this;
    }

    override
    public HistoricDetailQueryImpl excludeTaskDetails() {
        this.excludeTaskRelated = true;
        return this;
    }

    override
    public long executeCount(CommandContext commandContext) {
        return CommandContextUtil.getHistoricDetailEntityManager(commandContext).findHistoricDetailCountByQueryCriteria(this);
    }

    override
    public List!HistoricDetail executeList(CommandContext commandContext) {
        List!HistoricDetail historicDetails = CommandContextUtil.getHistoricDetailEntityManager(commandContext).findHistoricDetailsByQueryCriteria(this);

        HistoricDetailVariableInstanceUpdateEntity varUpdate = null;
        if (historicDetails !is null) {
            for (HistoricDetail historicDetail : historicDetails) {
                if (historicDetail instanceof HistoricDetailVariableInstanceUpdateEntity) {
                    varUpdate = (HistoricDetailVariableInstanceUpdateEntity) historicDetail;

                    // Touch byte-array to ensure initialized inside context
                    // TODO there should be a generic way to initialize variable
                    // values
                    varUpdate.getBytes();

                    // ACT-863: EntityManagerFactorySession instance needed for
                    // fetching value, touch while inside context to store
                    // cached value
                    if (varUpdate.getVariableType() instanceof JPAEntityVariableType) {
                        // Use HistoricJPAEntityVariableType to force caching of
                        // value to return from query
                        varUpdate.setVariableType(HistoricJPAEntityVariableType.getSharedInstance());
                        varUpdate.getValue();
                    } else if (varUpdate.getVariableType() instanceof JPAEntityListVariableType) {
                        // Use HistoricJPAEntityListVariableType to force
                        // caching of list to return from query
                        varUpdate.setVariableType(HistoricJPAEntityListVariableType.getSharedInstance());
                        varUpdate.getValue();
                    }
                }
            }
        }
        return historicDetails;
    }

    // order by
    // /////////////////////////////////////////////////////////////////

    override
    public HistoricDetailQueryImpl orderByProcessInstanceId() {
        orderBy(HistoricDetailQueryProperty.PROCESS_INSTANCE_ID);
        return this;
    }

    override
    public HistoricDetailQueryImpl orderByTime() {
        orderBy(HistoricDetailQueryProperty.TIME);
        return this;
    }

    override
    public HistoricDetailQueryImpl orderByVariableName() {
        orderBy(HistoricDetailQueryProperty.VARIABLE_NAME);
        return this;
    }

    override
    public HistoricDetailQueryImpl orderByFormPropertyId() {
        orderBy(HistoricDetailQueryProperty.VARIABLE_NAME);
        return this;
    }

    override
    public HistoricDetailQueryImpl orderByVariableRevision() {
        orderBy(HistoricDetailQueryProperty.VARIABLE_REVISION);
        return this;
    }

    override
    public HistoricDetailQueryImpl orderByVariableType() {
        orderBy(HistoricDetailQueryProperty.VARIABLE_TYPE);
        return this;
    }

    // getters and setters
    // //////////////////////////////////////////////////////

    public string getId() {
        return id;
    }

    public string getProcessInstanceId() {
        return processInstanceId;
    }

    public string getTaskId() {
        return taskId;
    }

    public string getActivityId() {
        return activityId;
    }

    public string getType() {
        return type;
    }

    public bool getExcludeTaskRelated() {
        return excludeTaskRelated;
    }

    public string getExecutionId() {
        return executionId;
    }

    public string getActivityInstanceId() {
        return activityInstanceId;
    }

}
