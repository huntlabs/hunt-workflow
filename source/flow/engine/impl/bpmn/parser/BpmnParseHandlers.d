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
module flow.engine.impl.bpmn.parser.BpmnParseHandlers;

import hunt.collection.ArrayList;
import hunt.collection.HashMap;
import hunt.collection.List;
import hunt.collection.Map;

import flow.bpmn.model.BaseElement;
import flow.bpmn.model.DataObject;
import flow.bpmn.model.FlowElement;
import flow.engine.parse.BpmnParseHandler;
import flow.engine.impl.bpmn.parser.BpmnParse;
import hunt.Exceptions;
import hunt.logging;
/**
 * @author Joram Barrez
 */
class BpmnParseHandlers {

    protected Map!(BaseElement, List!BpmnParseHandler) parseHandlers;

    this() {
        this.parseHandlers = new HashMap!(BaseElement, List!BpmnParseHandler)();
    }

    public List!BpmnParseHandler getHandlersFor(BaseElement clazz) {
        return parseHandlers.get(clazz);
    }

    public void addHandlers(List!BpmnParseHandler bpmnParseHandlers) {
        foreach (BpmnParseHandler bpmnParseHandler ; bpmnParseHandlers) {
            addHandler(bpmnParseHandler);
        }
    }

    public void addHandler(BpmnParseHandler bpmnParseHandler) {
        foreach (BaseElement type ; bpmnParseHandler.getHandledTypes()) {
            List!BpmnParseHandler handlers = parseHandlers.get(type);
            if (handlers is null) {
                handlers = new ArrayList!BpmnParseHandler();
                parseHandlers.put(type, handlers);
            }
            handlers.add(bpmnParseHandler);
        }
    }

    public void parseElement(BpmnParse bpmnParse, BaseElement element) {

        if (cast(DataObject)element !is null) {
            // ignore DataObject elements because they are processed on Process
            // and Sub process level
            return;
        }

        if (cast(FlowElement)element !is null) {
            bpmnParse.setCurrentFlowElement(cast(FlowElement) element);
        }

        // Execute parse handlers
        //List!BpmnParseHandler handlers = parseHandlers.get(element.getClass());
        List!BpmnParseHandler handlers = null;//= parseHandlers.get(element);
        foreach(MapEntry!(BaseElement, List!BpmnParseHandler) entry ; parseHandlers)
        {
            if(typeid(entry.getKey()) == typeid(element))
            {
                handlers = entry.getValue();
                break;
            }
        }

        if (handlers is null) {
            logWarning("Could not find matching parse handler for %s this is likely a bug",element.getId());
           // LOGGER.warn("Could not find matching parse handler for + {} this is likely a bug.", element.getId());
        } else {
            foreach (BpmnParseHandler handler ; handlers) {
                handler.parse(bpmnParse, element);
            }
        }
    }

}
