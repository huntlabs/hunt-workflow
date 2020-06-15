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
//
//import flow.common.interceptor.Command;
//import flow.common.interceptor.CommandConfig;
//import flow.common.interceptor.CommandContext;
//import flow.common.interceptor.CommandExecutor;
//import flow.engine.ProcessEngines;
//import flow.engine.impl.ProcessEngineImpl;
//import flow.engine.impl.util.CommandContextUtil;
//
///**
// * @author Tom Baeyens
// */
//class DbSchemaUpdate {
//
//    public static void main(string[] args) {
//        ProcessEngineImpl processEngine = (ProcessEngineImpl) ProcessEngines.getDefaultProcessEngine();
//        CommandExecutor commandExecutor = processEngine.getProcessEngineConfiguration().getCommandExecutor();
//        CommandConfig config = new CommandConfig().transactionNotSupported();
//        commandExecutor.execute(config, new Command!Object() {
//            override
//            public Object execute(CommandContext commandContext) {
//                CommandContextUtil.getProcessEngineConfiguration(commandContext).getSchemaManager().schemaUpdate();
//                return null;
//            }
//        });
//    }
//
//}
