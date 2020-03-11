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


import flow.bpmn.model.BaseElement;
import flow.bpmn.model.ParallelGateway;
import flow.engine.impl.bpmn.parser.BpmnParse;

/**
 * @author Joram Barrez
 */
class ParallelGatewayParseHandler extends AbstractActivityBpmnParseHandler<ParallelGateway> {

    @Override
    class<? extends BaseElement> getHandledType() {
        return ParallelGateway.class;
    }

    @Override
    protected void executeParse(BpmnParse bpmnParse, ParallelGateway gateway) {
        gateway.setBehavior(bpmnParse.getActivityBehaviorFactory().createParallelGatewayActivityBehavior(gateway));
    }

}
