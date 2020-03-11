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

//          Copyright linsen 2020.
// Distributed under the Boost Software License, Version 1.0.
//    (See accompanying file LICENSE_1_0.txt or copy at
//          http://www.boost.org/LICENSE_1_0.txt)}

module flow.bpmn.model.AbstractFlowableHttpHandler;





//import com.fasterxml.jackson.annotation.JsonIgnore;
import flow.bpmn.model.BaseElement;
import hunt.collection.ArrayList;
import hunt.collection.List;
import flow.bpmn.model.FieldExtension;
/**
 * @author Tijs Rademakers
 */
abstract class AbstractFlowableHttpHandler : BaseElement {

    protected string implementationType;
    protected string implementation;
    protected List!FieldExtension fieldExtensions ;//= new ArrayList<>();

   // @JsonIgnore
    protected Object instance; // Can be used to set an instance of the listener directly. That instance will then always be reused.

    this()
    {
      fieldExtensions = new ArrayList!FieldExtension;
    }

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

    public List!FieldExtension getFieldExtensions() {
        return fieldExtensions;
    }

    public void setFieldExtensions(List!FieldExtension fieldExtensions) {
        this.fieldExtensions = fieldExtensions;
    }

    public Object getInstance() {
        return instance;
    }

    public void setInstance(Object instance) {
        this.instance = instance;
    }

    override
     AbstractFlowableHttpHandler clone()
     {

     }

    public void setValues(AbstractFlowableHttpHandler otherHandler) {
        setImplementation(otherHandler.getImplementation());
        setImplementationType(otherHandler.getImplementationType());

        fieldExtensions = new ArrayList!FieldExtension();
        if (otherHandler.getFieldExtensions() !is null && !otherHandler.getFieldExtensions().isEmpty()) {
            foreach (FieldExtension extension ; otherHandler.getFieldExtensions()) {
                fieldExtensions.add(extension.clone());
            }
        }
    }
}
