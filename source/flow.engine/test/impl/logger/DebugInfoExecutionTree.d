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


import hunt.collection.ArrayList;
import hunt.collection.List;

import org.slf4j.Logger;

/**
 * @author jbarrez
 */
class DebugInfoExecutionTree {

    protected DebugInfoExecutionTreeNode processInstance;

    public DebugInfoExecutionTreeNode getProcessInstance() {
        return processInstance;
    }

    public void setProcessInstance(DebugInfoExecutionTreeNode processInstance) {
        this.processInstance = processInstance;
    }

    public static class DebugInfoExecutionTreeNode {

        protected string id;
        protected string processDefinitionId;
        protected string activityId;
        protected string activityName;
        protected DebugInfoExecutionTreeNode parentNode;
        protected List<DebugInfoExecutionTreeNode> childNodes = new ArrayList<>();

        /* See http://stackoverflow.com/questions/4965335/how-to-print-binary-tree-diagram */
        public void print(Logger logger) {
            logger.info("");
            logger.info(id);
            for (DebugInfoExecutionTreeNode childNode : childNodes) {
                childNode.print(logger, "", true);
            }
            logger.info("");
        }

        protected void print(Logger logger, string prefix, bool isTail) {
            logger.info("{}{}{}", prefix, isTail ? "└── " : "├── ", getCurrentFlowElementInfo());
            for (int i = 0; i < childNodes.size() - 1; i++) {
                childNodes.get(i).print(logger, prefix + (isTail ? "    " : "│   "), false);
            }
            if (childNodes.size() > 0) {
                childNodes.get(childNodes.size() - 1).print(logger, prefix + (isTail ? "    " : "│   "), true);
            }
        }

        protected string getCurrentFlowElementInfo() {
            StringBuilder strb = new StringBuilder(30);
            strb.append(id);

            if (activityId !is null || activityName !is null) {
                strb.append(" in flow element ");

                if (activityId !is null) {
                    strb.append("'").append(activityId).append("'");
                }

                if (activityName !is null) {
                    strb.append(" with name ").append(activityName);
                }

            }

            return strb.toString();
        }

        public string getId() {
            return id;
        }

        public void setId(string id) {
            this.id = id;
        }

        public string getProcessDefinitionId() {
            return processDefinitionId;
        }

        public void setProcessDefinitionId(string processDefinitionId) {
            this.processDefinitionId = processDefinitionId;
        }

        public string getActivityId() {
            return activityId;
        }

        public void setActivityId(string activityId) {
            this.activityId = activityId;
        }

        public string getActivityName() {
            return activityName;
        }

        public void setActivityName(string activityName) {
            this.activityName = activityName;
        }

        public DebugInfoExecutionTreeNode getParentNode() {
            return parentNode;
        }

        public void setParentNode(DebugInfoExecutionTreeNode parentNode) {
            this.parentNode = parentNode;
        }

        public List<DebugInfoExecutionTreeNode> getChildNodes() {
            return childNodes;
        }

        public void setChildNodes(List<DebugInfoExecutionTreeNode> childNodes) {
            this.childNodes = childNodes;
        }

    }

}
