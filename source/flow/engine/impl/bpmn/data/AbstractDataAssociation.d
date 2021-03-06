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
module flow.engine.impl.bpmn.data.AbstractDataAssociation;


import flow.common.api.deleg.Expression;
import flow.engine.deleg.DelegateExecution;

/**
 * A data association (Input or Output) between a source and a target
 *
 * @author Esteban Robles Luna
 */
abstract class AbstractDataAssociation {

    protected string source;

    protected Expression sourceExpression;

    protected string target;

    this(string source, string target) {
        this.source = source;
        this.target = target;
    }

    this(Expression sourceExpression, string target) {
        this.sourceExpression = sourceExpression;
        this.target = target;
    }

    abstract void evaluate(DelegateExecution execution);

    public string getSource() {
        return source;
    }

    public string getTarget() {
        return target;
    }

    public Expression getSourceExpression() {
        return sourceExpression;
    }
}
