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
module flow.engine.impl.deleg.ActivityBehaviorInvocation;

import flow.engine.deleg.DelegateExecution;
import flow.engine.impl.deleg.invocation.DelegateInvocation;
import flow.engine.impl.deleg.ActivityBehavior;
/**
 *
 * @author Daniel Meyer
 */
class ActivityBehaviorInvocation : DelegateInvocation {

    protected  ActivityBehavior behaviorInstance;

    protected  DelegateExecution execution;

    this(ActivityBehavior behaviorInstance, DelegateExecution execution) {
        this.behaviorInstance = behaviorInstance;
        this.execution = execution;
    }

    override
    protected void invoke() {
        behaviorInstance.execute(execution);
    }

    override
    public Object getTarget() {
        return behaviorInstance;
    }

}
