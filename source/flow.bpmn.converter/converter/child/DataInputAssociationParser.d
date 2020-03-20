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


import javax.xml.stream.XMLStreamReader;

import flow.bpmn.converter.converter.util.BpmnXMLUtil;
import flow.bpmn.model.Activity;
import flow.bpmn.model.BaseElement;
import flow.bpmn.model.BpmnModel;
import flow.bpmn.model.DataAssociation;

/**
 * @author Tijs Rademakers
 */
public class DataInputAssociationParser extends BaseChildElementParser {

    @Override
    public String getElementName() {
        return ELEMENT_INPUT_ASSOCIATION;
    }

    @Override
    public void parseChildElement(XMLStreamReader xtr, BaseElement parentElement, BpmnModel model) throws Exception {

        if (!(parentElement instanceof Activity))
            return;

        DataAssociation dataAssociation = new DataAssociation();
        BpmnXMLUtil.addXMLLocation(dataAssociation, xtr);
        DataAssociationParser.parseDataAssociation(dataAssociation, getElementName(), xtr);

        ((Activity) parentElement).getDataInputAssociations().add(dataAssociation);
    }
}