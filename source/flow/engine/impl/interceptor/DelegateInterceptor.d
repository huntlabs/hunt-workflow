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
module flow.engine.impl.interceptor.DelegateInterceptor;

import flow.engine.impl.deleg.invocation.DelegateInvocation;

/**
 * Interceptor responsible for handling calls to 'user code'. User code represents external Java code (e.g. services and listeners) invoked by the process engine. The following is a list of classes
 * that represent user code:
 * <ul>
 * <li>{@link flow.engine.deleg.JavaDelegate}</li>
 * <li>{@link flow.engine.deleg.ExecutionListener}</li>
 * <li>{@link flow.engine.deleg.Expression}</li>
 * <li>{@link flow.engine.deleg.TaskListener}</li>
 * </ul>
 *
 * The interceptor is passed in an instance of {@link DelegateInvocation}. Implementations are responsible for calling {@link DelegateInvocation#proceed()}.
 *
 * @author Daniel Meyer
 */
interface DelegateInterceptor {

    public void handleInvocation(DelegateInvocation invocation);

}
