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

module flow.job.service.TimerJobService;
import hunt.collection.List;

import flow.job.service.impl.persistence.entity.AbstractRuntimeJobEntity;
import flow.job.service.impl.persistence.entity.JobEntity;
import flow.job.service.impl.persistence.entity.TimerJobEntity;

/**
 * Service which provides access to timer jobs.
 *
 * @author Tijs Rademakers
 */
interface TimerJobService {

    void scheduleTimerJob(TimerJobEntity timerJob);

    TimerJobEntity findTimerJobById(string jobId);

    List!TimerJobEntity findTimerJobsByExecutionId(string executionId);

    List!TimerJobEntity findTimerJobsByProcessInstanceId(string processInstanceId);

    List!TimerJobEntity findJobsByTypeAndProcessDefinitionId(string type, string processDefinitionId);

    List!TimerJobEntity findJobsByTypeAndProcessDefinitionKeyNoTenantId(string type, string processDefinitionKey);

    List!TimerJobEntity findJobsByTypeAndProcessDefinitionKeyAndTenantId(string type, string processDefinitionKey, string tenantId);

    AbstractRuntimeJobEntity moveJobToTimerJob(JobEntity job);

    TimerJobEntity createTimerJob();

    void insertTimerJob(TimerJobEntity timerJob);

    void deleteTimerJob(TimerJobEntity timerJob);

    void deleteTimerJobsByExecutionId(string executionId);
}
