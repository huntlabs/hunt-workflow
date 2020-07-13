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
module flow.engine.impl.deleg.invocation.JavaDelegateInvocation;

import flow.engine.deleg.DelegateExecution;
import flow.engine.deleg.JavaDelegate;
import flow.engine.impl.deleg.invocation.DelegateInvocation;
/**
 * Class handling invocations of JavaDelegates
 *
 * @author Daniel Meyer
 */
class JavaDelegateInvocation : DelegateInvocation {

    protected  JavaDelegate delegateInstance;
    protected  DelegateExecution execution;

    this(JavaDelegate delegateInstance, DelegateExecution execution) {
        this.delegateInstance = delegateInstance;
        this.execution = execution;
    }

    override
    protected void invoke() {
        delegateInstance.execute(execution);
    }

    override
    public Object getTarget() {
        return cast(Object)delegateInstance;
    }

}
