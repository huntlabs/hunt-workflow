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
module flow.job.service.impl.cmd.LockExclusiveJobCmd;


import flow.common.api.FlowableIllegalArgumentException;
import flow.common.interceptor.Command;
import flow.common.interceptor.CommandContext;
import flow.job.service.api.Job;
import flow.job.service.InternalJobManager;
import flow.job.service.impl.util.CommandContextUtil;
import hunt.logging;
/**
 * @author Tijs Rademakers
 */
class LockExclusiveJobCmd : Command!Object {

    protected Job job;

    this(Job job) {
        this.job = job;
    }

    public Object execute(CommandContext commandContext) {

        if (job is null) {
            throw new FlowableIllegalArgumentException("job is null");
        }
        logInfo("Executing lock exclusive job {%s} {}",job.getId);
        //if (LOGGER.isDebugEnabled()) {
        //    LOGGER.debug("Executing lock exclusive job {} {}", job.getId(), job.getExecutionId());
        //}

        if (job.isExclusive()) {
            if (job.getExecutionId() !is null || job.getScopeId() !is null) {
                InternalJobManager internalJobManager = CommandContextUtil.getJobServiceConfiguration().getInternalJobManager();
                if (internalJobManager !is null) {
                    internalJobManager.lockJobScope(job);
                }
            }
        }

        return null;
    }
}
