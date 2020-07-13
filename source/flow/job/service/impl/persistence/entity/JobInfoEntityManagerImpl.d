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

module flow.job.service.impl.persistence.entity.JobInfoEntityManagerImpl;

import hunt.collection.List;

import flow.common.Page;
import flow.job.service.JobServiceConfiguration;
import flow.job.service.impl.persistence.entity.AbstractJobServiceEngineEntityManager;
import flow.job.service.impl.persistence.entity.JobInfoEntityManager;

/**
 * @author Tom Baeyens
 * @author Daniel Meyer
 * @author Joram Barrez
 */
abstract class JobInfoEntityManagerImpl(T , DM) : AbstractJobServiceEngineEntityManager!(T, DM) ,JobInfoEntityManager!T {
//abstract class JobInfoEntityManagerImpl<T extends JobInfoEntity, DM extends JobInfoDataManager<T>>


    this(JobServiceConfiguration jobServiceConfiguration, DM jobDataManager) {
        super(jobServiceConfiguration, jobDataManager);
    }


    public List!T findJobsToExecute(Page page) {
        return dataManager.findJobsToExecute(page);
    }


    public List!T findJobsByExecutionId(string executionId) {
        return dataManager.findJobsByExecutionId(executionId);
    }


    public List!T findJobsByProcessInstanceId(string processInstanceId) {
        return dataManager.findJobsByProcessInstanceId(processInstanceId);
    }


    public List!T findExpiredJobs(Page page) {
        return dataManager.findExpiredJobs(page);
    }


    public void resetExpiredJob(string jobId) {
        dataManager.resetExpiredJob(jobId);
    }


    public void updateJobTenantIdForDeployment(string deploymentId, string newTenantId) {
        dataManager.updateJobTenantIdForDeployment(deploymentId, newTenantId);
    }

}
