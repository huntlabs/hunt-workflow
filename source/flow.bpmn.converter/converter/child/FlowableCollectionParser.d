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
module flow.bpmn.converter.converter.child.FlowableCollectionParser;

import flow.bpmn.converter.converter.util.BpmnXMLUtil;
import flow.bpmn.model.BaseElement;
import flow.bpmn.model.BpmnModel;
import flow.bpmn.model.CollectionHandler;
import flow.bpmn.model.ImplementationType;
import flow.bpmn.model.MultiInstanceLoopCharacteristics;
import flow.bpmn.converter.converter.child.BaseChildElementParser;
import flow.bpmn.converter.constants.BpmnXMLConstants;
import hunt.xml;
import std.uni;
import hunt.logging;
/**
 * @author Lori Small
 */
class FlowableCollectionParser : BaseChildElementParser {

  void loopNexSibling(Element n , MultiInstanceLoopCharacteristics multiInstanceLoopCharacteristics , bool readyWithFormProperty)
  {
    Element node = n;
    while(!readyWithFormProperty && node !is null && node.getType == NodeType.Element)
    {
      //DOSOMETHING
      if (icmp(ELEMENT_MULTIINSTANCE_COLLECTION_STRING,(node.getName())) == 0) {
        // it is a string value
        multiInstanceLoopCharacteristics.setCollectionString(node.getText());

      } else if (icmp(ELEMENT_MULTIINSTANCE_COLLECTION_EXPRESSION,(node.getName())) == 0) {
        // it is an expression
        multiInstanceLoopCharacteristics.setInputDataItem(node.getName());

      }

      Element child  = node.firstNode;
      if(child !is null && child.getType == NodeType.Element)
      {
        //writefln(child.toString);
        //DOSOMETHING
        if (icmp(ELEMENT_MULTIINSTANCE_COLLECTION_STRING,(child.getName())) == 0) {
          // it is a string value
          multiInstanceLoopCharacteristics.setCollectionString(child.getText());

        } else if (icmp(ELEMENT_MULTIINSTANCE_COLLECTION_EXPRESSION,(child.getName())) == 0) {
          // it is an expression
          multiInstanceLoopCharacteristics.setInputDataItem(child.getName());

        }
        loopNexSibling(child.nextSibling , multiInstanceLoopCharacteristics ,readyWithFormProperty);
      }
      node = node.nextSibling;
    }
  }

    override
    public void parseChildElement(Element xtr, BaseElement parentElement, BpmnModel model)  {
        if (cast(MultiInstanceLoopCharacteristics)parentElement is null) {
            return;
        }

        MultiInstanceLoopCharacteristics multiInstanceLoopCharacteristics = cast(MultiInstanceLoopCharacteristics) parentElement;

        CollectionHandler collectionHandler = null;

        if (xtr.firstAttribute(ATTRIBUTE_MULTIINSTANCE_COLLECTION_CLASS) !is null && xtr.firstAttribute(ATTRIBUTE_MULTIINSTANCE_COLLECTION_CLASS).getValue.length != 0) {
            collectionHandler = new CollectionHandler();
        	collectionHandler.setImplementation(xtr.firstAttribute(ATTRIBUTE_MULTIINSTANCE_COLLECTION_CLASS).getValue);
        	collectionHandler.setImplementationType(ImplementationType.IMPLEMENTATION_TYPE_CLASS);

        } else if (xtr.firstAttribute(ATTRIBUTE_MULTIINSTANCE_COLLECTION_DELEGATEEXPRESSION) !is null && xtr.firstAttribute(ATTRIBUTE_MULTIINSTANCE_COLLECTION_DELEGATEEXPRESSION).getValue.length != 0) {
            collectionHandler = new CollectionHandler();
        	collectionHandler.setImplementation(xtr.firstAttribute(ATTRIBUTE_MULTIINSTANCE_COLLECTION_DELEGATEEXPRESSION).getValue);
        	collectionHandler.setImplementationType(ImplementationType.IMPLEMENTATION_TYPE_DELEGATEEXPRESSION);
        }

        if (collectionHandler !is null)  {
            BpmnXMLUtil.addXMLLocation(collectionHandler, xtr);
            multiInstanceLoopCharacteristics.setHandler(collectionHandler);
        }

        bool readyWithCollection = false;
        try {
              if(xtr !is null)
              {
                loopNexSibling(xtr.firstNode, multiInstanceLoopCharacteristics ,readyWithCollection);
              }
            //while (!readyWithCollection && xtr.hasNext()) {
            //    xtr.next();
            //    if (xtr.isStartElement() && ELEMENT_MULTIINSTANCE_COLLECTION_STRING.equalsIgnoreCase(xtr.getLocalName())) {
            //		// it is a string value
            //        multiInstanceLoopCharacteristics.setCollectionString(xtr.getElementText());
            //
            //    } else if (xtr.isStartElement() && ELEMENT_MULTIINSTANCE_COLLECTION_EXPRESSION.equalsIgnoreCase(xtr.getLocalName())) {
            //		// it is an expression
            //        multiInstanceLoopCharacteristics.setInputDataItem(xtr.getElementText());
            //
            //    } else if (xtr.isEndElement() && getElementName().equalsIgnoreCase(xtr.getLocalName())) {
            //    	readyWithCollection = true;
            //    }
            //}
        } catch (Exception e) {
            logError("Error parsing collection child elements %s", e.msg);
        }
    }

    override
    public string getElementName() {
        return ELEMENT_MULTIINSTANCE_COLLECTION;
    }
}
