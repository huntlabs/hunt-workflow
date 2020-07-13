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
module flow.job.service.impl.asyncexecutor.AsyncJobAddedNotification;

import flow.common.interceptor.CommandContext;
import flow.common.interceptor.CommandContextCloseListener;
import flow.job.service.impl.persistence.entity.JobInfoEntity;
import flow.job.service.impl.asyncexecutor.AsyncExecutor;

/**
 * @author Joram Barrez
 */
class AsyncJobAddedNotification : CommandContextCloseListener {

    protected JobInfoEntity job;
    protected AsyncExecutor asyncExecutor;

    this(JobInfoEntity job, AsyncExecutor asyncExecutor) {
        this.job = job;
        this.asyncExecutor = asyncExecutor;
    }

    public void closed(CommandContext commandContext) {
        execute(commandContext);
    }

    public void execute(CommandContext commandContext) {
        asyncExecutor.executeAsyncJob(job);
    }

    public void closing(CommandContext commandContext) {
    }

    public void afterSessionsFlush(CommandContext commandContext) {
    }

    public void closeFailure(CommandContext commandContext) {
    }

}
