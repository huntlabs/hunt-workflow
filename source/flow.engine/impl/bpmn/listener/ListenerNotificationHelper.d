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


import hunt.collection.List;
import hunt.collection.Map;

import flow.bpmn.model.FlowElement;
import flow.bpmn.model.FlowableListener;
import flow.bpmn.model.HasExecutionListeners;
import flow.bpmn.model.ImplementationType;
import flow.bpmn.model.Task;
import flow.bpmn.model.UserTask;
import flow.common.api.FlowableException;
import flow.common.cfg.TransactionContext;
import flow.common.cfg.TransactionListener;
import flow.common.cfg.TransactionState;
import flow.common.context.Context;
import flow.engine.deleg.BaseExecutionListener;
import flow.engine.deleg.CustomPropertiesResolver;
import flow.engine.deleg.DelegateExecution;
import flow.engine.deleg.ExecutionListener;
import flow.engine.deleg.TransactionDependentExecutionListener;
import flow.engine.deleg.TransactionDependentTaskListener;
import flow.engine.impl.bpmn.parser.factory.ListenerFactory;
import flow.engine.impl.delegate.invocation.TaskListenerInvocation;
import flow.engine.impl.util.CommandContextUtil;
import flow.engine.impl.util.ExecutionHelper;
import flow.engine.impl.util.ProcessDefinitionUtil;
import flow.task.service.deleg.BaseTaskListener;
import flow.task.service.deleg.TaskListener;
import org.flowable.task.service.impl.persistence.entity.TaskEntity;

/**
 * @author Joram Barrez
 */
class ListenerNotificationHelper {

    public void executeExecutionListeners(HasExecutionListeners elementWithExecutionListeners, DelegateExecution execution, string eventType) {
        List<FlowableListener> listeners = elementWithExecutionListeners.getExecutionListeners();
        if (listeners !is null && listeners.size() > 0) {
            ListenerFactory listenerFactory = CommandContextUtil.getProcessEngineConfiguration().getListenerFactory();
            for (FlowableListener listener : listeners) {

                if (eventType.equals(listener.getEvent())) {

                    BaseExecutionListener executionListener = null;

                    if (ImplementationType.IMPLEMENTATION_TYPE_CLASS.equalsIgnoreCase(listener.getImplementationType())) {
                        executionListener = listenerFactory.createClassDelegateExecutionListener(listener);
                    } else if (ImplementationType.IMPLEMENTATION_TYPE_EXPRESSION.equalsIgnoreCase(listener.getImplementationType())) {
                        executionListener = listenerFactory.createExpressionExecutionListener(listener);
                    } else if (ImplementationType.IMPLEMENTATION_TYPE_DELEGATEEXPRESSION.equalsIgnoreCase(listener.getImplementationType())) {
                        if (listener.getOnTransaction() !is null) {
                            executionListener = listenerFactory.createTransactionDependentDelegateExpressionExecutionListener(listener);
                        } else {
                            executionListener = listenerFactory.createDelegateExpressionExecutionListener(listener);
                        }
                    } else if (ImplementationType.IMPLEMENTATION_TYPE_INSTANCE.equalsIgnoreCase(listener.getImplementationType())) {
                        executionListener = (ExecutionListener) listener.getInstance();
                    }

                    if (executionListener !is null) {
                        if (listener.getOnTransaction() !is null) {
                            planTransactionDependentExecutionListener(listenerFactory, execution, (TransactionDependentExecutionListener) executionListener, listener);
                        } else {
                            execution.setEventName(eventType); // eventName is used to differentiate the event when reusing an execution listener for various events
                            execution.setCurrentFlowableListener(listener);
                            ((ExecutionListener) executionListener).notify(execution);
                            execution.setEventName(null);
                            execution.setCurrentFlowableListener(null);
                        }
                    }
                }
            }
        }
    }

    protected void planTransactionDependentExecutionListener(ListenerFactory listenerFactory, DelegateExecution execution,
                    TransactionDependentExecutionListener executionListener, FlowableListener listener) {

        Map!(string, Object) executionVariablesToUse = execution.getVariables();
        CustomPropertiesResolver customPropertiesResolver = createCustomPropertiesResolver(listener);
        Map!(string, Object) customPropertiesMapToUse = invokeCustomPropertiesResolver(execution, customPropertiesResolver);

        TransactionDependentExecutionListenerExecutionScope scope = new TransactionDependentExecutionListenerExecutionScope(
                execution.getProcessInstanceId(), execution.getId(), execution.getCurrentFlowElement(), executionVariablesToUse, customPropertiesMapToUse);

        addTransactionListener(listener, new ExecuteExecutionListenerTransactionListener(executionListener, scope,
                        CommandContextUtil.getProcessEngineConfiguration().getCommandExecutor()));
    }

    public void executeTaskListeners(TaskEntity taskEntity, string eventType) {
        if (taskEntity.getProcessDefinitionId() !is null) {
            flow.bpmn.model.Process process = ProcessDefinitionUtil.getProcess(taskEntity.getProcessDefinitionId());
            FlowElement flowElement = process.getFlowElement(taskEntity.getTaskDefinitionKey(), true);
            if (flowElement instanceof UserTask) {
                UserTask userTask = (UserTask) flowElement;
                executeTaskListeners(userTask, taskEntity, eventType);
            }
        }
    }

    public void executeTaskListeners(UserTask userTask, TaskEntity taskEntity, string eventType) {
        for (FlowableListener listener : userTask.getTaskListeners()) {
            string event = listener.getEvent();
            if (event.equals(eventType) || event.equals(TaskListener.EVENTNAME_ALL_EVENTS)) {
                BaseTaskListener taskListener = createTaskListener(listener);

                if (listener.getOnTransaction() !is null) {
                    planTransactionDependentTaskListener(ExecutionHelper.getExecution(taskEntity.getExecutionId()), (TransactionDependentTaskListener) taskListener, listener);
                } else {
                    taskEntity.setEventName(eventType);
                    taskEntity.setEventHandlerId(listener.getId());

                    try {
                        CommandContextUtil.getProcessEngineConfiguration().getDelegateInterceptor()
                                .handleInvocation(new TaskListenerInvocation((TaskListener) taskListener, taskEntity));
                    } catch (Exception e) {
                        throw new FlowableException("Exception while invoking TaskListener: " + e.getMessage(), e);
                    } finally {
                        taskEntity.setEventName(null);
                    }
                }
            }
        }
    }

    protected BaseTaskListener createTaskListener(FlowableListener listener) {
        BaseTaskListener taskListener = null;

        ListenerFactory listenerFactory = CommandContextUtil.getProcessEngineConfiguration().getListenerFactory();
        if (ImplementationType.IMPLEMENTATION_TYPE_CLASS.equalsIgnoreCase(listener.getImplementationType())) {
            taskListener = listenerFactory.createClassDelegateTaskListener(listener);
        } else if (ImplementationType.IMPLEMENTATION_TYPE_EXPRESSION.equalsIgnoreCase(listener.getImplementationType())) {
            taskListener = listenerFactory.createExpressionTaskListener(listener);
        } else if (ImplementationType.IMPLEMENTATION_TYPE_DELEGATEEXPRESSION.equalsIgnoreCase(listener.getImplementationType())) {
            if (listener.getOnTransaction() !is null) {
                taskListener = listenerFactory.createTransactionDependentDelegateExpressionTaskListener(listener);
            } else {
                taskListener = listenerFactory.createDelegateExpressionTaskListener(listener);
            }
        } else if (ImplementationType.IMPLEMENTATION_TYPE_INSTANCE.equalsIgnoreCase(listener.getImplementationType())) {
            taskListener = (TaskListener) listener.getInstance();
        }
        return taskListener;
    }

    protected void planTransactionDependentTaskListener(DelegateExecution execution, TransactionDependentTaskListener taskListener, FlowableListener listener) {
        Map!(string, Object) executionVariablesToUse = execution.getVariables();
        CustomPropertiesResolver customPropertiesResolver = createCustomPropertiesResolver(listener);
        Map!(string, Object) customPropertiesMapToUse = invokeCustomPropertiesResolver(execution, customPropertiesResolver);

        TransactionDependentTaskListenerExecutionScope scope = new TransactionDependentTaskListenerExecutionScope(
                execution.getProcessInstanceId(), execution.getId(), (Task) execution.getCurrentFlowElement(), executionVariablesToUse, customPropertiesMapToUse);
        addTransactionListener(listener, new ExecuteTaskListenerTransactionListener(taskListener, scope,
                        CommandContextUtil.getProcessEngineConfiguration().getCommandExecutor()));
    }

    protected CustomPropertiesResolver createCustomPropertiesResolver(FlowableListener listener) {
        CustomPropertiesResolver customPropertiesResolver = null;
        ListenerFactory listenerFactory = CommandContextUtil.getProcessEngineConfiguration().getListenerFactory();
        if (ImplementationType.IMPLEMENTATION_TYPE_CLASS.equalsIgnoreCase(listener.getCustomPropertiesResolverImplementationType())) {
            customPropertiesResolver = listenerFactory.createClassDelegateCustomPropertiesResolver(listener);
        } else if (ImplementationType.IMPLEMENTATION_TYPE_EXPRESSION.equalsIgnoreCase(listener.getCustomPropertiesResolverImplementationType())) {
            customPropertiesResolver = listenerFactory.createExpressionCustomPropertiesResolver(listener);
        } else if (ImplementationType.IMPLEMENTATION_TYPE_DELEGATEEXPRESSION.equalsIgnoreCase(listener.getCustomPropertiesResolverImplementationType())) {
            customPropertiesResolver = listenerFactory.createDelegateExpressionCustomPropertiesResolver(listener);
        }
        return customPropertiesResolver;
    }

    protected Map!(string, Object) invokeCustomPropertiesResolver(DelegateExecution execution, CustomPropertiesResolver customPropertiesResolver) {
        Map!(string, Object) customPropertiesMapToUse = null;
        if (customPropertiesResolver !is null) {
            customPropertiesMapToUse = customPropertiesResolver.getCustomPropertiesMap(execution);
        }
        return customPropertiesMapToUse;
    }

    protected void addTransactionListener(FlowableListener listener, TransactionListener transactionListener) {
        TransactionContext transactionContext = Context.getTransactionContext();
        if (TransactionDependentExecutionListener.ON_TRANSACTION_BEFORE_COMMIT.equals(listener.getOnTransaction())) {
            transactionContext.addTransactionListener(TransactionState.COMMITTING, transactionListener);

        } else if (TransactionDependentExecutionListener.ON_TRANSACTION_COMMITTED.equals(listener.getOnTransaction())) {
            transactionContext.addTransactionListener(TransactionState.COMMITTED, transactionListener);

        } else if (TransactionDependentExecutionListener.ON_TRANSACTION_ROLLED_BACK.equals(listener.getOnTransaction())) {
            transactionContext.addTransactionListener(TransactionState.ROLLED_BACK, transactionListener);

        }
    }

}
