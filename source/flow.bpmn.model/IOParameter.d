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

module flow.bpmn.model.IOParameter;

import flow.bpmn.model.BaseElement;
/**
 * @author Tijs Rademakers
 */
class IOParameter : BaseElement {
   alias setValues = BaseElement.setValues;
    protected string source;
    protected string sourceExpression;
    protected string target;
    protected string targetExpression;
    protected bool _isTransient;

    public string getSource() {
        return source;
    }

    public void setSource(string source) {
        this.source = source;
    }

    public string getTarget() {
        return target;
    }

    public void setTarget(string target) {
        this.target = target;
    }

    public string getSourceExpression() {
        return sourceExpression;
    }

    public void setSourceExpression(string sourceExpression) {
        this.sourceExpression = sourceExpression;
    }

    public string getTargetExpression() {
        return targetExpression;
    }

    public void setTargetExpression(string targetExpression) {
        this.targetExpression = targetExpression;
    }

    public bool isTransient() {
        return _isTransient;
    }

    public void setTransient(bool isTransient) {
        this._isTransient = isTransient;
    }

    override
    public IOParameter clone() {
        IOParameter clone = new IOParameter();
        clone.setValues(this);
        return clone;
    }

    public void setValues(IOParameter otherElement) {
        super.setValues(otherElement);
        setSource(otherElement.getSource());
        setSourceExpression(otherElement.getSourceExpression());
        setTarget(otherElement.getTarget());
        setTargetExpression(otherElement.getTargetExpression());
        setTransient(otherElement.isTransient());
    }
}
