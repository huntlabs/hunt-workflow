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


import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

import com.fasterxml.jackson.annotation.JsonIgnore;

/**
 * @author Tijs Rademakers
 */
class FlowableListener extends BaseElement {

    protected string event;
    protected string implementationType;
    protected string implementation;
    protected List<FieldExtension> fieldExtensions = new ArrayList<>();
    protected string onTransaction;
    protected string customPropertiesResolverImplementationType;
    protected string customPropertiesResolverImplementation;

    @JsonIgnore
    protected Object instance; // Can be used to set an instance of the listener directly. That instance will then always be reused.
    
    public FlowableListener() {
        // Always generate a random identifier to look up the listener while executing the logic
        setId(UUID.randomUUID().toString());
    }

    public string getEvent() {
        return event;
    }

    public void setEvent(string event) {
        this.event = event;
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

    public List<FieldExtension> getFieldExtensions() {
        return fieldExtensions;
    }

    public void setFieldExtensions(List<FieldExtension> fieldExtensions) {
        this.fieldExtensions = fieldExtensions;
    }

    public string getOnTransaction() {
        return onTransaction;
    }

    public void setOnTransaction(string onTransaction) {
        this.onTransaction = onTransaction;
    }

    public string getCustomPropertiesResolverImplementationType() {
        return customPropertiesResolverImplementationType;
    }

    public void setCustomPropertiesResolverImplementationType(string customPropertiesResolverImplementationType) {
        this.customPropertiesResolverImplementationType = customPropertiesResolverImplementationType;
    }

    public string getCustomPropertiesResolverImplementation() {
        return customPropertiesResolverImplementation;
    }

    public void setCustomPropertiesResolverImplementation(string customPropertiesResolverImplementation) {
        this.customPropertiesResolverImplementation = customPropertiesResolverImplementation;
    }

    public Object getInstance() {
        return instance;
    }

    public void setInstance(Object instance) {
        this.instance = instance;
    }

    @Override
    public FlowableListener clone() {
        FlowableListener clone = new FlowableListener();
        clone.setValues(this);
        return clone;
    }

    public void setValues(FlowableListener otherListener) {
        setEvent(otherListener.getEvent());
        setImplementation(otherListener.getImplementation());
        setImplementationType(otherListener.getImplementationType());

        fieldExtensions = new ArrayList<>();
        if (otherListener.getFieldExtensions() != null && !otherListener.getFieldExtensions().isEmpty()) {
            for (FieldExtension extension : otherListener.getFieldExtensions()) {
                fieldExtensions.add(extension.clone());
            }
        }
    }
}
