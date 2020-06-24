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

module flow.bpmn.model.BaseElement;

import hunt.collection.ArrayList;
import hunt.collection.LinkedHashMap;
import hunt.collection.List;
import hunt.collection.Map;
import std.array;
import flow.bpmn.model.HasExtensionAttributes;
import flow.bpmn.model.ExtensionElement;
import flow.bpmn.model.ExtensionAttribute;
//import org.apache.commons.lang3.StringUtils;

/**
 * @author Tijs Rademakers
 */
abstract class BaseElement : HasExtensionAttributes {

    protected string id;
    protected int xmlRowNumber;
    protected int xmlColumnNumber;
    protected Map!(string, List!ExtensionElement) extensionElements ;//= new LinkedHashMap<>();
    /** extension attributes could be part of each element */
    protected Map!(string, List!ExtensionAttribute) attributes ;//= new LinkedHashMap<>();

    this()
    {
      extensionElements = new LinkedHashMap!(string, List!ExtensionElement)();
      attributes = new LinkedHashMap!(string, List!ExtensionAttribute);
    }

    public string getId() {
        return id;
    }

    public void setId(string id) {
        this.id = id;
    }

    public int getXmlRowNumber() {
        return xmlRowNumber;
    }

    public void setXmlRowNumber(int xmlRowNumber) {
        this.xmlRowNumber = xmlRowNumber;
    }

    public int getXmlColumnNumber() {
        return xmlColumnNumber;
    }

    public void setXmlColumnNumber(int xmlColumnNumber) {
        this.xmlColumnNumber = xmlColumnNumber;
    }

    public Map!(string, List!ExtensionElement) getExtensionElements() {
        return extensionElements;
    }

    public void addExtensionElement(ExtensionElement extensionElement) {
        if (extensionElement !is null && (extensionElement.getName() !is null && extensionElement.getName().length != 0)) {
            List!ExtensionElement elementList = null;
            if (!this.extensionElements.containsKey(extensionElement.getName())) {
                elementList = new ArrayList!ExtensionElement();
                this.extensionElements.put(extensionElement.getName(), elementList);
            }
            this.extensionElements.get(extensionElement.getName()).add(extensionElement);
        }
    }

    public void setExtensionElements(Map!(string, List!ExtensionElement) extensionElements) {
        this.extensionElements = extensionElements;
    }


    public Map!(string, List!ExtensionAttribute) getAttributes() {
        return attributes;
    }


    public string getAttributeValue(string namespace, string name) {
        List!ExtensionAttribute attributes = getAttributes().get(name);
        if (attributes !is null && !attributes.isEmpty()) {
            foreach (ExtensionAttribute attribute ; attributes) {
                if ((namespace is null && attribute.getNamespace() is null) || namespace == (attribute.getNamespace()))
                    return attribute.getValue();
            }
        }
        return null;
    }


    public void addAttribute(ExtensionAttribute attribute) {
        if (attribute !is null && (attribute.getName()!is null && attribute.getName().length != 0)) {
            List!ExtensionAttribute attributeList = null;
            if (!this.attributes.containsKey(attribute.getName())) {
                attributeList = new ArrayList!ExtensionAttribute();
                this.attributes.put(attribute.getName(), attributeList);
            }
            this.attributes.get(attribute.getName()).add(attribute);
        }
    }


    public void setAttributes(Map!(string, List!ExtensionAttribute) attributes) {
        this.attributes = attributes;
    }

    public void setValues(BaseElement otherElement) {
        setId(otherElement.getId());
        if (extensionElements is null)
        {
            extensionElements = new LinkedHashMap!(string, List!ExtensionElement)();
        }else
        {
            extensionElements.clear();
        }

        if (otherElement.getExtensionElements() !is null && !otherElement.getExtensionElements().isEmpty()) {
            foreach (string key ; otherElement.getExtensionElements().byKey().array) {
                List!ExtensionElement otherElementList = otherElement.getExtensionElements().get(key);
                if (otherElementList !is null && !otherElementList.isEmpty()) {
                    List!ExtensionElement elementList = new ArrayList!ExtensionElement();
                    foreach (ExtensionElement extensionElement ; otherElementList) {
                        elementList.add(extensionElement.clone());
                    }
                    extensionElements.put(key, elementList);
                }
            }
        }

        if (attributes is null)
        {
            attributes  = new LinkedHashMap!(string, List!ExtensionAttribute);
        }else
        {
            attributes.clear;
        }
        if (otherElement.getAttributes() !is null && !otherElement.getAttributes().isEmpty()) {
            foreach (string key ; otherElement.getAttributes().byKey().array) {
                List!ExtensionAttribute otherAttributeList = otherElement.getAttributes().get(key);
                if (otherAttributeList !is null && !otherAttributeList.isEmpty()) {
                    List!ExtensionAttribute attributeList = new ArrayList!ExtensionAttribute();
                    foreach (ExtensionAttribute extensionAttribute ; otherAttributeList) {
                        attributeList.add(extensionAttribute.clone());
                    }
                    attributes.put(key, attributeList);
                }
            }
        }
    }


     BaseElement clone(){
          return null;
     }
}
