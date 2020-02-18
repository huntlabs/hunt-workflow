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


import flow.common.api.FlowableIllegalArgumentException;
import flow.common.interceptor.Command;
import flow.common.interceptor.CommandContext;
import org.flowable.job.api.Job;
import org.flowable.job.api.JobNotFoundException;
import org.flowable.job.service.impl.persistence.entity.SuspendedJobEntity;
import org.flowable.job.service.impl.util.CommandContextUtil;

import java.io.Serializable;

/**
 * @author martin.grofcik
 */
class MoveSuspendedJobToExecutableJobCmd implements Command<Job>, Serializable {

    private static final long serialVersionUID = 1L;

    protected string jobId;

    public MoveSuspendedJobToExecutableJobCmd(string jobId) {
        this.jobId = jobId;
    }

    @Override
    public Job execute(CommandContext commandContext) {

        if (jobId is null) {
            throw new FlowableIllegalArgumentException("jobId and job is null");
        }

        SuspendedJobEntity job = CommandContextUtil.getSuspendedJobEntityManager(commandContext).findById(jobId);
        if (job is null) {
            throw new JobNotFoundException(jobId);
        }
        return CommandContextUtil.getJobServiceConfiguration().getJobService().activateSuspendedJob(job);
    }

    public string getJobId() {
        return jobId;
    }

}
