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
module flow.job.service.impl.persistence.entity.data.JobInfoDataManager;

import hunt.collection.List;

import flow.common.Page;
import flow.common.persistence.entity.data.DataManager;
import flow.job.service.impl.persistence.entity.JobInfoEntity;

interface JobInfoDataManager(T) : DataManager!T {

    List!T findJobsToExecute(Page page);

    List!T findJobsByExecutionId( string executionId);

    List!T findJobsByProcessInstanceId( string processInstanceId);

    List!T findExpiredJobs(Page page);

    void updateJobTenantIdForDeployment(string deploymentId, string newTenantId);

    void resetExpiredJob(string jobId);

}
