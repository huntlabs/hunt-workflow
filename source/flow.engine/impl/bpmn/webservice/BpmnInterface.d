///* Licensed under the Apache License, Version 2.0 (the "License");
// * you may not use this file except in compliance with the License.
// * You may obtain a copy of the License at
// *
// *      http://www.apache.org/licenses/LICENSE-2.0
// *
// * Unless required by applicable law or agreed to in writing, software
// * distributed under the License is distributed on an "AS IS" BASIS,
// * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// * See the License for the specific language governing permissions and
// * limitations under the License.
// */
//
//
//import hunt.collection;
//import hunt.collection.HashMap;
//import hunt.collection.Map;
//
///**
// * An Interface defines a set of operations that are implemented by services external to the process.
// *
// * @author Joram Barrez
// */
//class BpmnInterface {
//
//    protected string id;
//
//    protected string name;
//
//    protected BpmnInterfaceImplementation implementation;
//
//    /**
//     * Mapping of the operations of this interface. The key of the map is the id of the operation, for easy retrieval.
//     */
//    protected Map!(string, Operation) operations = new HashMap<>();
//
//    public BpmnInterface() {
//
//    }
//
//    public BpmnInterface(string id, string name) {
//        setId(id);
//        setName(name);
//    }
//
//    public string getId() {
//        return id;
//    }
//
//    public void setId(string id) {
//        this.id = id;
//    }
//
//    public string getName() {
//        return name;
//    }
//
//    public void setName(string name) {
//        this.name = name;
//    }
//
//    public void addOperation(Operation operation) {
//        operations.put(operation.getId(), operation);
//    }
//
//    public Operation getOperation(string operationId) {
//        return operations.get(operationId);
//    }
//
//    public Collection!Operation getOperations() {
//        return operations.values();
//    }
//
//    public BpmnInterfaceImplementation getImplementation() {
//        return implementation;
//    }
//
//    public void setImplementation(BpmnInterfaceImplementation implementation) {
//        this.implementation = implementation;
//    }
//}
