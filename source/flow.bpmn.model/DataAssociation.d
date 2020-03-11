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
module flow.bpmn.model.DataAssociation;

import hunt.collection.ArrayList;
import hunt.collection.List;
import flow.bpmn.model.BaseElement;
import flow.bpmn.model.Assignment;

class DataAssociation : BaseElement {

    protected string sourceRef;
    protected string targetRef;
    protected string transformation;
    protected List!Assignment assignments ;// = new ArrayList<>();

    this()
    {
        assignments = new ArrayList!Assignment;
    }

    public string getSourceRef() {
        return sourceRef;
    }

    public void setSourceRef(string sourceRef) {
        this.sourceRef = sourceRef;
    }

    public string getTargetRef() {
        return targetRef;
    }

    public void setTargetRef(string targetRef) {
        this.targetRef = targetRef;
    }

    public string getTransformation() {
        return transformation;
    }

    public void setTransformation(string transformation) {
        this.transformation = transformation;
    }

    public List!Assignment getAssignments() {
        return assignments;
    }

    public void setAssignments(List!Assignment assignments) {
        this.assignments = assignments;
    }

    override
    public DataAssociation clone() {
        DataAssociation clone = new DataAssociation();
        clone.setValues(this);
        return clone;
    }

    public void setValues(DataAssociation otherAssociation) {
        setSourceRef(otherAssociation.getSourceRef());
        setTargetRef(otherAssociation.getTargetRef());
        setTransformation(otherAssociation.getTransformation());

        assignments = new ArrayList!Assignment();
        if (otherAssociation.getAssignments() !is null && !otherAssociation.getAssignments().isEmpty()) {
            foreach (Assignment assignment ; otherAssociation.getAssignments()) {
                assignments.add(assignment.clone());
            }
        }
    }
}
