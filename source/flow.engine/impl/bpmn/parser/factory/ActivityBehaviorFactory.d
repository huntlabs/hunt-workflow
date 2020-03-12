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


import flow.bpmn.model.Activity;
import flow.bpmn.model.BoundaryEvent;
import flow.bpmn.model.BpmnModel;
import flow.bpmn.model.BusinessRuleTask;
import flow.bpmn.model.CallActivity;
import flow.bpmn.model.CancelEventDefinition;
import flow.bpmn.model.CaseServiceTask;
import flow.bpmn.model.CompensateEventDefinition;
import flow.bpmn.model.ConditionalEventDefinition;
import flow.bpmn.model.EndEvent;
import flow.bpmn.model.ErrorEventDefinition;
import flow.bpmn.model.Escalation;
import flow.bpmn.model.EscalationEventDefinition;
import flow.bpmn.model.EventGateway;
import flow.bpmn.model.EventSubProcess;
import flow.bpmn.model.ExclusiveGateway;
import flow.bpmn.model.InclusiveGateway;
import flow.bpmn.model.IntermediateCatchEvent;
import flow.bpmn.model.ManualTask;
import flow.bpmn.model.MessageEventDefinition;
import flow.bpmn.model.ParallelGateway;
import flow.bpmn.model.ReceiveTask;
import flow.bpmn.model.ScriptTask;
import flow.bpmn.model.SendEventServiceTask;
import flow.bpmn.model.SendTask;
import flow.bpmn.model.ServiceTask;
import flow.bpmn.model.Signal;
import flow.bpmn.model.SignalEventDefinition;
import flow.bpmn.model.StartEvent;
import flow.bpmn.model.SubProcess;
import flow.bpmn.model.Task;
import flow.bpmn.model.ThrowEvent;
import flow.bpmn.model.TimerEventDefinition;
import flow.bpmn.model.Transaction;
import flow.bpmn.model.UserTask;
import flow.engine.impl.bpmn.behavior.AbstractBpmnActivityBehavior;
import flow.engine.impl.bpmn.behavior.AdhocSubProcessActivityBehavior;
import flow.engine.impl.bpmn.behavior.BoundaryCancelEventActivityBehavior;
import flow.engine.impl.bpmn.behavior.BoundaryCompensateEventActivityBehavior;
import flow.engine.impl.bpmn.behavior.BoundaryConditionalEventActivityBehavior;
import flow.engine.impl.bpmn.behavior.BoundaryEscalationEventActivityBehavior;
import flow.engine.impl.bpmn.behavior.BoundaryEventActivityBehavior;
import flow.engine.impl.bpmn.behavior.BoundaryEventRegistryEventActivityBehavior;
import flow.engine.impl.bpmn.behavior.BoundaryMessageEventActivityBehavior;
import flow.engine.impl.bpmn.behavior.BoundarySignalEventActivityBehavior;
import flow.engine.impl.bpmn.behavior.BoundaryTimerEventActivityBehavior;
import flow.engine.impl.bpmn.behavior.CallActivityBehavior;
import flow.engine.impl.bpmn.behavior.CancelEndEventActivityBehavior;
import flow.engine.impl.bpmn.behavior.CaseTaskActivityBehavior;
import flow.engine.impl.bpmn.behavior.ErrorEndEventActivityBehavior;
import flow.engine.impl.bpmn.behavior.EscalationEndEventActivityBehavior;
import flow.engine.impl.bpmn.behavior.EventBasedGatewayActivityBehavior;
import flow.engine.impl.bpmn.behavior.EventSubProcessActivityBehavior;
import flow.engine.impl.bpmn.behavior.EventSubProcessConditionalStartEventActivityBehavior;
import flow.engine.impl.bpmn.behavior.EventSubProcessErrorStartEventActivityBehavior;
import flow.engine.impl.bpmn.behavior.EventSubProcessEscalationStartEventActivityBehavior;
import flow.engine.impl.bpmn.behavior.EventSubProcessEventRegistryStartEventActivityBehavior;
import flow.engine.impl.bpmn.behavior.EventSubProcessMessageStartEventActivityBehavior;
import flow.engine.impl.bpmn.behavior.EventSubProcessSignalStartEventActivityBehavior;
import flow.engine.impl.bpmn.behavior.EventSubProcessTimerStartEventActivityBehavior;
import flow.engine.impl.bpmn.behavior.ExclusiveGatewayActivityBehavior;
import flow.engine.impl.bpmn.behavior.InclusiveGatewayActivityBehavior;
import flow.engine.impl.bpmn.behavior.IntermediateCatchConditionalEventActivityBehavior;
import flow.engine.impl.bpmn.behavior.IntermediateCatchEventActivityBehavior;
import flow.engine.impl.bpmn.behavior.IntermediateCatchMessageEventActivityBehavior;
import flow.engine.impl.bpmn.behavior.IntermediateCatchSignalEventActivityBehavior;
import flow.engine.impl.bpmn.behavior.IntermediateCatchTimerEventActivityBehavior;
import flow.engine.impl.bpmn.behavior.IntermediateThrowCompensationEventActivityBehavior;
import flow.engine.impl.bpmn.behavior.IntermediateThrowEscalationEventActivityBehavior;
import flow.engine.impl.bpmn.behavior.IntermediateThrowNoneEventActivityBehavior;
import flow.engine.impl.bpmn.behavior.IntermediateThrowSignalEventActivityBehavior;
import flow.engine.impl.bpmn.behavior.MailActivityBehavior;
import flow.engine.impl.bpmn.behavior.ManualTaskActivityBehavior;
import flow.engine.impl.bpmn.behavior.NoneEndEventActivityBehavior;
import flow.engine.impl.bpmn.behavior.NoneStartEventActivityBehavior;
import flow.engine.impl.bpmn.behavior.ParallelGatewayActivityBehavior;
import flow.engine.impl.bpmn.behavior.ParallelMultiInstanceBehavior;
import flow.engine.impl.bpmn.behavior.ReceiveTaskActivityBehavior;
import flow.engine.impl.bpmn.behavior.ScriptTaskActivityBehavior;
import flow.engine.impl.bpmn.behavior.SendEventTaskActivityBehavior;
import flow.engine.impl.bpmn.behavior.SequentialMultiInstanceBehavior;
import flow.engine.impl.bpmn.behavior.ServiceTaskDelegateExpressionActivityBehavior;
import flow.engine.impl.bpmn.behavior.ServiceTaskExpressionActivityBehavior;
import flow.engine.impl.bpmn.behavior.ShellActivityBehavior;
import flow.engine.impl.bpmn.behavior.SubProcessActivityBehavior;
import flow.engine.impl.bpmn.behavior.TaskActivityBehavior;
import flow.engine.impl.bpmn.behavior.TerminateEndEventActivityBehavior;
import flow.engine.impl.bpmn.behavior.TransactionActivityBehavior;
import flow.engine.impl.bpmn.behavior.UserTaskActivityBehavior;
import flow.engine.impl.bpmn.behavior.WebServiceActivityBehavior;
import flow.engine.impl.bpmn.helper.ClassDelegate;
import flow.engine.impl.bpmn.parser.BpmnParse;
import flow.engine.impl.bpmn.parser.BpmnParser;
import flow.engine.impl.cfg.ProcessEngineConfigurationImpl;
import flow.engine.impl.deleg.ActivityBehavior;

/**
 * Factory class used by the {@link BpmnParser} and {@link BpmnParse} to instantiate the behaviour classes. For example when parsing an exclusive gateway, this factory will be requested to create a
 * new {@link ActivityBehavior} that will be set on the {@link ActivityImpl} of that step of the process and will implement the spec-compliant behavior of the exclusive gateway.
 *
 * You can provide your own implementation of this class. This way, you can give different execution semantics to a standard bpmn xml construct. Eg. you could tweak the exclusive gateway to do
 * something completely different if you would want that. Creating your own {@link ActivityBehaviorFactory} is only advisable if you want to change the default behavior of any BPMN default construct.
 * And even then, think twice, because it won't be spec compliant bpmn anymore.
 *
 * Note that you can always express any custom step as a service task with a class delegation.
 *
 * The easiest and advisable way to implement your own {@link ActivityBehaviorFactory} is to extend the {@link DefaultActivityBehaviorFactory} class and override the method specific to the
 * {@link ActivityBehavior} you want to change.
 *
 * An instance of this interface can be injected in the {@link ProcessEngineConfigurationImpl} and its subclasses.
 *
 * @author Joram Barrez
 */
interface ActivityBehaviorFactory {

    abstract NoneStartEventActivityBehavior createNoneStartEventActivityBehavior(StartEvent startEvent);

    abstract TaskActivityBehavior createTaskActivityBehavior(Task task);

    abstract ManualTaskActivityBehavior createManualTaskActivityBehavior(ManualTask manualTask);

    abstract ReceiveTaskActivityBehavior createReceiveTaskActivityBehavior(ReceiveTask receiveTask);

    abstract UserTaskActivityBehavior createUserTaskActivityBehavior(UserTask userTask);

    abstract ClassDelegate createClassDelegateServiceTask(ServiceTask serviceTask);

    abstract ServiceTaskDelegateExpressionActivityBehavior createServiceTaskDelegateExpressionActivityBehavior(ServiceTask serviceTask);

    abstract ServiceTaskExpressionActivityBehavior createServiceTaskExpressionActivityBehavior(ServiceTask serviceTask);

    abstract WebServiceActivityBehavior createWebServiceActivityBehavior(ServiceTask serviceTask, BpmnModel bpmnModel);

    abstract WebServiceActivityBehavior createWebServiceActivityBehavior(SendTask sendTask, BpmnModel bpmnModel);

    abstract MailActivityBehavior createMailActivityBehavior(ServiceTask serviceTask);

    abstract MailActivityBehavior createMailActivityBehavior(SendTask sendTask);

    // We do not want a hard dependency on the Mule module, hence we return
    // ActivityBehavior and instantiate the delegate instance using a string instead of the Class itself.
    abstract ActivityBehavior createMuleActivityBehavior(ServiceTask serviceTask);

    abstract ActivityBehavior createMuleActivityBehavior(SendTask sendTask);

    abstract ActivityBehavior createCamelActivityBehavior(ServiceTask serviceTask);

    abstract ActivityBehavior createCamelActivityBehavior(SendTask sendTask);

    abstract ActivityBehavior createDmnActivityBehavior(ServiceTask serviceTask);

    abstract ActivityBehavior createDmnActivityBehavior(SendTask sendTask);

    abstract ActivityBehavior createHttpActivityBehavior(ServiceTask serviceTask);

    abstract ShellActivityBehavior createShellActivityBehavior(ServiceTask serviceTask);

    abstract ActivityBehavior createBusinessRuleTaskActivityBehavior(BusinessRuleTask businessRuleTask);

    abstract ScriptTaskActivityBehavior createScriptTaskActivityBehavior(ScriptTask scriptTask);

    abstract SendEventTaskActivityBehavior createSendEventTaskBehavior(SendEventServiceTask sendEventServiceTask);

    abstract ExclusiveGatewayActivityBehavior createExclusiveGatewayActivityBehavior(ExclusiveGateway exclusiveGateway);

    abstract ParallelGatewayActivityBehavior createParallelGatewayActivityBehavior(ParallelGateway parallelGateway);

    abstract InclusiveGatewayActivityBehavior createInclusiveGatewayActivityBehavior(InclusiveGateway inclusiveGateway);

    abstract EventBasedGatewayActivityBehavior createEventBasedGatewayActivityBehavior(EventGateway eventGateway);

    abstract SequentialMultiInstanceBehavior createSequentialMultiInstanceBehavior(Activity activity, AbstractBpmnActivityBehavior innerActivityBehavior);

    abstract ParallelMultiInstanceBehavior createParallelMultiInstanceBehavior(Activity activity, AbstractBpmnActivityBehavior innerActivityBehavior);

    abstract SubProcessActivityBehavior createSubprocessActivityBehavior(SubProcess subProcess);

    abstract EventSubProcessActivityBehavior createEventSubprocessActivityBehavior(EventSubProcess eventSubProcess);

    abstract EventSubProcessConditionalStartEventActivityBehavior createEventSubProcessConditionalStartEventActivityBehavior(StartEvent startEvent,
                    ConditionalEventDefinition conditionalEventDefinition, string conditionExpression);

    abstract EventSubProcessErrorStartEventActivityBehavior createEventSubProcessErrorStartEventActivityBehavior(StartEvent startEvent);

    abstract EventSubProcessEscalationStartEventActivityBehavior createEventSubProcessEscalationStartEventActivityBehavior(StartEvent startEvent);

    abstract EventSubProcessMessageStartEventActivityBehavior createEventSubProcessMessageStartEventActivityBehavior(StartEvent startEvent, MessageEventDefinition messageEventDefinition);

    abstract EventSubProcessSignalStartEventActivityBehavior createEventSubProcessSignalStartEventActivityBehavior(StartEvent startEvent, SignalEventDefinition signalEventDefinition, Signal signal);

    abstract EventSubProcessTimerStartEventActivityBehavior createEventSubProcessTimerStartEventActivityBehavior(StartEvent startEvent, TimerEventDefinition timerEventDefinition);

    abstract EventSubProcessEventRegistryStartEventActivityBehavior createEventSubProcessEventRegistryStartEventActivityBehavior(StartEvent startEvent, string eventDefinitionKey);

    abstract AdhocSubProcessActivityBehavior createAdhocSubprocessActivityBehavior(SubProcess subProcess);

    abstract CallActivityBehavior createCallActivityBehavior(CallActivity callActivity);

    abstract CaseTaskActivityBehavior createCaseTaskBehavior(CaseServiceTask caseServiceTask);

    abstract TransactionActivityBehavior createTransactionActivityBehavior(Transaction transaction);

    abstract IntermediateCatchEventActivityBehavior createIntermediateCatchEventActivityBehavior(IntermediateCatchEvent intermediateCatchEvent);

    abstract IntermediateCatchMessageEventActivityBehavior createIntermediateCatchMessageEventActivityBehavior(IntermediateCatchEvent intermediateCatchEvent,
            MessageEventDefinition messageEventDefinition);

    abstract IntermediateCatchConditionalEventActivityBehavior createIntermediateCatchConditionalEventActivityBehavior(IntermediateCatchEvent intermediateCatchEvent,
                    ConditionalEventDefinition conditionalEventDefinition, string conditionExpression);

    abstract IntermediateCatchTimerEventActivityBehavior createIntermediateCatchTimerEventActivityBehavior(IntermediateCatchEvent intermediateCatchEvent, TimerEventDefinition timerEventDefinition);

    abstract IntermediateCatchSignalEventActivityBehavior createIntermediateCatchSignalEventActivityBehavior(IntermediateCatchEvent intermediateCatchEvent,
            SignalEventDefinition signalEventDefinition, Signal signal);

    abstract IntermediateThrowNoneEventActivityBehavior createIntermediateThrowNoneEventActivityBehavior(ThrowEvent throwEvent);

    abstract IntermediateThrowSignalEventActivityBehavior createIntermediateThrowSignalEventActivityBehavior(ThrowEvent throwEvent, SignalEventDefinition signalEventDefinition, Signal signal);

    abstract IntermediateThrowEscalationEventActivityBehavior createIntermediateThrowEscalationEventActivityBehavior(ThrowEvent throwEvent, EscalationEventDefinition escalationEventDefinition, Escalation escalation);

    abstract IntermediateThrowCompensationEventActivityBehavior createIntermediateThrowCompensationEventActivityBehavior(ThrowEvent throwEvent, CompensateEventDefinition compensateEventDefinition);

    abstract NoneEndEventActivityBehavior createNoneEndEventActivityBehavior(EndEvent endEvent);

    abstract ErrorEndEventActivityBehavior createErrorEndEventActivityBehavior(EndEvent endEvent, ErrorEventDefinition errorEventDefinition);

    abstract EscalationEndEventActivityBehavior createEscalationEndEventActivityBehavior(EndEvent endEvent, EscalationEventDefinition escalationEventDefinition, Escalation escalation);

    abstract CancelEndEventActivityBehavior createCancelEndEventActivityBehavior(EndEvent endEvent);

    abstract TerminateEndEventActivityBehavior createTerminateEndEventActivityBehavior(EndEvent endEvent);

    abstract BoundaryEventActivityBehavior createBoundaryEventActivityBehavior(BoundaryEvent boundaryEvent, bool interrupting);

    abstract BoundaryCancelEventActivityBehavior createBoundaryCancelEventActivityBehavior(CancelEventDefinition cancelEventDefinition);

    abstract BoundaryTimerEventActivityBehavior createBoundaryTimerEventActivityBehavior(BoundaryEvent boundaryEvent, TimerEventDefinition timerEventDefinition, bool interrupting);

    abstract BoundarySignalEventActivityBehavior createBoundarySignalEventActivityBehavior(BoundaryEvent boundaryEvent, SignalEventDefinition signalEventDefinition, Signal signal, bool interrupting);

    abstract BoundaryMessageEventActivityBehavior createBoundaryMessageEventActivityBehavior(BoundaryEvent boundaryEvent, MessageEventDefinition messageEventDefinition, bool interrupting);

    abstract BoundaryConditionalEventActivityBehavior createBoundaryConditionalEventActivityBehavior(BoundaryEvent boundaryEvent, ConditionalEventDefinition conditionalEventDefinition,
                    string conditionExpression, bool interrupting);

    abstract BoundaryEscalationEventActivityBehavior createBoundaryEscalationEventActivityBehavior(BoundaryEvent boundaryEvent, EscalationEventDefinition escalationEventDefinition, Escalation escalation, bool interrupting);

    abstract BoundaryCompensateEventActivityBehavior createBoundaryCompensateEventActivityBehavior(BoundaryEvent boundaryEvent, CompensateEventDefinition compensateEventDefinition, bool interrupting);

    abstract BoundaryEventRegistryEventActivityBehavior createBoundaryEventRegistryEventActivityBehavior(BoundaryEvent boundaryEvent, string eventDefinitionKey, bool interrupting);
}
