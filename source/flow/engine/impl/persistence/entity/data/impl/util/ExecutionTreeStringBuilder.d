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
module flow.engine.impl.persistence.entity.data.impl.util.ExecutionTreeStringBuilder;

import hunt.collection.List;

import flow.engine.impl.persistence.entity.ExecutionEntity;
import hunt.util.StringBuilder;
/**
 * Prints a nicely tree-looking overview of the executions.
 *
 * @author jbarrez
 */
class ExecutionTreeStringBuilder {

    protected ExecutionEntity executionEntity;

    this(ExecutionEntity executionEntity) {
        this.executionEntity = executionEntity;
    }

    /* See http://stackoverflow.com/questions/4965335/how-to-print-binary-tree-diagram */
    override
     string toString() {
        StringBuilder strb = new StringBuilder();
        strb.append(executionEntity.getId()).append(" : ")
                .append(executionEntity.getActivityId())
                .append(", parent id ")
                .append(executionEntity.getParentId())
                .append("\r\n");

        List!ExecutionEntity children = executionEntity.getExecutionEntities();
        if (children !is null) {
            foreach (ExecutionEntity childExecution ; children) {
                internalToString(childExecution, strb, "", true);
            }
        }
        return strb.toString();
    }

    protected void internalToString(ExecutionEntity execution, StringBuilder strb, string prefix, bool isTail) {
        strb.append(prefix)
                .append(isTail ? "└── " : "├── ")
                .append(execution.getId()).append(" : ")
                .append("activityId=").append(execution.getActivityId())
                .append(", parent id ")
                .append(execution.getParentId())
                .append(execution.isScope() ? " (scope)" : "")
                .append(execution.isMultiInstanceRoot() ? " (multi instance root)" : "")
                .append("\r\n");

        List!ExecutionEntity children = executionEntity.getExecutionEntities();
        if (children !is null) {
            for (int i = 0; i < children.size() - 1; i++) {
                internalToString(children.get(i), strb, prefix ~ (isTail ? "    " : "│   "), false);
            }
            if (children.size() > 0) {
                internalToString(children.get(children.size() - 1), strb, prefix ~ (isTail ? "    " : "│   "), true);
            }
        }
    }

}
