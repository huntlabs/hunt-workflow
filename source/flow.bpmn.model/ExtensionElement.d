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

module flow.bpmn.model.ExtensionElement;

import hunt.collection.ArrayList;
import hunt.collection.LinkedHashMap;
import hunt.collection.List;
import hunt.collection.Map;
import flow.bpmn.model.BaseElement;
import std.array;

//import org.apache.commons.lang3.StringUtils;

class ExtensionElement : BaseElement {

    alias setValues = BaseElement.setValues;

    protected string name;
    protected string namespacePrefix;
    protected string namespace;
    protected string elementText;
    protected Map!(string, List!ExtensionElement) childElements ;// = new LinkedHashMap<>();

    this()
    {
      childElements = new LinkedHashMap!(string, List!ExtensionElement);
    }

    public string getElementText() {
        return elementText;
    }

    public void setElementText(string elementText) {
        this.elementText = elementText;
    }

    public string getName() {
        return name;
    }

    public void setName(string name) {
        this.name = name;
    }

    public string getNamespacePrefix() {
        return namespacePrefix;
    }

    public void setNamespacePrefix(string namespacePrefix) {
        this.namespacePrefix = namespacePrefix;
    }

    public string getNamespace() {
        return namespace;
    }

    public void setNamespace(string namespace) {
        this.namespace = namespace;
    }

    public Map!(string, List!ExtensionElement) getChildElements() {
        return childElements;
    }

    public void addChildElement(ExtensionElement childElement) {
        if (childElement !is null && (childElement.getName() !is null && childElement.getName().length != 0)) {
            List!ExtensionElement elementList = null;
            if (!this.childElements.containsKey(childElement.getName())) {
                elementList = new ArrayList!ExtensionElement();
                this.childElements.put(childElement.getName(), elementList);
            }
            this.childElements.get(childElement.getName()).add(childElement);
        }
    }

    public void setChildElements(Map!(string, List!ExtensionElement) childElements) {
        this.childElements = childElements;
    }

    override
    public ExtensionElement clone() {
        ExtensionElement clone = new ExtensionElement();
        clone.setValues(this);
        return clone;
    }

    public void setValues(ExtensionElement otherElement) {
        setName(otherElement.getName());
        setNamespacePrefix(otherElement.getNamespacePrefix());
        setNamespace(otherElement.getNamespace());
        setElementText(otherElement.getElementText());
        setAttributes(otherElement.getAttributes());

        childElements = new LinkedHashMap!(string, List!ExtensionElement)();
        if (otherElement.getChildElements() !is null && !otherElement.getChildElements().isEmpty()) {
            foreach (string key ; otherElement.getChildElements().byKey().array) {
                List!ExtensionElement otherElementList = otherElement.getChildElements().get(key);
                if (otherElementList !is null && !otherElementList.isEmpty()) {
                    List!ExtensionElement elementList = new ArrayList!ExtensionElement();
                    foreach (ExtensionElement extensionElement ; otherElementList) {
                        elementList.add(extensionElement.clone());
                    }
                    childElements.put(key, elementList);
                }
            }
        }
    }
}
