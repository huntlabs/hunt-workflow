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
//module flow.engine.impl.cmd.GetProcessInstanceMigrationBatchResultCmd;
//
//import hunt.collection.List;
//
//import flow.batch.service.api.Batch;
//import flow.batch.service.api.BatchPart;
//import flow.batch.service.api.BatchService;
//import flow.common.api.FlowableException;
//import flow.common.interceptor.Command;
//import flow.common.interceptor.CommandContext;
//import flow.engine.impl.util.CommandContextUtil;
//import flow.engine.migration.ProcessInstanceBatchMigrationPartResult;
//import flow.engine.migration.ProcessInstanceBatchMigrationResult;
//
//
//class GetProcessInstanceMigrationBatchResultCmd implements Command!ProcessInstanceBatchMigrationResult {
//
//    public static final string BATCH_RESULT_STATUS_LABEL = "resultStatus";
//    public static final string BATCH_RESULT_MESSAGE_LABEL = "resultMessage";
//
//    protected string batchId;
//
//    public GetProcessInstanceMigrationBatchResultCmd(string batchId) {
//        this.batchId = batchId;
//    }
//
//    override
//    public ProcessInstanceBatchMigrationResult execute(CommandContext commandContext) {
//        BatchService batchService = CommandContextUtil.getBatchService(commandContext);
//        Batch batch = batchService.getBatch(batchId);
//
//        if (batch !is null) {
//            ObjectMapper objectMapper = CommandContextUtil.getProcessEngineConfiguration(commandContext).getObjectMapper();
//            ProcessInstanceBatchMigrationResult result = convertFromBatch(batch, objectMapper);
//            List!BatchPart batchParts = batchService.findBatchPartsByBatchId(batch.getId());
//            if (batchParts !is null && !batchParts.isEmpty()) {
//                for (BatchPart batchPart : batchParts) {
//                    result.addMigrationPart(convertFromBatchPart(batchPart, objectMapper));
//                }
//            }
//            return result;
//        }
//
//        return null;
//    }
//
//    protected ProcessInstanceBatchMigrationResult convertFromBatch(Batch batch, ObjectMapper objectMapper) {
//        ProcessInstanceBatchMigrationResult result = new ProcessInstanceBatchMigrationResult();
//
//        result.setBatchId(batch.getId());
//        result.setSourceProcessDefinitionId(batch.getBatchSearchKey());
//        result.setTargetProcessDefinitionId(batch.getBatchSearchKey2());
//        result.setStatus(batch.getStatus());
//
//        return result;
//    }
//
//    protected ProcessInstanceBatchMigrationPartResult convertFromBatchPart(BatchPart batchPart, ObjectMapper objectMapper) {
//        ProcessInstanceBatchMigrationPartResult partResult = new ProcessInstanceBatchMigrationPartResult();
//
//        partResult.setBatchId(batchPart.getId());
//        partResult.setProcessInstanceId(batchPart.getScopeId());
//        partResult.setSourceProcessDefinitionId(batchPart.getBatchSearchKey());
//        partResult.setTargetProcessDefinitionId(batchPart.getBatchSearchKey2());
//
//        if (batchPart.getCompleteTime() !is null) {
//            partResult.setStatus(ProcessInstanceBatchMigrationResult.STATUS_COMPLETED);
//        }
//
//        partResult.setResult(batchPart.getStatus());
//        if (ProcessInstanceBatchMigrationResult.RESULT_FAIL.equals(batchPart.getStatus()) && batchPart.getResultDocumentJson() !is null) {
//            try {
//                JsonNode resultNode = objectMapper.readTree(batchPart.getResultDocumentJson());
//                if (resultNode.has(BATCH_RESULT_MESSAGE_LABEL)) {
//                    string resultMessage = resultNode.get(BATCH_RESULT_MESSAGE_LABEL).asText();
//                    partResult.setMigrationMessage(resultMessage);
//                }
//
//            } catch (IOException e) {
//                throw new FlowableException("Error reading batch part " + batchPart.getId());
//            }
//        }
//
//        return partResult;
//    }
//}
