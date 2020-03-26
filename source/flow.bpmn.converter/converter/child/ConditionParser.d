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
module flow.bpmn.converter.converter.child.ConditionParser;

import javax.xml.stream.XMLStreamReader;

import flow.bpmn.model.BaseElement;
import flow.bpmn.model.BpmnModel;
import flow.bpmn.model.ConditionalEventDefinition;
import hunt.xml;
import flow.bpmn.converter.converter.child.BaseChildElementParser;
import flow.bpmn.converter.constants.BpmnXMLConstants;

/**
 * @author Tijs Rademakers
 */
class ConditionParser : BaseChildElementParser {

    override
    public string getElementName() {
        return ELEMENT_CONDITION;
    }

    override
    public void parseChildElement(Element xtr, BaseElement parentElement, BpmnModel model)  {
        if (cast(ConditionalEventDefinition)parentElement is null )
            return;

        (cast(ConditionalEventDefinition) parentElement).setConditionExpression(xtr.getText());
    }
}
