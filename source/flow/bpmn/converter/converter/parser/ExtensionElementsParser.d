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
module flow.bpmn.converter.converter.parser.ExtensionElementsParser;

import hunt.collection.List;


import flow.bpmn.converter.constants.BpmnXMLConstants;
import flow.bpmn.converter.converter.child.FlowableEventListenerParser;
import flow.bpmn.converter.converter.child.ExecutionListenerParser;
import flow.bpmn.converter.converter.util.BpmnXMLUtil;
import flow.bpmn.model.BaseElement;
import flow.bpmn.model.BpmnModel;
import flow.bpmn.model.ExtensionElement;
import flow.bpmn.model.Process;
import flow.bpmn.model.SubProcess;
import hunt.xml;
import hunt.Exceptions;

/**
 * @author Tijs Rademakers
 */
class ExtensionElementsParser : BpmnXMLConstants {

  void loopNexSibling(Element n , BaseElement parentElement , Process activeProcess, BpmnModel model, bool readyWithFormProperty)
  {
    Element node = n;
    while(!readyWithFormProperty && node !is null && node.getType == NodeType.Element)
    {
      //DOSOMETHING
      if (ELEMENT_EXECUTION_LISTENER == node.getName()) {
        new ExecutionListenerParser().parseChildElement(node, parentElement, model);
      } else if (ELEMENT_EVENT_LISTENER == node.getName()) {
        new FlowableEventListenerParser().parseChildElement(node, parentElement, model);
      } else if (ELEMENT_POTENTIAL_STARTER == node.getName()) {
       // new PotentialStarterParser().parse(xtr, activeProcess);
          implementationMissing(false);
      } else {
        ExtensionElement extensionElement = BpmnXMLUtil.parseExtensionElement(node);
        parentElement.addExtensionElement(extensionElement);
      }
      Element child  = node.firstNode;
      if(child !is null && child.getType == NodeType.Element)
      {
        //writefln(child.toString);
        //DOSOMETHING
        if (ELEMENT_EXECUTION_LISTENER == child.getName()) {
          new ExecutionListenerParser().parseChildElement(child, parentElement, model);
        } else if (ELEMENT_EVENT_LISTENER == child.getName()) {
          new FlowableEventListenerParser().parseChildElement(child, parentElement, model);
        } else if (ELEMENT_POTENTIAL_STARTER == child.getName()) {
          // new PotentialStarterParser().parse(xtr, activeProcess);
          implementationMissing(false);
        } else {
          ExtensionElement extensionElement = BpmnXMLUtil.parseExtensionElement(child);
          parentElement.addExtensionElement(extensionElement);
        }

        loopNexSibling(child.nextSibling , parentElement ,activeProcess , model, readyWithFormProperty);
      }
      node = node.nextSibling;
    }
  }


    public void parse(Element xtr, List!SubProcess activeSubProcessList, Process activeProcess, BpmnModel model)  {
        BaseElement parentElement = null;
        if (!activeSubProcessList.isEmpty()) {
            parentElement = activeSubProcessList.get(activeSubProcessList.size() - 1);

        } else {
            parentElement = activeProcess;
        }

        bool readyWithChildElements = false;
        if (xtr !is null)
        {
            loopNexSibling(xtr.firstNode , parentElement, activeProcess , model , readyWithChildElements);
        }

        //while (!readyWithChildElements && xtr.hasNext()) {
        //    xtr.next();
        //    if (xtr.isStartElement()) {
        //        if (ELEMENT_EXECUTION_LISTENER.equals(xtr.getLocalName())) {
        //            new ExecutionListenerParser().parseChildElement(xtr, parentElement, model);
        //        } else if (ELEMENT_EVENT_LISTENER.equals(xtr.getLocalName())) {
        //            new FlowableEventListenerParser().parseChildElement(xtr, parentElement, model);
        //        } else if (ELEMENT_POTENTIAL_STARTER.equals(xtr.getLocalName())) {
        //            new PotentialStarterParser().parse(xtr, activeProcess);
        //        } else {
        //            ExtensionElement extensionElement = BpmnXMLUtil.parseExtensionElement(xtr);
        //            parentElement.addExtensionElement(extensionElement);
        //        }
        //
        //    } else if (xtr.isEndElement()) {
        //        if (ELEMENT_EXTENSIONS.equals(xtr.getLocalName())) {
        //            readyWithChildElements = true;
        //        }
        //    }
        //}
    }
}
