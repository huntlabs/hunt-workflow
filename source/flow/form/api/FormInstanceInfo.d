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

module flow.form.api.FormInstanceInfo;
import hunt.time.LocalDateTime;
import flow.form.api.FormInfo;
alias Date = LocalDateTime;

//import com.fasterxml.jackson.annotation.JsonInclude;
//import com.fasterxml.jackson.annotation.JsonInclude.Include;

/**
 * @author Tijs Rademakers
 */
//@JsonInclude(Include.NON_NULL)
class FormInstanceInfo : FormInfo {

    private static  long serialVersionUID = 1L;

    protected string formInstanceId;
    protected string submittedBy;
    protected Date submittedDate;
    protected string selectedOutcome;
    protected string taskId;
    protected string processInstanceId;
    protected string processDefinitionId;
    protected string scopeId;
    protected string scopeType;
    protected string scopeDefinitionId;
    protected string tenantId;

    public string getFormInstanceId() {
        return formInstanceId;
    }

    public void setFormInstanceId(string formInstanceId) {
        this.formInstanceId = formInstanceId;
    }

    public string getSubmittedBy() {
        return submittedBy;
    }

    public void setSubmittedBy(string submittedBy) {
        this.submittedBy = submittedBy;
    }

    public Date getSubmittedDate() {
        return submittedDate;
    }

    public void setSubmittedDate(Date submittedDate) {
        this.submittedDate = submittedDate;
    }

    public string getSelectedOutcome() {
        return selectedOutcome;
    }

    public void setSelectedOutcome(string selectedOutcome) {
        this.selectedOutcome = selectedOutcome;
    }

    public string getTaskId() {
        return taskId;
    }

    public void setTaskId(string taskId) {
        this.taskId = taskId;
    }

    public string getProcessInstanceId() {
        return processInstanceId;
    }

    public void setProcessInstanceId(string processInstanceId) {
        this.processInstanceId = processInstanceId;
    }

    public string getProcessDefinitionId() {
        return processDefinitionId;
    }

    public void setProcessDefinitionId(string processDefinitionId) {
        this.processDefinitionId = processDefinitionId;
    }

    public string getScopeId() {
        return scopeId;
    }

    public void setScopeId(string scopeId) {
        this.scopeId = scopeId;
    }

    public string getScopeType() {
        return scopeType;
    }

    public void setScopeType(string scopeType) {
        this.scopeType = scopeType;
    }

    public string getScopeDefinitionId() {
        return scopeDefinitionId;
    }

    public void setScopeDefinitionId(string scopeDefinitionId) {
        this.scopeDefinitionId = scopeDefinitionId;
    }

    public string getTenantId() {
        return tenantId;
    }

    public void setTenantId(string tenantId) {
        this.tenantId = tenantId;
    }

}
