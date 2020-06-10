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
module flow.engine.impl.bpmn.parser.factory.ActivityBehaviorFactory;

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
//import flow.engine.impl.bpmn.behavior.MailActivityBehavior;
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
//import flow.engine.impl.bpmn.behavior.ShellActivityBehavior;
import flow.engine.impl.bpmn.behavior.SubProcessActivityBehavior;
import flow.engine.impl.bpmn.behavior.TaskActivityBehavior;
import flow.engine.impl.bpmn.behavior.TerminateEndEventActivityBehavior;
import flow.engine.impl.bpmn.behavior.TransactionActivityBehavior;
import flow.engine.impl.bpmn.behavior.UserTaskActivityBehavior;
//import flow.engine.impl.bpmn.behavior.WebServiceActivityBehavior;
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

     NoneStartEventActivityBehavior createNoneStartEventActivityBehavior(StartEvent startEvent);

     TaskActivityBehavior createTaskActivityBehavior(Task task);

     ManualTaskActivityBehavior createManualTaskActivityBehavior(ManualTask manualTask);

     ReceiveTaskActivityBehavior createReceiveTaskActivityBehavior(ReceiveTask receiveTask);

     UserTaskActivityBehavior createUserTaskActivityBehavior(UserTask userTask);

     ClassDelegate createClassDelegateServiceTask(ServiceTask serviceTask);

     ServiceTaskDelegateExpressionActivityBehavior createServiceTaskDelegateExpressionActivityBehavior(ServiceTask serviceTask);

     ServiceTaskExpressionActivityBehavior createServiceTaskExpressionActivityBehavior(ServiceTask serviceTask);

     //WebServiceActivityBehavior createWebServiceActivityBehavior(ServiceTask serviceTask, BpmnModel bpmnModel);
     //
     //WebServiceActivityBehavior createWebServiceActivityBehavior(SendTask sendTask, BpmnModel bpmnModel);
     //
     //MailActivityBehavior createMailActivityBehavior(ServiceTask serviceTask);
     //
     //MailActivityBehavior createMailActivityBehavior(SendTask sendTask);

    // We do not want a hard dependency on the Mule module, hence we return
    // ActivityBehavior and instantiate the delegate instance using a string instead of the Class itself.
     ActivityBehavior createMuleActivityBehavior(ServiceTask serviceTask);

     ActivityBehavior createMuleActivityBehavior(SendTask sendTask);

     ActivityBehavior createCamelActivityBehavior(ServiceTask serviceTask);

     ActivityBehavior createCamelActivityBehavior(SendTask sendTask);

     ActivityBehavior createDmnActivityBehavior(ServiceTask serviceTask);

     ActivityBehavior createDmnActivityBehavior(SendTask sendTask);

     ActivityBehavior createHttpActivityBehavior(ServiceTask serviceTask);

     //ShellActivityBehavior createShellActivityBehavior(ServiceTask serviceTask);

     ActivityBehavior createBusinessRuleTaskActivityBehavior(BusinessRuleTask businessRuleTask);

     ScriptTaskActivityBehavior createScriptTaskActivityBehavior(ScriptTask scriptTask);

     SendEventTaskActivityBehavior createSendEventTaskBehavior(SendEventServiceTask sendEventServiceTask);

     ExclusiveGatewayActivityBehavior createExclusiveGatewayActivityBehavior(ExclusiveGateway exclusiveGateway);

     ParallelGatewayActivityBehavior createParallelGatewayActivityBehavior(ParallelGateway parallelGateway);

     InclusiveGatewayActivityBehavior createInclusiveGatewayActivityBehavior(InclusiveGateway inclusiveGateway);

     EventBasedGatewayActivityBehavior createEventBasedGatewayActivityBehavior(EventGateway eventGateway);

     SequentialMultiInstanceBehavior createSequentialMultiInstanceBehavior(Activity activity, AbstractBpmnActivityBehavior innerActivityBehavior);

     ParallelMultiInstanceBehavior createParallelMultiInstanceBehavior(Activity activity, AbstractBpmnActivityBehavior innerActivityBehavior);

     SubProcessActivityBehavior createSubprocessActivityBehavior(SubProcess subProcess);

     EventSubProcessActivityBehavior createEventSubprocessActivityBehavior(EventSubProcess eventSubProcess);

     EventSubProcessConditionalStartEventActivityBehavior createEventSubProcessConditionalStartEventActivityBehavior(StartEvent startEvent,
                    ConditionalEventDefinition conditionalEventDefinition, string conditionExpression);

     EventSubProcessErrorStartEventActivityBehavior createEventSubProcessErrorStartEventActivityBehavior(StartEvent startEvent);

     EventSubProcessEscalationStartEventActivityBehavior createEventSubProcessEscalationStartEventActivityBehavior(StartEvent startEvent);

     EventSubProcessMessageStartEventActivityBehavior createEventSubProcessMessageStartEventActivityBehavior(StartEvent startEvent, MessageEventDefinition messageEventDefinition);

     EventSubProcessSignalStartEventActivityBehavior createEventSubProcessSignalStartEventActivityBehavior(StartEvent startEvent, SignalEventDefinition signalEventDefinition, Signal signal);

     EventSubProcessTimerStartEventActivityBehavior createEventSubProcessTimerStartEventActivityBehavior(StartEvent startEvent, TimerEventDefinition timerEventDefinition);

     EventSubProcessEventRegistryStartEventActivityBehavior createEventSubProcessEventRegistryStartEventActivityBehavior(StartEvent startEvent, string eventDefinitionKey);

     AdhocSubProcessActivityBehavior createAdhocSubprocessActivityBehavior(SubProcess subProcess);

     CallActivityBehavior createCallActivityBehavior(CallActivity callActivity);

     CaseTaskActivityBehavior createCaseTaskBehavior(CaseServiceTask caseServiceTask);

     TransactionActivityBehavior createTransactionActivityBehavior(Transaction transaction);

     IntermediateCatchEventActivityBehavior createIntermediateCatchEventActivityBehavior(IntermediateCatchEvent intermediateCatchEvent);

     IntermediateCatchMessageEventActivityBehavior createIntermediateCatchMessageEventActivityBehavior(IntermediateCatchEvent intermediateCatchEvent,
            MessageEventDefinition messageEventDefinition);

     IntermediateCatchConditionalEventActivityBehavior createIntermediateCatchConditionalEventActivityBehavior(IntermediateCatchEvent intermediateCatchEvent,
                    ConditionalEventDefinition conditionalEventDefinition, string conditionExpression);

     IntermediateCatchTimerEventActivityBehavior createIntermediateCatchTimerEventActivityBehavior(IntermediateCatchEvent intermediateCatchEvent, TimerEventDefinition timerEventDefinition);

     IntermediateCatchSignalEventActivityBehavior createIntermediateCatchSignalEventActivityBehavior(IntermediateCatchEvent intermediateCatchEvent,
            SignalEventDefinition signalEventDefinition, Signal signal);

     IntermediateThrowNoneEventActivityBehavior createIntermediateThrowNoneEventActivityBehavior(ThrowEvent throwEvent);

     IntermediateThrowSignalEventActivityBehavior createIntermediateThrowSignalEventActivityBehavior(ThrowEvent throwEvent, SignalEventDefinition signalEventDefinition, Signal signal);

     IntermediateThrowEscalationEventActivityBehavior createIntermediateThrowEscalationEventActivityBehavior(ThrowEvent throwEvent, EscalationEventDefinition escalationEventDefinition, Escalation escalation);

     IntermediateThrowCompensationEventActivityBehavior createIntermediateThrowCompensationEventActivityBehavior(ThrowEvent throwEvent, CompensateEventDefinition compensateEventDefinition);

     NoneEndEventActivityBehavior createNoneEndEventActivityBehavior(EndEvent endEvent);

     ErrorEndEventActivityBehavior createErrorEndEventActivityBehavior(EndEvent endEvent, ErrorEventDefinition errorEventDefinition);

     EscalationEndEventActivityBehavior createEscalationEndEventActivityBehavior(EndEvent endEvent, EscalationEventDefinition escalationEventDefinition, Escalation escalation);

     CancelEndEventActivityBehavior createCancelEndEventActivityBehavior(EndEvent endEvent);

     TerminateEndEventActivityBehavior createTerminateEndEventActivityBehavior(EndEvent endEvent);

     BoundaryEventActivityBehavior createBoundaryEventActivityBehavior(BoundaryEvent boundaryEvent, bool interrupting);

     BoundaryCancelEventActivityBehavior createBoundaryCancelEventActivityBehavior(CancelEventDefinition cancelEventDefinition);

     BoundaryTimerEventActivityBehavior createBoundaryTimerEventActivityBehavior(BoundaryEvent boundaryEvent, TimerEventDefinition timerEventDefinition, bool interrupting);

     BoundarySignalEventActivityBehavior createBoundarySignalEventActivityBehavior(BoundaryEvent boundaryEvent, SignalEventDefinition signalEventDefinition, Signal signal, bool interrupting);

     BoundaryMessageEventActivityBehavior createBoundaryMessageEventActivityBehavior(BoundaryEvent boundaryEvent, MessageEventDefinition messageEventDefinition, bool interrupting);

     BoundaryConditionalEventActivityBehavior createBoundaryConditionalEventActivityBehavior(BoundaryEvent boundaryEvent, ConditionalEventDefinition conditionalEventDefinition,
                    string conditionExpression, bool interrupting);

     BoundaryEscalationEventActivityBehavior createBoundaryEscalationEventActivityBehavior(BoundaryEvent boundaryEvent, EscalationEventDefinition escalationEventDefinition, Escalation escalation, bool interrupting);

     BoundaryCompensateEventActivityBehavior createBoundaryCompensateEventActivityBehavior(BoundaryEvent boundaryEvent, CompensateEventDefinition compensateEventDefinition, bool interrupting);

     BoundaryEventRegistryEventActivityBehavior createBoundaryEventRegistryEventActivityBehavior(BoundaryEvent boundaryEvent, string eventDefinitionKey, bool interrupting);
}
