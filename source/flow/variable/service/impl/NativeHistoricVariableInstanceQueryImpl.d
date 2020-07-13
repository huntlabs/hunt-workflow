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
//module flow.variable.service.impl.NativeHistoricVariableInstanceQueryImpl;
//
//import hunt.collection.List;
//import hunt.collection.Map;
//
//import flow.common.query.AbstractNativeQuery;
//import flow.common.interceptor.CommandContext;
//import flow.common.interceptor.CommandExecutor;
//import flow.variable.service.api.history.HistoricVariableInstance;
//import flow.variable.service.api.history.NativeHistoricVariableInstanceQuery;
//import flow.variable.service.impl.util.CommandContextUtil;
//
//class NativeHistoricVariableInstanceQueryImpl : AbstractNativeQuery<NativeHistoricVariableInstanceQuery, HistoricVariableInstance> implements NativeHistoricVariableInstanceQuery {
//
//    private static final long serialVersionUID = 1L;
//
//    public NativeHistoricVariableInstanceQueryImpl(CommandContext commandContext) {
//        super(commandContext);
//    }
//
//    public NativeHistoricVariableInstanceQueryImpl(CommandExecutor commandExecutor) {
//        super(commandExecutor);
//    }
//
//    // results ////////////////////////////////////////////////////////////////
//
//    @Override
//    public List<HistoricVariableInstance> executeList(CommandContext commandContext, Map<String, Object> parameterMap) {
//        return CommandContextUtil.getHistoricVariableInstanceEntityManager(commandContext).findHistoricVariableInstancesByNativeQuery(parameterMap);
//    }
//
//    @Override
//    public long executeCount(CommandContext commandContext, Map<String, Object> parameterMap) {
//        return CommandContextUtil.getHistoricVariableInstanceEntityManager(commandContext).findHistoricVariableInstanceCountByNativeQuery(parameterMap);
//    }
//
//}
