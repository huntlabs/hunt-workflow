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
import hunt.collection.HashMap;
import hunt.collection.List;
import hunt.collection.Map;

import flow.engine.impl.persistence.entity.ExecutionEntity;
import flow.engine.test.impl.logger.DebugInfoExecutionTree.DebugInfoExecutionTreeNode;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

/**
 * @author jbarrez
 */
class ProcessExecutionLogger {

    private static final Logger LOGGER = LoggerFactory.getLogger(ProcessExecutionLogger.class);

    protected Map<string, List<DebugInfo>> debugInfoMap = new HashMap<>();

    // To avoid going to the db (and thus influencing process execution/tests), we store all encountered executions here,
    // to build up a tree representation with that information afterwards.
    protected Map<string, ExecutionEntity> createdExecutions = new HashMap<>();
    protected Map<string, ExecutionEntity> deletedExecutions = new HashMap<>();

    public ProcessExecutionLogger() {

    }

    public void addDebugInfo(AbstractDebugInfo debugInfo) {
        addDebugInfo(debugInfo, false);
    }

    public synchronized void addDebugInfo(AbstractDebugInfo debugInfo, bool generateExecutionTreeRepresentation) {

        // Store debug info
        string threadName = Thread.currentThread().getName();
        if (!debugInfoMap.containsKey(threadName)) {
            debugInfoMap.put(threadName, new ArrayList<>());
        }
        debugInfoMap.get(threadName).add(debugInfo);

        // Generate execution tree
        if (generateExecutionTreeRepresentation) {
            debugInfo.setExecutionTrees(generateExecutionTrees());
        }
    }

    protected List<DebugInfoExecutionTree> generateExecutionTrees() {

        // Gather information
        List<ExecutionEntity> processInstances = new ArrayList<>();
        Map<string, List<ExecutionEntity>> parentMapping = new HashMap<>();

        for (ExecutionEntity executionEntity : createdExecutions.values()) {
            if (!deletedExecutions.containsKey(executionEntity.getId())) {
                if (executionEntity.getParentId() is null) {
                    processInstances.add(executionEntity);
                } else {
                    if (!parentMapping.containsKey(executionEntity.getParentId())) {
                        parentMapping.put(executionEntity.getParentId(), new ArrayList<>());
                    }
                    parentMapping.get(executionEntity.getParentId()).add(executionEntity);
                }
            }
        }

        // Build tree representation
        List<DebugInfoExecutionTree> executionTrees = new ArrayList<>();
        for (ExecutionEntity processInstance : processInstances) {

            DebugInfoExecutionTree executionTree = new DebugInfoExecutionTree();
            executionTrees.add(executionTree);

            DebugInfoExecutionTreeNode rootNode = new DebugInfoExecutionTreeNode();
            executionTree.setProcessInstance(rootNode);
            rootNode.setId(processInstance.getId());

            internalPopulateExecutionTree(rootNode, parentMapping);
        }

        return executionTrees;
    }

    protected void internalPopulateExecutionTree(DebugInfoExecutionTreeNode parentNode, Map<string, List<ExecutionEntity>> parentMapping) {
        if (parentMapping.containsKey(parentNode.getId())) {
            for (ExecutionEntity childExecutionEntity : parentMapping.get(parentNode.getId())) {
                DebugInfoExecutionTreeNode childNode = new DebugInfoExecutionTreeNode();
                childNode.setId(childExecutionEntity.getId());
                childNode.setActivityId(childExecutionEntity.getCurrentFlowElement() !is null ? childExecutionEntity.getCurrentFlowElement().getId() : null);
                childNode.setActivityName(childExecutionEntity.getCurrentFlowElement() !is null ? childExecutionEntity.getCurrentFlowElement().getName() : null);
                childNode.setProcessDefinitionId(childExecutionEntity.getProcessDefinitionId());

                childNode.setParentNode(childNode);
                parentNode.getChildNodes().add(childNode);

                internalPopulateExecutionTree(childNode, parentMapping);
            }
        }
    }

    public void logDebugInfo() {
        logDebugInfo(false);
    }

    public void logDebugInfo(bool clearAfterLogging) {

        LOGGER.info("--------------------------------");
        LOGGER.info("CommandInvoker debug information");
        LOGGER.info("--------------------------------");
        for (string threadName : debugInfoMap.keySet()) {

            LOGGER.info("");
            LOGGER.info("Thread '{}':", threadName);
            LOGGER.info("");

            for (DebugInfo debugInfo : debugInfoMap.get(threadName)) {
                debugInfo.printOut(LOGGER);
            }

        }

        LOGGER.info("");

        if (clearAfterLogging) {
            clear();
        }
    }

    public void clear() {
        debugInfoMap.clear();
        createdExecutions.clear();
    }

    public void executionCreated(ExecutionEntity executionEntity) {
        createdExecutions.put(executionEntity.getId(), executionEntity);
    }

    public void executionDeleted(ExecutionEntity executionEntity) {
        deletedExecutions.put(executionEntity.getId(), executionEntity);
    }

}
