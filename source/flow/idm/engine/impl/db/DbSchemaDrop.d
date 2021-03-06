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
module flow.idm.engine.impl.db.DbSchemaDrop;


//import flow.common.interceptor.Command;
//import flow.common.interceptor.CommandConfig;
//import flow.common.interceptor.CommandContext;
//import flow.common.interceptor.CommandExecutor;
//import flow.idm.engine.IdmEngine;
//import flow.idm.engine.IdmEngines;
//import flow.idm.engine.impl.util.CommandContextUtil;
//
///**
// * @author Tijs Rademakers
// */
//class DbSchemaDrop {
//
//    public static void main(String[] args) {
//        IdmEngine idmEngine = IdmEngines.getDefaultIdmEngine();
//        CommandExecutor commandExecutor = idmEngine.getIdmEngineConfiguration().getCommandExecutor();
//        CommandConfig config = new CommandConfig().transactionNotSupported();
//        commandExecutor.execute(config, new Command<Object>() {
//            @Override
//            public Object execute(CommandContext commandContext) {
//                CommandContextUtil.getIdmEngineConfiguration(commandContext).getSchemaManager().schemaDrop();
//                return null;
//            }
//        });
//    }
//}
