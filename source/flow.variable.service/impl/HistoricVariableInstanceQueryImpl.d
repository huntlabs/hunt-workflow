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

module flow.variable.service.impl.HistoricVariableInstanceQueryImpl;

import hunt.collection.List;
import hunt.collection.Set;

import flow.common.api.FlowableIllegalArgumentException;
import flow.common.query.AbstractQuery;
import flow.common.interceptor.CommandContext;
import flow.common.interceptor.CommandExecutor;
import flow.variable.service.api.history.HistoricVariableInstance;
import flow.variable.service.api.history.HistoricVariableInstanceQuery;
import flow.variable.service.api.types.VariableTypes;
import flow.variable.service.impl.persistence.entity.HistoricVariableInstanceEntity;
import flow.variable.service.impl.types.CacheableVariable;
//import flow.variable.service.impl.types.JPAEntityListVariableType;
//import flow.variable.service.impl.types.JPAEntityVariableType;
import flow.variable.service.impl.util.CommandContextUtil;
import flow.variable.service.impl.QueryVariableValue;
import flow.variable.service.impl.QueryOperator;
import flow.variable.service.impl.HistoricVariableInstanceQueryProperty;
import hunt.String;
import std.string;
/**
 * @author Joram Barrez
 * @author Tijs Rademakers
 */
class HistoricVariableInstanceQueryImpl : AbstractQuery!(HistoricVariableInstanceQuery, HistoricVariableInstance), HistoricVariableInstanceQuery {

    protected string id;
    protected string taskId;
    protected Set!string taskIds;
    protected string executionId;
    protected Set!string executionIds;
    protected string processInstanceId;
    protected string activityInstanceId;
    protected string variableName;
    protected string variableNameLike;
    protected bool excludeTaskRelated;
    protected bool excludeVariableInitialization;
    protected string scopeId;
    protected string subScopeId;
    protected string scopeType;
    protected QueryVariableValue queryVariableValue;

    this() {
    }

    this(CommandContext commandContext) {
        super(commandContext);
    }

    this(CommandExecutor commandExecutor) {
        super(commandExecutor);
    }


    public HistoricVariableInstanceQuery id(string id) {
        this.id = id;
        return this;
    }


    public HistoricVariableInstanceQueryImpl processInstanceId(string processInstanceId) {
        if (processInstanceId is null) {
            throw new FlowableIllegalArgumentException("processInstanceId is null");
        }
        this.processInstanceId = processInstanceId;
        return this;
    }


    public HistoricVariableInstanceQueryImpl executionId(string executionId) {
        if (executionId is null) {
            throw new FlowableIllegalArgumentException("Execution id is null");
        }
        this.executionId = executionId;
        return this;
    }


    public HistoricVariableInstanceQueryImpl executionIds(Set!string executionIds) {
        if (executionIds is null) {
            throw new FlowableIllegalArgumentException("executionIds is null");
        }
        if (executionIds.isEmpty()) {
            throw new FlowableIllegalArgumentException("Set of executionIds is empty");
        }
        this.executionIds = executionIds;
        return this;
    }

    public HistoricVariableInstanceQuery activityInstanceId(string activityInstanceId) {
        this.activityInstanceId = activityInstanceId;
        return this;
    }


    public HistoricVariableInstanceQuery taskId(string taskId) {
        if (taskId is null) {
            throw new FlowableIllegalArgumentException("taskId is null");
        }
        if (excludeTaskRelated) {
            throw new FlowableIllegalArgumentException("Cannot use taskId together with excludeTaskVariables");
        }
        this.taskId = taskId;
        return this;
    }


    public HistoricVariableInstanceQueryImpl taskIds(Set!string taskIds) {
        if (taskIds is null) {
            throw new FlowableIllegalArgumentException("taskIds is null");
        }
        if (taskIds.isEmpty()) {
            throw new FlowableIllegalArgumentException("Set of taskIds is empty");
        }
        if (excludeTaskRelated) {
            throw new FlowableIllegalArgumentException("Cannot use taskIds together with excludeTaskVariables");
        }
        this.taskIds = taskIds;
        return this;
    }


    public HistoricVariableInstanceQuery excludeTaskVariables() {
        if (taskId !is null) {
            throw new FlowableIllegalArgumentException("Cannot use taskId together with excludeTaskVariables");
        }
        if (taskIds !is null) {
            throw new FlowableIllegalArgumentException("Cannot use taskIds together with excludeTaskVariables");
        }
        excludeTaskRelated = true;
        return this;
    }


    public HistoricVariableInstanceQuery excludeVariableInitialization() {
        excludeVariableInitialization = true;
        return this;
    }


    public HistoricVariableInstanceQuery variableName(string variableName) {
        if (variableName is null) {
            throw new FlowableIllegalArgumentException("variableName is null");
        }
        this.variableName = variableName;
        return this;
    }


    public HistoricVariableInstanceQuery variableValueEquals(string variableName, Object variableValue) {
        if (variableName is null) {
            throw new FlowableIllegalArgumentException("variableName is null");
        }
        if (variableValue is null) {
            throw new FlowableIllegalArgumentException("variableValue is null");
        }
        this.variableName = variableName;
        queryVariableValue = new QueryVariableValue(variableName, variableValue, QueryOperator.EQUALS, true);
        return this;
    }


    public HistoricVariableInstanceQuery variableValueNotEquals(string variableName, Object variableValue) {
        if (variableName is null) {
            throw new FlowableIllegalArgumentException("variableName is null");
        }
        if (variableValue is null) {
            throw new FlowableIllegalArgumentException("variableValue is null");
        }
        this.variableName = variableName;
        queryVariableValue = new QueryVariableValue(variableName, variableValue, QueryOperator.NOT_EQUALS, true);
        return this;
    }


    public HistoricVariableInstanceQuery variableValueLike(string variableName, string variableValue) {
        if (variableName is null) {
            throw new FlowableIllegalArgumentException("variableName is null");
        }
        if (variableValue is null) {
            throw new FlowableIllegalArgumentException("variableValue is null");
        }
        this.variableName = variableName;
        queryVariableValue = new QueryVariableValue(variableName, new String(variableValue), QueryOperator.LIKE, true);
        return this;
    }


    public HistoricVariableInstanceQuery variableValueLikeIgnoreCase(string variableName, string variableValue) {
        if (variableName is null) {
            throw new FlowableIllegalArgumentException("variableName is null");
        }
        if (variableValue is null) {
            throw new FlowableIllegalArgumentException("variableValue is null");
        }
        this.variableName = variableName;
        queryVariableValue = new QueryVariableValue(variableName, new String(toLower!string(variableValue)), QueryOperator.LIKE_IGNORE_CASE, true);
        return this;
    }


    public HistoricVariableInstanceQuery variableNameLike(string variableNameLike) {
        if (variableNameLike is null) {
            throw new FlowableIllegalArgumentException("variableNameLike is null");
        }
        this.variableNameLike = variableNameLike;
        return this;
    }


    public HistoricVariableInstanceQuery scopeId(string scopeId) {
        this.scopeId = scopeId;
        return this;
    }


    public HistoricVariableInstanceQuery subScopeId(string subScopeId) {
        this.subScopeId = subScopeId;
        return this;
    }


    public HistoricVariableInstanceQuery scopeType(string scopeType) {
        this.scopeType = scopeType;
        return this;
    }

    protected void ensureVariablesInitialized() {
        if (this.queryVariableValue !is null) {
            VariableTypes variableTypes = CommandContextUtil.getVariableServiceConfiguration().getVariableTypes();
            queryVariableValue.initialize(variableTypes);
        }
    }


    public long executeCount(CommandContext commandContext) {
        ensureVariablesInitialized();
        return CommandContextUtil.getHistoricVariableInstanceEntityManager(commandContext).findHistoricVariableInstanceCountByQueryCriteria(this);
    }


    public List!HistoricVariableInstance executeList(CommandContext commandContext) {
        ensureVariablesInitialized();

        List!HistoricVariableInstance historicVariableInstances = CommandContextUtil.getHistoricVariableInstanceEntityManager(commandContext).findHistoricVariableInstancesByQueryCriteria(this);

        if (!excludeVariableInitialization) {
            foreach (HistoricVariableInstance historicVariableInstance ; historicVariableInstances) {
                HistoricVariableInstanceEntity variableEntity = cast(HistoricVariableInstanceEntity) historicVariableInstance;
                if (variableEntity !is null) {
                    if (variableEntity.getVariableType() !is null) {
                        variableEntity.getValue();

                        //TODO
                        // make sure JPA entities are cached for later retrieval
                        if ("jpa-entity" == (variableEntity.getVariableType().getTypeName()) || "jpa-entity-list" == (variableEntity.getVariableType().getTypeName())) {
                            (cast(CacheableVariable) variableEntity.getVariableType()).setForceCacheable(true);
                        }
                    }
                }
            }
        }
        return historicVariableInstances;
    }

    // order by
    // /////////////////////////////////////////////////////////////////


    public HistoricVariableInstanceQuery orderByProcessInstanceId() {
        orderBy(HistoricVariableInstanceQueryProperty.PROCESS_INSTANCE_ID);
        return this;
    }


    public HistoricVariableInstanceQuery orderByVariableName() {
        orderBy(HistoricVariableInstanceQueryProperty.VARIABLE_NAME);
        return this;
    }

    // getters and setters
    // //////////////////////////////////////////////////////

    public string getProcessInstanceId() {
        return processInstanceId;
    }

    public string getTaskId() {
        return taskId;
    }

    public string getActivityInstanceId() {
        return activityInstanceId;
    }

    public bool getExcludeTaskRelated() {
        return excludeTaskRelated;
    }

    public string getVariableName() {
        return variableName;
    }

    public string getVariableNameLike() {
        return variableNameLike;
    }

    public string getScopeId() {
        return scopeId;
    }

    public string getSubScopeId() {
        return subScopeId;
    }

    public string getScopeType() {
        return scopeType;
    }

    public QueryVariableValue getQueryVariableValue() {
        return queryVariableValue;
    }

}
