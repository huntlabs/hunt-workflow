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

//          Copyright linse 2020.
// Distributed under the Boost Software License, Version 1.0.
//    (See accompanying file LICENSE_1_0.txt or copy at
//          http://www.boost.org/LICENSE_1_0.txt)}

module flow.engine.repository.DiagramLayout;





//import java.io.Serializable;
//import hunt.collection.ArrayList;
//import hunt.collection.List;
//import hunt.collection.Map;
//import java.util.Map.Entry;
//
///**
// * Stores a two-dimensional graph layout.
// *
// * @author Falko Menge
// */
//class DiagramLayout implements Serializable {
//
//    private static final long serialVersionUID = 1L;
//
//    private Map!(string, DiagramElement) elements;
//
//    public DiagramLayout(Map!(string, DiagramElement) elements) {
//        this.setElements(elements);
//    }
//
//    public DiagramNode getNode(string id) {
//        DiagramElement element = getElements().get(id);
//        if (element instanceof DiagramNode) {
//            return (DiagramNode) element;
//        } else {
//            return null;
//        }
//    }
//
//    public DiagramEdge getEdge(string id) {
//        DiagramElement element = getElements().get(id);
//        if (element instanceof DiagramEdge) {
//            return (DiagramEdge) element;
//        } else {
//            return null;
//        }
//    }
//
//    public Map!(string, DiagramElement) getElements() {
//        return elements;
//    }
//
//    public void setElements(Map!(string, DiagramElement) elements) {
//        this.elements = elements;
//    }
//
//    public List!DiagramNode getNodes() {
//        List!DiagramNode nodes = new ArrayList<>();
//        for (Entry!(string, DiagramElement) entry : getElements().entrySet()) {
//            DiagramElement element = entry.getValue();
//            if (element instanceof DiagramNode) {
//                nodes.add((DiagramNode) element);
//            }
//        }
//        return nodes;
//    }
//
//}
