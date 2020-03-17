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
module flow.batch.service.impl.BatchBuilderImpl;

import flow.batch.service.api.Batch;
import flow.batch.service.api.BatchBuilder;
import flow.batch.service.impl.util.CommandContextUtil;
import flow.common.interceptor.Command;
import flow.common.interceptor.CommandContext;
import flow.common.interceptor.CommandExecutor;
import flow.batch.service.impl.BatchServiceImpl;
/**
 * @author Tijs Rademakers
 */
class BatchBuilderImpl : BatchBuilder {

    protected BatchServiceImpl batchService;
    protected CommandExecutor commandExecutor;

    protected string batchType;
    protected string searchKey;
    protected string searchKey2;
    protected string status;
    protected string batchDocumentJson;
    protected string tenantId;

    this() {}

    this(CommandExecutor commandExecutor) {
        this.commandExecutor = commandExecutor;
    }

    this(BatchServiceImpl batchService) {
        this.batchService = batchService;
    }


    public BatchBuilder batchType(string batchType) {
        this.batchType = batchType;
        return this;
    }


    public BatchBuilder searchKey(string searchKey) {
        this.searchKey = searchKey;
        return this;
    }


    public BatchBuilder searchKey2(string searchKey2) {
        this.searchKey2 = searchKey2;
        return this;
    }


    public BatchBuilder status(string status) {
        this.status = status;
        return this;
    }


    public BatchBuilder batchDocumentJson(string batchDocumentJson) {
        this.batchDocumentJson = batchDocumentJson;
        return this;
    }


    public BatchBuilder tenantId(string tenantId) {
        this.tenantId = tenantId;
        return this;
    }


    public Batch create() {
        if (commandExecutor !is null) {
            BatchBuilder selfBatchBuilder = this;
            return commandExecutor.execute(new class Command!Batch {
                public Batch execute(CommandContext commandContext) {
                    return CommandContextUtil.getBatchEntityManager(commandContext).createBatch(selfBatchBuilder);
                }
            });

        } else {
            return batchService.createBatch(this);
        }
    }


    public string getBatchType() {
        return batchType;
    }


    public string getSearchKey() {
        return searchKey;
    }


    public string getSearchKey2() {
        return searchKey2;
    }


    public string getStatus() {
        return status;
    }


    public string getBatchDocumentJson() {
        return batchDocumentJson;
    }


    public string getTenantId() {
        return tenantId;
    }
}
