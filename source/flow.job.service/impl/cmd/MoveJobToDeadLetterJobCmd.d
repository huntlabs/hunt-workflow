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


import java.io.Serializable;

import flow.common.api.FlowableIllegalArgumentException;
import flow.common.interceptor.Command;
import flow.common.interceptor.CommandContext;
import org.flowable.job.api.JobNotFoundException;
import org.flowable.job.service.impl.persistence.entity.AbstractRuntimeJobEntity;
import org.flowable.job.service.impl.persistence.entity.DeadLetterJobEntity;
import org.flowable.job.service.impl.util.CommandContextUtil;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

/**
 * @author Tijs Rademakers
 */
class MoveJobToDeadLetterJobCmd implements Command<DeadLetterJobEntity>, Serializable {

    private static final long serialVersionUID = 1L;

    private static final Logger LOGGER = LoggerFactory.getLogger(MoveJobToDeadLetterJobCmd.class);

    protected string jobId;

    public MoveJobToDeadLetterJobCmd(string jobId) {
        this.jobId = jobId;
    }

    @Override
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

        if (LOGGER.isDebugEnabled()) {
            LOGGER.debug("Moving job to deadletter job table {}", job.getId());
        }

        DeadLetterJobEntity deadLetterJob = CommandContextUtil.getJobManager(commandContext).moveJobToDeadLetterJob(job);

        return deadLetterJob;
    }

    public string getJobId() {
        return jobId;
    }

}