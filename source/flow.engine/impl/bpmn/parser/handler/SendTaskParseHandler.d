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
module flow.engine.impl.bpmn.parser.handler.SendTaskParseHandler;

import flow.bpmn.model.BaseElement;
import flow.bpmn.model.ImplementationType;
import flow.bpmn.model.SendTask;
//import flow.engine.impl.bpmn.behavior.WebServiceActivityBehavior;
import flow.engine.impl.bpmn.parser.BpmnParse;
import flow.engine.impl.bpmn.parser.handler.AbstractActivityBpmnParseHandler;
import hunt.Exceptions;
/**
 * @author Joram Barrez
 */
class SendTaskParseHandler : AbstractActivityBpmnParseHandler!SendTask {


    override
    TypeInfo getHandledType() {
        return typeid(SendTask);
    }

    override
    protected void executeParse(BpmnParse bpmnParse, SendTask sendTask) {
        implementationMissing(false);
        //if (StringUtils.isNotEmpty(sendTask.getType())) {
        //
        //    if (sendTask.getType().equalsIgnoreCase("mail")) {
        //        sendTask.setBehavior(bpmnParse.getActivityBehaviorFactory().createMailActivityBehavior(sendTask));
        //    } else if (sendTask.getType().equalsIgnoreCase("mule")) {
        //        sendTask.setBehavior(bpmnParse.getActivityBehaviorFactory().createMuleActivityBehavior(sendTask));
        //    } else if (sendTask.getType().equalsIgnoreCase("camel")) {
        //        sendTask.setBehavior(bpmnParse.getActivityBehaviorFactory().createCamelActivityBehavior(sendTask));
        //    } else if (sendTask.getType().equalsIgnoreCase("dmn")) {
        //        sendTask.setBehavior(bpmnParse.getActivityBehaviorFactory().createDmnActivityBehavior(sendTask));
        //    }
        //
        //} else if (ImplementationType.IMPLEMENTATION_TYPE_WEBSERVICE.equalsIgnoreCase(sendTask.getImplementationType()) && StringUtils.isNotEmpty(sendTask.getOperationRef())) {
        //
        //    WebServiceActivityBehavior webServiceActivityBehavior = bpmnParse.getActivityBehaviorFactory().createWebServiceActivityBehavior(sendTask, bpmnParse.getBpmnModel());
        //    sendTask.setBehavior(webServiceActivityBehavior);
        //
        //} else {
        //    LOGGER.warn("One of the attributes 'type' or 'operation' is mandatory on sendTask {}", sendTask.getId());
        //}
    }

}
