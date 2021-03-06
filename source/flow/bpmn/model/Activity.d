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

module flow.bpmn.model.Activity;

import hunt.collection.ArrayList;
import hunt.collection.List;
import flow.bpmn.model.FlowNode;
import flow.bpmn.model.MultiInstanceLoopCharacteristics;
import flow.bpmn.model.IOSpecification;
import flow.bpmn.model.DataAssociation;
import flow.bpmn.model.BoundaryEvent;
import flow.bpmn.model.MapExceptionEntry;
import flow.bpmn.model.BaseElement;
import flow.bpmn.model.FlowElement;
/**
 * @author Tijs Rademakers
 */
abstract class Activity : FlowNode {

    protected string defaultFlow;
    protected bool forCompensation;
    protected MultiInstanceLoopCharacteristics loopCharacteristics;
    protected IOSpecification ioSpecification;
    protected List!DataAssociation dataInputAssociations ;//= new ArrayList<>();
    protected List!DataAssociation dataOutputAssociations ;// = new ArrayList<>();
    protected List!BoundaryEvent boundaryEvents ;//= new ArrayList<>();
    protected string failedJobRetryTimeCycleValue;
    protected List!MapExceptionEntry mapExceptions ;//= new ArrayList<>();

    alias setValues = FlowNode.setValues;
    alias setValues = BaseElement.setValues;
    alias setValues = FlowElement.setValues;
    this()
    {
        dataInputAssociations = new ArrayList!DataAssociation;
        dataOutputAssociations = new ArrayList!DataAssociation;
        boundaryEvents = new ArrayList!BoundaryEvent;
        mapExceptions = new ArrayList!MapExceptionEntry;
    }

    override
    string getClassType()
    {
      return "activity";
    }

    public string getFailedJobRetryTimeCycleValue() {
        return failedJobRetryTimeCycleValue;
    }

    public void setFailedJobRetryTimeCycleValue(string failedJobRetryTimeCycleValue) {
        this.failedJobRetryTimeCycleValue = failedJobRetryTimeCycleValue;
    }

    public bool isForCompensation() {
        return forCompensation;
    }

    public void setForCompensation(bool forCompensation) {
        this.forCompensation = forCompensation;
    }

    public List!BoundaryEvent getBoundaryEvents() {
        return boundaryEvents;
    }

    public void setBoundaryEvents(List!BoundaryEvent boundaryEvents) {
        this.boundaryEvents = boundaryEvents;
    }

    public string getDefaultFlow() {
        return defaultFlow;
    }

    public void setDefaultFlow(string defaultFlow) {
        this.defaultFlow = defaultFlow;
    }

    public MultiInstanceLoopCharacteristics getLoopCharacteristics() {
        return loopCharacteristics;
    }

    public void setLoopCharacteristics(MultiInstanceLoopCharacteristics loopCharacteristics) {
        this.loopCharacteristics = loopCharacteristics;
    }

    public bool hasMultiInstanceLoopCharacteristics() {
        return getLoopCharacteristics() !is null;
    }

    public IOSpecification getIoSpecification() {
        return ioSpecification;
    }

    public void setIoSpecification(IOSpecification ioSpecification) {
        this.ioSpecification = ioSpecification;
    }

    public List!DataAssociation getDataInputAssociations() {
        return dataInputAssociations;
    }

    public void setDataInputAssociations(List!DataAssociation dataInputAssociations) {
        this.dataInputAssociations = dataInputAssociations;
    }

    public List!DataAssociation getDataOutputAssociations() {
        return dataOutputAssociations;
    }

    public void setDataOutputAssociations(List!DataAssociation dataOutputAssociations) {
        this.dataOutputAssociations = dataOutputAssociations;
    }

    public List!MapExceptionEntry getMapExceptions() {
        return mapExceptions;
    }

    public void setMapExceptions(List!MapExceptionEntry mapExceptions) {
        this.mapExceptions = mapExceptions;
    }

    public void setValues(Activity otherActivity) {
        super.setValues(otherActivity);
        setFailedJobRetryTimeCycleValue(otherActivity.getFailedJobRetryTimeCycleValue());
        setDefaultFlow(otherActivity.getDefaultFlow());
        setForCompensation(otherActivity.isForCompensation());
        if (otherActivity.getLoopCharacteristics() !is null) {
            setLoopCharacteristics(otherActivity.getLoopCharacteristics().clone());
        }
        if (otherActivity.getIoSpecification() !is null) {
            setIoSpecification(otherActivity.getIoSpecification().clone());
        }

        dataInputAssociations = new ArrayList!DataAssociation();
        if (otherActivity.getDataInputAssociations() !is null && !otherActivity.getDataInputAssociations().isEmpty()) {
            foreach (DataAssociation association ; otherActivity.getDataInputAssociations()) {
                dataInputAssociations.add(association.clone());
            }
        }

        dataOutputAssociations = new ArrayList!DataAssociation();
        if (otherActivity.getDataOutputAssociations() !is null && !otherActivity.getDataOutputAssociations().isEmpty()) {
            foreach (DataAssociation association ; otherActivity.getDataOutputAssociations()) {
                dataOutputAssociations.add(association.clone());
            }
        }

        boundaryEvents.clear();
        boundaryEvents.addAll(otherActivity.getBoundaryEvents());
    }
}
