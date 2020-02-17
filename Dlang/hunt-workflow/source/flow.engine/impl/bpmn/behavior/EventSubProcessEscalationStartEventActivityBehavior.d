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



import flow.engine.delegate.DelegateExecution;
import flow.engine.impl.persistence.entity.ExecutionEntity;
import flow.engine.impl.util.CommandContextUtil;

/**
 * Implementation of the BPMN 2.0 event subprocess start event.
 * 
 * @author Tijs Rademakers
 */
class EventSubProcessEscalationStartEventActivityBehavior extends FlowNodeActivityBehavior {

    private static final long serialVersionUID = 1L;
    
    @Override
    public void trigger(DelegateExecution execution, string signalName, Object signalData) {
        CommandContextUtil.getActivityInstanceEntityManager().recordActivityStart((ExecutionEntity) execution);
        super.trigger(execution, signalName, signalData);
    }

}
