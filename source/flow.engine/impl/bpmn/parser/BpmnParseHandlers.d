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


import hunt.collection.ArrayList;
import hunt.collection.HashMap;
import hunt.collection.List;
import hunt.collection.Map;

import flow.bpmn.model.BaseElement;
import flow.bpmn.model.DataObject;
import flow.bpmn.model.FlowElement;
import flow.engine.parse.BpmnParseHandler;
import org.slf4j.Logger;

/**
 * @author Joram Barrez
 */
class BpmnParseHandlers {

    private static final Logger LOGGER = org.slf4j.LoggerFactory.getLogger(BpmnParseHandlers.class);

    protected Map<Class<? : BaseElement>, List!BpmnParseHandler> parseHandlers;

    public BpmnParseHandlers() {
        this.parseHandlers = new HashMap<>();
    }

    public List!BpmnParseHandler getHandlersFor(Class<? : BaseElement> clazz) {
        return parseHandlers.get(clazz);
    }

    public void addHandlers(List!BpmnParseHandler bpmnParseHandlers) {
        for (BpmnParseHandler bpmnParseHandler : bpmnParseHandlers) {
            addHandler(bpmnParseHandler);
        }
    }

    public void addHandler(BpmnParseHandler bpmnParseHandler) {
        for (Class<? : BaseElement> type : bpmnParseHandler.getHandledTypes()) {
            List!BpmnParseHandler handlers = parseHandlers.get(type);
            if (handlers is null) {
                handlers = new ArrayList<>();
                parseHandlers.put(type, handlers);
            }
            handlers.add(bpmnParseHandler);
        }
    }

    public void parseElement(BpmnParse bpmnParse, BaseElement element) {

        if (element instanceof DataObject) {
            // ignore DataObject elements because they are processed on Process
            // and Sub process level
            return;
        }

        if (element instanceof FlowElement) {
            bpmnParse.setCurrentFlowElement((FlowElement) element);
        }

        // Execute parse handlers
        List!BpmnParseHandler handlers = parseHandlers.get(element.getClass());

        if (handlers is null) {
            LOGGER.warn("Could not find matching parse handler for + {} this is likely a bug.", element.getId());
        } else {
            for (BpmnParseHandler handler : handlers) {
                handler.parse(bpmnParse, element);
            }
        }
    }

}
