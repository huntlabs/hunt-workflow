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

module flow.bpmn.model.CollectionHandler;
import flow.bpmn.model.BaseElement;

/**
 * @author Lori Small
 */
class CollectionHandler : BaseElement {

  alias setValues = BaseElement.setValues;

  protected string implementationType;
    protected string implementation;

    public string getImplementationType() {
        return implementationType;
    }

    public void setImplementationType(string implementationType) {
        this.implementationType = implementationType;
    }

    public string getImplementation() {
        return implementation;
    }

    public void setImplementation(string implementation) {
        this.implementation = implementation;
    }

    public void setValues(CollectionHandler otherParser) {
        super.setValues(otherParser);
        setImplementation(otherParser.getImplementation());
        setImplementationType(otherParser.getImplementationType());
    }

    override
    public CollectionHandler clone() {
    	CollectionHandler clone = new CollectionHandler();
        clone.setValues(this);
        return clone;
    }
}
