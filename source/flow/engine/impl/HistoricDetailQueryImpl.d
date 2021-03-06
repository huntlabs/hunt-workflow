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

module flow.engine.impl.HistoricDetailQueryImpl;

import hunt.collection.List;

import flow.common.query.AbstractQuery;
import flow.common.interceptor.CommandContext;
import flow.common.interceptor.CommandExecutor;
import flow.engine.history.HistoricDetail;
import flow.engine.history.HistoricDetailQuery;
import flow.engine.impl.persistence.entity.HistoricDetailVariableInstanceUpdateEntity;
import flow.engine.impl.util.CommandContextUtil;
import flow.engine.impl.HistoricDetailQueryProperty;

//import flow.variable.service.impl.types.HistoricJPAEntityListVariableType;
//import flow.variable.service.impl.types.HistoricJPAEntityVariableType;
//import flow.variable.service.impl.types.JPAEntityListVariableType;
//import flow.variable.service.impl.types.JPAEntityVariableType;

/**
 * @author Tom Baeyens
 * @author Joram Barrez
 */
class HistoricDetailQueryImpl : AbstractQuery!(HistoricDetailQuery, HistoricDetail) , HistoricDetailQuery {

    protected string _id;
    protected string _taskId;
    protected string _processInstanceId;
    protected string _executionId;
    protected string _activityId;
    protected string _activityInstanceId;
    protected string type;
    protected bool excludeTaskRelated;

    this() {
    }

    this(CommandContext commandContext) {
        super(commandContext);
    }

    this(CommandExecutor commandExecutor) {
        super(commandExecutor);
    }


    public HistoricDetailQueryImpl id(string id) {
        this._id = id;
        return this;
    }


    public HistoricDetailQueryImpl processInstanceId(string processInstanceId) {
        this._processInstanceId = processInstanceId;
        return this;
    }


    public HistoricDetailQueryImpl executionId(string executionId) {
        this._executionId = executionId;
        return this;
    }

    public HistoricDetailQueryImpl activityId(string activityId) {
        this._activityId = activityId;
        return this;
    }


    public HistoricDetailQueryImpl activityInstanceId(string activityInstanceId) {
        this._activityInstanceId = activityInstanceId;
        return this;
    }


    public HistoricDetailQueryImpl taskId(string taskId) {
        this._taskId = taskId;
        return this;
    }


    public HistoricDetailQueryImpl formProperties() {
        this.type = "FormProperty";
        return this;
    }


    public HistoricDetailQueryImpl variableUpdates() {
        this.type = "VariableUpdate";
        return this;
    }


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
            foreach (HistoricDetail historicDetail ; historicDetails) {
                if (cast(HistoricDetailVariableInstanceUpdateEntity)historicDetail !is null) {
                    varUpdate = cast(HistoricDetailVariableInstanceUpdateEntity) historicDetail;

                    // Touch byte-array to ensure initialized inside context
                    // TODO there should be a generic way to initialize variable
                    // values
                    varUpdate.getBytes();

                    // ACT-863: EntityManagerFactorySession instance needed for
                    // fetching value, touch while inside context to store
                    // cached value
                    //if (varUpdate.getVariableType() instanceof JPAEntityVariableType) {
                    //    // Use HistoricJPAEntityVariableType to force caching of
                    //    // value to return from query
                    //    varUpdate.setVariableType(HistoricJPAEntityVariableType.getSharedInstance());
                    //    varUpdate.getValue();
                    //} else if (varUpdate.getVariableType() instanceof JPAEntityListVariableType) {
                    //    // Use HistoricJPAEntityListVariableType to force
                    //    // caching of list to return from query
                    //    varUpdate.setVariableType(HistoricJPAEntityListVariableType.getSharedInstance());
                    //    varUpdate.getValue();
                    //}
                }
            }
        }
        return historicDetails;
    }

    // order by
    // /////////////////////////////////////////////////////////////////


    public HistoricDetailQueryImpl orderByProcessInstanceId() {
        orderBy(HistoricDetailQueryProperty.PROCESS_INSTANCE_ID);
        return this;
    }


    public HistoricDetailQueryImpl orderByTime() {
        orderBy(HistoricDetailQueryProperty.TIME);
        return this;
    }


    public HistoricDetailQueryImpl orderByVariableName() {
        orderBy(HistoricDetailQueryProperty.VARIABLE_NAME);
        return this;
    }


    public HistoricDetailQueryImpl orderByFormPropertyId() {
        orderBy(HistoricDetailQueryProperty.VARIABLE_NAME);
        return this;
    }


    public HistoricDetailQueryImpl orderByVariableRevision() {
        orderBy(HistoricDetailQueryProperty.VARIABLE_REVISION);
        return this;
    }


    public HistoricDetailQueryImpl orderByVariableType() {
        orderBy(HistoricDetailQueryProperty.VARIABLE_TYPE);
        return this;
    }

    // getters and setters
    // //////////////////////////////////////////////////////

    public string getId() {
        return _id;
    }

    public string getProcessInstanceId() {
        return _processInstanceId;
    }

    public string getTaskId() {
        return _taskId;
    }

    public string getActivityId() {
        return _activityId;
    }

    public string getType() {
        return type;
    }

    public bool getExcludeTaskRelated() {
        return excludeTaskRelated;
    }

    public string getExecutionId() {
        return _executionId;
    }

    public string getActivityInstanceId() {
        return _activityInstanceId;
    }

}
