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



import java.util.ArrayList;
import java.util.List;

class ProcessInstanceBatchMigrationResult {
    
    public static final string STATUS_IN_PROGRESS = "inProgress";
    public static final string STATUS_WAITING = "waiting";
    public static final string STATUS_COMPLETED = "completed";
    
    public static final string RESULT_SUCCESS = "success";
    public static final string RESULT_FAIL = "fail";

    protected string batchId;
    protected string status;
    protected string sourceProcessDefinitionId;
    protected string targetProcessDefinitionId;
    protected List<ProcessInstanceBatchMigrationPartResult> allMigrationParts = new ArrayList<>();
    protected List<ProcessInstanceBatchMigrationPartResult> succesfulMigrationParts = new ArrayList<>();
    protected List<ProcessInstanceBatchMigrationPartResult> failedMigrationParts = new ArrayList<>();
    protected List<ProcessInstanceBatchMigrationPartResult> waitingMigrationParts = new ArrayList<>();

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

    public List<ProcessInstanceBatchMigrationPartResult> getAllMigrationParts() {
        return allMigrationParts;
    }

    public void addMigrationPart(ProcessInstanceBatchMigrationPartResult migrationPart) {
        if (allMigrationParts is null) {
            allMigrationParts = new ArrayList<>();
        }
        allMigrationParts.add(migrationPart);
        
        if (!STATUS_COMPLETED.equals(migrationPart.getStatus())) {
            if (waitingMigrationParts is null) {
                waitingMigrationParts = new ArrayList<>();
            }
            waitingMigrationParts.add(migrationPart);
        
        } else {
            if (RESULT_SUCCESS.equals(migrationPart.getResult())) {
                if (succesfulMigrationParts is null) {
                    succesfulMigrationParts = new ArrayList<>();
                }
                succesfulMigrationParts.add(migrationPart);
            
            } else {
                if (failedMigrationParts is null) {
                    failedMigrationParts = new ArrayList<>();
                }
                failedMigrationParts.add(migrationPart);
            }
        }
    }

    public List<ProcessInstanceBatchMigrationPartResult> getSuccessfulMigrationParts() {
        return succesfulMigrationParts;
    }

    public List<ProcessInstanceBatchMigrationPartResult> getFailedMigrationParts() {
        return failedMigrationParts;
    }

    public List<ProcessInstanceBatchMigrationPartResult> getWaitingMigrationParts() {
        return waitingMigrationParts;
    }

}
