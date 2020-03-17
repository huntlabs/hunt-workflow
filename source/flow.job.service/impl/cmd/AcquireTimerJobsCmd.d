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
module flow.job.service.impl.cmd.AcquireTimerJobsCmd;

//import java.util.Calendar;
//import java.util.GregorianCalendar;
import hunt.collection.List;

import flow.common.Page;
import flow.common.interceptor.Command;
import flow.common.interceptor.CommandContext;
import flow.job.service.impl.asyncexecutor.AcquiredTimerJobEntities;
import flow.job.service.impl.asyncexecutor.AsyncExecutor;
import flow.job.service.impl.persistence.entity.TimerJobEntity;
import flow.job.service.impl.util.CommandContextUtil;
import hunt.Exceptions;

/**
 * @author Tijs Rademakers
 */
class AcquireTimerJobsCmd : Command!AcquiredTimerJobEntities {

    private  AsyncExecutor asyncExecutor;

    this(AsyncExecutor asyncExecutor) {
        this.asyncExecutor = asyncExecutor;
    }

    public AcquiredTimerJobEntities execute(CommandContext commandContext) {
        AcquiredTimerJobEntities acquiredJobs = new AcquiredTimerJobEntities();
        List!TimerJobEntity timerJobs = CommandContextUtil.getTimerJobEntityManager(commandContext)
                .findTimerJobsToExecute(new Page(0, asyncExecutor.getMaxAsyncJobsDuePerAcquisition()));

        foreach (TimerJobEntity job ; timerJobs) {
            lockJob(commandContext, job, asyncExecutor.getAsyncJobLockTimeInMillis());
            acquiredJobs.addJob(job);
        }

        return acquiredJobs;
    }

    protected void lockJob(CommandContext commandContext, TimerJobEntity job, int lockTimeInMillis) {
        implementationMissing(false);
        // This will trigger an optimistic locking exception when two concurrent executors
        // try to lock, as the revision will not match.

        //GregorianCalendar gregorianCalendar = new GregorianCalendar();
        //gregorianCalendar.setTime(CommandContextUtil.getJobServiceConfiguration(commandContext).getClock().getCurrentTime());
        //gregorianCalendar.add(Calendar.MILLISECOND, lockTimeInMillis);
        //job.setLockOwner(asyncExecutor.getLockOwner());
        //job.setLockExpirationTime(gregorianCalendar.getTime());
    }
}
