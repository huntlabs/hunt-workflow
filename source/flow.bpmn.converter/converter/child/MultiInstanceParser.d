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
module flow.bpmn.converter.converter.child.MultiInstanceParser;

import hunt.collection.HashMap;
import hunt.collection.Map;

import flow.bpmn.converter.converter.child.FlowableCollectionParser;
import flow.bpmn.converter.converter.util.BpmnXMLUtil;
import flow.bpmn.model.Activity;
import flow.bpmn.model.BaseElement;
import flow.bpmn.model.BpmnModel;
import hunt.Boolean;
import flow.bpmn.model.MultiInstanceLoopCharacteristics;
import flow.bpmn.converter.converter.child.BaseChildElementParser;
import flow.bpmn.converter.constants.BpmnXMLConstants;
import hunt.xml;
import std.uni;
import hunt.logging;
/**
 * @author Tijs Rademakers
 */
class MultiInstanceParser : BaseChildElementParser {

    override
    public string getElementName() {
        return ELEMENT_MULTIINSTANCE;
    }


    void loopNexSibling(Element n , MultiInstanceLoopCharacteristics multiInstanceDef , bool readyWithMultiInstance, BpmnModel model)
    {
      Element node = n;
      while(!readyWithMultiInstance && node !is null && node.getType == NodeType.Element)
      {
        //DOSOMETHING
          if (icmp(ELEMENT_MULTIINSTANCE_CARDINALITY,node.getName) == 0) {
            multiInstanceDef.setLoopCardinality(node.getText());

          } else if (icmp(ELEMENT_MULTIINSTANCE_DATAINPUT,(node.getName)) == 0) {
            multiInstanceDef.setInputDataItem(node.getText());

          } else if (icmp(ELEMENT_MULTIINSTANCE_DATAITEM,(node.getName)) == 0) {
            if (node.firstAttribute(ATTRIBUTE_NAME) !is null) {
              multiInstanceDef.setElementVariable(node.firstAttribute(ATTRIBUTE_NAME).getValue());
            }

          } else if (icmp(ELEMENT_MULTIINSTANCE_CONDITION,(node.getName)) == 0) {
            multiInstanceDef.setCompletionCondition(node.getText());

          } else if (icmp(ELEMENT_EXTENSIONS,(node.getName)) == 0) {
                    // parse extension elements
                    // initialize collection element parser in case it exists
            Map!(string, BaseChildElementParser) childParserMap = new HashMap!(string, BaseChildElementParser)();
            childParserMap.put(ELEMENT_MULTIINSTANCE_COLLECTION, new FlowableCollectionParser());
            BpmnXMLUtil.parseChildElements(ELEMENT_EXTENSIONS, multiInstanceDef, node, childParserMap, model);

          }
           else if (icmp(getElementName(),(node.getName)) == 0) {
             readyWithMultiInstance = true;
          }
        Element child  = node.firstNode;
        if(child !is null && child.getType == NodeType.Element)
        {
          //writefln(child.toString);
          //DOSOMETHING
          if (icmp(ELEMENT_MULTIINSTANCE_CARDINALITY,child.getName) == 0) {
            multiInstanceDef.setLoopCardinality(child.getText());

          } else if (icmp(ELEMENT_MULTIINSTANCE_DATAINPUT,(child.getName)) == 0) {
            multiInstanceDef.setInputDataItem(child.getText());

          } else if (icmp(ELEMENT_MULTIINSTANCE_DATAITEM,(child.getName)) == 0) {
            if (child.firstAttribute(ATTRIBUTE_NAME) !is null) {
              multiInstanceDef.setElementVariable(child.firstAttribute(ATTRIBUTE_NAME).getValue());
            }

          } else if (icmp(ELEMENT_MULTIINSTANCE_CONDITION,(child.getName)) == 0) {
            multiInstanceDef.setCompletionCondition(child.getText());

          } else if (icmp(ELEMENT_EXTENSIONS,(child.getName)) == 0) {
            // parse extension elements
            // initialize collection element parser in case it exists
            Map!(string, BaseChildElementParser) childParserMap = new HashMap!(string, BaseChildElementParser)();
            childParserMap.put(ELEMENT_MULTIINSTANCE_COLLECTION, new FlowableCollectionParser());
            BpmnXMLUtil.parseChildElements(ELEMENT_EXTENSIONS, multiInstanceDef, child, childParserMap, model);

          }
          else if (icmp(getElementName(),(child.getName)) == 0) {
              readyWithMultiInstance = true;
            }
          loopNexSibling(child.nextSibling , multiInstanceDef ,readyWithMultiInstance,model);
        }
        node = node.nextSibling;
      }
    }


    override
    public void parseChildElement(Element xtr, BaseElement parentElement, BpmnModel model)  {
        if (cast(Activity)parentElement is null )
            return;

        MultiInstanceLoopCharacteristics multiInstanceDef = new MultiInstanceLoopCharacteristics();
        BpmnXMLUtil.addXMLLocation(multiInstanceDef, xtr);
        if (xtr.firstAttribute(ATTRIBUTE_MULTIINSTANCE_SEQUENTIAL) !is null) {
            multiInstanceDef.setSequential(Boolean.valueOf(xtr.firstAttribute(ATTRIBUTE_MULTIINSTANCE_SEQUENTIAL).getValue()).booleanValue());
        }
        multiInstanceDef.setInputDataItem(BpmnXMLUtil.getAttributeValue(ATTRIBUTE_MULTIINSTANCE_COLLECTION, xtr));
        multiInstanceDef.setElementVariable(BpmnXMLUtil.getAttributeValue(ATTRIBUTE_MULTIINSTANCE_VARIABLE, xtr));
        multiInstanceDef.setElementIndexVariable(BpmnXMLUtil.getAttributeValue(ATTRIBUTE_MULTIINSTANCE_INDEX_VARIABLE, xtr));

        bool readyWithMultiInstance = false;
        try {
            if (xtr !is null)
            {
              loopNexSibling(xtr.firstNode,multiInstanceDef,readyWithMultiInstance,model);
            }
            //while (!readyWithMultiInstance && xtr.hasNext()) {
            //    xtr.next();
            //    if (xtr.isStartElement() && icmp(ELEMENT_MULTIINSTANCE_CARDINALITY,xtr.getName) == 0) {
            //        multiInstanceDef.setLoopCardinality(xtr.getElementText());
            //
            //    } else if (xtr.isStartElement() && ELEMENT_MULTIINSTANCE_DATAINPUT.equalsIgnoreCase(xtr.getName)) {
            //        multiInstanceDef.setInputDataItem(xtr.getElementText());
            //
            //    } else if (xtr.isStartElement() && ELEMENT_MULTIINSTANCE_DATAITEM.equalsIgnoreCase(xtr.getName)) {
            //        if (xtr.firstAttribute(null, ATTRIBUTE_NAME) !is null) {
            //            multiInstanceDef.setElementVariable(xtr.firstAttribute(null, ATTRIBUTE_NAME));
            //        }
            //
            //    } else if (xtr.isStartElement() && ELEMENT_MULTIINSTANCE_CONDITION.equalsIgnoreCase(xtr.getName)) {
            //        multiInstanceDef.setCompletionCondition(xtr.getElementText());
            //
            //    } else if (xtr.isStartElement() && ELEMENT_EXTENSIONS.equalsIgnoreCase(xtr.getName)) {
            //        // parse extension elements
            //        // initialize collection element parser in case it exists
            //        Map<string, BaseChildElementParser> childParserMap = new HashMap<>();
            //        childParserMap.put(ELEMENT_MULTIINSTANCE_COLLECTION, new FlowableCollectionParser());
            //        BpmnXMLUtil.parseChildElements(ELEMENT_EXTENSIONS, multiInstanceDef, xtr, childParserMap, model);
            //
            //    } else if (xtr.isEndElement() && getElementName().equalsIgnoreCase(xtr.getName)) {
            //        readyWithMultiInstance = true;
            //    }
            //}
        } catch (Exception e) {
            logError("Error parsing multi instance definition %s", e.msg);
        }

        (cast(Activity) parentElement).setLoopCharacteristics(multiInstanceDef);
    }
}
