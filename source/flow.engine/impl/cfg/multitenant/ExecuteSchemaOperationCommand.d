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
module flow.engine.impl.cfg.multitenant.ExecuteSchemaOperationCommand;

import flow.common.cfg.multitenant.TenantInfoHolder;
import flow.common.db.SchemaManager;
import flow.common.interceptor.Command;
import flow.common.interceptor.CommandContext;
import flow.engine.ProcessEngineConfiguration;
import flow.engine.impl.cfg.ProcessEngineConfigurationImpl;
import flow.engine.impl.util.CommandContextUtil;
import hunt.Object;
import hunt.Exceptions;
/**
 * {@link Command} that is used by the {@link MultiSchemaMultiTenantProcessEngineConfiguration} to make sure the 'databaseSchemaUpdate' setting is applied for each tenant datasource.
 *
 * @author Joram Barrez
 */
class ExecuteSchemaOperationCommand : Command!Void {

    protected string schemaOperation;

    protected TenantInfoHolder tenantInfoHolder;

    this(string schemaOperation) {
        this.schemaOperation = schemaOperation;
    }

    public Void execute(CommandContext commandContext) {
        implementationMissing(false);
        //SchemaManager processSchemaManager = CommandContextUtil.getProcessEngineConfiguration(commandContext).getSchemaManager();
        //if (ProcessEngineConfigurationImpl.DB_SCHEMA_UPDATE_DROP_CREATE.equals(schemaOperation)) {
        //    try {
        //        processSchemaManager.schemaDrop();
        //    } catch (RuntimeException e) {
        //        // ignore
        //    }
        //}
        //if (flow.engine.ProcessEngineConfiguration.DB_SCHEMA_UPDATE_CREATE_DROP.equals(schemaOperation)
        //        || ProcessEngineConfigurationImpl.DB_SCHEMA_UPDATE_DROP_CREATE.equals(schemaOperation)
        //        || ProcessEngineConfigurationImpl.DB_SCHEMA_UPDATE_CREATE.equals(schemaOperation)) {
        //    processSchemaManager.schemaCreate();
        //
        //} else if (flow.engine.ProcessEngineConfiguration.DB_SCHEMA_UPDATE_FALSE.equals(schemaOperation)) {
        //    processSchemaManager.schemaCheckVersion();
        //
        //} else if (ProcessEngineConfiguration.DB_SCHEMA_UPDATE_TRUE.equals(schemaOperation)) {
        //    processSchemaManager.schemaUpdate();
        //}

        return null;
    }

}
