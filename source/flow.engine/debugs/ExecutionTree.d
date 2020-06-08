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

//
//import java.util.Iterator;
//import hunt.collection.List;
//
//import flow.engine.impl.persistence.entity.ExecutionEntity;
//
///**
// * @author Joram Barrez
// */
//class ExecutionTree implements Iterable!ExecutionTreeNode {
//
//    protected ExecutionTreeNode root;
//
//    public ExecutionTree() {
//
//    }
//
//    public ExecutionTreeNode getRoot() {
//        return root;
//    }
//
//    public void setRoot(ExecutionTreeNode root) {
//        this.root = root;
//    }
//
//    /**
//     * Looks up the {@link ExecutionEntity} for a given id.
//     */
//    public ExecutionTreeNode getTreeNode(string executionId) {
//        return getTreeNode(executionId, root);
//    }
//
//    protected ExecutionTreeNode getTreeNode(string executionId, ExecutionTreeNode currentNode) {
//        if (currentNode.getExecutionEntity().getId().equals(executionId)) {
//            return currentNode;
//        }
//
//        List!ExecutionTreeNode children = currentNode.getChildren();
//        if (currentNode.getChildren() !is null && children.size() > 0) {
//            int index = 0;
//            while (index < children.size()) {
//                ExecutionTreeNode result = getTreeNode(executionId, children.get(index));
//                if (result !is null) {
//                    return result;
//                }
//                index++;
//            }
//        }
//
//        return null;
//    }
//
//    override
//    public Iterator!ExecutionTreeNode iterator() {
//        return new ExecutionTreeBfsIterator(this.getRoot());
//    }
//
//    public ExecutionTreeBfsIterator bfsIterator() {
//        return new ExecutionTreeBfsIterator(this.getRoot());
//    }
//
//    /**
//     * Uses an {@link ExecutionTreeBfsIterator}, but returns the leafs first (so flipped order of BFS)
//     */
//    public ExecutionTreeBfsIterator leafsFirstIterator() {
//        return new ExecutionTreeBfsIterator(this.getRoot(), true);
//    }
//
//    override
//    public string toString() {
//        return root !is null ? root.toString() : "";
//    }
//
//}
