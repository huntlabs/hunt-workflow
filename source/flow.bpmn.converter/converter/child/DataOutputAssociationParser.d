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
module flow.bpmn.converter.converter.child.DataOutputAssociationParser;

import flow.bpmn.converter.converter.child.DataAssociationParser;
import flow.bpmn.converter.converter.util.BpmnXMLUtil;
import flow.bpmn.model.Activity;
import flow.bpmn.model.BaseElement;
import flow.bpmn.model.BpmnModel;
import flow.bpmn.model.DataAssociation;
import flow.bpmn.converter.converter.child.BaseChildElementParser;
import flow.bpmn.converter.constants.BpmnXMLConstants;
import hunt.xml;
import std.uni;
import hunt.logging;
import std.string;
/**
 * @author Tijs Rademakers
 */
class DataOutputAssociationParser : BaseChildElementParser {

    override
    public string getElementName() {
        return ELEMENT_OUTPUT_ASSOCIATION;
    }

    override
    public void parseChildElement(Element xtr, BaseElement parentElement, BpmnModel model)  {

        if (cast(Activity)parentElement is null)
            return;

        DataAssociation dataAssociation = new DataAssociation();
        BpmnXMLUtil.addXMLLocation(dataAssociation, xtr);
        DataAssociationParser.parseDataAssociation(dataAssociation, getElementName(), xtr);

        (cast(Activity) parentElement).getDataOutputAssociations().add(dataAssociation);
    }
}
