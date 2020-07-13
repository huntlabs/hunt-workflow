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
module flow.job.service.impl.persistence.entity.data.TimerJobDataManager;

import hunt.collection.List;

import flow.common.Page;
import flow.common.persistence.entity.data.DataManager;
import flow.job.service.api.Job;
import flow.job.service.impl.TimerJobQueryImpl;
import flow.job.service.impl.persistence.entity.TimerJobEntity;

/**
 * @author Tijs Rademakers
 * @author Vasile Dirla
 */
interface TimerJobDataManager : DataManager!TimerJobEntity {

    List!TimerJobEntity findTimerJobsToExecute(Page page);

    List!TimerJobEntity findJobsByTypeAndProcessDefinitionId(string jobHandlerType, string processDefinitionId);

    List!TimerJobEntity findJobsByTypeAndProcessDefinitionKeyNoTenantId(string jobHandlerType, string processDefinitionKey);

    List!TimerJobEntity findJobsByTypeAndProcessDefinitionKeyAndTenantId(string jobHandlerType, string processDefinitionKey, string tenantId);

    List!TimerJobEntity findJobsByExecutionId(string executionId);

    List!TimerJobEntity findJobsByProcessInstanceId(string processInstanceId);

    List!TimerJobEntity findJobsByScopeIdAndSubScopeId(string scopeId, string subScopeId);

    List!Job findJobsByQueryCriteria(TimerJobQueryImpl jobQuery);

    long findJobCountByQueryCriteria(TimerJobQueryImpl jobQuery);

    void updateJobTenantIdForDeployment(string deploymentId, string newTenantId);

}
