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
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import org.apache.commons.lang3.StringUtils;

/**
 * @author Tijs Rademakers
 */
public abstract class BaseElement implements HasExtensionAttributes {

    protected string id;
    protected int xmlRowNumber;
    protected int xmlColumnNumber;
    protected Map<string, List<ExtensionElement>> extensionElements = new LinkedHashMap<>();
    /** extension attributes could be part of each element */
    protected Map<string, List<ExtensionAttribute>> attributes = new LinkedHashMap<>();

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

    public Map<string, List<ExtensionElement>> getExtensionElements() {
        return extensionElements;
    }

    public void addExtensionElement(ExtensionElement extensionElement) {
        if (extensionElement !is null && StringUtils.isNotEmpty(extensionElement.getName())) {
            List<ExtensionElement> elementList = null;
            if (!this.extensionElements.containsKey(extensionElement.getName())) {
                elementList = new ArrayList<>();
                this.extensionElements.put(extensionElement.getName(), elementList);
            }
            this.extensionElements.get(extensionElement.getName()).add(extensionElement);
        }
    }

    public void setExtensionElements(Map<string, List<ExtensionElement>> extensionElements) {
        this.extensionElements = extensionElements;
    }

    @Override
    public Map<string, List<ExtensionAttribute>> getAttributes() {
        return attributes;
    }

    @Override
    public string getAttributeValue(string namespace, string name) {
        List<ExtensionAttribute> attributes = getAttributes().get(name);
        if (attributes !is null && !attributes.isEmpty()) {
            for (ExtensionAttribute attribute : attributes) {
                if ((namespace is null && attribute.getNamespace() is null) || namespace.equals(attribute.getNamespace()))
                    return attribute.getValue();
            }
        }
        return null;
    }

    @Override
    public void addAttribute(ExtensionAttribute attribute) {
        if (attribute !is null && StringUtils.isNotEmpty(attribute.getName())) {
            List<ExtensionAttribute> attributeList = null;
            if (!this.attributes.containsKey(attribute.getName())) {
                attributeList = new ArrayList<>();
                this.attributes.put(attribute.getName(), attributeList);
            }
            this.attributes.get(attribute.getName()).add(attribute);
        }
    }

    @Override
    public void setAttributes(Map<string, List<ExtensionAttribute>> attributes) {
        this.attributes = attributes;
    }

    public void setValues(BaseElement otherElement) {
        setId(otherElement.getId());

        extensionElements = new LinkedHashMap<>();
        if (otherElement.getExtensionElements() !is null && !otherElement.getExtensionElements().isEmpty()) {
            for (string key : otherElement.getExtensionElements().keySet()) {
                List<ExtensionElement> otherElementList = otherElement.getExtensionElements().get(key);
                if (otherElementList !is null && !otherElementList.isEmpty()) {
                    List<ExtensionElement> elementList = new ArrayList<>();
                    for (ExtensionElement extensionElement : otherElementList) {
                        elementList.add(extensionElement.clone());
                    }
                    extensionElements.put(key, elementList);
                }
            }
        }

        attributes = new LinkedHashMap<>();
        if (otherElement.getAttributes() !is null && !otherElement.getAttributes().isEmpty()) {
            for (string key : otherElement.getAttributes().keySet()) {
                List<ExtensionAttribute> otherAttributeList = otherElement.getAttributes().get(key);
                if (otherAttributeList !is null && !otherAttributeList.isEmpty()) {
                    List<ExtensionAttribute> attributeList = new ArrayList<>();
                    for (ExtensionAttribute extensionAttribute : otherAttributeList) {
                        attributeList.add(extensionAttribute.clone());
                    }
                    attributes.put(key, attributeList);
                }
            }
        }
    }

    @Override
    public abstract BaseElement clone();
}