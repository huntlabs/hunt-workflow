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
//import flow.common.query.AbstractNativeQuery;
//import flow.common.interceptor.CommandContext;
//import flow.common.interceptor.CommandExecutor;
//import flow.idm.api.NativeTokenQuery;
//import flow.idm.api.Token;
//import flow.idm.engine.impl.util.CommandContextUtil;
//
//class NativeTokenQueryImpl extends AbstractNativeQuery<NativeTokenQuery, Token> implements NativeTokenQuery {
//
//    private static final long serialVersionUID = 1L;
//
//    public NativeTokenQueryImpl(CommandContext commandContext) {
//        super(commandContext);
//    }
//
//    public NativeTokenQueryImpl(CommandExecutor commandExecutor) {
//        super(commandExecutor);
//    }
//
//    // results ////////////////////////////////////////////////////////////////
//
//    @Override
//    public List<Token> executeList(CommandContext commandContext, Map!(string, Object) parameterMap) {
//        return CommandContextUtil.getTokenEntityManager(commandContext).findTokensByNativeQuery(parameterMap);
//    }
//
//    @Override
//    public long executeCount(CommandContext commandContext, Map!(string, Object) parameterMap) {
//        return CommandContextUtil.getTokenEntityManager(commandContext).findTokenCountByNativeQuery(parameterMap);
//    }
//
//}
