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

module flow.engine.impl.bpmn.helper.ClassDelegate;

import hunt.collection.List;
import hunt.collection.Map;

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
//import flow.engine.impl.context.BpmnOverrideContext;
import flow.engine.impl.deleg.ActivityBehavior;
import flow.engine.impl.deleg.SubProcessActivityBehavior;
import flow.engine.impl.deleg.TriggerableActivityBehavior;
import flow.engine.impl.deleg.invocation.ExecutionListenerInvocation;
import flow.engine.impl.deleg.invocation.TaskListenerInvocation;
import flow.engine.impl.persistence.entity.ExecutionEntity;
import flow.engine.impl.util.CommandContextUtil;
import flow.task.service.deleg.DelegateTask;
import flow.task.service.deleg.TaskListener;
import flow.engine.impl.bpmn.helper.AbstractClassDelegate;
//import com.fasterxml.jackson.databind.node.ObjectNode;
import hunt.Exceptions;
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
class ClassDelegate : AbstractClassDelegate , TaskListener, ExecutionListener, TransactionDependentExecutionListener, TransactionDependentTaskListener, SubProcessActivityBehavior, CustomPropertiesResolver {

    protected ActivityBehavior activityBehaviorInstance;
    protected Expression skipExpression;
    protected List!MapExceptionEntry mapExceptions;
    protected CustomPropertiesResolver customPropertiesResolverInstance;
    protected bool triggerable;

    this(string className, List!FieldDeclaration fieldDeclarations, Expression skipExpression) {
        super(className, fieldDeclarations);
        this.skipExpression = skipExpression;
    }

    this(string id, string className, List!FieldDeclaration fieldDeclarations, bool triggerable, Expression skipExpression,
                         List!MapExceptionEntry mapExceptions) {
        this(className, fieldDeclarations, skipExpression);
        this.triggerable = triggerable;
        this.serviceTaskId = id;
        this.mapExceptions = mapExceptions;
    }

    this(TypeInfo clazz, List!FieldDeclaration fieldDeclarations, Expression skipExpression) {
        this(clazz.toString, fieldDeclarations, skipExpression);
    }

    this(string className, List!FieldDeclaration fieldDeclarations) {
        super(className, fieldDeclarations);
    }

    this(TypeInfo clazz, List!FieldDeclaration fieldDeclarations) {
        super(clazz, fieldDeclarations);
    }

    // Execution listener
    public void notify(DelegateExecution execution) {
        ExecutionListener executionListenerInstance = getExecutionListenerInstance();
        CommandContextUtil.getProcessEngineConfiguration().getDelegateInterceptor().handleInvocation(new ExecutionListenerInvocation(executionListenerInstance, execution));
    }

    // Transaction Dependent execution listener
    public void notify(string processInstanceId, string executionId, FlowElement flowElement, Map!(string, Object) executionVariables, Map!(string, Object) customPropertiesMap) {
        TransactionDependentExecutionListener transactionDependentExecutionListenerInstance = getTransactionDependentExecutionListenerInstance();

        // Note that we can't wrap it in the delegate interceptor like usual here due to being executed when the context is already removed.
        transactionDependentExecutionListenerInstance.notify(processInstanceId, executionId, flowElement, executionVariables, customPropertiesMap);
    }

    public Map!(string, Object) getCustomPropertiesMap(DelegateExecution execution) {
        if (customPropertiesResolverInstance is null) {
            customPropertiesResolverInstance = getCustomPropertiesResolverInstance();
        }
        return customPropertiesResolverInstance.getCustomPropertiesMap(execution);
    }

    // Task listener
    public void notify(DelegateTask delegateTask) {
        TaskListener taskListenerInstance = getTaskListenerInstance();

        try {
            CommandContextUtil.getProcessEngineConfiguration().getDelegateInterceptor().handleInvocation(new TaskListenerInvocation(taskListenerInstance, delegateTask));
        } catch (Exception e) {
            throw new FlowableException("Exception while invoking TaskListener: ");
        }
    }

    public void notify(string processInstanceId, string executionId, Task task, Map!(string, Object) executionVariables, Map!(string, Object) customPropertiesMap) {
        TransactionDependentTaskListener transactionDependentTaskListenerInstance = getTransactionDependentTaskListenerInstance();
        transactionDependentTaskListenerInstance.notify(processInstanceId, executionId, task, executionVariables, customPropertiesMap);
    }

    protected ExecutionListener getExecutionListenerInstance() {
        Object delegateInstance = instantiateDelegate(className, fieldDeclarations);
        if (cast(ExecutionListener)delegateInstance !is null) {
            return cast(ExecutionListener) delegateInstance;
        } else if (cast(JavaDelegate)delegateInstance !is null) {
            return new ServiceTaskJavaDelegateActivityBehavior(cast(JavaDelegate) delegateInstance, triggerable, skipExpression);
        } else {
            throw new FlowableIllegalArgumentException(" doesn't implement " ~ typeid(ExecutionListener).toString ~ " nor " ~ typeid(JavaDelegate).toString);
        }
    }

    protected TransactionDependentExecutionListener getTransactionDependentExecutionListenerInstance() {
        Object delegateInstance = instantiateDelegate(className, fieldDeclarations);
        if (cast(TransactionDependentExecutionListener)delegateInstance !is null) {
            return cast(TransactionDependentExecutionListener) delegateInstance;
        } else {
            throw new FlowableIllegalArgumentException(" doesn't implement " ~ typeid(TransactionDependentExecutionListener).toString);
        }
    }

    protected CustomPropertiesResolver getCustomPropertiesResolverInstance() {
        Object delegateInstance = instantiateDelegate(className, fieldDeclarations);
        if (cast(CustomPropertiesResolver)delegateInstance !is null) {
            return cast(CustomPropertiesResolver) delegateInstance;
        } else {
            throw new FlowableIllegalArgumentException(" doesn't implement " ~ typeid(CustomPropertiesResolver).toString);
        }
    }

    protected TaskListener getTaskListenerInstance() {
        Object delegateInstance = instantiateDelegate(className, fieldDeclarations);
        if (cast(TaskListener)delegateInstance !is null) {
            return cast(TaskListener) delegateInstance;
        } else {
            throw new FlowableIllegalArgumentException(" doesn't implement " ~ typeid(TaskListener).toString);
        }
    }

    protected TransactionDependentTaskListener getTransactionDependentTaskListenerInstance() {
        Object delegateInstance = instantiateDelegate(className, fieldDeclarations);
        if (cast(TransactionDependentTaskListener)delegateInstance !is null) {
            return cast(TransactionDependentTaskListener) delegateInstance;
        } else {
            throw new FlowableIllegalArgumentException(" doesn't implement " ~ typeid(TransactionDependentTaskListener).toString);
        }
    }

    // Activity Behavior
    override
    public void execute(DelegateExecution execution) {
        if (CommandContextUtil.getProcessEngineConfiguration().isEnableProcessDefinitionInfoCache()) {
              implementationMissing(false);
            //ObjectNode taskElementProperties = BpmnOverrideContext.getBpmnOverrideElementProperties(serviceTaskId, execution.getProcessDefinitionId());
            //if (taskElementProperties !is null && taskElementProperties.has(DynamicBpmnConstants.SERVICE_TASK_CLASS_NAME)) {
            //    string overrideClassName = taskElementProperties.get(DynamicBpmnConstants.SERVICE_TASK_CLASS_NAME).asText();
            //    if (StringUtils.isNotEmpty(overrideClassName) && !overrideClassName.equals(className)) {
            //        className = overrideClassName;
            //        activityBehaviorInstance = null;
            //    }
            //}
        }

        if (activityBehaviorInstance is null) {
            activityBehaviorInstance = getActivityBehaviorInstance();
        }

        try {
            activityBehaviorInstance.execute(execution);
        } catch (BpmnError error) {
            implementationMissing(false);
           // ErrorPropagation.propagateError(error, execution);
        } catch (RuntimeException e) {
            implementationMissing(false);
            //if (!ErrorPropagation.mapException(e, (ExecutionEntity) execution, mapExceptions))
            //    throw e;
        }
    }

    // Signallable activity behavior
    override
    public void trigger(DelegateExecution execution, string signalName, Object signalData) {
        if (activityBehaviorInstance is null) {
            activityBehaviorInstance = getActivityBehaviorInstance();
        }

        if (cast(TriggerableActivityBehavior)activityBehaviorInstance !is null) {
            (cast(TriggerableActivityBehavior) activityBehaviorInstance).trigger(execution, signalName, signalData);
            if(triggerable) {
                leave(execution);
            }
        } else {
            throw new FlowableException("signal() can only be called on a " ~ typeid(TriggerableActivityBehavior).toString ~ " instance");
        }
    }

    // Subprocess activityBehaviour

    override
    public void completing(DelegateExecution execution, DelegateExecution subProcessInstance) {
        if (activityBehaviorInstance is null) {
            activityBehaviorInstance = getActivityBehaviorInstance();
        }

        if (cast(SubProcessActivityBehavior)activityBehaviorInstance !is null) {
            (cast(SubProcessActivityBehavior) activityBehaviorInstance).completing(execution, subProcessInstance);
        } else {
            throw new FlowableException("completing() can only be called on a " ~ typeid(SubProcessActivityBehavior).toString ~ " instance");
        }
    }

    override
    public void completed(DelegateExecution execution){
        if (activityBehaviorInstance is null) {
            activityBehaviorInstance = getActivityBehaviorInstance();
        }

        if (cast(SubProcessActivityBehavior)activityBehaviorInstance !is null) {
            (cast(SubProcessActivityBehavior) activityBehaviorInstance).completed(execution);
        } else {
            throw new FlowableException("completed() can only be called on a " ~ typeid(SubProcessActivityBehavior).toString ~ " instance");
        }
    }

    protected ActivityBehavior getActivityBehaviorInstance() {
        Object delegateInstance = instantiateDelegate(className, fieldDeclarations);

        if (cast(ActivityBehavior)delegateInstance !is null) {
            return determineBehaviour(cast(ActivityBehavior) delegateInstance);
        } else if (cast(JavaDelegate)delegateInstance !is null) {
            return determineBehaviour(new ServiceTaskJavaDelegateActivityBehavior(cast(JavaDelegate) delegateInstance, triggerable, skipExpression));
        } else {
            throw new FlowableIllegalArgumentException(" doesn't implement " ~ typeid(JavaDelegate).toString ~ " nor " ~ typeid(ActivityBehavior).toString);
        }
    }

    // Adds properties to the given delegation instance (eg multi instance) if needed
    protected ActivityBehavior determineBehaviour(ActivityBehavior delegateInstance) {
        if (hasMultiInstanceCharacteristics()) {
            multiInstanceActivityBehavior.setInnerActivityBehavior(cast(AbstractBpmnActivityBehavior) delegateInstance);
            return multiInstanceActivityBehavior;
        }
        return delegateInstance;
    }

}
