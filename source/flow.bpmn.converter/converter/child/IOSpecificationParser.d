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
module flow.bpmn.converter.converter.child.IOSpecificationParser;


import flow.bpmn.converter.converter.util.BpmnXMLUtil;
import flow.bpmn.model.Activity;
import flow.bpmn.model.BaseElement;
import flow.bpmn.model.BpmnModel;
import flow.bpmn.model.DataSpec;
import flow.bpmn.model.IOSpecification;
import flow.bpmn.model.Process;
import flow.bpmn.converter.converter.child.BaseChildElementParser;
import flow.bpmn.converter.constants.BpmnXMLConstants;
import hunt.xml;
import std.uni;
import hunt.logging;
import std.string;
/**
 * @author Tijs Rademakers
 */
class IOSpecificationParser : BaseChildElementParser {

    override
    public string getElementName() {
        return ELEMENT_IOSPECIFICATION;
    }

     void loopNexSibling(Element n , IOSpecification ioSpecification , bool readyWithFormProperty , BpmnModel model)
     {
       Element node = n;
       while(!readyWithFormProperty && node !is null && node.getType == NodeType.Element)
       {
         //DOSOMETHING
         if (icmp( ELEMENT_DATA_INPUT,(node.getName())) == 0) {
           DataSpec dataSpec = new DataSpec();
           BpmnXMLUtil.addXMLLocation( dataSpec, node);
           dataSpec.setId( node.firstAttribute( ATTRIBUTE_ID) is null ? "" : node.firstAttribute( ATTRIBUTE_ID).getValue);
           dataSpec.setName( node.firstAttribute( ATTRIBUTE_NAME) is null ? "" : node.firstAttribute( ATTRIBUTE_NAME).getValue);
           dataSpec.setItemSubjectRef( parseItemSubjectRef( node.firstAttribute( ATTRIBUTE_ITEM_SUBJECT_REF) is null ? "" : node.firstAttribute( ATTRIBUTE_ITEM_SUBJECT_REF).getValue, model));
           ioSpecification.getDataInputs().add( dataSpec);

         } else if (icmp( ELEMENT_DATA_OUTPUT,(node.getName())) == 0) {
           DataSpec dataSpec = new DataSpec();
           BpmnXMLUtil.addXMLLocation( dataSpec, node);
           dataSpec.setId( node.firstAttribute( ATTRIBUTE_ID) is null ? "" : node.firstAttribute( ATTRIBUTE_ID).getValue);
           dataSpec.setName( node.firstAttribute( ATTRIBUTE_NAME) is null ? "" : node.firstAttribute( ATTRIBUTE_NAME).getValue);
           dataSpec.setItemSubjectRef( parseItemSubjectRef( node.firstAttribute( ATTRIBUTE_ITEM_SUBJECT_REF) is null ? "" : node.firstAttribute( ATTRIBUTE_ITEM_SUBJECT_REF).getValue, model));
           ioSpecification.getDataOutputs().add( dataSpec);

         } else if (icmp( ELEMENT_DATA_INPUT_REFS,(node.getName())) == 0) {
           string dataInputRefs = node.getText();
           if (dataInputRefs.length != 0) {
             ioSpecification.getDataInputRefs().add( strip( dataInputRefs));
           }
         } else if (icmp( ELEMENT_DATA_OUTPUT_REFS,(node.getName())) == 0) {
           string dataOutputRefs = node.getText();
           if (dataOutputRefs.length != 0) {
             ioSpecification.getDataOutputRefs().add( strip( dataOutputRefs));
           }
         }
           Element child  = node.firstNode;
           if (child !is null && child.getType == NodeType.Element)
           {
             //writefln(child.toString);
             //DOSOMETHING
             if (icmp( ELEMENT_DATA_INPUT,(child.getName())) == 0) {
               DataSpec dataSpec = new DataSpec();
               BpmnXMLUtil.addXMLLocation( dataSpec, child);
               dataSpec.setId( child.firstAttribute( ATTRIBUTE_ID) is null ? "" : child.firstAttribute( ATTRIBUTE_ID).getValue);
               dataSpec.setName( child.firstAttribute( ATTRIBUTE_NAME) is null ? "" : child.firstAttribute( ATTRIBUTE_NAME).getValue);
               dataSpec.setItemSubjectRef( parseItemSubjectRef( child.firstAttribute( ATTRIBUTE_ITEM_SUBJECT_REF) is null ? "" : child.firstAttribute( ATTRIBUTE_ITEM_SUBJECT_REF).getValue, model));
               ioSpecification.getDataInputs().add( dataSpec);

             } else if (icmp( ELEMENT_DATA_OUTPUT,(child.getName())) == 0) {
               DataSpec dataSpec = new DataSpec();
               BpmnXMLUtil.addXMLLocation( dataSpec, child);
               dataSpec.setId( child.firstAttribute( ATTRIBUTE_ID) is null ? "" : child.firstAttribute( ATTRIBUTE_ID).getValue);
               dataSpec.setName( child.firstAttribute( ATTRIBUTE_NAME) is null ? "" : child.firstAttribute( ATTRIBUTE_NAME).getValue);
               dataSpec.setItemSubjectRef( parseItemSubjectRef( child.firstAttribute( ATTRIBUTE_ITEM_SUBJECT_REF) is null ? "" : child.firstAttribute( ATTRIBUTE_ITEM_SUBJECT_REF).getValue, model));
               ioSpecification.getDataOutputs().add( dataSpec);

             } else if (icmp( ELEMENT_DATA_INPUT_REFS,(child.getName())) == 0) {
               string dataInputRefs = child.getText();
               if (dataInputRefs.length != 0) {
                 ioSpecification.getDataInputRefs().add( strip( dataInputRefs));
               }
             } else if (icmp( ELEMENT_DATA_OUTPUT_REFS,(child.getName())) == 0) {
               string dataOutputRefs = child.getText();
               if (dataOutputRefs.length != 0) {
                 ioSpecification.getDataOutputRefs().add( strip( dataOutputRefs));
               }

             loopNexSibling( child.nextSibling , ioSpecification ,readyWithFormProperty, model);
           }
           node = node.nextSibling;
         }
       }
     }

    override
    public void parseChildElement(Element xtr, BaseElement parentElement, BpmnModel model)  {

        if ((cast(Activity)parentElement is null) && (cast(Process)parentElement is null))
            return;

        IOSpecification ioSpecification = new IOSpecification();
        BpmnXMLUtil.addXMLLocation(ioSpecification, xtr);
        bool readyWithIOSpecification = false;
        try {
              if (xtr !is null)
              {
                  loopNexSibling(xtr, ioSpecification, readyWithIOSpecification,model );
              }
            //while (!readyWithIOSpecification && xtr.hasNext()) {
            //    xtr.next();
            //    if (xtr.isStartElement() && ELEMENT_DATA_INPUT.equalsIgnoreCase(xtr.getLocalName())) {
            //        DataSpec dataSpec = new DataSpec();
            //        BpmnXMLUtil.addXMLLocation(dataSpec, xtr);
            //        dataSpec.setId(xtr.getAttributeValue(null, ATTRIBUTE_ID));
            //        dataSpec.setName(xtr.getAttributeValue(null, ATTRIBUTE_NAME));
            //        dataSpec.setItemSubjectRef(parseItemSubjectRef(xtr.getAttributeValue(null, ATTRIBUTE_ITEM_SUBJECT_REF), model));
            //        ioSpecification.getDataInputs().add(dataSpec);
            //
            //    } else if (xtr.isStartElement() && ELEMENT_DATA_OUTPUT.equalsIgnoreCase(xtr.getLocalName())) {
            //        DataSpec dataSpec = new DataSpec();
            //        BpmnXMLUtil.addXMLLocation(dataSpec, xtr);
            //        dataSpec.setId(xtr.getAttributeValue(null, ATTRIBUTE_ID));
            //        dataSpec.setName(xtr.getAttributeValue(null, ATTRIBUTE_NAME));
            //        dataSpec.setItemSubjectRef(parseItemSubjectRef(xtr.getAttributeValue(null, ATTRIBUTE_ITEM_SUBJECT_REF), model));
            //        ioSpecification.getDataOutputs().add(dataSpec);
            //
            //    } else if (xtr.isStartElement() && ELEMENT_DATA_INPUT_REFS.equalsIgnoreCase(xtr.getLocalName())) {
            //        string dataInputRefs = xtr.getElementText();
            //        if (stringUtils.isNotEmpty(dataInputRefs)) {
            //            ioSpecification.getDataInputRefs().add(dataInputRefs.trim());
            //        }
            //
            //    } else if (xtr.isStartElement() && ELEMENT_DATA_OUTPUT_REFS.equalsIgnoreCase(xtr.getLocalName())) {
            //        string dataOutputRefs = xtr.getElementText();
            //        if (stringUtils.isNotEmpty(dataOutputRefs)) {
            //            ioSpecification.getDataOutputRefs().add(dataOutputRefs.trim());
            //        }
            //
            //    } else if (xtr.isEndElement() && getElementName().equalsIgnoreCase(xtr.getLocalName())) {
            //        readyWithIOSpecification = true;
            //    }
            //}
        } catch (Exception e) {
            logError("Error parsing ioSpecification child elements %s", e.msg);
        }

        if (cast(Process)parentElement !is null) {
            (cast(Process) parentElement).setIoSpecification(ioSpecification);
        } else {
            (cast(Activity) parentElement).setIoSpecification(ioSpecification);
        }
    }

    protected string parseItemSubjectRef(string itemSubjectRef, BpmnModel model) {
        string result = null;
        if (itemSubjectRef.length != 0) {
            int indexOfP = cast(int)itemSubjectRef.indexOf(':');
            if (indexOfP != -1) {
                string prefix = itemSubjectRef[0 .. indexOfP];
                string resolvedNamespace = model.getNamespace(prefix);
                result = resolvedNamespace ~ ":" ~ itemSubjectRef[indexOfP + 1 .. $];
            } else {
                result = model.getTargetNamespace() ~ ":" ~ itemSubjectRef;
            }
        }
        return result;
    }
}
