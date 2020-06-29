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

module flow.variable.service.impl.AbstractVariableQueryImpl;

import hunt.collection.ArrayList;
import hunt.collection.List;

import flow.common.api.FlowableIllegalArgumentException;
import flow.common.api.query.Query;
import flow.common.query.AbstractQuery;
import flow.common.interceptor.CommandContext;
import flow.common.interceptor.CommandExecutor;
import flow.variable.service.api.types.VariableTypes;
import flow.variable.service.impl.util.CommandContextUtil;
import flow.variable.service.impl.QueryVariableValue;
import flow.variable.service.impl.QueryOperator;
import std.string;
import hunt.String;
import hunt.Boolean;
/**
 * Abstract query class that adds methods to query for variable values.
 *
 * @author Frederik Heremans
 */
abstract class AbstractVariableQueryImpl(T , U) : AbstractQuery!(T, U) {


    protected List!QueryVariableValue queryVariableValues ;//= new ArrayList<>();

    this() {
        queryVariableValues = new ArrayList!QueryVariableValue;
    }

    this(CommandContext commandContext) {
        super(commandContext);
        queryVariableValues = new ArrayList!QueryVariableValue;
    }

    this(CommandExecutor commandExecutor) {
        super(commandExecutor);
        queryVariableValues = new ArrayList!QueryVariableValue;
    }

    override
    public abstract long executeCount(CommandContext commandContext);

    override
    public abstract List!U executeList(CommandContext commandContext);

    public T variableValueEquals(string name, Object value) {
        return variableValueEquals(name, value, true);
    }


    protected T variableValueEquals(string name, Object value, bool localScope) {
        addVariable(name, value, QueryOperator.EQUALS, localScope);
        return cast(T) this;
    }

    public T variableValueEquals(Object value) {
        return variableValueEquals(value, true);
    }


    protected T variableValueEquals(Object value, bool localScope) {
        queryVariableValues.add(new QueryVariableValue(null, value, QueryOperator.EQUALS, localScope));
        return cast(T) this;
    }

    public T variableValueEqualsIgnoreCase(string name, string value) {
        return variableValueEqualsIgnoreCase(name, value, true);
    }


    public T variableValueEqualsIgnoreCase(string name, string value, bool localScope) {
        if (value is null) {
            throw new FlowableIllegalArgumentException("value is null");
        }
        addVariable(name, new String(toLower!string(value)), QueryOperator.EQUALS_IGNORE_CASE, localScope);
        return cast(T) this;
    }

    public T variableValueNotEqualsIgnoreCase(string name, string value) {
        return variableValueNotEqualsIgnoreCase(name, value, true);
    }


    protected T variableValueNotEqualsIgnoreCase(string name, string value, bool localScope) {
        if (value is null) {
            throw new FlowableIllegalArgumentException("value is null");
        }
        addVariable(name, new String(toLower!string(value)), QueryOperator.NOT_EQUALS_IGNORE_CASE, localScope);
        return cast(T) this;
    }

    public T variableValueNotEquals(string name, Object value) {
        return variableValueNotEquals(name, value, true);
    }


    public T variableValueNotEquals(string name, Object value, bool localScope) {
        addVariable(name, value, QueryOperator.NOT_EQUALS, localScope);
        return cast(T) this;
    }

    public T variableValueGreaterThan(string name, Object value) {
        return variableValueGreaterThan(name, value, true);
    }


    protected T variableValueGreaterThan(string name, Object value, bool localScope) {
        addVariable(name, value, QueryOperator.GREATER_THAN, localScope);
        return cast(T) this;
    }

    public T variableValueGreaterThanOrEqual(string name, Object value) {
        return variableValueGreaterThanOrEqual(name, value, true);
    }


    protected T variableValueGreaterThanOrEqual(string name, Object value, bool localScope) {
        addVariable(name, value, QueryOperator.GREATER_THAN_OR_EQUAL, localScope);
        return cast(T) this;
    }

    public T variableValueLessThan(string name, Object value) {
        return variableValueLessThan(name, value, true);
    }


    protected T variableValueLessThan(string name, Object value, bool localScope) {
        addVariable(name, value, QueryOperator.LESS_THAN, localScope);
        return cast(T) this;
    }

    public T variableValueLessThanOrEqual(string name, Object value) {
        return variableValueLessThanOrEqual(name, value, true);
    }


    protected T variableValueLessThanOrEqual(string name, Object value, bool localScope) {
        addVariable(name, value, QueryOperator.LESS_THAN_OR_EQUAL, localScope);
        return cast(T) this;
    }

    public T variableValueLike(string name, string value) {
        return variableValueLike(name, value, true);
    }

    public T variableValueLikeIgnoreCase(string name, string value) {
        return variableValueLikeIgnoreCase(name, value, true);
    }


    protected T variableValueLike(string name, string value, bool localScope) {
        addVariable(name, new String(value), QueryOperator.LIKE, localScope);
        return cast(T) this;
    }


    protected T variableValueLikeIgnoreCase(string name, string value, bool localScope) {
        addVariable(name, new String(toLower!string(value)), QueryOperator.LIKE_IGNORE_CASE, localScope);
        return cast(T) this;
    }

    public T variableExists(string name) {
        return variableExists(name, true);
    }


    public T variableExists(string name, bool localScope) {
        addVariable(name, null, QueryOperator.EXISTS, localScope);
        return cast(T) this;
    }

    public T variableNotExists(string name) {
        return variableNotExists(name, true);
    }


    protected T variableNotExists(string name, bool localScope) {
        addVariable(name, null, QueryOperator.NOT_EXISTS, localScope);
        return cast(T) this;
    }

    protected void addVariable(string name, Object value, QueryOperator operator, bool localScope) {
        if (name is null) {
            throw new FlowableIllegalArgumentException("name is null");
        }
        if (value is null || isBoolean(value)) {
            // Null-values and booleans can only be used in EQUALS, NOT_EQUALS, EXISTS and NOT_EXISTS
            switch (operator) {
                case GREATER_THAN:
                    throw new FlowableIllegalArgumentException("Booleans and null cannot be used in 'greater than' condition");
                case LESS_THAN:
                    throw new FlowableIllegalArgumentException("Booleans and null cannot be used in 'less than' condition");
                case GREATER_THAN_OR_EQUAL:
                    throw new FlowableIllegalArgumentException("Booleans and null cannot be used in 'greater than or equal' condition");
                case LESS_THAN_OR_EQUAL:
                    throw new FlowableIllegalArgumentException("Booleans and null cannot be used in 'less than or equal' condition");
            }

            if (operator == QueryOperator.EQUALS_IGNORE_CASE && (cast(String)value is null)) {
                throw new FlowableIllegalArgumentException("Only string values can be used with 'equals ignore case' condition");
            }

            if (operator == QueryOperator.NOT_EQUALS_IGNORE_CASE && (cast(String)value is null)) {
                throw new FlowableIllegalArgumentException("Only string values can be used with 'not equals ignore case' condition");
            }

            if ((operator == QueryOperator.LIKE || operator == QueryOperator.LIKE_IGNORE_CASE) && (cast(String)value is null)) {
                throw new FlowableIllegalArgumentException("Only string values can be used with 'like' condition");
            }
        }
        queryVariableValues.add(new QueryVariableValue(name, value, operator, localScope));
    }

    protected bool isBoolean(Object value) {
        if (value is null) {
            return false;
        }
        return cast(value)value !is null? true : false;
       // return Boolean.class.isAssignableFrom(value.getClass()) || bool.class.isAssignableFrom(value.getClass());
    }

    protected void ensureVariablesInitialized() {
        if (!queryVariableValues.isEmpty()) {
            VariableTypes variableTypes = CommandContextUtil.getVariableServiceConfiguration().getVariableTypes();
            foreach (QueryVariableValue queryVariableValue ; queryVariableValues) {
                queryVariableValue.initialize(variableTypes);
            }
        }
    }

    public List!QueryVariableValue getQueryVariableValues() {
        return queryVariableValues;
    }

    public bool hasValueComparisonQueryVariables() {
        foreach (QueryVariableValue qvv ; queryVariableValues) {
            if (QueryOperator.EXISTS.toString() != (qvv.getOperator()) && QueryOperator.NOT_EXISTS.toString() != (qvv.getOperator())) {
                return true;
            }
        }
        return false;
    }

    public bool hasLocalQueryVariableValue() {
        foreach (QueryVariableValue qvv ; queryVariableValues) {
            if (qvv.isLocal()) {
                return true;
            }
        }
        return false;
    }

    public bool hasNonLocalQueryVariableValue() {
        foreach (QueryVariableValue qvv ; queryVariableValues) {
            if (!qvv.isLocal()) {
                return true;
            }
        }
        return false;
    }

}
