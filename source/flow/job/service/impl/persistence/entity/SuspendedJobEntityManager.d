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
module flow.job.service.impl.persistence.entity.SuspendedJobEntityManager;

import hunt.collection.List;

import flow.common.persistence.entity.EntityManager;
import flow.job.service.api.Job;
import flow.job.service.impl.JobQueryImpl;
import flow.job.service.impl.SuspendedJobQueryImpl;
import flow.job.service.impl.persistence.entity.SuspendedJobEntity;

/**
 * @author Tijs Rademakers
 */
interface SuspendedJobEntityManager : EntityManager!SuspendedJobEntity {

    /**
     * Returns all {@link SuspendedJobEntity} instances related to on {@link ExecutionEntity}.
     */
    List!SuspendedJobEntity findJobsByExecutionId(string id);

    /**
     * Returns all {@link SuspendedJobEntity} instances related to on {@link ExecutionEntity}.
     */
    List!SuspendedJobEntity findJobsByProcessInstanceId(string id);

    /**
     * Executes a {@link JobQueryImpl} and returns the matching {@link SuspendedJobEntity} instances.
     */
    List!Job findJobsByQueryCriteria(SuspendedJobQueryImpl jobQuery);

    /**
     * Same as {@link #findJobsByQueryCriteria(SuspendedJobQueryImpl)}, but only returns a count and not the instances itself.
     */
    long findJobCountByQueryCriteria(SuspendedJobQueryImpl jobQuery);

    /**
     * Changes the tenantId for all jobs related to a given {@link DeploymentEntity}.
     */
    void updateJobTenantIdForDeployment(string deploymentId, string newTenantId);

}
