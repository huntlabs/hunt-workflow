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
module flow.engine.impl.bpmn.parser.handler.AbstractBpmnParseHandler;

import hunt.collection;
import hunt.collection.HashSet;
import hunt.collection.Set;

import flow.bpmn.model.Artifact;
import flow.bpmn.model.Association;
import flow.bpmn.model.BaseElement;
import flow.bpmn.model.BpmnModel;
import flow.bpmn.model.EventGateway;
import flow.bpmn.model.FlowElement;
import flow.bpmn.model.FlowableListener;
import flow.bpmn.model.ImplementationType;
import flow.bpmn.model.IntermediateCatchEvent;
import flow.bpmn.model.SequenceFlow;
import flow.engine.deleg.ExecutionListener;
import flow.engine.impl.bpmn.parser.BpmnParse;
import flow.engine.parse.BpmnParseHandler;
import  std.uni;
/**
 * @author Joram Barrez
 */
abstract class AbstractBpmnParseHandler(T) : BpmnParseHandler {

    public static  string PROPERTYNAME_EVENT_SUBSCRIPTION_DECLARATION = "eventDefinitions";

    public static  string PROPERTYNAME_ERROR_EVENT_DEFINITIONS = "errorEventDefinitions";

    public static  string PROPERTYNAME_TIMER_DECLARATION = "timerDeclarations";

    public Set!TypeInfo getHandledTypes() {
        Set!TypeInfo types = new HashSet!TypeInfo();
        types.add(getHandledType());
        return types;
    }

    protected abstract TypeInfo getHandledType();

    public void parse(BpmnParse bpmnParse, BaseElement element) {
        T baseElement = cast(T) element;
        executeParse(bpmnParse, baseElement);
    }

    protected abstract void executeParse(BpmnParse bpmnParse, T element);

    protected ExecutionListener createExecutionListener(BpmnParse bpmnParse, FlowableListener listener) {
        ExecutionListener executionListener = null;

        if (sicmp(ImplementationType.IMPLEMENTATION_TYPE_CLASS,(listener.getImplementationType())) == 0) {
            executionListener = bpmnParse.getListenerFactory().createClassDelegateExecutionListener(listener);
        } else if (sicmp(ImplementationType.IMPLEMENTATION_TYPE_EXPRESSION,(listener.getImplementationType())) == 0) {
            executionListener = bpmnParse.getListenerFactory().createExpressionExecutionListener(listener);
        } else if (sicmp(ImplementationType.IMPLEMENTATION_TYPE_DELEGATEEXPRESSION,(listener.getImplementationType())) == 0) {
            executionListener = bpmnParse.getListenerFactory().createDelegateExpressionExecutionListener(listener);
        }
        return executionListener;
    }

    protected string getPrecedingEventBasedGateway(BpmnParse bpmnParse, IntermediateCatchEvent event) {
        string eventBasedGatewayId = null;
        foreach (SequenceFlow sequenceFlow ; event.getIncomingFlows()) {
            FlowElement sourceElement = bpmnParse.getBpmnModel().getFlowElement(sequenceFlow.getSourceRef());
            if (cast(EventGateway)sourceElement !is null) {
                eventBasedGatewayId = sourceElement.getId();
                break;
            }
        }
        return eventBasedGatewayId;
    }

    protected void processArtifacts(BpmnParse bpmnParse, Collection!Artifact artifacts) {
        // associations
        foreach (Artifact artifact ; artifacts) {
            if (cast(Association)artifact !is null) {
                createAssociation(bpmnParse, cast(Association) artifact);
            }
        }
    }

    protected void createAssociation(BpmnParse bpmnParse, Association association) {
        BpmnModel bpmnModel = bpmnParse.getBpmnModel();
        if (bpmnModel.getArtifact(association.getSourceRef()) !is null || bpmnModel.getArtifact(association.getTargetRef()) !is null) {

            // connected to a text annotation so skipping it
        }

        // ActivityImpl sourceActivity =
        // parentScope.findActivity(association.getSourceRef());
        // ActivityImpl targetActivity =
        // parentScope.findActivity(association.getTargetRef());

        // an association may reference elements that are not parsed as
        // activities (like for instance
        // text annotations so do not throw an exception if sourceActivity or
        // targetActivity are null)
        // However, we make sure they reference 'something':
        // if (sourceActivity is null) {
        // bpmnModel.addProblem("Invalid reference sourceRef '" +
        // association.getSourceRef() + "' of association element ",
        // association.getId());
        // } else if (targetActivity is null) {
        // bpmnModel.addProblem("Invalid reference targetRef '" +
        // association.getTargetRef() + "' of association element ",
        // association.getId());
        /*
         * } else { if (sourceActivity.getProperty("type").equals("compensationBoundaryCatch" )) { Object isForCompensation = targetActivity.getProperty(PROPERTYNAME_IS_FOR_COMPENSATION); if
         * (isForCompensation is null || !(bool) isForCompensation) { LOGGER.warn( "compensation boundary catch must be connected to element with isForCompensation=true" ); } else { ActivityImpl
         * compensatedActivity = sourceActivity.getParentActivity(); compensatedActivity.setProperty(BpmnParse .PROPERTYNAME_COMPENSATION_HANDLER_ID, targetActivity.getId()); } } }
         */
    }
}
