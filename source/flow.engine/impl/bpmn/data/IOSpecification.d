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
module flow.engine.impl.bpmn.data.IOSpecification;

import hunt.collection.ArrayList;
import hunt.collections;
import hunt.collection.List;
import hunt.collection.Collections;
import flow.engine.deleg.DelegateExecution;
import flow.engine.impl.bpmn.data.Data;
import flow.engine.impl.bpmn.data.DataRef;
/**
 * Implementation of the BPMN 2.0 'ioSpecification'
 *
 * @author Esteban Robles Luna
 * @author Falko Menge
 */
class IOSpecification {

    protected List!Data dataInputs;

    protected List!Data dataOutputs;

    protected List!DataRef dataInputRefs;

    protected List!DataRef dataOutputRefs;

    this() {
        this.dataInputs = new ArrayList!Data();
        this.dataOutputs = new ArrayList!Data();
        this.dataInputRefs = new ArrayList!DataRef();
        this.dataOutputRefs = new ArrayList!DataRef();
    }

    public void initialize(DelegateExecution execution) {
        foreach (Data data ; this.dataInputs) {
            execution.setTransientVariable(data.getName(), data.getDefinition().createInstance());
        }

        foreach (Data data ; this.dataOutputs) {
            execution.setTransientVariable(data.getName(), data.getDefinition().createInstance());
        }
    }

    public List!Data getDataInputs() {
        return this.dataInputs;
    }

    public List!Data getDataOutputs() {
        return this.dataOutputs;
    }

    public void addInput(Data data) {
        this.dataInputs.add(data);
    }

    public void addOutput(Data data) {
        this.dataOutputs.add(data);
    }

    public void addInputRef(DataRef dataRef) {
        this.dataInputRefs.add(dataRef);
    }

    public void addOutputRef(DataRef dataRef) {
        this.dataOutputRefs.add(dataRef);
    }

    public string getFirstDataInputName() {
        return this.dataInputs.get(0).getName();
    }

    public string getFirstDataOutputName() {
        if (this.dataOutputs !is null && !this.dataOutputs.isEmpty()) {
            return this.dataOutputs.get(0).getName();
        } else {
            return null;
        }
    }
}
