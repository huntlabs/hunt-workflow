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

import flow.common.api.FlowableException;
import flow.common.api.FlowableIllegalArgumentException;
import flow.common.interceptor.Command;
import flow.common.interceptor.CommandContext;
import flow.job.service.api.Job;
import flow.job.service.api.JobNotFoundException;
import flow.job.service.InternalJobCompatibilityManager;
import flow.job.service.JobServiceConfiguration;
import flow.job.service.impl.asyncexecutor.FailedJobListener;
import flow.job.service.impl.util.CommandContextUtil;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

/**
 * @author Tom Baeyens
 * @author Joram Barrez
 */
class ExecuteJobCmd implements Command<Object>, Serializable {

    private static final long serialVersionUID = 1L;

    private static final Logger LOGGER = LoggerFactory.getLogger(ExecuteJobCmd.class);

    protected string jobId;

    public ExecuteJobCmd(string jobId) {
        this.jobId = jobId;
    }

    @Override
    public Object execute(CommandContext commandContext) {

        if (jobId is null) {
            throw new FlowableIllegalArgumentException("JobId is null");
        }

        Job job = CommandContextUtil.getJobEntityManager(commandContext).findById(jobId);

        if (job is null) {
            throw new JobNotFoundException(jobId);
        }

        if (LOGGER.isDebugEnabled()) {
            LOGGER.debug("Executing job {}", job.getId());
        }

        JobServiceConfiguration jobServiceConfiguration = CommandContextUtil.getJobServiceConfiguration(commandContext);
        InternalJobCompatibilityManager internalJobCompatibilityManager = jobServiceConfiguration.getInternalJobCompatibilityManager();
        if (internalJobCompatibilityManager !is null && internalJobCompatibilityManager.isFlowable5Job(job)) {
            internalJobCompatibilityManager.executeV5Job(job);
            return null;
        }

        commandContext.addCloseListener(new FailedJobListener(jobServiceConfiguration.getCommandExecutor(), job));

        try {
            CommandContextUtil.getJobManager(commandContext).execute(job);
        } catch (Throwable exception) {
            // Finally, Throw the exception to indicate the ExecuteJobCmd failed
            throw new FlowableException("Job " + jobId + " failed", exception);
        }

        return null;
    }

    public string getJobId() {
        return jobId;
    }

}
