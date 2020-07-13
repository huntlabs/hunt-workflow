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

module flow.bpmn.model.IOSpecification;


import hunt.collection.ArrayList;
import hunt.collection.List;
import flow.bpmn.model.BaseElement;
import flow.bpmn.model.DataSpec;

class IOSpecification : BaseElement {

    alias setValues = BaseElement.setValues;

    protected List!DataSpec dataInputs ;//= new ArrayList<>();
    protected List!DataSpec dataOutputs ;//= new ArrayList<>();
    protected List!string dataInputRefs ;//= new ArrayList<>();
    protected List!string dataOutputRefs ;//= new ArrayList<>();

    this()
    {
        dataInputs = new  ArrayList!DataSpec;
        dataOutputs = new ArrayList!DataSpec;
        dataInputRefs = new ArrayList!string;
        dataOutputRefs = new ArrayList!string;
    }

    public List!DataSpec getDataInputs() {
        return dataInputs;
    }

    public void setDataInputs(List!DataSpec dataInputs) {
        this.dataInputs = dataInputs;
    }

    public List!DataSpec getDataOutputs() {
        return dataOutputs;
    }

    public void setDataOutputs(List!DataSpec dataOutputs) {
        this.dataOutputs = dataOutputs;
    }

    public List!string getDataInputRefs() {
        return dataInputRefs;
    }

    public void setDataInputRefs(List!string dataInputRefs) {
        this.dataInputRefs = dataInputRefs;
    }

    public List!string getDataOutputRefs() {
        return dataOutputRefs;
    }

    public void setDataOutputRefs(List!string dataOutputRefs) {
        this.dataOutputRefs = dataOutputRefs;
    }

    override
    public IOSpecification clone() {
        IOSpecification clone = new IOSpecification();
        clone.setValues(this);
        return clone;
    }

    public void setValues(IOSpecification otherSpec) {
        dataInputs = new ArrayList!DataSpec();
        if (otherSpec.getDataInputs() !is null && !otherSpec.getDataInputs().isEmpty()) {
            foreach (DataSpec dataSpec ; otherSpec.getDataInputs()) {
                dataInputs.add(dataSpec.clone());
            }
        }

        dataOutputs = new ArrayList!DataSpec();
        if (otherSpec.getDataOutputs() !is null && !otherSpec.getDataOutputs().isEmpty()) {
            foreach (DataSpec dataSpec ; otherSpec.getDataOutputs()) {
                dataOutputs.add(dataSpec.clone());
            }
        }

        dataInputRefs = new ArrayList!string(otherSpec.getDataInputRefs());
        dataOutputRefs = new ArrayList!string(otherSpec.getDataOutputRefs());
    }
}
