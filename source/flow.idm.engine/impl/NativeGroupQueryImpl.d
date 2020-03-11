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
//import flow.idm.api.Group;
//import flow.idm.api.NativeGroupQuery;
//import flow.idm.engine.impl.util.CommandContextUtil;
//
//class NativeGroupQueryImpl extends AbstractNativeQuery<NativeGroupQuery, Group> implements NativeGroupQuery {
//
//    private static final long serialVersionUID = 1L;
//
//    public NativeGroupQueryImpl(CommandContext commandContext) {
//        super(commandContext);
//    }
//
//    public NativeGroupQueryImpl(CommandExecutor commandExecutor) {
//        super(commandExecutor);
//    }
//
//    // results ////////////////////////////////////////////////////////////////
//
//    @Override
//    public List!Group executeList(CommandContext commandContext, Map!(string, Object) parameterMap) {
//        return CommandContextUtil.getGroupEntityManager(commandContext).findGroupsByNativeQuery(parameterMap);
//    }
//
//    @Override
//    public long executeCount(CommandContext commandContext, Map!(string, Object) parameterMap) {
//        return CommandContextUtil.getGroupEntityManager(commandContext).findGroupCountByNativeQuery(parameterMap);
//    }
//
//}
