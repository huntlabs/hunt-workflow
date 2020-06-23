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

    protected string _batchType;
    protected string _searchKey;
    protected string _searchKey2;
    protected string _status;
    protected string _batchDocumentJson;
    protected string _tenantId;

    this() {}

    this(CommandExecutor commandExecutor) {
        this.commandExecutor = commandExecutor;
    }

    this(BatchServiceImpl batchService) {
        this.batchService = batchService;
    }


    public BatchBuilder batchType(string batchType) {
        this._batchType = batchType;
        return this;
    }


    public BatchBuilder searchKey(string searchKey) {
        this._searchKey = searchKey;
        return this;
    }


    public BatchBuilder searchKey2(string searchKey2) {
        this._searchKey2 = searchKey2;
        return this;
    }


    public BatchBuilder status(string status) {
        this._status = status;
        return this;
    }


    public BatchBuilder batchDocumentJson(string batchDocumentJson) {
        this._batchDocumentJson = batchDocumentJson;
        return this;
    }


    public BatchBuilder tenantId(string tenantId) {
        this._tenantId = tenantId;
        return this;
    }


    public Batch create() {
        if (commandExecutor !is null) {
            BatchBuilder selfBatchBuilder = this;
            return cast(Batch)commandExecutor.execute(cast(CommandAbstract)(new class Command!Batch {
                public Batch execute(CommandContext commandContext) {
                    return CommandContextUtil.getBatchEntityManager(commandContext).createBatch(selfBatchBuilder);
                }
            }));

        } else {
            return batchService.createBatch(this);
        }
    }


    public string getBatchType() {
        return _batchType;
    }


    public string getSearchKey() {
        return _searchKey;
    }


    public string getSearchKey2() {
        return _searchKey2;
    }


    public string getStatus() {
        return _status;
    }


    public string getBatchDocumentJson() {
        return _batchDocumentJson;
    }


    public string getTenantId() {
        return _tenantId;
    }
}
