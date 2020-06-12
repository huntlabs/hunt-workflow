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
module flow.engine.impl.cmd.GetBatchDocumentCmd;

import flow.batch.service.api.Batch;
import flow.common.api.FlowableObjectNotFoundException;
import flow.common.interceptor.Command;
import flow.common.interceptor.CommandContext;
import flow.engine.impl.util.CommandContextUtil;

class GetBatchDocumentCmd : Command!string {

    protected string batchId;

    this(string batchId) {
        this.batchId = batchId;
    }

    public string execute(CommandContext commandContext) {
        Batch batch = CommandContextUtil.getBatchService(commandContext).getBatch(batchId);
        if (batch is null) {
            throw new FlowableObjectNotFoundException("No batch found for id " ~ batchId);
        }

        return batch.getBatchDocumentJson();
    }
}
