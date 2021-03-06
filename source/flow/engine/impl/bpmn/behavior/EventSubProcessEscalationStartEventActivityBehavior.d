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
module flow.engine.impl.bpmn.behavior.EventSubProcessEscalationStartEventActivityBehavior;


import flow.engine.deleg.DelegateExecution;
import flow.engine.impl.persistence.entity.ExecutionEntity;
import flow.engine.impl.util.CommandContextUtil;
import flow.engine.impl.bpmn.behavior.FlowNodeActivityBehavior;
/**
 * Implementation of the BPMN 2.0 event subprocess start event.
 *
 * @author Tijs Rademakers
 */
class EventSubProcessEscalationStartEventActivityBehavior : FlowNodeActivityBehavior {

    override
    public void trigger(DelegateExecution execution, string signalName, Object signalData) {
        CommandContextUtil.getActivityInstanceEntityManager().recordActivityStart(cast(ExecutionEntity) execution);
        super.trigger(execution, signalName, signalData);
    }

}
