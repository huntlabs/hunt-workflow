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
module flow.job.service.impl.cmd.MoveJobToDeadLetterJobCmd;


import flow.common.api.FlowableIllegalArgumentException;
import flow.common.interceptor.Command;
import flow.common.interceptor.CommandContext;
import flow.job.service.api.JobNotFoundException;
import flow.job.service.impl.persistence.entity.AbstractRuntimeJobEntity;
import flow.job.service.impl.persistence.entity.DeadLetterJobEntity;
import flow.job.service.impl.util.CommandContextUtil;
import hunt.logging;
/**
 * @author Tijs Rademakers
 */
class MoveJobToDeadLetterJobCmd : Command!DeadLetterJobEntity {

    protected string jobId;

    this(string jobId) {
        this.jobId = jobId;
    }

    public DeadLetterJobEntity execute(CommandContext commandContext) {

        if (jobId is null) {
            throw new FlowableIllegalArgumentException("jobId and job is null");
        }

        AbstractRuntimeJobEntity job = CommandContextUtil.getTimerJobEntityManager(commandContext).findById(jobId);
        if (job is null) {
            job = CommandContextUtil.getJobEntityManager(commandContext).findById(jobId);
        }

        if (job is null) {
            throw new JobNotFoundException(jobId);
        }

        logInfo("Moving job to deadletter job table {%s}",job.getId());

        //if (LOGGER.isDebugEnabled()) {
        //    LOGGER.debug("Moving job to deadletter job table {}", job.getId());
        //}

        DeadLetterJobEntity deadLetterJob = CommandContextUtil.getJobManager(commandContext).moveJobToDeadLetterJob(job);

        return deadLetterJob;
    }

    public string getJobId() {
        return jobId;
    }

}
