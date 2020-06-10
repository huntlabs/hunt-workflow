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

module flow.engine.impl.bpmn.parser.FieldDeclaration;


/**
 * Represents a field declaration in object form:
 *
 * &lt;field name='someField&gt; &lt;string ...
 *
 * @author Joram Barrez
 * @author Frederik Heremans
 */
class FieldDeclaration {

    protected string name;
    protected string type;
    protected Object value;

    this(string name, string type, Object value) {
        this.name = name;
        this.type = type;
        this.value = value;
    }

    this() {

    }

    public string getName() {
        return name;
    }

    public void setName(string name) {
        this.name = name;
    }

    public string getType() {
        return type;
    }

    public void setType(string type) {
        this.type = type;
    }

    public Object getValue() {
        return value;
    }

    public void setValue(Object value) {
        this.value = value;
    }

}
