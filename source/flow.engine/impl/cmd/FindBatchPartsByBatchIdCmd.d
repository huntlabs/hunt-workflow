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
module flow.engine.impl.cmd.FindBatchPartsByBatchIdCmd;

import hunt.collection.List;

import flow.batch.service.api.BatchPart;
import flow.common.interceptor.Command;
import flow.common.interceptor.CommandContext;
import flow.engine.impl.util.CommandContextUtil;

class FindBatchPartsByBatchIdCmd : Command!(List!BatchPart) {

    protected string batchId;
    protected string status;

    this(string batchId) {
        this.batchId = batchId;
    }

    this(string batchId, string status) {
        this.batchId = batchId;
        this.status = status;
    }

    public List!BatchPart execute(CommandContext commandContext) {
        if (status !is null) {
            return CommandContextUtil.getBatchService(commandContext).findBatchPartsByBatchIdAndStatus(batchId, status);
        } else {
            return CommandContextUtil.getBatchService(commandContext).findBatchPartsByBatchId(batchId);
        }
    }
}
