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
module flow.engine.impl.bpmn.data.SimpleDataInputAssociation;

import hunt.collection.ArrayList;
import hunt.collection.List;

import flow.common.api.deleg.Expression;
import flow.engine.deleg.DelegateExecution;
import flow.engine.impl.bpmn.data.AbstractDataAssociation;
import flow.engine.impl.bpmn.data.Assignment;
/**
 * A simple data input association between a source and a target with assignments
 *
 * @author Esteban Robles Luna
 */
class SimpleDataInputAssociation : AbstractDataAssociation {

    protected List!Assignment assignments  ;//= new ArrayList<>();

    this(Expression sourceExpression, string target) {
        super(sourceExpression, target);
        assignments = new ArrayList!Assignment;
    }

    this(string source, string target) {
        super(source, target);
        assignments = new ArrayList!Assignment;
    }

    public void addAssignment(Assignment assignment) {
        this.assignments.add(assignment);
    }

    override
    public void evaluate(DelegateExecution execution) {
        foreach (Assignment assignment ; this.assignments) {
            assignment.evaluate(execution);
        }
    }
}
