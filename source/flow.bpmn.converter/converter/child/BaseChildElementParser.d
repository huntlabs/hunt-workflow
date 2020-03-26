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
module flow.bpmn.converter.converter.child.BaseChildElementParser;


import flow.bpmn.converter.constants.BpmnXMLConstants;
import flow.bpmn.model.BaseElement;
import flow.bpmn.model.BpmnModel;
import hunt.xml;
import hunt.Exceptions;

import flow.bpmn.converter.converter.child.BaseChildElementParser;
import flow.bpmn.converter.constants.BpmnXMLConstants;
import hunt.xml;
import std.uni;
import hunt.logging;
import std.string;
/**
 * @author Tijs Rademakers
 */
abstract class BaseChildElementParser : BpmnXMLConstants {


    public abstract string getElementName();

    public abstract void parseChildElement(Element xtr, BaseElement parentElement, BpmnModel model);

  void loopNexSibling(Element n , BaseElement parentElement, BpmnModel model, BaseChildElementParser parser)
  {
    Element node = n;
    while(node !is null && node.getType == NodeType.Element)
    {
      //DOSOMETHING
      if (parser.getElementName() == (node.getName())) {
          parser.parseChildElement(node, parentElement, model);
      }

      Element child  = node.firstNode;
      if(child !is null && child.getType == NodeType.Element)
      {
        //writefln(child.toString);
        //DOSOMETHING
        if (parser.getElementName() == (child.getName())) {
          parser.parseChildElement(child, parentElement, model);
        }

        loopNexSibling(child.nextSibling , parentElement ,model ,parser);
      }
      node = node.nextSibling;
    }
  }

    protected void parseChildElements(Element xtr, BaseElement parentElement, BpmnModel model, BaseChildElementParser parser) {
        //implementationMissing(false);
        //loopNexSibling(xtr, parentElement, model, parser);
        if (xtr !is null)
        {
            loopNexSibling(xtr.firstNode, parentElement, model, parser);
        }
        //while (!readyWithChildElements && xtr.hasNext()) {
        //    xtr.next();
        //    if (xtr.isStartElement()) {
        //        if (parser.getElementName().equals(xtr.getLocalName())) {
        //            parser.parseChildElement(xtr, parentElement, model);
        //        }
        //
        //    } else if (xtr.isEndElement() && getElementName().equalsIgnoreCase(xtr.getLocalName())) {
        //        readyWithChildElements = true;
        //    }
        //}
    }

    public bool accepts(BaseElement element) {
        return element !is null;
    }
}
