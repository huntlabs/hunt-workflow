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
module flow.engine.impl.bpmn.parser.handler.InclusiveGatewayParseHandler;

import flow.bpmn.model.BaseElement;
import flow.bpmn.model.InclusiveGateway;
import flow.engine.impl.bpmn.parser.BpmnParse;
import flow.engine.impl.bpmn.parser.handler.AbstractActivityBpmnParseHandler;

/**
 * @author Joram Barrez
 */
class InclusiveGatewayParseHandler : AbstractActivityBpmnParseHandler!InclusiveGateway {

    override
    BaseElement getHandledType() {
        return new InclusiveGateway;
    }

    override
    protected void executeParse(BpmnParse bpmnParse, InclusiveGateway gateway) {
        gateway.setBehavior(bpmnParse.getActivityBehaviorFactory().createInclusiveGatewayActivityBehavior(gateway));
    }

}
