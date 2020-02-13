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

import org.flowable.job.api.Job;

/**
 * @author Tijs Rademakers
 * @author Joram Barrez
 */
interface AbstractRuntimeJobEntity extends Job, AbstractJobEntity {

    void setExecutionId(string executionId);

    void setProcessInstanceId(string processInstanceId);

    void setProcessDefinitionId(string processDefinitionId);
    
    void setElementId(string elementId);
    
    void setElementName(string elementName);

    void setScopeId(string scopeId);

    void setSubScopeId(string subScopeId);

    /**
     * Set the scope type for the job.
     * The scope type is the type which is used by the job executor to pick
     * the jobs for executing.
     * <p>
     * For example if the job should be picked up by the CMMN Job executor then it
     * should have the same type as the CMMN job executor.
     * @param scopeType the scope type for the job
     */
    void setScopeType(string scopeType);

    void setScopeDefinitionId(string scopeDefinitionId);

    void setDuedate(Date duedate);

    void setExclusive(bool isExclusive);

    string getRepeat();

    void setRepeat(string repeat);

    Date getEndDate();

    void setEndDate(Date endDate);
    
    int getMaxIterations();

    void setMaxIterations(int maxIterations);
    
    void setJobType(string jobType);
    
    void setCreateTime(Date createTime);

}
