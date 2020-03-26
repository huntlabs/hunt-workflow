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
module flow.bpmn.converter.converter.ScriptTaskXMLConverter;

import hunt.collection.HashMap;
import hunt.collection.Map;

import flow.bpmn.converter.converter.child.BaseChildElementParser;
import flow.bpmn.converter.converter.child.ScriptTextParser;
import flow.bpmn.converter.converter.util.BpmnXMLUtil;
import flow.bpmn.model.BaseElement;
import flow.bpmn.model.BpmnModel;
import flow.bpmn.model.ScriptTask;
import hunt.Boolean;
import flow.bpmn.converter.constants.BpmnXMLConstants;
import flow.bpmn.converter.converter.BaseBpmnXMLConverter;
import hunt.xml;
/**
 * @author Tijs Rademakers
 */
class ScriptTaskXMLConverter : BaseBpmnXMLConverter {

    protected Map!(string, BaseChildElementParser) childParserMap  ;//= new HashMap<>();

    this() {
        ScriptTextParser scriptTextParser = new ScriptTextParser();
        childParserMap = new HashMap!(string, BaseChildElementParser);
        childParserMap.put(scriptTextParser.getElementName(), scriptTextParser);
    }

    override
    public TypeInfo getBpmnElementType() {
        return typeid(ScriptTask);
    }

    override
    protected string getXMLElementName() {
        return ELEMENT_TASK_SCRIPT;
    }

    override
    protected BaseElement convertXMLToElement(Element xtr, BpmnModel model)  {
        ScriptTask scriptTask = new ScriptTask();
        BpmnXMLUtil.addXMLLocation(scriptTask, xtr);
        scriptTask.setScriptFormat(xtr.getAttributeValue(null, ATTRIBUTE_TASK_SCRIPT_FORMAT));
        scriptTask.setResultVariable(BpmnXMLUtil.getAttributeValue(ATTRIBUTE_TASK_SCRIPT_RESULTVARIABLE, xtr));
        if (scriptTask.getResultVariable() !is null && scriptTask.getResultVariable().length != 0) {
            scriptTask.setResultVariable(BpmnXMLUtil.getAttributeValue(ATTRIBUTE_TASK_SERVICE_RESULTVARIABLE, xtr));
        }
        string autoStoreVariables = BpmnXMLUtil.getAttributeValue(ATTRIBUTE_TASK_SCRIPT_AUTO_STORE_VARIABLE, xtr);
        if (autoStoreVariables.length != 0) {
            scriptTask.setAutoStoreVariables(Boolean.valueOf(autoStoreVariables).booleanValue());
        }
        parseChildElements(getXMLElementName(), scriptTask, childParserMap, model, xtr);
        return scriptTask;
    }

    //override
    //protected void writeAdditionalAttributes(BaseElement element, BpmnModel model, XMLStreamWriter xtw)  {
    //    ScriptTask scriptTask = (ScriptTask) element;
    //    writeDefaultAttribute(ATTRIBUTE_TASK_SCRIPT_FORMAT, scriptTask.getScriptFormat(), xtw);
    //    writeQualifiedAttribute(ATTRIBUTE_TASK_SCRIPT_RESULTVARIABLE, scriptTask.getResultVariable(), xtw);
    //    writeQualifiedAttribute(ATTRIBUTE_TASK_SCRIPT_AUTO_STORE_VARIABLE, String.valueOf(scriptTask.isAutoStoreVariables()), xtw);
    //}
    //
    //override
    //protected void writeAdditionalChildElements(BaseElement element, BpmnModel model, XMLStreamWriter xtw)  {
    //    ScriptTask scriptTask = (ScriptTask) element;
    //    if (StringUtils.isNotEmpty(scriptTask.getScript())) {
    //        xtw.writeStartElement(ATTRIBUTE_TASK_SCRIPT_TEXT);
    //        xtw.writeCData(scriptTask.getScript());
    //        xtw.writeEndElement();
    //    }
    //}
}
