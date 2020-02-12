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

import org.flowable.bpmn.model.Task;
import org.flowable.task.service.delegate.BaseTaskListener;

/**
 * Callback interface to be notified of transaction events.
 *
 * @author Yvo Swillens
 */
interface TransactionDependentTaskListener extends BaseTaskListener {

    string ON_TRANSACTION_COMMITTING = "before-commit";
    string ON_TRANSACTION_COMMITTED = "committed";
    string ON_TRANSACTION_ROLLED_BACK = "rolled-back";

    void notify(string processInstanceId, string executionId, Task task,
            Map<string, Object> executionVariables, Map<string, Object> customPropertiesMap);
}
