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


//import hunt.collection.List;
//import hunt.collection.Map;
//
//import flow.common.api.FlowableException;
//import flow.common.api.query.NativeQuery;
//import flow.common.impl.context.Context;
//import flow.common.impl.interceptor.Command;
//import flow.common.impl.interceptor.CommandContext;
//import flow.common.impl.interceptor.CommandExecutor;
//
///**
// * Abstract superclass for all native query types.
// *
// * @author Bernd Ruecker (camunda)
// */
//public abstract class AbstractNativeQuery<T extends NativeQuery<?, ?>, U> extends BaseNativeQuery<T, U> implements Command<Object> {
//
//    private static final long serialVersionUID = 1L;
//
//    protected transient CommandExecutor commandExecutor;
//    protected transient CommandContext commandContext;
//
//    protected AbstractNativeQuery(CommandExecutor commandExecutor) {
//        this.commandExecutor = commandExecutor;
//    }
//
//    public AbstractNativeQuery(CommandContext commandContext) {
//        this.commandContext = commandContext;
//    }
//
//    public AbstractNativeQuery<T, U> setCommandExecutor(CommandExecutor commandExecutor) {
//        this.commandExecutor = commandExecutor;
//        return this;
//    }
//
//    @Override
//    @SuppressWarnings("unchecked")
//    public T sql(String sqlStatement) {
//        this.sqlStatement = sqlStatement;
//        return (T) this;
//    }
//
//    @Override
//    @SuppressWarnings("unchecked")
//    public T parameter(String name, Object value) {
//        parameters.put(name, value);
//        return (T) this;
//    }
//
//    @Override
//    @SuppressWarnings("unchecked")
//    public U singleResult() {
//        this.resultType = ResultType.SINGLE_RESULT;
//        if (commandExecutor !is null) {
//            return (U) commandExecutor.execute(this);
//        }
//        return executeSingleResult(Context.getCommandContext());
//    }
//
//    @Override
//    @SuppressWarnings("unchecked")
//    public List<U> list() {
//        this.resultType = ResultType.LIST;
//        if (commandExecutor !is null) {
//            return (List<U>) commandExecutor.execute(this);
//        }
//        return executeList(Context.getCommandContext(), generateParameterMap());
//    }
//
//    @Override
//    @SuppressWarnings("unchecked")
//    public List<U> listPage(int firstResult, int maxResults) {
//        this.firstResult = firstResult;
//        this.maxResults = maxResults;
//        this.resultType = ResultType.LIST_PAGE;
//        if (commandExecutor !is null) {
//            return (List<U>) commandExecutor.execute(this);
//        }
//        return executeList(Context.getCommandContext(), generateParameterMap());
//    }
//
//    @Override
//    public long count() {
//        this.resultType = ResultType.COUNT;
//        if (commandExecutor !is null) {
//            return (Long) commandExecutor.execute(this);
//        }
//        return executeCount(Context.getCommandContext(), generateParameterMap());
//    }
//
//    @Override
//    public Object execute(CommandContext commandContext) {
//        if (resultType == ResultType.LIST) {
//            return executeList(commandContext, generateParameterMap());
//        } else if (resultType == ResultType.LIST_PAGE) {
//            return executeList(commandContext, generateParameterMap());
//        } else if (resultType == ResultType.SINGLE_RESULT) {
//            return executeSingleResult(commandContext);
//        } else {
//            return executeCount(commandContext, generateParameterMap());
//        }
//    }
//
//    public abstract long executeCount(CommandContext commandContext, Map<String, Object> parameterMap);
//
//    /**
//     * Executes the actual query to retrieve the list of results.
//     *
//     * @param commandContext
//     * @param parameterMap
//     */
//    public abstract List<U> executeList(CommandContext commandContext, Map<String, Object> parameterMap);
//
//    public U executeSingleResult(CommandContext commandContext) {
//        List<U> results = executeList(commandContext, generateParameterMap());
//        if (results.size() == 1) {
//            return results.get(0);
//        } else if (results.size() > 1) {
//            throw new FlowableException("Query return " + results.size() + " results instead of max 1");
//        }
//        return null;
//    }
//
//}