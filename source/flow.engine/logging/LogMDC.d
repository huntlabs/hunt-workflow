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


import flow.engine.impl.persistence.entity.ExecutionEntity;
import org.slf4j.MDC;

/**
 * Constants and functions for MDC (Mapped Diagnostic Context) logging
 * 
 * @author Saeid Mirzaei
 */

class LogMDC {

    public static final string LOG_MDC_PROCESSDEFINITION_ID = "mdcProcessDefinitionID";
    public static final string LOG_MDC_EXECUTION_ID = "mdcExecutionId";
    public static final string LOG_MDC_PROCESSINSTANCE_ID = "mdcProcessInstanceID";
    public static final string LOG_MDC_BUSINESS_KEY = "mdcBusinessKey";
    public static final string LOG_MDC_TASK_ID = "mdcTaskId";

    static bool enabled;

    public static bool isMDCEnabled() {
        return enabled;
    }

    public static void setMDCEnabled(bool b) {
        enabled = b;
    }

    public static void putMDCExecution(ExecutionEntity e) {
        if (e.getId() !is null)
            MDC.put(LOG_MDC_EXECUTION_ID, e.getId());
        if (e.getProcessDefinitionId() !is null)
            MDC.put(LOG_MDC_PROCESSDEFINITION_ID, e.getProcessDefinitionId());
        if (e.getProcessInstanceId() !is null)
            MDC.put(LOG_MDC_PROCESSINSTANCE_ID, e.getProcessInstanceId());
        if (e.getProcessInstanceBusinessKey() !is null)
            MDC.put(LOG_MDC_BUSINESS_KEY, e.getProcessInstanceBusinessKey());

    }

    public static void clear() {
        MDC.clear();
    }
}
