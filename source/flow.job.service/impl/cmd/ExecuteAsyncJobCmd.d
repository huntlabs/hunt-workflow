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
module flow.job.service.impl.cmd.ExecuteAsyncJobCmd;


import flow.common.api.FlowableIllegalArgumentException;
import flow.common.api.deleg.event.FlowableEngineEventType;
import flow.common.api.deleg.event.FlowableEventDispatcher;
import flow.common.interceptor.Command;
import flow.common.interceptor.CommandContext;
import flow.job.service.event.impl.FlowableJobEventBuilder;
import flow.job.service.impl.persistence.entity.JobInfoEntity;
import flow.job.service.impl.persistence.entity.JobInfoEntityManager;
import flow.job.service.impl.util.CommandContextUtil;
import hunt.logging;
import hunt.Exceptions;
/**
 * @author Tijs Rademakers
 * @author Joram Barrez
 */
class ExecuteAsyncJobCmd : Command!Object {

    protected string jobId;
    //protected JobInfoEntityManager<? extends JobInfoEntity> jobEntityManager;
    protected JobInfoEntityManager!JobInfoEntity jobEntityManager;
    this(string jobId) {
        this.jobId = jobId;
    }

    this(string jobId, JobInfoEntityManager!JobInfoEntity jobEntityManager) {
        this.jobId = jobId;
        this.jobEntityManager = jobEntityManager;
    }

    public Object execute(CommandContext commandContext) {

        if (jobEntityManager is null) {
            jobEntityManager = cast(JobInfoEntityManager!JobInfoEntity)(CommandContextUtil.getJobEntityManager(commandContext)); // Backwards compatibility
        }

        if (jobId is null) {
            throw new FlowableIllegalArgumentException("jobId is null");
        }

        // We need to refetch the job, as it could have been deleted by another concurrent job
        // For example: an embedded subprocess with a couple of async tasks and a timer on the boundary of the subprocess
        // when the timer fires, all executions and thus also the jobs inside of the embedded subprocess are destroyed.
        // However, the async task jobs could already have been fetched and put in the queue.... while in reality they have been deleted.
        // A refetch is thus needed here to be sure that it exists for this transaction.

        JobInfoEntity job = jobEntityManager.findById(jobId);
        if (job is null) {
            logError("Job does not exist anymore and will not be executed. It has most likely been deleted
                     as part of another concurrent part of the process instance.");
            return null;
        }

        //if (LOGGER.isDebugEnabled()) {
        //    LOGGER.debug("Executing async job {}", job.getId());
        //}
        logInfo("Executing async job {%s}",job.getId);

        CommandContextUtil.getJobManager(commandContext).execute(job);

        FlowableEventDispatcher eventDispatcher = CommandContextUtil.getEventDispatcher(commandContext);
        if (eventDispatcher !is null && eventDispatcher.isEnabled()) {
            eventDispatcher.dispatchEvent(
                    FlowableJobEventBuilder.createEntityEvent(FlowableEngineEventType.JOB_EXECUTION_SUCCESS, cast(Object)job));
        }

        return null;
    }
}
