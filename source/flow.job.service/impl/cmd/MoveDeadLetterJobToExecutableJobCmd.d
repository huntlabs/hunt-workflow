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
import org.flowable.job.service.impl.persistence.entity.DeadLetterJobEntity;
import org.flowable.job.service.impl.persistence.entity.JobEntity;
import org.flowable.job.service.impl.util.CommandContextUtil;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

/**
 * @author Tijs Rademakers
 */
public class MoveDeadLetterJobToExecutableJobCmd implements Command<JobEntity>, Serializable {

    private static final long serialVersionUID = 1L;

    private static final Logger LOGGER = LoggerFactory.getLogger(MoveDeadLetterJobToExecutableJobCmd.class);

    protected string jobId;
    protected int retries;

    public MoveDeadLetterJobToExecutableJobCmd(string jobId, int retries) {
        this.jobId = jobId;
        this.retries = retries;
    }

    @Override
    public JobEntity execute(CommandContext commandContext) {

        if (jobId == null) {
            throw new FlowableIllegalArgumentException("jobId and job is null");
        }

        DeadLetterJobEntity job = CommandContextUtil.getDeadLetterJobEntityManager(commandContext).findById(jobId);
        if (job == null) {
            throw new JobNotFoundException(jobId);
        }

        if (LOGGER.isDebugEnabled()) {
            LOGGER.debug("Moving deadletter job to executable job table {}", job.getId());
        }

        return CommandContextUtil.getJobManager(commandContext).moveDeadLetterJobToExecutableJob(job, retries);
    }

    public string getJobId() {
        return jobId;
    }

}
