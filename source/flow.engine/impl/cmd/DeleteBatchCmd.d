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


import flow.batch.service.api.Batch;
import flow.batch.service.api.BatchService;
import flow.common.api.FlowableException;
import flow.common.interceptor.Command;
import flow.common.interceptor.CommandContext;
import flow.engine.impl.util.CommandContextUtil;

class DeleteBatchCmd implements Command<Void> {

    protected string batchId;

    public DeleteBatchCmd(string batchId) {
        this.batchId = batchId;
    }

    @Override
    public Void execute(CommandContext commandContext) {
        BatchService batchService = CommandContextUtil.getBatchService(commandContext);
        Batch batch = batchService.getBatch(batchId);
        if (batch is null) {
            throw new FlowableException("batch entity not found for id " + batchId);
        }

        batchService.deleteBatch(batchId);

        return null;
    }
}
