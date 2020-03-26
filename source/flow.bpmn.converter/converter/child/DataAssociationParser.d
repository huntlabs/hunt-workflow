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
module flow.bpmn.converter.converter.child.DataAssociationParser;


import flow.bpmn.converter.constants.BpmnXMLConstants;
import flow.bpmn.converter.converter.util.BpmnXMLUtil;
import flow.bpmn.model.Assignment;
import flow.bpmn.model.DataAssociation;
import flow.bpmn.converter.converter.child.BaseChildElementParser;
import flow.bpmn.converter.constants.BpmnXMLConstants;
import hunt.xml;
import std.uni;
import hunt.logging;
import std.string;

class DataAssociationParser : BpmnXMLConstants {

  void loopNexSibling(Element n , DataAssociation dataAssociation ,Assignment assignment, bool readyWithFormProperty)
  {
    Element node = n;
    while(!readyWithFormProperty && node !is null && node.getType == NodeType.Element)
    {
      //DOSOMETHING
      if (ELEMENT_SOURCE_REF == (node.getName())) {
        string sourceRef = node.getText();
        if (sourceRef !is null && sourceRef.length != 0) {
          dataAssociation.setSourceRef(strip(sourceRef));
        }

      } else if (ELEMENT_TARGET_REF == (node.getName())) {
        string targetRef = node.getName();
        if (targetRef !is null && targetRef.length != 0) {
          dataAssociation.setTargetRef(strip(targetRef));
        }

      } else if (ELEMENT_TRANSFORMATION == (node.getName())) {
        string transformation = node.getText();
        if (transformation !is null && transformation.length != 0) {
          dataAssociation.setTransformation(strip(transformation));
        }

      } else if (ELEMENT_ASSIGNMENT == (node.getName())) {
        assignment = new Assignment();
        BpmnXMLUtil.addXMLLocation(assignment, node);

      } else if (ELEMENT_FROM == (node.getName())) {
        string from = node.getText();
        if (assignment !is null && from !is null && from.length != 0) {
          assignment.setFrom(strip(from));
        }

      } else if (ELEMENT_TO == (node.getName())) {
        string to = node.getText();
        if (assignment !is null && to !is null && to.length != 0) {
          assignment.setTo(strip(to));
        }
      }

      Element child  = node.firstNode;
      if(child !is null && child.getType == NodeType.Element)
      {
        //writefln(child.toString);
        //DOSOMETHING
        if (ELEMENT_SOURCE_REF == (child.getName())) {
          string sourceRef = child.getText();
          if (sourceRef !is null && sourceRef.length != 0) {
            dataAssociation.setSourceRef(strip(sourceRef));
          }

        } else if (ELEMENT_TARGET_REF == (child.getName())) {
          string targetRef = child.getName();
          if (targetRef !is null && targetRef.length != 0) {
            dataAssociation.setTargetRef(strip(targetRef));
          }

        } else if (ELEMENT_TRANSFORMATION == (child.getName())) {
          string transformation = child.getText();
          if (transformation !is null && transformation.length != 0) {
            dataAssociation.setTransformation(strip(transformation));
          }

        } else if (ELEMENT_ASSIGNMENT == (child.getName())) {
          assignment = new Assignment();
          BpmnXMLUtil.addXMLLocation(assignment, child);

        } else if (ELEMENT_FROM == (child.getName())) {
          string from = child.getText();
          if (assignment !is null && from !is null && from.length != 0) {
            assignment.setFrom(strip(from));
          }

        } else if (ELEMENT_TO == (child.getName())) {
          string to = child.getText();
          if (assignment !is null && to !is null && to.length != 0) {
            assignment.setTo(strip(to));
          }
        }

        if(ELEMENT_ASSIGNMENT == (child.getName()) && assignment !is null && assignment.getFrom().length != 0 && assignment.getTo().length != 0)
        {
          dataAssociation.getAssignments().add(assignment);
          assignment = null;
        }

        loopNexSibling(child.nextSibling , dataAssociation ,assignment , readyWithFormProperty);
      }

      if(ELEMENT_ASSIGNMENT == (node.getName()) && assignment !is null && assignment.getFrom().length != 0 && assignment.getTo().length != 0)
      {
        dataAssociation.getAssignments().add(assignment);
        assignment = null;
      }

      node = node.nextSibling;
    }
  }


    public static void parseDataAssociation(DataAssociation dataAssociation, string elementName, Element xtr) {
        bool readyWithDataAssociation = false;
        Assignment assignment = null;
        try {

            dataAssociation.setId(xtr.firstAttribute("id") is null ? null : xtr.firstAttribute("id").getValue);

            if (xtr !is null)
            {
                loopNexSibling(xtr.firstNode, dataAssociation, assignment , readyWithDataAssociation);
            }
            //while (!readyWithDataAssociation && xtr.hasNext()) {
            //    xtr.next();
            //    if (xtr.isStartElement() && ELEMENT_SOURCE_REF.equals(xtr.getLocalName())) {
            //        string sourceRef = xtr.getElementText();
            //        if (stringUtils.isNotEmpty(sourceRef)) {
            //            dataAssociation.setSourceRef(sourceRef.trim());
            //        }
            //
            //    } else if (xtr.isStartElement() && ELEMENT_TARGET_REF.equals(xtr.getLocalName())) {
            //        string targetRef = xtr.getElementText();
            //        if (stringUtils.isNotEmpty(targetRef)) {
            //            dataAssociation.setTargetRef(targetRef.trim());
            //        }
            //
            //    } else if (xtr.isStartElement() && ELEMENT_TRANSFORMATION.equals(xtr.getLocalName())) {
            //        string transformation = xtr.getElementText();
            //        if (stringUtils.isNotEmpty(transformation)) {
            //            dataAssociation.setTransformation(transformation.trim());
            //        }
            //
            //    } else if (xtr.isStartElement() && ELEMENT_ASSIGNMENT.equals(xtr.getLocalName())) {
            //        assignment = new Assignment();
            //        BpmnXMLUtil.addXMLLocation(assignment, xtr);
            //
            //    } else if (xtr.isStartElement() && ELEMENT_FROM.equals(xtr.getLocalName())) {
            //        string from = xtr.getElementText();
            //        if (assignment !is null && stringUtils.isNotEmpty(from)) {
            //            assignment.setFrom(from.trim());
            //        }
            //
            //    } else if (xtr.isStartElement() && ELEMENT_TO.equals(xtr.getLocalName())) {
            //        string to = xtr.getElementText();
            //        if (assignment !is null && stringUtils.isNotEmpty(to)) {
            //            assignment.setTo(to.trim());
            //        }
            //
            //    } else if (xtr.isEndElement() && ELEMENT_ASSIGNMENT.equals(xtr.getLocalName())) {
            //        if (stringUtils.isNotEmpty(assignment.getFrom()) && stringUtils.isNotEmpty(assignment.getTo())) {
            //            dataAssociation.getAssignments().add(assignment);
            //        }
            //
            //    } else if (xtr.isEndElement() && elementName.equals(xtr.getLocalName())) {
            //        readyWithDataAssociation = true;
            //    }
            //}
        } catch (Exception e) {
            logError("Error parsing data association child elements %s", e.msg);
        }
    }
}
