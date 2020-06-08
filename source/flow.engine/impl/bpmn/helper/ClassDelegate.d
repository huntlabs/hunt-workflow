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

import org.apache.commons.lang3.StringUtils;
import flow.bpmn.model.FlowElement;
import flow.bpmn.model.MapExceptionEntry;
import flow.bpmn.model.Task;
import flow.common.api.FlowableException;
import flow.common.api.FlowableIllegalArgumentException;
import flow.common.api.deleg.Expression;
import flow.engine.DynamicBpmnConstants;
import flow.engine.deleg.BpmnError;
import flow.engine.deleg.CustomPropertiesResolver;
import flow.engine.deleg.DelegateExecution;
import flow.engine.deleg.ExecutionListener;
import flow.engine.deleg.JavaDelegate;
import flow.engine.deleg.TransactionDependentExecutionListener;
import flow.engine.deleg.TransactionDependentTaskListener;
import flow.engine.impl.bpmn.behavior.AbstractBpmnActivityBehavior;
import flow.engine.impl.bpmn.behavior.ServiceTaskJavaDelegateActivityBehavior;
import flow.engine.impl.bpmn.parser.FieldDeclaration;
import flow.engine.impl.context.BpmnOverrideContext;
import flow.engine.impl.deleg.ActivityBehavior;
import flow.engine.impl.deleg.SubProcessActivityBehavior;
import flow.engine.impl.deleg.TriggerableActivityBehavior;
import flow.engine.impl.deleg.invocation.ExecutionListenerInvocation;
import flow.engine.impl.deleg.invocation.TaskListenerInvocation;
import flow.engine.impl.persistence.entity.ExecutionEntity;
import flow.engine.impl.util.CommandContextUtil;
import flow.task.service.deleg.DelegateTask;
import flow.task.service.deleg.TaskListener;

import com.fasterxml.jackson.databind.node.ObjectNode;

/**
 * Helper class for bpmn constructs that allow class delegation.
 *
 * This class will lazily instantiate the referenced classes when needed at runtime.
 *
 * @author Joram Barrez
 * @author Falko Menge
 * @author Saeid Mirzaei
 * @author Yvo Swillens
 */
class ClassDelegate : AbstractClassDelegate implements TaskListener, ExecutionListener, TransactionDependentExecutionListener, TransactionDependentTaskListener, SubProcessActivityBehavior, CustomPropertiesResolver {

    private static final long serialVersionUID = 1L;

    protected ActivityBehavior activityBehaviorInstance;
    protected Expression skipExpression;
    protected List!MapExceptionEntry mapExceptions;
    protected CustomPropertiesResolver customPropertiesResolverInstance;
    protected bool triggerable;

    public ClassDelegate(string className, List!FieldDeclaration fieldDeclarations, Expression skipExpression) {
        super(className, fieldDeclarations);
        this.skipExpression = skipExpression;
    }

    public ClassDelegate(string id, string className, List!FieldDeclaration fieldDeclarations, bool triggerable, Expression skipExpression,
                         List!MapExceptionEntry mapExceptions) {
        this(className, fieldDeclarations, skipExpression);
        this.triggerable = triggerable;
        this.serviceTaskId = id;
        this.mapExceptions = mapExceptions;
    }

    public ClassDelegate(Class<?> clazz, List!FieldDeclaration fieldDeclarations, Expression skipExpression) {
        this(clazz.getName(), fieldDeclarations, skipExpression);
    }

    public ClassDelegate(string className, List!FieldDeclaration fieldDeclarations) {
        super(className, fieldDeclarations);
    }

    public ClassDelegate(Class<?> clazz, List!FieldDeclaration fieldDeclarations) {
        super(clazz, fieldDeclarations);
    }

    // Execution listener
    override
    public void notify(DelegateExecution execution) {
        ExecutionListener executionListenerInstance = getExecutionListenerInstance();
        CommandContextUtil.getProcessEngineConfiguration().getDelegateInterceptor().handleInvocation(new ExecutionListenerInvocation(executionListenerInstance, execution));
    }

    // Transaction Dependent execution listener
    override
    public void notify(string processInstanceId, string executionId, FlowElement flowElement, Map!(string, Object) executionVariables, Map!(string, Object) customPropertiesMap) {
        TransactionDependentExecutionListener transactionDependentExecutionListenerInstance = getTransactionDependentExecutionListenerInstance();

        // Note that we can't wrap it in the delegate interceptor like usual here due to being executed when the context is already removed.
        transactionDependentExecutionListenerInstance.notify(processInstanceId, executionId, flowElement, executionVariables, customPropertiesMap);
    }

    override
    public Map!(string, Object) getCustomPropertiesMap(DelegateExecution execution) {
        if (customPropertiesResolverInstance is null) {
            customPropertiesResolverInstance = getCustomPropertiesResolverInstance();
        }
        return customPropertiesResolverInstance.getCustomPropertiesMap(execution);
    }

    // Task listener
    override
    public void notify(DelegateTask delegateTask) {
        TaskListener taskListenerInstance = getTaskListenerInstance();

        try {
            CommandContextUtil.getProcessEngineConfiguration().getDelegateInterceptor().handleInvocation(new TaskListenerInvocation(taskListenerInstance, delegateTask));
        } catch (Exception e) {
            throw new FlowableException("Exception while invoking TaskListener: " + e.getMessage(), e);
        }
    }

    override
    public void notify(string processInstanceId, string executionId, Task task, Map!(string, Object) executionVariables, Map!(string, Object) customPropertiesMap) {
        TransactionDependentTaskListener transactionDependentTaskListenerInstance = getTransactionDependentTaskListenerInstance();
        transactionDependentTaskListenerInstance.notify(processInstanceId, executionId, task, executionVariables, customPropertiesMap);
    }

    protected ExecutionListener getExecutionListenerInstance() {
        Object delegateInstance = instantiateDelegate(className, fieldDeclarations);
        if (delegateInstance instanceof ExecutionListener) {
            return (ExecutionListener) delegateInstance;
        } else if (delegateInstance instanceof JavaDelegate) {
            return new ServiceTaskJavaDelegateActivityBehavior((JavaDelegate) delegateInstance, triggerable, skipExpression);
        } else {
            throw new FlowableIllegalArgumentException(delegateInstance.getClass().getName() + " doesn't implement " + ExecutionListener.class + " nor " + JavaDelegate.class);
        }
    }

    protected TransactionDependentExecutionListener getTransactionDependentExecutionListenerInstance() {
        Object delegateInstance = instantiateDelegate(className, fieldDeclarations);
        if (delegateInstance instanceof TransactionDependentExecutionListener) {
            return (TransactionDependentExecutionListener) delegateInstance;
        } else {
            throw new FlowableIllegalArgumentException(delegateInstance.getClass().getName() + " doesn't implement " + TransactionDependentExecutionListener.class);
        }
    }

    protected CustomPropertiesResolver getCustomPropertiesResolverInstance() {
        Object delegateInstance = instantiateDelegate(className, fieldDeclarations);
        if (delegateInstance instanceof CustomPropertiesResolver) {
            return (CustomPropertiesResolver) delegateInstance;
        } else {
            throw new FlowableIllegalArgumentException(delegateInstance.getClass().getName() + " doesn't implement " + CustomPropertiesResolver.class);
        }
    }

    protected TaskListener getTaskListenerInstance() {
        Object delegateInstance = instantiateDelegate(className, fieldDeclarations);
        if (delegateInstance instanceof TaskListener) {
            return (TaskListener) delegateInstance;
        } else {
            throw new FlowableIllegalArgumentException(delegateInstance.getClass().getName() + " doesn't implement " + TaskListener.class);
        }
    }

    protected TransactionDependentTaskListener getTransactionDependentTaskListenerInstance() {
        Object delegateInstance = instantiateDelegate(className, fieldDeclarations);
        if (delegateInstance instanceof TransactionDependentTaskListener) {
            return (TransactionDependentTaskListener) delegateInstance;
        } else {
            throw new FlowableIllegalArgumentException(delegateInstance.getClass().getName() + " doesn't implement " + TransactionDependentTaskListener.class);
        }
    }

    // Activity Behavior
    override
    public void execute(DelegateExecution execution) {
        if (CommandContextUtil.getProcessEngineConfiguration().isEnableProcessDefinitionInfoCache()) {
            ObjectNode taskElementProperties = BpmnOverrideContext.getBpmnOverrideElementProperties(serviceTaskId, execution.getProcessDefinitionId());
            if (taskElementProperties !is null && taskElementProperties.has(DynamicBpmnConstants.SERVICE_TASK_CLASS_NAME)) {
                string overrideClassName = taskElementProperties.get(DynamicBpmnConstants.SERVICE_TASK_CLASS_NAME).asText();
                if (StringUtils.isNotEmpty(overrideClassName) && !overrideClassName.equals(className)) {
                    className = overrideClassName;
                    activityBehaviorInstance = null;
                }
            }
        }

        if (activityBehaviorInstance is null) {
            activityBehaviorInstance = getActivityBehaviorInstance();
        }

        try {
            activityBehaviorInstance.execute(execution);
        } catch (BpmnError error) {
            ErrorPropagation.propagateError(error, execution);
        } catch (RuntimeException e) {
            if (!ErrorPropagation.mapException(e, (ExecutionEntity) execution, mapExceptions))
                throw e;
        }
    }

    // Signallable activity behavior
    override
    public void trigger(DelegateExecution execution, string signalName, Object signalData) {
        if (activityBehaviorInstance is null) {
            activityBehaviorInstance = getActivityBehaviorInstance();
        }

        if (activityBehaviorInstance instanceof TriggerableActivityBehavior) {
            ((TriggerableActivityBehavior) activityBehaviorInstance).trigger(execution, signalName, signalData);
            if(triggerable) {
                leave(execution);
            }
        } else {
            throw new FlowableException("signal() can only be called on a " + TriggerableActivityBehavior.class.getName() + " instance");
        }
    }

    // Subprocess activityBehaviour

    override
    public void completing(DelegateExecution execution, DelegateExecution subProcessInstance) throws Exception {
        if (activityBehaviorInstance is null) {
            activityBehaviorInstance = getActivityBehaviorInstance();
        }

        if (activityBehaviorInstance instanceof SubProcessActivityBehavior) {
            ((SubProcessActivityBehavior) activityBehaviorInstance).completing(execution, subProcessInstance);
        } else {
            throw new FlowableException("completing() can only be called on a " + SubProcessActivityBehavior.class.getName() + " instance");
        }
    }

    override
    public void completed(DelegateExecution execution) throws Exception {
        if (activityBehaviorInstance is null) {
            activityBehaviorInstance = getActivityBehaviorInstance();
        }

        if (activityBehaviorInstance instanceof SubProcessActivityBehavior) {
            ((SubProcessActivityBehavior) activityBehaviorInstance).completed(execution);
        } else {
            throw new FlowableException("completed() can only be called on a " + SubProcessActivityBehavior.class.getName() + " instance");
        }
    }

    protected ActivityBehavior getActivityBehaviorInstance() {
        Object delegateInstance = instantiateDelegate(className, fieldDeclarations);

        if (delegateInstance instanceof ActivityBehavior) {
            return determineBehaviour((ActivityBehavior) delegateInstance);
        } else if (delegateInstance instanceof JavaDelegate) {
            return determineBehaviour(new ServiceTaskJavaDelegateActivityBehavior((JavaDelegate) delegateInstance, triggerable, skipExpression));
        } else {
            throw new FlowableIllegalArgumentException(delegateInstance.getClass().getName() + " doesn't implement " + JavaDelegate.class.getName() + " nor " + ActivityBehavior.class.getName());
        }
    }

    // Adds properties to the given delegation instance (eg multi instance) if needed
    protected ActivityBehavior determineBehaviour(ActivityBehavior delegateInstance) {
        if (hasMultiInstanceCharacteristics()) {
            multiInstanceActivityBehavior.setInnerActivityBehavior((AbstractBpmnActivityBehavior) delegateInstance);
            return multiInstanceActivityBehavior;
        }
        return delegateInstance;
    }

}
