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

module flow.engine.impl.bpmn.behavior.AdhocSubProcessActivityBehavior;

import hunt.collection;
import hunt.collection.HashMap;
import hunt.collection.Map;

import flow.bpmn.model.FlowElement;
import flow.bpmn.model.SubProcess;
import flow.bpmn.model.ValuedDataObject;
import flow.common.api.FlowableException;
import flow.engine.deleg.DelegateExecution;
import flow.engine.impl.bpmn.behavior.AbstractBpmnActivityBehavior;

/**
 * Implementation of the BPMN 2.0 ad-hoc subprocess.
 *
 * @author Tijs Rademakers
 */
class AdhocSubProcessActivityBehavior : AbstractBpmnActivityBehavior {

    override
    public void execute(DelegateExecution execution) {
        SubProcess subProcess = getSubProcessFromExecution(execution);
        execution.setScope(true);

        // initialize the template-defined data objects as variables
        Map!(string, Object) dataObjectVars = processDataObjects(subProcess.getDataObjects());
        if (dataObjectVars !is null) {
            execution.setVariablesLocal(dataObjectVars);
        }
    }

    protected SubProcess getSubProcessFromExecution(DelegateExecution execution) {
        FlowElement flowElement = execution.getCurrentFlowElement();
        SubProcess subProcess = null;
        if (cast(SubProcess)flowElement !is null) {
            subProcess = cast(SubProcess) flowElement;
        } else {
            throw new FlowableException("Programmatic error: sub process behaviour can only be applied" ~ " to a SubProcess instance, but got an instance of " );
        }
        return subProcess;
    }

    protected Map!(string, Object) processDataObjects(Collection!ValuedDataObject dataObjects) {
        Map!(string, Object) variablesMap = new HashMap!(string, Object)();
        // convert data objects to process variables
        if (dataObjects !is null) {
            foreach (ValuedDataObject dataObject ; dataObjects) {
                variablesMap.put(dataObject.getName(), dataObject.getValue());
            }
        }
        return variablesMap;
    }
}
