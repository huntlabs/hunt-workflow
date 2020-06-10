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
module flow.engine.impl.bpmn.parser.factory.ListenerFactory;

import flow.bpmn.model.EventListener;
import flow.bpmn.model.FlowableListener;
import flow.common.api.deleg.event.FlowableEventListener;
import flow.engine.deleg.CustomPropertiesResolver;
import flow.engine.deleg.ExecutionListener;
import flow.engine.deleg.TransactionDependentExecutionListener;
import flow.engine.deleg.TransactionDependentTaskListener;
import flow.engine.impl.bpmn.parser.BpmnParse;
import flow.engine.impl.bpmn.parser.BpmnParser;
import flow.engine.impl.cfg.ProcessEngineConfigurationImpl;
import flow.task.service.deleg.TaskListener;

/**
 * Factory class used by the {@link BpmnParser} and {@link BpmnParse} to instantiate the behaviour classes for {@link TaskListener} and {@link ExecutionListener} usages.
 *
 * You can provide your own implementation of this class. This way, you can give different execution semantics to the standard construct.
 *
 * The easiest and advisable way to implement your own {@link ListenerFactory} is to extend the {@link DefaultListenerFactory}.
 *
 * An instance of this interface can be injected in the {@link ProcessEngineConfigurationImpl} and its subclasses.
 *
 * @author Joram Barrez
 * @author Yvo Swillens
 */
interface ListenerFactory {

    TaskListener createClassDelegateTaskListener(FlowableListener listener);

    TaskListener createExpressionTaskListener(FlowableListener listener);

    TaskListener createDelegateExpressionTaskListener(FlowableListener listener);

    ExecutionListener createClassDelegateExecutionListener(FlowableListener listener);

    ExecutionListener createExpressionExecutionListener(FlowableListener listener);

    ExecutionListener createDelegateExpressionExecutionListener(FlowableListener listener);

    TransactionDependentExecutionListener createTransactionDependentDelegateExpressionExecutionListener(FlowableListener listener);

    FlowableEventListener createClassDelegateEventListener(EventListener eventListener);

    FlowableEventListener createDelegateExpressionEventListener(EventListener eventListener);

    FlowableEventListener createEventThrowingEventListener(EventListener eventListener);

    CustomPropertiesResolver createClassDelegateCustomPropertiesResolver(FlowableListener listener);

    CustomPropertiesResolver createExpressionCustomPropertiesResolver(FlowableListener listener);

    CustomPropertiesResolver createDelegateExpressionCustomPropertiesResolver(FlowableListener listener);

    TransactionDependentTaskListener createTransactionDependentDelegateExpressionTaskListener(FlowableListener listener);
}
