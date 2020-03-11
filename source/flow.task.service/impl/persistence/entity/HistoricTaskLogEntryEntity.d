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


import java.util.Date;

import flow.common.persistence.entity.Entity;
import flow.task.api.history.HistoricTaskLogEntry;

/**
 * @author martin.grofcik
 */
interface HistoricTaskLogEntryEntity extends HistoricTaskLogEntry, Entity {

    void setLogNumber(long logNumber);

    void setType(string type);

    void setTaskId(string taskId);

    void setTimeStamp(Date timeStamp);

    void setUserId(string userId);

    void setData(string data);

    void setExecutionId(string executionId);

    void setProcessInstanceId(string processInstanceId);

    void setProcessDefinitionId(string processDefinitionId);

    void setScopeId(string scopeId);

    void setScopeDefinitionId(string scopeDefinitionId);

    void setSubScopeId(string subScopeId);

    void setScopeType(string scopeType);

    void setTenantId(string tenantId);
}
