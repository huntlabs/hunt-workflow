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
module flow.engine.impl.bpmn.behavior.MultiInstanceActivityBehavior;


import hunt.collection.ArrayList;
import hunt.collection;
import hunt.collection.Collections;
//import java.util.Iterator;
import hunt.collection.List;
import hunt.collection.Map;

import flow.bpmn.model.Activity;
import flow.bpmn.model.BoundaryEvent;
import flow.bpmn.model.CollectionHandler;
import flow.bpmn.model.CompensateEventDefinition;
import flow.bpmn.model.FlowElement;
import flow.bpmn.model.FlowNode;
import flow.bpmn.model.ImplementationType;
import flow.bpmn.model.Process;
import flow.common.api.FlowableIllegalArgumentException;
import flow.common.api.deleg.Expression;
import flow.common.api.deleg.event.FlowableEngineEventType;
import flow.common.el.ExpressionManager;
import flow.engine.DynamicBpmnConstants;
import flow.engine.deleg.BpmnError;
import flow.engine.deleg.DelegateExecution;
import flow.engine.deleg.ExecutionListener;
import flow.engine.deleg.event.FlowableMultiInstanceActivityCompletedEvent;
import flow.engine.deleg.event.impl.FlowableEventBuilder;
import flow.engine.impl.bpmn.helper.ClassDelegateCollectionHandler;
import flow.engine.impl.bpmn.helper.DelegateExpressionCollectionHandler;
import flow.engine.impl.bpmn.helper.DelegateExpressionUtil;
//import flow.engine.impl.bpmn.helper.ErrorPropagation;
import flow.engine.impl.cfg.ProcessEngineConfigurationImpl;
//import flow.engine.impl.context.BpmnOverrideContext;
import flow.engine.impl.deleg.ActivityBehavior;
import flow.engine.impl.deleg.FlowableCollectionHandler;
import flow.engine.impl.deleg.SubProcessActivityBehavior;
import flow.engine.impl.persistence.entity.ExecutionEntity;
import flow.engine.impl.persistence.entity.ExecutionEntityManager;
import flow.engine.impl.util.CommandContextUtil;
import flow.engine.impl.util.ProcessDefinitionUtil;
import flow.engine.impl.bpmn.behavior.FlowNodeActivityBehavior;
import flow.engine.impl.bpmn.behavior.AbstractBpmnActivityBehavior;
import hunt.Exceptions;
import hunt.Boolean;
import hunt.Integer;
import hunt.Number;
import hunt.String;
import std.uni;
//import com.fasterxml.jackson.databind.JsonNode;
//import com.fasterxml.jackson.databind.node.ObjectNode;

/**
 * Implementation of the multi-instance functionality as described in the BPMN 2.0 spec.
 *
 * Multi instance functionality is implemented as an {@link ActivityBehavior} that wraps the original {@link ActivityBehavior} of the activity.
 *
 * Only subclasses of {@link AbstractBpmnActivityBehavior} can have multi-instance behavior. As such, special logic is contained in the {@link AbstractBpmnActivityBehavior} to delegate to the
 * {@link MultiInstanceActivityBehavior} if needed.
 *
 * @author Joram Barrez
 * @author Tijs Rademakers
 */
abstract class MultiInstanceActivityBehavior : FlowNodeActivityBehavior , SubProcessActivityBehavior {

    protected static  string DELETE_REASON_END = "MI_END";

    // Variable names for outer instance(as described in spec)
    protected static  string NUMBER_OF_INSTANCES = "nrOfInstances";
    protected static  string NUMBER_OF_ACTIVE_INSTANCES = "nrOfActiveInstances";
    protected static  string NUMBER_OF_COMPLETED_INSTANCES = "nrOfCompletedInstances";

    // Instance members
    protected Activity activity;
    protected AbstractBpmnActivityBehavior innerActivityBehavior;
    protected Expression loopCardinalityExpression;
    protected string completionCondition;
    protected Expression collectionExpression;
    protected string collectionVariable; // Not used anymore. Left here for backwards compatibility.
    protected string collectionElementVariable;
    protected string collectionString;
    protected CollectionHandler collectionHandler;
    // default variable name for loop counter for inner instances (as described in the spec)
    protected string collectionElementIndexVariable = "loopCounter";

    /**
     * @param activity
     * @param innerActivityBehavior
     *            The original {@link ActivityBehavior} of the activity that will be wrapped inside this behavior.
     */
    this(Activity activity, AbstractBpmnActivityBehavior innerActivityBehavior) {
        this.activity = activity;
        setInnerActivityBehavior(innerActivityBehavior);
    }

    override
    public void execute(DelegateExecution delegateExecution) {
        ExecutionEntity execution = cast(ExecutionEntity) delegateExecution;
        if (getLocalLoopVariable(execution, getCollectionElementIndexVariable()) is null) {

            int nrOfInstances = 0;

            try {
                nrOfInstances = createInstances(delegateExecution);
            } catch (BpmnError error) {
               // ErrorPropagation.propagateError(error, execution);
            }

            if (nrOfInstances == 0) {
                cleanupMiRoot(execution);
            }

        } else {
            // for synchronous, history was created already in ContinueMultiInstanceOperation,
            // but that would lead to wrong timings for asynchronous which is why it's here
            if (activity.isAsynchronous()) {
                CommandContextUtil.getActivityInstanceEntityManager().recordActivityStart(execution);
            }
            innerActivityBehavior.execute(execution);
        }
    }

    protected abstract int createInstances(DelegateExecution execution);

    override
    public void leave(DelegateExecution execution) {
        cleanupMiRoot(execution);
    }

    protected void cleanupMiRoot(DelegateExecution execution) {
        // Delete multi instance root and all child executions.
        // Create a fresh execution to continue

        ExecutionEntity multiInstanceRootExecution = cast(ExecutionEntity) getMultiInstanceRootExecution(execution);
        FlowElement flowElement = multiInstanceRootExecution.getCurrentFlowElement();
        ExecutionEntity parentExecution = multiInstanceRootExecution.getParent();

        ExecutionEntityManager executionEntityManager = CommandContextUtil.getExecutionEntityManager();
        Collection!string executionIdsNotToSendCancelledEventsFor = execution.isMultiInstanceRoot() ? null : Collections.singletonList!string(execution.getId());
        executionEntityManager.deleteChildExecutions(multiInstanceRootExecution, null, executionIdsNotToSendCancelledEventsFor, DELETE_REASON_END, true, flowElement);
        executionEntityManager.deleteRelatedDataForExecution(multiInstanceRootExecution, DELETE_REASON_END);
        executionEntityManager.dele(multiInstanceRootExecution);

        ExecutionEntity newExecution = executionEntityManager.createChildExecution(parentExecution);
        newExecution.setCurrentFlowElement(flowElement);
        super.leave(newExecution);
    }

    protected void executeCompensationBoundaryEvents(FlowElement flowElement, DelegateExecution execution) {

        // Execute compensation boundary events
        Collection!BoundaryEvent boundaryEvents = findBoundaryEventsForFlowNode(execution.getProcessDefinitionId(), flowElement);
        if (boundaryEvents !is null && !boundaryEvents.isEmpty()) {

            // The parent execution becomes a scope, and a child execution is created for each of the boundary events
            foreach (BoundaryEvent boundaryEvent ; boundaryEvents) {

                if (boundaryEvent.getEventDefinitions().isEmpty()) {
                    continue;
                }

                if (cast(CompensateEventDefinition) (boundaryEvent.getEventDefinitions().get(0)) !is null) {
                    ExecutionEntity childExecutionEntity = CommandContextUtil.getExecutionEntityManager()
                            .createChildExecution(cast(ExecutionEntity) execution);
                    childExecutionEntity.setParentId(execution.getId());
                    childExecutionEntity.setCurrentFlowElement(boundaryEvent);
                    childExecutionEntity.setScope(false);

                    ActivityBehavior boundaryEventBehavior = (cast(ActivityBehavior) boundaryEvent.getBehavior());
                    boundaryEventBehavior.execute(childExecutionEntity);
                }
            }
        }
    }

    protected Collection!BoundaryEvent findBoundaryEventsForFlowNode( string processDefinitionId,  FlowElement flowElement) {
        Process process = getProcessDefinition(processDefinitionId);

        // This could be cached or could be done at parsing time
        List!BoundaryEvent results = new ArrayList!BoundaryEvent(1);
        Collection!BoundaryEvent boundaryEvents = process.findFlowElementsOfType!BoundaryEvent(typeid(BoundaryEvent), true);
        foreach (BoundaryEvent boundaryEvent ; boundaryEvents) {
            if (boundaryEvent.getAttachedToRefId() !is null && boundaryEvent.getAttachedToRefId() == (flowElement.getId())) {
                results.add(boundaryEvent);
            }
        }
        return results;
    }

    protected Process getProcessDefinition(string processDefinitionId) {
        return ProcessDefinitionUtil.getProcess(processDefinitionId);
    }

    // Intercepts signals, and delegates it to the wrapped {@link ActivityBehavior}.
    override
    public void trigger(DelegateExecution execution, string signalName, Object signalData) {
        innerActivityBehavior.trigger(execution, signalName, signalData);
    }

    // required for supporting embedded subprocesses
    public void lastExecutionEnded(DelegateExecution execution) {
        // ScopeUtil.createEventScopeExecution((ExecutionEntity) execution);
        leave(execution);
    }

    // required for supporting external subprocesses
    public void completing(DelegateExecution execution, DelegateExecution subProcessInstance) {
    }

    // required for supporting external subprocesses
    public void completed(DelegateExecution execution) {
        leave(execution);
    }

    public bool completionConditionSatisfied(DelegateExecution execution) {
        if (completionCondition !is null) {

            ProcessEngineConfigurationImpl processEngineConfiguration = CommandContextUtil.getProcessEngineConfiguration();
            ExpressionManager expressionManager = processEngineConfiguration.getExpressionManager();

            string activeCompletionCondition = null;

            if (CommandContextUtil.getProcessEngineConfiguration().isEnableProcessDefinitionInfoCache()) {
                implementationMissing(false);
                //ObjectNode taskElementProperties = BpmnOverrideContext.getBpmnOverrideElementProperties(activity.getId(), execution.getProcessDefinitionId());
                //activeCompletionCondition = getActiveValue(completionCondition, DynamicBpmnConstants.MULTI_INSTANCE_COMPLETION_CONDITION, taskElementProperties);

            } else {
                activeCompletionCondition = completionCondition;
            }

            Object value = expressionManager.createExpression(activeCompletionCondition).getValue(execution);

            //if (!(value instanceof bool)) {
            //    throw new FlowableIllegalArgumentException("completionCondition '" + activeCompletionCondition + "' does not evaluate to a bool value");
            //}

            bool booleanValue = (cast(Boolean) value).booleanValue;
            //if (LOGGER.isDebugEnabled()) {
            //    LOGGER.debug("Completion condition of multi-instance satisfied: {}", booleanValue);
            //}
            return booleanValue;
        }
        return false;
    }

    public int getLoopVariable(DelegateExecution execution, string variableName) {
        Object value = execution.getVariableLocal(variableName);
        DelegateExecution parent = execution.getParent();
        while (value is null && parent !is null) {
            value = parent.getVariableLocal(variableName);
            parent = parent.getParent();
        }
        return (value !is null ? (cast(Integer)value).intValue : 0);
    }

    // Helpers
    // //////////////////////////////////////////////////////////////////////

    protected void sendCompletedWithConditionEvent(DelegateExecution execution) {
        CommandContextUtil.getEventDispatcher(CommandContextUtil.getCommandContext()).dispatchEvent(
                buildCompletedEvent(execution, FlowableEngineEventType.MULTI_INSTANCE_ACTIVITY_COMPLETED_WITH_CONDITION));
    }

    protected void sendCompletedEvent(DelegateExecution execution) {
        CommandContextUtil.getEventDispatcher(CommandContextUtil.getCommandContext()).dispatchEvent(
                buildCompletedEvent(execution, FlowableEngineEventType.MULTI_INSTANCE_ACTIVITY_COMPLETED));
    }

    protected FlowableMultiInstanceActivityCompletedEvent buildCompletedEvent(DelegateExecution execution, FlowableEngineEventType eventType) {
        FlowElement flowNode = execution.getCurrentFlowElement();

        return FlowableEventBuilder.createMultiInstanceActivityCompletedEvent(eventType,
        (cast(Integer) execution.getVariable(NUMBER_OF_INSTANCES)).intValue,
        (cast(Integer) execution.getVariable(NUMBER_OF_ACTIVE_INSTANCES)).intValue,
        (cast(Integer) execution.getVariable(NUMBER_OF_COMPLETED_INSTANCES)).intValue,
                flowNode.getId(),
                flowNode.getName(), execution.getId(), execution.getProcessInstanceId(), execution.getProcessDefinitionId(), flowNode);
    }

    protected int resolveNrOfInstances(DelegateExecution execution) {
        if (loopCardinalityExpression !is null) {
            return resolveLoopCardinality(execution);

        } else if (usesCollection()) {
            Collection collection = resolveAndValidateCollection(execution);
            return collection.size();

        } else {
            throw new FlowableIllegalArgumentException("Couldn't resolve collection expression nor variable reference");
        }
    }

    protected void executeOriginalBehavior(DelegateExecution execution, ExecutionEntity multiInstanceRootExecution, int loopCounter) {
        implementationMissing(false);
        //if (usesCollection() && collectionElementVariable !is null) {
        //    Collection collection = (Collection) resolveAndValidateCollection(execution);
        //
        //    Object value = null;
        //    int index = 0;
        //    Iterator it = collection.iterator();
        //    while (index <= loopCounter) {
        //        value = it.next();
        //        index++;
        //    }
        //    setLoopVariable(execution, collectionElementVariable, value);
        //}
        //
        //execution.setCurrentFlowElement(activity);
        //CommandContextUtil.getAgenda().planContinueMultiInstanceOperation((ExecutionEntity) execution, multiInstanceRootExecution, loopCounter);
    }

    protected Collection!Object resolveAndValidateCollection(DelegateExecution execution) {
        implementationMissing(null);
        //Object obj = resolveCollection(execution);
        //if (collectionHandler !is null ) {
        //    return createFlowableCollectionHandler(collectionHandler, execution).resolveCollection(obj, execution);
        //} else {
        //    if (obj instanceof Collection) {
        //        return (Collection) obj;
        //
        //    } else if (obj instanceof Iterable) {
        //        return iterableToCollection((Iterable) obj);
        //
        //    } else if (obj instanceof string) {
        //        Object collectionVariable = execution.getVariable((string) obj);
        //        if (collectionVariable instanceof Collection) {
        //            return (Collection) collectionVariable;
        //        } else if (collectionVariable instanceof Iterable) {
        //            return iterableToCollection((Iterable) collectionVariable);
        //        } else if (collectionVariable is null) {
        //            throw new FlowableIllegalArgumentException("Variable '" + obj + "' was not found");
        //        } else {
        //            throw new FlowableIllegalArgumentException("Variable '" + obj + "':" + collectionVariable + " is not a Collection");
        //        }
        //
        //    } else {
        //        throw new FlowableIllegalArgumentException("Couldn't resolve collection expression, variable reference or string");
        //
        //    }
        //}
    }

    //protected Collection iterableToCollection(Iterable iterable) {
    //    List result = new ArrayList();
    //    iterable.forEach(element -> result.add(element));
    //    return result;
    //}

    protected Object resolveCollection(DelegateExecution execution) {
        Object collection = null;
        if (collectionExpression !is null) {
            collection = collectionExpression.getValue(execution);

        } else if (collectionVariable !is null) {
            collection = execution.getVariable(collectionVariable);

        } else if (collectionString !is null) {
            collection = collectionString;
        }
        return collection;
    }

    protected bool usesCollection() {
        return collectionExpression !is null || collectionVariable !is null || collectionString !is null;
    }

    protected bool isExtraScopeNeeded(FlowNode flowNode) {
        return flowNode.getSubProcess() !is null;
    }

    protected int resolveLoopCardinality(DelegateExecution execution) {
        // Using Number since expr can evaluate to eg. Long (which is also the default for Juel)
        Object value = loopCardinalityExpression.getValue(execution);
        if (cast(Number)value !is null) {
            return (cast(Number) value).intValue();

        } else if (cast(String)value !is null) {
            return Integer.valueOf(cast(String) value);

        } else {
            throw new FlowableIllegalArgumentException("Could not resolve loopCardinality expression '" ~ loopCardinalityExpression.getExpressionText() ~ "': not a number nor number string");
        }
    }

    protected void setLoopVariable(DelegateExecution execution, string variableName, Object value) {
        execution.setVariableLocal(variableName, value);
    }

    protected Integer getLocalLoopVariable(DelegateExecution execution, string variableName) {
        Map!(string, Object) localVariables = execution.getVariablesLocal();
        if (localVariables.containsKey(variableName)) {
            return cast(Integer) execution.getVariableLocal(variableName);

        } else if (!execution.isMultiInstanceRoot()) {
            DelegateExecution parentExecution = execution.getParent();
            localVariables = parentExecution.getVariablesLocal();
            if (localVariables.containsKey(variableName)) {
                return cast(Integer) parentExecution.getVariableLocal(variableName);

            } else if (!parentExecution.isMultiInstanceRoot()) {
                DelegateExecution superExecution = parentExecution.getParent();
                return cast(Integer) superExecution.getVariableLocal(variableName);

            } else {
                return null;
            }

        } else {
            return null;
        }
    }

    /**
     * Since no transitions are followed when leaving the inner activity, it is needed to call the end listeners yourself.
     */
    protected void callActivityEndListeners(DelegateExecution execution) {
        CommandContextUtil.getProcessEngineConfiguration().getListenerNotificationHelper()
                .executeExecutionListeners(activity, execution, ExecutionListener.EVENTNAME_END);
    }

    protected void logLoopDetails(DelegateExecution execution, string custom, int loopCounter, int nrOfCompletedInstances, int nrOfActiveInstances, int nrOfInstances) {
        //if (LOGGER.isDebugEnabled()) {
        //    LOGGER.debug("Multi-instance '{}' {}. Details: loopCounter={}, nrOrCompletedInstances={},nrOfActiveInstances={},nrOfInstances={}",
        //            execution.getCurrentFlowElement() !is null ? execution.getCurrentFlowElement().getId() : "", custom, loopCounter,
        //            nrOfCompletedInstances, nrOfActiveInstances, nrOfInstances);
        //}
    }

    protected DelegateExecution getMultiInstanceRootExecution(DelegateExecution executionEntity) {
        DelegateExecution multiInstanceRootExecution = null;
        DelegateExecution currentExecution = executionEntity;
        while (currentExecution !is null && multiInstanceRootExecution is null && currentExecution.getParent() !is null) {
            if (currentExecution.isMultiInstanceRoot()) {
                multiInstanceRootExecution = currentExecution;
            } else {
                currentExecution = currentExecution.getParent();
            }
        }
        return multiInstanceRootExecution;
    }

    //protected string getActiveValue(string originalValue, string propertyName, ObjectNode taskElementProperties) {
    //    string activeValue = originalValue;
    //    if (taskElementProperties !is null) {
    //        JsonNode overrideValueNode = taskElementProperties.get(propertyName);
    //        if (overrideValueNode !is null) {
    //            if (overrideValueNode.isNull()) {
    //                activeValue = null;
    //            } else {
    //                activeValue = overrideValueNode.asText();
    //            }
    //        }
    //    }
    //    return activeValue;
    //}

    protected FlowableCollectionHandler createFlowableCollectionHandler(CollectionHandler handler, DelegateExecution execution) {
    	FlowableCollectionHandler collectionHandler = null;

        if (sicmp(ImplementationType.IMPLEMENTATION_TYPE_CLASS,(handler.getImplementationType())) == 0) {
        	collectionHandler = new ClassDelegateCollectionHandler(handler.getImplementation(), null);

        } else if (sicmp(ImplementationType.IMPLEMENTATION_TYPE_DELEGATEEXPRESSION ,(handler.getImplementationType())) == 0) {
        	Object deleg = DelegateExpressionUtil.resolveDelegateExpression(CommandContextUtil.getProcessEngineConfiguration().getExpressionManager().createExpression(handler.getImplementation()), execution);
            if (cast(FlowableCollectionHandler)deleg !is null) {
                collectionHandler = new DelegateExpressionCollectionHandler(execution, CommandContextUtil.getProcessEngineConfiguration().getExpressionManager().createExpression(handler.getImplementation()));
            } else {
                throw new FlowableIllegalArgumentException("Delegate expression " ~ handler.getImplementation() ~ " did not resolve to an implementation of " ~ typeid(FlowableCollectionHandler).toString);
            }
        }
        return collectionHandler;
    }

    // Getters and Setters
    // ///////////////////////////////////////////////////////////

    public Expression getLoopCardinalityExpression() {
        return loopCardinalityExpression;
    }

    public void setLoopCardinalityExpression(Expression loopCardinalityExpression) {
        this.loopCardinalityExpression = loopCardinalityExpression;
    }

    public string getCompletionCondition() {
        return completionCondition;
    }

    public void setCompletionCondition(string completionCondition) {
        this.completionCondition = completionCondition;
    }

    public Expression getCollectionExpression() {
        return collectionExpression;
    }

    public void setCollectionExpression(Expression collectionExpression) {
        this.collectionExpression = collectionExpression;
    }

    public string getCollectionVariable() {
        return collectionVariable;
    }

    public void setCollectionVariable(string collectionVariable) {
        this.collectionVariable = collectionVariable;
    }

    public string getCollectionElementVariable() {
        return collectionElementVariable;
    }

    public void setCollectionElementVariable(string collectionElementVariable) {
        this.collectionElementVariable = collectionElementVariable;
    }

    public string getCollectionString() {
        return collectionString;
    }

    public void setCollectionString(string collectionString) {
        this.collectionString = collectionString;
    }

	public CollectionHandler getHandler() {
		return collectionHandler;
	}

	public void setHandler(CollectionHandler collectionHandler) {
		this.collectionHandler = collectionHandler;
	}

	public string getCollectionElementIndexVariable() {
        return collectionElementIndexVariable;
    }

    public void setCollectionElementIndexVariable(string collectionElementIndexVariable) {
        this.collectionElementIndexVariable = collectionElementIndexVariable;
    }

    public void setInnerActivityBehavior(AbstractBpmnActivityBehavior innerActivityBehavior) {
        this.innerActivityBehavior = innerActivityBehavior;
        this.innerActivityBehavior.setMultiInstanceActivityBehavior(this);
    }

    public AbstractBpmnActivityBehavior getInnerActivityBehavior() {
        return innerActivityBehavior;
    }
}
