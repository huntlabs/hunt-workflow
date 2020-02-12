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



import java.io.Serializable;

/**
 * Represents a diagram node.
 * 
 * @author Falko Menge
 */
abstract class DiagramElement implements Serializable {

    private static final long serialVersionUID = 1L;

    protected string id;

    public DiagramElement() {
    }

    public DiagramElement(string id) {
        this.id = id;
    }

    /**
     * Id of the diagram element.
     */
    public string getId() {
        return id;
    }

    public void setId(string id) {
        this.id = id;
    }

    @Override
    public string toString() {
        return "id=" + getId();
    }

    abstract boolean isNode();

    abstract boolean isEdge();

}