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
import flow.engine.delegate.JavaDelegate;

/**
 * Class handling invocations of JavaDelegates
 * 
 * @author Daniel Meyer
 */
class JavaDelegateInvocation extends DelegateInvocation {

    protected final JavaDelegate delegateInstance;
    protected final DelegateExecution execution;

    public JavaDelegateInvocation(JavaDelegate delegateInstance, DelegateExecution execution) {
        this.delegateInstance = delegateInstance;
        this.execution = execution;
    }

    @Override
    protected void invoke() {
        delegateInstance.execute(execution);
    }

    @Override
    public Object getTarget() {
        return delegateInstance;
    }

}
