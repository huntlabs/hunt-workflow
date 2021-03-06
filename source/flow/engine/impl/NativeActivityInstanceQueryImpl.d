///* Licensed under the Apache License, Version 2.0 (the "License");
// * you may not use this file except in compliance with the License.
// * You may obtain a copy of the License at
// *
// *      http://www.apache.org/licenses/LICENSE-2.0
// *
// * Unless required by applicable law or agreed to in writing, software
// * distributed under the License is distributed on an "AS IS" BASIS,
// * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// * See the License for the specific language governing permissions and
// * limitations under the License.
// */
//
//
//import hunt.collection.List;
//import hunt.collection.Map;
//
//import flow.common.query.AbstractNativeQuery;
//import flow.common.interceptor.CommandContext;
//import flow.common.interceptor.CommandExecutor;
//import flow.engine.impl.util.CommandContextUtil;
//import flow.engine.runtime.ActivityInstance;
//import flow.engine.runtime.NativeActivityInstanceQuery;
//
//class NativeActivityInstanceQueryImpl : AbstractNativeQuery!(NativeActivityInstanceQuery, ActivityInstance) implements NativeActivityInstanceQuery {
//
//    private static final long serialVersionUID = 1L;
//
//    public NativeActivityInstanceQueryImpl(CommandContext commandContext) {
//        super(commandContext);
//    }
//
//    public NativeActivityInstanceQueryImpl(CommandExecutor commandExecutor) {
//        super(commandExecutor);
//    }
//
//    // results ////////////////////////////////////////////////////////////////
//
//    override
//    public List!ActivityInstance executeList(CommandContext commandContext, Map!(string, Object) parameterMap) {
//        return CommandContextUtil.getActivityInstanceEntityManager(commandContext).findActivityInstancesByNativeQuery(parameterMap);
//    }
//
//    override
//    public long executeCount(CommandContext commandContext, Map!(string, Object) parameterMap) {
//        return CommandContextUtil.getActivityInstanceEntityManager(commandContext).findActivityInstanceCountByNativeQuery(parameterMap);
//    }
//
//}
