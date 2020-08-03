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

module flow.bpmn.model.FlowElement;

import hunt.collection.ArrayList;
import hunt.collection.List;
import flow.bpmn.model.BaseElement;
import flow.bpmn.model.HasExecutionListeners;
import flow.bpmn.model.FlowableListener;
import flow.bpmn.model.FlowElementsContainer;
import flow.bpmn.model.SubProcess;

//import com.fasterxml.jackson.annotation.JsonIgnore;

/**
 * @author Tijs Rademakers
 */
abstract class FlowElement : BaseElement , HasExecutionListeners {

    alias setValues = BaseElement.setValues;
    protected string name;
    protected string documentation;
    protected List!FlowableListener executionListeners ;// = new ArrayList<>();
    protected FlowElementsContainer parentContainer;

    this()
    {
      executionListeners = new ArrayList!FlowableListener;
    }

    public string getName() {
        return name;
    }

    public void setName(string name) {
        this.name = name;
    }

    public string getDocumentation() {
        return documentation;
    }

    public void setDocumentation(string documentation) {
        this.documentation = documentation;
    }

    //@Override
    public List!FlowableListener getExecutionListeners() {
        return executionListeners;
    }

    //@Override
    public void setExecutionListeners(List!FlowableListener executionListeners) {
        this.executionListeners = executionListeners;
    }

   // @JsonIgnore
    public FlowElementsContainer getParentContainer() {
        return parentContainer;
    }

   // @JsonIgnore
    public SubProcess getSubProcess() {
        SubProcess subProcess = null;
        //if (parentContainer instanceof SubProcess) {
        subProcess = cast(SubProcess) parentContainer;
        //}

        return subProcess;
    }

    public void setParentContainer(FlowElementsContainer parentContainer) {
        this.parentContainer = parentContainer;
    }

    override
     FlowElement clone()
    {
        return null;
    }

    public void setValues(FlowElement otherElement) {
        super.setValues(otherElement);
        setName(otherElement.getName());
        setDocumentation(otherElement.getDocumentation());

        executionListeners = new ArrayList!FlowableListener();
        if (otherElement.getExecutionListeners() !is null && !otherElement.getExecutionListeners().isEmpty()) {
            foreach (FlowableListener listener ; otherElement.getExecutionListeners()) {
                executionListeners.add(listener.clone());
            }
        }
    }

    string getClassType()
    {
        return "";
    }
}
