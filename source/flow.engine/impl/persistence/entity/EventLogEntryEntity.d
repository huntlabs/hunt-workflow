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


import hunt.time.LocalDateTime;

import flow.common.persistence.entity.Entity;
import flow.engine.event.EventLogEntry;

/**
 * An event log entry can only be inserted (and maybe deleted).
 *
 * @author Joram Barrez
 */
interface EventLogEntryEntity extends Entity, EventLogEntry {

    void setLogNumber(long logNumber);

    void setType(string type);

    void setProcessDefinitionId(string processDefinitionId);

    void setProcessInstanceId(string processInstanceId);

    void setExecutionId(string executionId);

    void setTaskId(string taskId);

    void setTimeStamp(Date timeStamp);

    void setUserId(string userId);

    void setData(byte[] data);

    string getLockOwner();

    void setLockOwner(string lockOwner);

    string getLockTime();

    void setLockTime(string lockTime);

    int getProcessed();

    void setProcessed(int isProcessed);

}
