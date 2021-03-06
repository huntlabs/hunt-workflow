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

module flow.bpmn.model.ExtensionAttribute;

class ExtensionAttribute {

    protected string name;
    protected string value;
    protected string namespacePrefix;
    protected string namespace;

    this() {
    }

    this(string name) {
        this.name = name;
    }

    public string getName() {
        return name;
    }

    public void setName(string name) {
        this.name = name;
    }

    public string getValue() {
        return value;
    }

    public void setValue(string value) {
        this.value = value;
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

    override
    public string toString() {
        string sb;
        if (namespacePrefix !is null) {
            sb ~= (namespacePrefix);
            if (name !is null)
                sb  = sb ~ ":" ~ name;
        } else
            sb ~= name;
        if (value !is null)
            sb = sb ~ "=" ~ value;
        return sb;
    }

    public ExtensionAttribute clone() {
        ExtensionAttribute clone = new ExtensionAttribute();
        clone.setValues(this);
        return clone;
    }

    public void setValues(ExtensionAttribute otherAttribute) {
        setName(otherAttribute.getName());
        setValue(otherAttribute.getValue());
        setNamespacePrefix(otherAttribute.getNamespacePrefix());
        setNamespace(otherAttribute.getNamespace());
    }
}
