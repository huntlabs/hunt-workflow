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


/**
 * Element for defining an event listener to hook in to the global event-mechanism.
 *
 * @author Frederik Heremans
 * @author Joram Barrez
 */

module flow.bpmn.model.EventListener;

import flow.bpmn.model.BaseElement;

class EventListener : BaseElement {

    protected string events;
    protected string implementationType;
    protected string implementation;
    protected string entityType;
    protected string onTransaction;

    public string getEvents() {
        return events;
    }

    public void setEvents(string events) {
        this.events = events;
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

    public void setEntityType(string entityType) {
        this.entityType = entityType;
    }

    public string getEntityType() {
        return entityType;
    }

    public string getOnTransaction() {
        return onTransaction;
    }

    public void setOnTransaction(string onTransaction) {
        this.onTransaction = onTransaction;
    }

    override
    public EventListener clone() {
        EventListener clone = new EventListener();
        clone.setValues(this);
        return clone;
    }

    public void setValues(EventListener otherListener) {
        setEvents(otherListener.getEvents());
        setImplementation(otherListener.getImplementation());
        setImplementationType(otherListener.getImplementationType());
        setEntityType(otherListener.getEntityType());
        setOnTransaction(otherListener.getOnTransaction());
    }
}
