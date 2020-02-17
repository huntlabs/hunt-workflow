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


import java.util.Map;

import org.flowable.eventsubscription.service.impl.persistence.entity.EventSubscriptionEntity;

/**
 * @author Tijs Rademakers
 */
interface CaseInstanceService {
    
    /**
     * @return A new id that will be used when starting a case instance.
     *         This is for example needed to set the bidrectional relation
     *         when a process instance starts a case instance through a case task.
     */
    string generateNewCaseInstanceId();

    string startCaseInstanceByKey(string caseDefinitionKey, string predefinedCaseInstanceId, string caseInstanceName, string businessKey,
                    string executionId, string tenantId, bool fallbackToDefaultTenant, Map<string, Object> inParametersMap);
    
    void handleSignalEvent(EventSubscriptionEntity eventSubscription);

    void deleteCaseInstance(string caseInstanceId);

    void deleteCaseInstancesForExecutionId(string executionId);

}
