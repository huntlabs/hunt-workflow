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

module flow.bpmn.model.MultiInstanceLoopCharacteristics;
import flow.bpmn.model.BaseElement;
import flow.bpmn.model.CollectionHandler;

class MultiInstanceLoopCharacteristics : BaseElement {

    alias setValues = BaseElement.setValues;

    protected string inputDataItem;
    protected string collectionString;
    protected CollectionHandler collectionHandler;
    protected string loopCardinality;
    protected string completionCondition;
    protected string elementVariable;
    protected string elementIndexVariable;
    protected bool sequential;

    public string getInputDataItem() {
        return inputDataItem;
    }

    public void setInputDataItem(string inputDataItem) {
        this.inputDataItem = inputDataItem;
    }

    public string getCollectionString() {
        return collectionString;
    }

    public void setCollectionString(string collectionString) {
        this.collectionString = collectionString;
    }

    public CollectionHandler getHandler() {
		return collectionHandler;
	}

	public void setHandler(CollectionHandler collectionHandler) {
		this.collectionHandler = collectionHandler;
	}

	public string getLoopCardinality() {
        return loopCardinality;
    }

    public void setLoopCardinality(string loopCardinality) {
        this.loopCardinality = loopCardinality;
    }

    public string getCompletionCondition() {
        return completionCondition;
    }

    public void setCompletionCondition(string completionCondition) {
        this.completionCondition = completionCondition;
    }

    public string getElementVariable() {
        return elementVariable;
    }

    public void setElementVariable(string elementVariable) {
        this.elementVariable = elementVariable;
    }

    public string getElementIndexVariable() {
        return elementIndexVariable;
    }

    public void setElementIndexVariable(string elementIndexVariable) {
        this.elementIndexVariable = elementIndexVariable;
    }

    public bool isSequential() {
        return sequential;
    }

    public void setSequential(bool sequential) {
        this.sequential = sequential;
    }

    override
    public MultiInstanceLoopCharacteristics clone() {
        MultiInstanceLoopCharacteristics clone = new MultiInstanceLoopCharacteristics();
        clone.setValues(this);
        return clone;
    }

    public void setValues(MultiInstanceLoopCharacteristics otherLoopCharacteristics) {
        setInputDataItem(otherLoopCharacteristics.getInputDataItem());
        setCollectionString(otherLoopCharacteristics.getCollectionString());
        if (otherLoopCharacteristics.getHandler() !is null) {
        	setHandler(otherLoopCharacteristics.getHandler().clone());
        }
        setLoopCardinality(otherLoopCharacteristics.getLoopCardinality());
        setCompletionCondition(otherLoopCharacteristics.getCompletionCondition());
        setElementVariable(otherLoopCharacteristics.getElementVariable());
        setElementIndexVariable(otherLoopCharacteristics.getElementIndexVariable());
        setSequential(otherLoopCharacteristics.isSequential());
    }
}
