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
module flow.bpmn.converter.converter.exp.ProcessExport;

import hunt.collection.List;

import hunt.collection.ArrayList;
import flow.bpmn.converter.constants.BpmnXMLConstants;
import flow.bpmn.converter.converter.util.BpmnXMLUtil;
import flow.bpmn.model.BpmnModel;
import flow.bpmn.model.ExtensionAttribute;
import flow.bpmn.model.Process;
import std.concurrency : initOnce;

class ProcessExport : BpmnXMLConstants {
    /**
     * default attributes taken from process instance attributes
     */
    //public static final List!ExtensionAttribute defaultProcessAttributes = Arrays.asList(
    //        new ExtensionAttribute(ATTRIBUTE_ID),
    //        new ExtensionAttribute(ATTRIBUTE_NAME),
    //        new ExtensionAttribute(ATTRIBUTE_PROCESS_EXECUTABLE),
    //        new ExtensionAttribute(ATTRIBUTE_PROCESS_CANDIDATE_USERS),
    //        new ExtensionAttribute(ATTRIBUTE_PROCESS_CANDIDATE_GROUPS),
    //        new ExtensionAttribute(ATTRIBUTE_PROCESS_EAGER_EXECUTION_FETCHING));


  static List!ExtensionAttribute defaultProcessAttributes() {
    __gshared List!ExtensionAttribute inst;
    return initOnce!inst(new ArrayList!ExtensionAttribute([
        new ExtensionAttribute(ATTRIBUTE_ID),
        new ExtensionAttribute(ATTRIBUTE_NAME),
        new ExtensionAttribute(ATTRIBUTE_PROCESS_EXECUTABLE),
        new ExtensionAttribute(ATTRIBUTE_PROCESS_CANDIDATE_USERS),
        new ExtensionAttribute(ATTRIBUTE_PROCESS_CANDIDATE_GROUPS),
        new ExtensionAttribute(ATTRIBUTE_PROCESS_EAGER_EXECUTION_FETCHING)
    ]));
  }
    //@SuppressWarnings("unchecked")
    //public static void writeProcess(Process process, BpmnModel model, XMLStreamWriter xtw)  {
    //    // start process element
    //    xtw.writeStartElement(ELEMENT_PROCESS);
    //    xtw.writeAttribute(ATTRIBUTE_ID, process.getId());
    //
    //    if (StringUtils.isNotEmpty(process.getName())) {
    //        xtw.writeAttribute(ATTRIBUTE_NAME, process.getName());
    //    }
    //
    //    xtw.writeAttribute(ATTRIBUTE_PROCESS_EXECUTABLE, Boolean.toString(process.isExecutable()));
    //
    //    if (!process.getCandidateStarterUsers().isEmpty()) {
    //        xtw.writeAttribute(FLOWABLE_EXTENSIONS_PREFIX, FLOWABLE_EXTENSIONS_NAMESPACE, ATTRIBUTE_PROCESS_CANDIDATE_USERS, BpmnXMLUtil.convertToDelimitedString(process.getCandidateStarterUsers()));
    //    }
    //
    //    if (!process.getCandidateStarterGroups().isEmpty()) {
    //        xtw.writeAttribute(FLOWABLE_EXTENSIONS_PREFIX, FLOWABLE_EXTENSIONS_NAMESPACE, ATTRIBUTE_PROCESS_CANDIDATE_GROUPS, BpmnXMLUtil.convertToDelimitedString(process.getCandidateStarterGroups()));
    //    }
    //
    //    if (process.isEnableEagerExecutionTreeFetching()) {
    //        xtw.writeAttribute(FLOWABLE_EXTENSIONS_PREFIX, FLOWABLE_EXTENSIONS_NAMESPACE, ATTRIBUTE_PROCESS_EAGER_EXECUTION_FETCHING, "true");
    //    }
    //
    //    // write custom attributes
    //    BpmnXMLUtil.writeCustomAttributes(process.getAttributes().values(), xtw, defaultProcessAttributes);
    //
    //    if (StringUtils.isNotEmpty(process.getDocumentation())) {
    //
    //        xtw.writeStartElement(ELEMENT_DOCUMENTATION);
    //        xtw.writeCharacters(process.getDocumentation());
    //        xtw.writeEndElement();
    //    }
    //
    //    bool didWriteExtensionStartElement = FlowableListenerExport.writeListeners(process, false, xtw);
    //    didWriteExtensionStartElement = BpmnXMLUtil.writeExtensionElements(process, didWriteExtensionStartElement, model.getNamespaces(), xtw);
    //
    //    if (didWriteExtensionStartElement) {
    //        // closing extensions element
    //        xtw.writeEndElement();
    //    }
    //
    //    LaneExport.writeLanes(process, model, xtw);
    //}
}
