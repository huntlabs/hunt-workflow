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

module flow.job.service.impl.cmd.GetJobExceptionStacktraceCmd;


import flow.common.api.FlowableIllegalArgumentException;
import flow.common.api.FlowableObjectNotFoundException;
import flow.common.interceptor.Command;
import flow.common.interceptor.CommandContext;
import flow.job.service.api.Job;
import flow.job.service.impl.persistence.entity.AbstractRuntimeJobEntity;
import flow.job.service.impl.util.CommandContextUtil;
import flow.job.service.impl.cmd.JobType;
/**
 * @author Frederik Heremans
 * @author Joram Barrez
 */
class GetJobExceptionStacktraceCmd : Command!string {

    private string jobId;
    protected JobType jobType;

    this(string jobId, JobType jobType) {
        this.jobId = jobId;
        this.jobType = jobType;
    }

    public string execute(CommandContext commandContext) {
        if (jobId is null) {
            throw new FlowableIllegalArgumentException("jobId is null");
        }

        AbstractRuntimeJobEntity job = null;
        switch (jobType) {
        case JobType.ASYNC:
            job = CommandContextUtil.getJobEntityManager(commandContext).findById(jobId);
            break;
        case JobType.TIMER:
            job = CommandContextUtil.getTimerJobEntityManager(commandContext).findById(jobId);
            break;
        case JobType.SUSPENDED:
            job = CommandContextUtil.getSuspendedJobEntityManager(commandContext).findById(jobId);
            break;
        case JobType.DEADLETTER:
            job = CommandContextUtil.getDeadLetterJobEntityManager(commandContext).findById(jobId);
            break;
        default:
            break;
        }

        if (job is null) {
            throw new FlowableObjectNotFoundException("No job found with id " ~ jobId);
        }

        return job.getExceptionStacktrace();
    }

}
