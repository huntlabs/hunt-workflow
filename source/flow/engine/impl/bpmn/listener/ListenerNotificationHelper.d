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
module flow.engine.impl.bpmn.listener.ListenerNotificationHelper;

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
import flow.engine.impl.deleg.invocation.TaskListenerInvocation;
import flow.engine.impl.util.CommandContextUtil;
import flow.engine.impl.util.ExecutionHelper;
import flow.engine.impl.util.ProcessDefinitionUtil;
import flow.task.service.deleg.BaseTaskListener;
import flow.task.service.deleg.TaskListener;
import flow.task.service.impl.persistence.entity.TaskEntity;
import  std.uni;
import flow.engine.impl.bpmn.listener.TransactionDependentExecutionListenerExecutionScope;
import flow.engine.impl.bpmn.listener.ExecuteTaskListenerTransactionListener;
import flow.engine.impl.bpmn.listener.ExecuteExecutionListenerTransactionListener;
import flow.bpmn.model.Process;
import flow.engine.impl.bpmn.listener.TransactionDependentTaskListenerExecutionScope;
/**
 * @author Joram Barrez
 */
class ListenerNotificationHelper {

    public void executeExecutionListeners(HasExecutionListeners elementWithExecutionListeners, DelegateExecution execution, string eventType) {
        List!FlowableListener listeners = elementWithExecutionListeners.getExecutionListeners();
        if (listeners !is null && listeners.size() > 0) {
            ListenerFactory listenerFactory = CommandContextUtil.getProcessEngineConfiguration().getListenerFactory();
            foreach (FlowableListener listener ; listeners) {

                if (eventType == (listener.getEvent())) {

                    BaseExecutionListener executionListener = null;

                    if (sicmp(ImplementationType.IMPLEMENTATION_TYPE_CLASS,(listener.getImplementationType())) == 0) {
                        executionListener = listenerFactory.createClassDelegateExecutionListener(listener);
                    } else if (sicmp(ImplementationType.IMPLEMENTATION_TYPE_EXPRESSION ,(listener.getImplementationType())) == 0) {
                        executionListener = listenerFactory.createExpressionExecutionListener(listener);
                    } else if (sicmp(ImplementationType.IMPLEMENTATION_TYPE_DELEGATEEXPRESSION ,(listener.getImplementationType())) == 0) {
                        if (listener.getOnTransaction() !is null && listener.getOnTransaction().length != 0) {
                            executionListener = listenerFactory.createTransactionDependentDelegateExpressionExecutionListener(listener);
                        } else {
                            executionListener = listenerFactory.createDelegateExpressionExecutionListener(listener);
                        }
                    } else if (sicmp(ImplementationType.IMPLEMENTATION_TYPE_INSTANCE,(listener.getImplementationType())) == 0) {
                        executionListener = cast(ExecutionListener) listener.getInstance();
                    }

                    if (executionListener !is null) {
                        if (listener.getOnTransaction() !is null) {
                            planTransactionDependentExecutionListener(listenerFactory, execution, cast(TransactionDependentExecutionListener) executionListener, listener);
                        } else {
                            execution.setEventName(eventType); // eventName is used to differentiate the event when reusing an execution listener for various events
                            execution.setCurrentFlowableListener(listener);
                            (cast(ExecutionListener) executionListener).notify(execution);
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

        TransactionDependentExecutionListenerExecutionScope scop = new TransactionDependentExecutionListenerExecutionScope(
                execution.getProcessInstanceId(), execution.getId(), execution.getCurrentFlowElement(), executionVariablesToUse, customPropertiesMapToUse);

        addTransactionListener(listener, new ExecuteExecutionListenerTransactionListener(executionListener, scop,
                        CommandContextUtil.getProcessEngineConfiguration().getCommandExecutor()));
    }

    public void executeTaskListeners(TaskEntity taskEntity, string eventType) {
        if (taskEntity.getProcessDefinitionId() !is null) {
            flow.bpmn.model.Process.Process process = ProcessDefinitionUtil.getProcess(taskEntity.getProcessDefinitionId());
            FlowElement flowElement = process.getFlowElement(taskEntity.getTaskDefinitionKey(), true);
            if (cast(UserTask)flowElement !is null) {
                UserTask userTask = cast(UserTask) flowElement;
                executeTaskListeners(userTask, taskEntity, eventType);
            }
        }
    }

    public void executeTaskListeners(UserTask userTask, TaskEntity taskEntity, string eventType) {
        foreach (FlowableListener listener ; userTask.getTaskListeners()) {
            string event = listener.getEvent();
            if (event == (eventType) || event == (TaskListener.EVENTNAME_ALL_EVENTS)) {
                BaseTaskListener taskListener = createTaskListener(listener);

                if (listener.getOnTransaction() !is null) {
                    planTransactionDependentTaskListener(ExecutionHelper.getExecution(taskEntity.getExecutionId()), cast(TransactionDependentTaskListener) taskListener, listener);
                } else {
                    taskEntity.setEventName(eventType);
                    taskEntity.setEventHandlerId(listener.getId());

                    try {
                        CommandContextUtil.getProcessEngineConfiguration().getDelegateInterceptor()
                                .handleInvocation(new TaskListenerInvocation(cast(TaskListener) taskListener, taskEntity));
                    } catch (Exception e) {
                        throw new FlowableException("Exception while invoking TaskListener: ");
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
        if (sicmp(ImplementationType.IMPLEMENTATION_TYPE_CLASS,(listener.getImplementationType())) == 0) {
            taskListener = listenerFactory.createClassDelegateTaskListener(listener);
        } else if (sicmp(ImplementationType.IMPLEMENTATION_TYPE_EXPRESSION,(listener.getImplementationType())) == 0) {
            taskListener = listenerFactory.createExpressionTaskListener(listener);
        } else if (sicmp(ImplementationType.IMPLEMENTATION_TYPE_DELEGATEEXPRESSION,(listener.getImplementationType())) == 0) {
            if (listener.getOnTransaction() !is null && listener.getOnTransaction().length != 0) {
                taskListener = listenerFactory.createTransactionDependentDelegateExpressionTaskListener(listener);
            } else {
                taskListener = listenerFactory.createDelegateExpressionTaskListener(listener);
            }
        } else if (sicmp(ImplementationType.IMPLEMENTATION_TYPE_INSTANCE ,(listener.getImplementationType())) == 0) {
            taskListener = cast(TaskListener) listener.getInstance();
        }
        return taskListener;
    }

    protected void planTransactionDependentTaskListener(DelegateExecution execution, TransactionDependentTaskListener taskListener, FlowableListener listener) {
        Map!(string, Object) executionVariablesToUse = execution.getVariables();
        CustomPropertiesResolver customPropertiesResolver = createCustomPropertiesResolver(listener);
        Map!(string, Object) customPropertiesMapToUse = invokeCustomPropertiesResolver(execution, customPropertiesResolver);

        TransactionDependentTaskListenerExecutionScope scop = new TransactionDependentTaskListenerExecutionScope(
                execution.getProcessInstanceId(), execution.getId(), cast(Task) execution.getCurrentFlowElement(), executionVariablesToUse, customPropertiesMapToUse);
        addTransactionListener(listener, new ExecuteTaskListenerTransactionListener(taskListener, scop,
                        CommandContextUtil.getProcessEngineConfiguration().getCommandExecutor()));
    }

    protected CustomPropertiesResolver createCustomPropertiesResolver(FlowableListener listener) {
        CustomPropertiesResolver customPropertiesResolver = null;
        ListenerFactory listenerFactory = CommandContextUtil.getProcessEngineConfiguration().getListenerFactory();
        if (sicmp(ImplementationType.IMPLEMENTATION_TYPE_CLASS ,(listener.getCustomPropertiesResolverImplementationType())) == 0) {
            customPropertiesResolver = listenerFactory.createClassDelegateCustomPropertiesResolver(listener);
        } else if (sicmp(ImplementationType.IMPLEMENTATION_TYPE_EXPRESSION,(listener.getCustomPropertiesResolverImplementationType())) == 0) {
            customPropertiesResolver = listenerFactory.createExpressionCustomPropertiesResolver(listener);
        } else if (sicmp(ImplementationType.IMPLEMENTATION_TYPE_DELEGATEEXPRESSION,(listener.getCustomPropertiesResolverImplementationType())) == 0) {
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
        if (TransactionDependentExecutionListener.ON_TRANSACTION_BEFORE_COMMIT == (listener.getOnTransaction())) {
            transactionContext.addTransactionListener(TransactionState.COMMITTING, transactionListener);

        } else if (TransactionDependentExecutionListener.ON_TRANSACTION_COMMITTED == (listener.getOnTransaction())) {
            transactionContext.addTransactionListener(TransactionState.COMMITTED, transactionListener);

        } else if (TransactionDependentExecutionListener.ON_TRANSACTION_ROLLED_BACK == (listener.getOnTransaction())) {
            transactionContext.addTransactionListener(TransactionState.ROLLED_BACK, transactionListener);

        }
    }

}
