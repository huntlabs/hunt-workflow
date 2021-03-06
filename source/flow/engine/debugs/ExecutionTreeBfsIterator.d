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


//import java.util.Iterator;
//import hunt.collection.LinkedList;
//
///**
// * Iterates over an {@link ExecutionTree} using breadth-first search
// *
// * @author Joram Barrez
// */
//class ExecutionTreeBfsIterator implements Iterator!ExecutionTreeNode {
//
//    protected ExecutionTreeNode rootNode;
//    protected bool reverseOrder;
//
//    protected LinkedList!ExecutionTreeNode flattenedList;
//    protected Iterator!ExecutionTreeNode flattenedListIterator;
//
//    public ExecutionTreeBfsIterator(ExecutionTreeNode executionTree) {
//        this(executionTree, false);
//    }
//
//    public ExecutionTreeBfsIterator(ExecutionTreeNode rootNode, bool reverseOrder) {
//        this.rootNode = rootNode;
//        this.reverseOrder = reverseOrder;
//    }
//
//    protected void flattenTree() {
//        flattenedList = new LinkedList<>();
//
//        LinkedList!ExecutionTreeNode nodesToHandle = new LinkedList<>();
//        nodesToHandle.add(rootNode);
//        while (!nodesToHandle.isEmpty()) {
//
//            ExecutionTreeNode currentNode = nodesToHandle.pop();
//            if (reverseOrder) {
//                flattenedList.addFirst(currentNode);
//            } else {
//                flattenedList.add(currentNode);
//            }
//
//            if (currentNode.getChildren() !is null && currentNode.getChildren().size() > 0) {
//                nodesToHandle.addAll(currentNode.getChildren());
//            }
//        }
//
//        flattenedListIterator = flattenedList.iterator();
//    }
//
//    override
//    public bool hasNext() {
//        if (flattenedList is null) {
//            flattenTree();
//        }
//        return flattenedListIterator.hasNext();
//    }
//
//    override
//    public ExecutionTreeNode next() {
//        if (flattenedList is null) {
//            flattenTree();
//        }
//        return flattenedListIterator.next();
//    }
//
//    override
//    public void remove() {
//        if (flattenedList is null) {
//            flattenTree();
//        }
//        flattenedListIterator.remove();
//    }
//
//}
