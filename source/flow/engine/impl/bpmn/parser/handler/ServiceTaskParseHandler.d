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
module flow.engine.impl.bpmn.parser.handler.ServiceTaskParseHandler;

import std.uni;
import flow.bpmn.model.BaseElement;
import flow.bpmn.model.ImplementationType;
import flow.bpmn.model.ServiceTask;
//import flow.engine.impl.bpmn.behavior.WebServiceActivityBehavior;
import flow.engine.impl.bpmn.parser.BpmnParse;
import flow.engine.impl.bpmn.parser.handler.AbstractActivityBpmnParseHandler;
import hunt.Exceptions;
import hunt.logging;
/**
 * @author Joram Barrez
 */
class ServiceTaskParseHandler : AbstractActivityBpmnParseHandler!ServiceTask {

    override
    BaseElement getHandledType() {
        return new ServiceTask;
    }

    override
    protected void executeParse(BpmnParse bpmnParse, ServiceTask serviceTask) {
        //implementationMissing(false);
        // Email, Mule, Http and Shell service tasks
        if (serviceTask.getType() !is null && serviceTask.getType().length != 0) {
            implementationMissing(false);
            //if (serviceTask.getType().equalsIgnoreCase("mail")) {
            //    serviceTask.setBehavior(bpmnParse.getActivityBehaviorFactory().createMailActivityBehavior(serviceTask));
            //
            //} else if (serviceTask.getType().equalsIgnoreCase("mule")) {
            //    serviceTask.setBehavior(bpmnParse.getActivityBehaviorFactory().createMuleActivityBehavior(serviceTask));
            //
            //} else if (serviceTask.getType().equalsIgnoreCase("camel")) {
            //    serviceTask.setBehavior(bpmnParse.getActivityBehaviorFactory().createCamelActivityBehavior(serviceTask));
            //
            //} else if (serviceTask.getType().equalsIgnoreCase("shell")) {
            //    serviceTask.setBehavior(bpmnParse.getActivityBehaviorFactory().createShellActivityBehavior(serviceTask));
            //
            //} else if (serviceTask.getType().equalsIgnoreCase("dmn")) {
            //    serviceTask.setBehavior(bpmnParse.getActivityBehaviorFactory().createDmnActivityBehavior(serviceTask));
            //
            //} else if (serviceTask.getType().equalsIgnoreCase("http")) {
            //    serviceTask.setBehavior(bpmnParse.getActivityBehaviorFactory().createHttpActivityBehavior(serviceTask));
            //
            //} else {
            //    LOGGER.warn("Invalid type: '{}' for service task {}", serviceTask.getType(), serviceTask.getId());
            //}

            // activiti:class
        } else if (sicmp(ImplementationType.IMPLEMENTATION_TYPE_CLASS,serviceTask.getImplementationType()) == 0) {

            serviceTask.setBehavior(bpmnParse.getActivityBehaviorFactory().createClassDelegateServiceTask(serviceTask));

            // activiti:delegateExpression
        } else if (sicmp(ImplementationType.IMPLEMENTATION_TYPE_DELEGATEEXPRESSION,serviceTask.getImplementationType()) == 0) {

            serviceTask.setBehavior(bpmnParse.getActivityBehaviorFactory().createServiceTaskDelegateExpressionActivityBehavior(serviceTask));

            // activiti:expression
        } else if (sicmp(ImplementationType.IMPLEMENTATION_TYPE_EXPRESSION,serviceTask.getImplementationType()) == 0) {

            serviceTask.setBehavior(bpmnParse.getActivityBehaviorFactory().createServiceTaskExpressionActivityBehavior(serviceTask));

            // Webservice
        } else if (sicmp(ImplementationType.IMPLEMENTATION_TYPE_WEBSERVICE,serviceTask.getImplementationType()) == 0 && (serviceTask.getOperationRef() !is null && serviceTask.getOperationRef().length != 0)) {
             implementationMissing(false);
            //WebServiceActivityBehavior webServiceActivityBehavior = bpmnParse.getActivityBehaviorFactory().createWebServiceActivityBehavior(serviceTask, bpmnParse.getBpmnModel());
            //serviceTask.setBehavior(webServiceActivityBehavior);

        } else {
            logWarning("One of the attributes 'class', 'delegateExpression', 'type', 'operation', or 'expression' is mandatory on service task {%s}", serviceTask.getId());
        }

    }
}
