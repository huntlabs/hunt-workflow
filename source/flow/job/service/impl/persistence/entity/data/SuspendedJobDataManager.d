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
module flow.job.service.impl.persistence.entity.data.SuspendedJobDataManager;

import hunt.collection.List;

import flow.common.persistence.entity.data.DataManager;
import flow.job.service.api.Job;
import flow.job.service.impl.SuspendedJobQueryImpl;
import flow.job.service.impl.persistence.entity.SuspendedJobEntity;

/**
 * @author Tijs Rademakers
 */
interface SuspendedJobDataManager : DataManager!SuspendedJobEntity {

    List!SuspendedJobEntity findJobsByExecutionId(string executionId);

    List!SuspendedJobEntity findJobsByProcessInstanceId(string processInstanceId);

    List!Job findJobsByQueryCriteria(SuspendedJobQueryImpl jobQuery);

    long findJobCountByQueryCriteria(SuspendedJobQueryImpl jobQuery);

    void updateJobTenantIdForDeployment(string deploymentId, string newTenantId);

}
