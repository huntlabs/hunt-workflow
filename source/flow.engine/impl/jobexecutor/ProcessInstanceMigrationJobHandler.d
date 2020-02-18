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


import org.flowable.batch.api.Batch;
import org.flowable.batch.api.BatchPart;
import org.flowable.batch.api.BatchService;
import flow.common.api.FlowableException;
import flow.common.interceptor.CommandContext;
import flow.engine.impl.cfg.ProcessEngineConfigurationImpl;
import flow.engine.impl.migration.ProcessInstanceMigrationDocumentImpl;
import flow.engine.impl.util.CommandContextUtil;
import flow.engine.migration.ProcessInstanceBatchMigrationResult;
import flow.engine.migration.ProcessInstanceMigrationDocument;
import flow.engine.migration.ProcessInstanceMigrationManager;
import org.flowable.job.service.impl.persistence.entity.JobEntity;
import org.flowable.variable.api.delegate.VariableScope;

import com.fasterxml.jackson.databind.node.ObjectNode;

class ProcessInstanceMigrationJobHandler extends AbstractProcessInstanceMigrationJobHandler {

    public static final string TYPE = "process-migration";

    @Override
    public string getType() {
        return TYPE;
    }

    @Override
    public void execute(JobEntity job, string configuration, VariableScope variableScope, CommandContext commandContext) {
        BatchService batchService = CommandContextUtil.getBatchService(commandContext);
        ProcessEngineConfigurationImpl processEngineConfiguration = CommandContextUtil.getProcessEngineConfiguration(commandContext);
        ProcessInstanceMigrationManager processInstanceMigrationManager = processEngineConfiguration.getProcessInstanceMigrationManager();

        string batchPartId = getBatchPartIdFromHandlerCfg(configuration);
        BatchPart batchPart = batchService.getBatchPart(batchPartId);
        Batch batch = batchService.getBatch(batchPart.getBatchId());
        ProcessInstanceMigrationDocument migrationDocument = ProcessInstanceMigrationDocumentImpl.fromJson(batch.getBatchDocumentJson());

        string exceptionMessage = null;
        try {
            processInstanceMigrationManager.migrateProcessInstance(batchPart.getScopeId(), migrationDocument, commandContext);
        } catch (FlowableException e) {
            exceptionMessage = e.getMessage();
        }

        string resultAsJsonString = prepareResultAsJsonString(exceptionMessage);
        
        if (exceptionMessage !is null) {
            batchService.completeBatchPart(batchPartId, ProcessInstanceBatchMigrationResult.RESULT_FAIL, resultAsJsonString);
        } else {
            batchService.completeBatchPart(batchPartId, ProcessInstanceBatchMigrationResult.RESULT_SUCCESS, resultAsJsonString);
        }
    }

    protected static string prepareResultAsJsonString(string exceptionMessage) {
        ObjectNode objectNode = getObjectMapper().createObjectNode();
        if (exceptionMessage is null) {
            objectNode.put(BATCH_RESULT_STATUS_LABEL, ProcessInstanceBatchMigrationResult.RESULT_SUCCESS);
        } else {
            objectNode.put(BATCH_RESULT_STATUS_LABEL, ProcessInstanceBatchMigrationResult.RESULT_FAIL);
            objectNode.put(BATCH_RESULT_MESSAGE_LABEL, exceptionMessage);
        }
        return objectNode.toString();
    }

}