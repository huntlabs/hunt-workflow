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
module flow.common.query.AbstractQuery;

import hunt.collection.List;
import hunt.Long;
import flow.common.api.FlowableException;
import flow.common.api.FlowableIllegalArgumentException;
import flow.common.api.query.Query;
import flow.common.api.query.QueryProperty;
import flow.common.Direction;
import flow.common.context.Context;
import flow.common.db.ListQueryParameterObject;
import flow.common.interceptor.Command;
import flow.common.interceptor.CommandContext;
import flow.common.interceptor.CommandExecutor;
import std.conv : to;
/**
 * Abstract superclass for all query types.
 *
 * @author Joram Barrez
 */
abstract class AbstractQuery(T , U) : ListQueryParameterObject , Command!Object, Query!(T, U) {


    protected  CommandExecutor commandExecutor;
    protected  CommandContext commandContext;

    this() {
        parameter = this;
    }

    this(CommandExecutor commandExecutor) {
        this.commandExecutor = commandExecutor;
    }

    this(CommandContext commandContext) {
        this.commandContext = commandContext;
    }

    public AbstractQuery!(T, U) setCommandExecutor(CommandExecutor commandExecutor) {
        this.commandExecutor = commandExecutor;
        return this;
    }



    public T orderBy(QueryProperty property) {
        this.orderProperty = property;
        return cast(T) this;
    }



    public T orderBy(QueryProperty property, NullHandlingOnOrder nullHandlingOnOrder) {
        orderBy(property);
        this.nullHandlingOnOrder = nullHandlingOnOrder;
        return cast(T) this;
    }


    public T asc() {
        return direction(Direction.ASCENDING);
    }


    public T desc() {
        return direction(Direction.DESCENDING);
    }


    public T direction(Direction direction) {
        if (orderProperty is null) {
            throw new FlowableIllegalArgumentException("You should call any of the orderBy methods first before specifying a direction");
        }
        addOrder(orderProperty.getName(), direction.getName(), nullHandlingOnOrder);
        orderProperty = null;
        nullHandlingOnOrder = NullHandlingOnOrder.NULLS_FIRST;
        return cast(T) this;
    }

    protected void checkQueryOk() {
        if (orderProperty !is null) {
            throw new FlowableIllegalArgumentException("Invalid query: call asc() or desc() after using orderByXX()");
        }
    }



    public U singleResult() {
        this.resultType = ResultType.SINGLE_RESULT;
        if (commandExecutor !is null) {
            return cast(U) commandExecutor.execute(this);
        }
        // The execute has a checkQueryOk() call as well, so no need to do the call earlier
        checkQueryOk();
        return executeSingleResult(Context.getCommandContext());
    }



    public List!U list() {
        this.resultType = ResultType.LIST;
        if (commandExecutor !is null) {
            return cast(List!U) commandExecutor.execute(this);
        }
        // The execute has a checkQueryOk() call as well, so no need to do the call earlier
        checkQueryOk();
        return executeList(Context.getCommandContext());
    }



    public List!U listPage(int firstResult, int maxResults) {
        this.firstResult = firstResult;
        this.maxResults = maxResults;
        this.resultType = ResultType.LIST_PAGE;
        if (commandExecutor !is null) {
            return cast(List!U) commandExecutor.execute(this);
        }
        // The execute has a checkQueryOk() call as well, so no need to do the call earlier
        checkQueryOk();
        return executeList(Context.getCommandContext());
    }


    public long count() {
        this.resultType = ResultType.COUNT;
        if (commandExecutor !is null) {
            return (cast(Long) commandExecutor.execute(this)).longValue;
        }
        // The execute has a checkQueryOk() call as well, so no need to do the call earlier
        checkQueryOk();
        return executeCount(Context.getCommandContext());
    }


    public Object execute(CommandContext commandContext) {
        checkQueryOk();
        if (resultType == ResultType.LIST) {
            return cast(Object)executeList(commandContext);
        } else if (resultType == ResultType.SINGLE_RESULT) {
            return cast(Object)executeSingleResult(commandContext);
        } else if (resultType == ResultType.LIST_PAGE) {
            return cast(Object)executeList(commandContext);
        } else {
            return new Long(executeCount(commandContext));
        }
    }

    public abstract long executeCount(CommandContext commandContext);

    /**
     * Executes the actual query to retrieve the list of results.
     */
    public abstract List!U executeList(CommandContext commandContext);

    public U executeSingleResult(CommandContext commandContext) {
        List!U results = executeList(commandContext);
        if (results.size() == 1) {
            return results.get(0);
        } else if (results.size() > 1) {
            throw new FlowableException("Query return " ~ to!string(results.size()) ~ " results instead of max 1");
        }
        return null;
    }

}
