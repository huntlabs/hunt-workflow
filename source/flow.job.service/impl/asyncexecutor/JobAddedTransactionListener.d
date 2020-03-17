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
module flow.job.service.impl.asyncexecutor.JobAddedTransactionListener;

import flow.common.cfg.TransactionListener;
import flow.common.interceptor.CommandContext;
import flow.common.interceptor.CommandExecutor;
import flow.job.service.api.JobInfo;
import flow.job.service.impl.asyncexecutor.AsyncExecutor;
/**
 * @author Tijs Rademakers
 * @author Joram Barrez
 */
class JobAddedTransactionListener : TransactionListener {

    protected JobInfo job;
    protected AsyncExecutor asyncExecutor;
    protected CommandExecutor commandExecutor;

    this(JobInfo job, AsyncExecutor asyncExecutor, CommandExecutor commandExecutor) {
        this.job = job;
        this.asyncExecutor = asyncExecutor;
        this.commandExecutor = commandExecutor;
    }

    public void execute(CommandContext commandContext) {
        // No need to wrap this call in a new command context, as otherwise the
        // call to the executeAsyncJob would require a new database connection and transaction
        // which would block the current connection/transaction (of the calling thread)
        // until the job has been handed of to the async executor.
        // When the connection pool is small, this might lead to contention and (temporary) locks.
        asyncExecutor.executeAsyncJob(job);
    }
}
