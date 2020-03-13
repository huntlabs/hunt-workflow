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
module flow.job.service.impl.persistence.entity.DeadLetterJobEntityManager;

import hunt.collection.List;

import flow.common.persistence.entity.EntityManager;
import flow.job.service.api.Job;
import flow.job.service.impl.DeadLetterJobQueryImpl;
import flow.job.service.impl.JobQueryImpl;
import flow.job.service.impl.persistence.entity.DeadLetterJobEntity;

/**
 * @author Tijs Rademakers
 */
interface DeadLetterJobEntityManager : EntityManager!DeadLetterJobEntity {

    /**
     * Returns all {@link DeadLetterJobEntity} instances related to an {@link ExecutionEntity}.
     */
    List!DeadLetterJobEntity findJobsByExecutionId(string id);

    /**
     * Returns all {@link DeadLetterJobEntity} instances related to a process instance
     */
    List!DeadLetterJobEntity findJobsByProcessInstanceId(string id);

    /**
     * Executes a {@link JobQueryImpl} and returns the matching {@link DeadLetterJobEntity} instances.
     */
    List!Job findJobsByQueryCriteria(DeadLetterJobQueryImpl jobQuery);

    /**
     * Same as {@link #findJobsByQueryCriteria(DeadLetterJobQueryImpl)}, but only returns a count and not the instances itself.
     */
    long findJobCountByQueryCriteria(DeadLetterJobQueryImpl jobQuery);

    /**
     * Changes the tenantId for all jobs related to a given {@link DeploymentEntity}.
     */
    void updateJobTenantIdForDeployment(string deploymentId, string newTenantId);

}
