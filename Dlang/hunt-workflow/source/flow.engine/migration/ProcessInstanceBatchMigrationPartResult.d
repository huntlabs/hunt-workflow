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



class ProcessInstanceBatchMigrationPartResult {

    protected string batchId;
    protected string status = ProcessInstanceBatchMigrationResult.STATUS_WAITING;
    protected string result;
    protected string processInstanceId;
    protected string sourceProcessDefinitionId;
    protected string targetProcessDefinitionId;
    protected string migrationMessage;

    public string getBatchId() {
        return batchId;
    }

    public void setBatchId(string batchId) {
        this.batchId = batchId;
    }

    public string getStatus() {
        return status;
    }

    public void setStatus(string status) {
        this.status = status;
    }
    
    public string getResult() {
        return result;
    }

    public void setResult(string result) {
        this.result = result;
    }

    public string getProcessInstanceId() {
        return processInstanceId;
    }

    public void setProcessInstanceId(string processInstanceId) {
        this.processInstanceId = processInstanceId;
    }

    public string getSourceProcessDefinitionId() {
        return sourceProcessDefinitionId;
    }

    public void setSourceProcessDefinitionId(string sourceProcessDefinitionId) {
        this.sourceProcessDefinitionId = sourceProcessDefinitionId;
    }

    public string getTargetProcessDefinitionId() {
        return targetProcessDefinitionId;
    }

    public void setTargetProcessDefinitionId(string targetProcessDefinitionId) {
        this.targetProcessDefinitionId = targetProcessDefinitionId;
    }

    public string getMigrationMessage() {
        return migrationMessage;
    }

    public void setMigrationMessage(string migrationMessage) {
        this.migrationMessage = migrationMessage;
    }
}
