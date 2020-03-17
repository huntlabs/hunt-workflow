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
module flow.idm.engine.impl.IdmManagementServiceImpl;

import hunt.collection.Map;

import flow.common.api.management.TableMetaData;
import flow.common.api.management.TablePageQuery;
import flow.common.cmd.CustomSqlExecution;
import flow.common.interceptor.Command;
import flow.common.interceptor.CommandConfig;
import flow.common.interceptor.CommandContext;
import flow.common.service.CommonEngineServiceImpl;
import flow.idm.api.IdmManagementService;
import flow.idm.engine.IdmEngineConfiguration;
import flow.idm.engine.impl.cmd.ExecuteCustomSqlCmd;
import flow.idm.engine.impl.cmd.GetPropertiesCmd;
import flow.idm.engine.impl.cmd.GetTableCountCmd;
import flow.idm.engine.impl.cmd.GetTableMetaDataCmd;
import flow.idm.engine.impl.cmd.GetTableNameCmd;
import flow.idm.engine.impl.util.CommandContextUtil;
import hunt.Exceptions;
/**
 * @author Tijs Rademakers
 */
class IdmManagementServiceImpl : CommonEngineServiceImpl!IdmEngineConfiguration , IdmManagementService {


    public Map!(string, long) getTableCount() {
        return commandExecutor.execute(new GetTableCountCmd());
    }


    //public string getTableName(Class<?> entityClass) {
    //    return commandExecutor.execute(new GetTableNameCmd(entityClass));
    //}
    public string getTableName(TypeInfo entityClass) {
        return commandExecutor.execute(new GetTableNameCmd(entityClass));
    }

    public TableMetaData getTableMetaData(string tableName) {
        return commandExecutor.execute(new GetTableMetaDataCmd(tableName));
    }


    public TablePageQuery createTablePageQuery() {
        implementationMissing(false);
        return null;
        //return new TablePageQueryImpl(commandExecutor);
    }


    public Map!(string, string) getProperties() {
        return commandExecutor.execute(new GetPropertiesCmd());
    }

    //
    //public string databaseSchemaUpgrade(final Connection connection,  string catalog,  string schema) {
    //    CommandConfig config = commandExecutor.getDefaultConfig().transactionNotSupported();
    //    return commandExecutor.execute(config, new Command!string() {
    //
    //        public string execute(CommandContext commandContext) {
    //            return CommandContextUtil.getIdmEngineConfiguration().getSchemaManager().schemaUpdate();
    //        }
    //    });
    //}

    //public <MapperType, ResultType> ResultType executeCustomSql(CustomSqlExecution<MapperType, ResultType> customSqlExecution) {
    //    Class<MapperType> mapperClass = customSqlExecution.getMapperClass();
    //    return commandExecutor.execute(new ExecuteCustomSqlCmd<>(mapperClass, customSqlExecution));
    //}

}
