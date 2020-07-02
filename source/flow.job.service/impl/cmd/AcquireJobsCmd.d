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
module flow.job.service.impl.cmd.AcquireJobsCmd;

//import java.util.Calendar;
//import java.util.GregorianCalendar;
import hunt.collection.List;

import flow.common.Page;
import flow.common.interceptor.Command;
import flow.common.interceptor.CommandContext;
import flow.job.service.impl.asyncexecutor.AcquiredJobEntities;
import flow.job.service.impl.asyncexecutor.AsyncExecutor;
import flow.job.service.impl.persistence.entity.JobInfoEntity;
import flow.job.service.impl.persistence.entity.JobInfoEntityManager;
import flow.job.service.impl.util.CommandContextUtil;
import hunt.Integer;
import hunt.Exceptions;

/**
 * @author Tijs Rademakers
 */
class AcquireJobsCmd : Command!AcquiredJobEntities {

    private  AsyncExecutor asyncExecutor;
    private  int remainingCapacity;
    private  JobInfoEntityManager!JobInfoEntity jobEntityManager;
    //private  JobInfoEntityManager<? extends JobInfoEntity> jobEntityManager;

    this(AsyncExecutor asyncExecutor) {
        this.asyncExecutor = asyncExecutor;
        this.remainingCapacity = Integer.MAX_VALUE;
        this.jobEntityManager = cast(JobInfoEntityManager!JobInfoEntity)(asyncExecutor.getJobServiceConfiguration().getJobEntityManager()); // backwards compatibility
    }

    this(AsyncExecutor asyncExecutor, int remainingCapacity, JobInfoEntityManager!JobInfoEntity jobEntityManager) {
        this.asyncExecutor = asyncExecutor;
        this.remainingCapacity = remainingCapacity;
        this.jobEntityManager = jobEntityManager;
    }

    public AcquiredJobEntities execute(CommandContext commandContext) {
        implementationMissing(false);
        return null;
        //int maxResults = Math.min(remainingCapacity, asyncExecutor.getMaxAsyncJobsDuePerAcquisition());
        //
        //List<? extends JobInfoEntity> jobs = jobEntityManager.findJobsToExecute(new Page(0, maxResults));
        //AcquiredJobEntities acquiredJobs = new AcquiredJobEntities();
        //
        //for (JobInfoEntity job : jobs) {
        //    lockJob(commandContext, job, asyncExecutor.getAsyncJobLockTimeInMillis());
        //    acquiredJobs.addJob(job);
        //}

        //return acquiredJobs;
    }

    protected void lockJob(CommandContext commandContext, JobInfoEntity job, int lockTimeInMillis) {
        implementationMissing(false);
        return;
        //GregorianCalendar gregorianCalendar = new GregorianCalendar();
        //gregorianCalendar.setTime(CommandContextUtil.getJobServiceConfiguration(commandContext).getClock().getCurrentTime());
        //gregorianCalendar.add(Calendar.MILLISECOND, lockTimeInMillis);
        //job.setLockOwner(asyncExecutor.getLockOwner());
        //job.setLockExpirationTime(gregorianCalendar.getTime());
    }
}
