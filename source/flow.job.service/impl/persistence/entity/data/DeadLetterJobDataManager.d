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

module flow.job.service.impl.persistence.entity.data.DeadLetterJobDataManager;
import hunt.collection.List;

import flow.common.persistence.entity.data.DataManager;
import flow.job.service.api.Job;
import flow.job.service.impl.DeadLetterJobQueryImpl;
import flow.job.service.impl.persistence.entity.DeadLetterJobEntity;

/**
 * @author Tijs Rademakers
 */
interface DeadLetterJobDataManager : DataManager!DeadLetterJobEntity {

    List!DeadLetterJobEntity findJobsByExecutionId(string executionId);

    List!DeadLetterJobEntity findJobsByProcessInstanceId(string processInstanceId);

    List!Job findJobsByQueryCriteria(DeadLetterJobQueryImpl jobQuery);

    long findJobCountByQueryCriteria(DeadLetterJobQueryImpl jobQuery);

    void updateJobTenantIdForDeployment(string deploymentId, string newTenantId);

}
