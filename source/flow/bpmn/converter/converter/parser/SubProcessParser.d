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
module flow.bpmn.converter.converter.parser.SubProcessParser;

import hunt.collection.List;


import flow.bpmn.converter.constants.BpmnXMLConstants;
import flow.bpmn.converter.converter.util.BpmnXMLUtil;
import flow.bpmn.model.AdhocSubProcess;
import flow.bpmn.model.EventSubProcess;
import flow.bpmn.model.Process;
import flow.bpmn.model.SubProcess;
import flow.bpmn.model.Transaction;
import hunt.xml;
import std.string;
import std.uni;
/**
 * @author Tijs Rademakers
 */
class SubProcessParser : BpmnXMLConstants {

    public void parse(Element xtr, List!SubProcess activeSubProcessList, Process activeProcess) {
        SubProcess subProcess = null;
        if (icmp(ELEMENT_TRANSACTION,(xtr.getName())) == 0) {
            subProcess = new Transaction();

        } else if (icmp(ELEMENT_ADHOC_SUBPROCESS,xtr.getName()) == 0) {
            AdhocSubProcess adhocSubProcess = new AdhocSubProcess();
            string orderingAttributeValue = xtr.firstAttribute(ATTRIBUTE_ORDERING) is null ? "" :  xtr.firstAttribute(ATTRIBUTE_ORDERING).getValue;
            if (orderingAttributeValue.length != 0) {
                adhocSubProcess.setOrdering(orderingAttributeValue);
            }

            if (sicmp(ATTRIBUTE_VALUE_FALSE ,xtr.firstAttribute(ATTRIBUTE_CANCEL_REMAINING_INSTANCES).getValue) == 0) {
                adhocSubProcess.setCancelRemainingInstances(false);
            }

            subProcess = adhocSubProcess;

        } else if (icmp(ATTRIBUTE_VALUE_TRUE,xtr.firstAttribute(ATTRIBUTE_TRIGGERED_BY) is null ? "" : xtr.firstAttribute(ATTRIBUTE_TRIGGERED_BY).getValue ) == 0) {
            subProcess = new EventSubProcess();

        } else {
            subProcess = new SubProcess();
        }

        BpmnXMLUtil.addXMLLocation(subProcess, xtr);
        activeSubProcessList.add(subProcess);

        subProcess.setId(xtr.firstAttribute(ATTRIBUTE_ID) is null ? "" : xtr.firstAttribute(ATTRIBUTE_ID).getValue);
        subProcess.setName(xtr.firstAttribute(ATTRIBUTE_NAME) is null ? "" : xtr.firstAttribute(ATTRIBUTE_NAME).getValue);

        bool async = false;
        string asyncString = BpmnXMLUtil.getAttributeValue(ATTRIBUTE_ACTIVITY_ASYNCHRONOUS, xtr);
        if (icmp(ATTRIBUTE_VALUE_TRUE,asyncString is null ? "" : asyncString) == 0) {
            async = true;
        }

        bool notExclusive = false;
        string exclusiveString = BpmnXMLUtil.getAttributeValue(ATTRIBUTE_ACTIVITY_EXCLUSIVE, xtr);
        if (icmp(ATTRIBUTE_VALUE_FALSE,exclusiveString is null ? "" : exclusiveString) == 0) {
            notExclusive = true;
        }

        bool forCompensation = false;
        string compensationString = xtr.firstAttribute(ATTRIBUTE_ACTIVITY_ISFORCOMPENSATION) is null ? "" : xtr.firstAttribute(ATTRIBUTE_ACTIVITY_ISFORCOMPENSATION).getValue;
        if (icmp(ATTRIBUTE_VALUE_TRUE,compensationString) == 0) {
            forCompensation = true;
        }

        subProcess.setAsynchronous(async);
        subProcess.setNotExclusive(notExclusive);
        subProcess.setForCompensation(forCompensation);
        if (xtr.firstAttribute(ATTRIBUTE_DEFAULT) !is null && xtr.firstAttribute(ATTRIBUTE_DEFAULT).getValue.length != 0) {
            subProcess.setDefaultFlow(xtr.firstAttribute(ATTRIBUTE_DEFAULT).getValue);
        }

        if (activeSubProcessList.size() > 1) {
            SubProcess parentSubProcess = activeSubProcessList.get(activeSubProcessList.size() - 2);
            parentSubProcess.addFlowElement(subProcess);

        } else {
            activeProcess.addFlowElement(subProcess);
        }
    }
}
