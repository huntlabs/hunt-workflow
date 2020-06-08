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


import hunt.collection.List;

import flow.batch.service.api.Batch;
import flow.batch.service.api.BatchPart;
import flow.batch.service.api.BatchService;
import flow.batch.service.impl.persistence.entity.BatchEntity;
import flow.common.interceptor.CommandContext;
import flow.engine.impl.util.CommandContextUtil;
import flow.engine.migration.ProcessInstanceBatchMigrationResult;
import flow.job.service.impl.persistence.entity.JobEntity;
import flow.variable.service.api.deleg.VariableScope;

class ProcessInstanceMigrationStatusJobHandler : AbstractProcessInstanceMigrationJobHandler {

    public static final string TYPE = "process-migration-status";

    override
    public string getType() {
        return TYPE;
    }

    override
    public void execute(JobEntity job, string configuration, VariableScope variableScope, CommandContext commandContext) {
        BatchService batchService = CommandContextUtil.getBatchService(commandContext);

        string batchId = getBatchIdFromHandlerCfg(configuration);
        Batch batch = batchService.getBatch(batchId);

        List!BatchPart batchParts = batchService.findBatchPartsByBatchId(batchId);
        int completedBatchParts = 0;
        int failedBatchParts = 0;
        for (BatchPart batchPart : batchParts) {
            if (batchPart.getCompleteTime() !is null) {
                completedBatchParts++;

                if (ProcessInstanceBatchMigrationResult.RESULT_FAIL.equals(batchPart.getStatus())) {
                    failedBatchParts++;
                }
            }
        }

        if (completedBatchParts == batchParts.size()) {
            updateBatchStatus(batch, ProcessInstanceBatchMigrationResult.STATUS_COMPLETED, batchService);
            job.setRepeat(null);

        } else {
            if (batchParts.size() == 0) {
                updateBatchStatus(batch, "No batch parts", batchService);
                job.setRepeat(null);

            } else {
                int completedPercentage = completedBatchParts / batchParts.size() * 100;
                updateBatchStatus(batch, completedPercentage + "% completed, " + failedBatchParts + " failed", batchService);
            }
        }
    }

    protected void updateBatchStatus(Batch batch, string status, BatchService batchService) {
        ((BatchEntity) batch).setStatus(ProcessInstanceBatchMigrationResult.STATUS_COMPLETED);
        batchService.updateBatch(batch);
    }

}
