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
module flow.bpmn.converter.converter.TextAnnotationXMLConverter;

import hunt.collection.HashMap;
import hunt.collection.Map;

import flow.bpmn.converter.converter.child.BaseChildElementParser;
import flow.bpmn.converter.converter.child.TextAnnotationTextParser;
import flow.bpmn.converter.converter.util.BpmnXMLUtil;
import flow.bpmn.model.BaseElement;
import flow.bpmn.model.BpmnModel;
import flow.bpmn.model.TextAnnotation;
import flow.bpmn.converter.constants.BpmnXMLConstants;
import flow.bpmn.converter.converter.BaseBpmnXMLConverter;
import hunt.xml;
/**
 * @author Tijs Rademakers
 */
class TextAnnotationXMLConverter : BaseBpmnXMLConverter {

    protected Map!(string, BaseChildElementParser) childParserMap  ;//= new HashMap<>();

    this() {
        childParserMap = new HashMap!(string, BaseChildElementParser);
        TextAnnotationTextParser annotationTextParser = new TextAnnotationTextParser();
        childParserMap.put(annotationTextParser.getElementName(), annotationTextParser);
    }

    override
    public TypeInfo getBpmnElementType() {
        return typeid(TextAnnotation);
    }

    override
    protected string getXMLElementName() {
        return ELEMENT_TEXT_ANNOTATION;
    }

    override
    protected BaseElement convertXMLToElement(Element xtr, BpmnModel model)  {
        TextAnnotation textAnnotation = new TextAnnotation();
        BpmnXMLUtil.addXMLLocation(textAnnotation, xtr);
        textAnnotation.setTextFormat(xtr.firstAttribute(ATTRIBUTE_TEXTFORMAT) is null ? "" : xtr.firstAttribute(ATTRIBUTE_TEXTFORMAT).getValue);
        parseChildElements(getXMLElementName(), textAnnotation, childParserMap, model, xtr);
        return textAnnotation;
    }

    //override
    //protected void writeAdditionalAttributes(BaseElement element, BpmnModel model, XMLStreamWriter xtw)  {
    //    TextAnnotation textAnnotation = (TextAnnotation) element;
    //    writeDefaultAttribute(ATTRIBUTE_TEXTFORMAT, textAnnotation.getTextFormat(), xtw);
    //}
    //
    //override
    //protected void writeAdditionalChildElements(BaseElement element, BpmnModel model, XMLStreamWriter xtw)  {
    //    TextAnnotation textAnnotation = (TextAnnotation) element;
    //    if (stringUtils.isNotEmpty(textAnnotation.getText())) {
    //        xtw.writeStartElement(ELEMENT_TEXT_ANNOTATION_TEXT);
    //        xtw.writeCharacters(textAnnotation.getText());
    //        xtw.writeEndElement();
    //    }
    //}
}
