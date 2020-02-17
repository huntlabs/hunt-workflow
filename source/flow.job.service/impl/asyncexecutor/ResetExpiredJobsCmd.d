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


import java.util.Collection;

import flow.common.interceptor.Command;
import flow.common.interceptor.CommandContext;
import org.flowable.job.service.impl.persistence.entity.JobInfoEntity;
import org.flowable.job.service.impl.persistence.entity.JobInfoEntityManager;
import org.flowable.job.service.impl.util.CommandContextUtil;

/**
 * @author Joram Barrez
 */
class ResetExpiredJobsCmd implements Command<Void> {

    protected Collection<string> jobIds;
    protected JobInfoEntityManager<? extends JobInfoEntity> jobEntityManager;
    
    public ResetExpiredJobsCmd(Collection<string> jobsIds, JobInfoEntityManager<? extends JobInfoEntity> jobEntityManager) {
        this.jobIds = jobsIds;
        this.jobEntityManager = jobEntityManager;
    }

    @Override
    public Void execute(CommandContext commandContext) {
        for (string jobId : jobIds) {
            JobInfoEntity job = jobEntityManager.findById(jobId);
            CommandContextUtil.getJobManager(commandContext).unacquire(job);
            jobEntityManager.resetExpiredJob(jobId);
        }
        return null;
    }

}
