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
import hunt.collection;
import hunt.collection.HashMap;
import hunt.collection.Map;
import java.util.Map.Entry;

import flow.bpmn.model.BpmnModel;
import flow.bpmn.model.SubProcess;
import flow.bpmn.model.ValuedDataObject;
import flow.common.api.FlowableIllegalArgumentException;
import flow.common.api.FlowableObjectNotFoundException;
import flow.common.interceptor.Command;
import flow.common.interceptor.CommandContext;
import flow.engine.DynamicBpmnConstants;
import flow.engine.compatibility.Flowable5CompatibilityHandler;
import flow.engine.impl.DataObjectImpl;
import flow.engine.impl.context.BpmnOverrideContext;
import flow.engine.impl.persistence.entity.ExecutionEntity;
import flow.engine.impl.util.CommandContextUtil;
import flow.engine.impl.util.Flowable5Util;
import flow.engine.impl.util.ProcessDefinitionUtil;
import flow.engine.runtime.DataObject;
import flow.engine.runtime.Execution;
import org.flowable.variable.api.persistence.entity.VariableInstance;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.node.ObjectNode;

class GetDataObjectsCmd implements Command<Map<string, DataObject>>, Serializable {

    private static final long serialVersionUID = 1L;
    protected string executionId;
    protected Collection!string dataObjectNames;
    protected bool isLocal;
    protected string locale;
    protected bool withLocalizationFallback;

    public GetDataObjectsCmd(string executionId, Collection!string dataObjectNames, bool isLocal) {
        this.executionId = executionId;
        this.dataObjectNames = dataObjectNames;
        this.isLocal = isLocal;
    }

    public GetDataObjectsCmd(string executionId, Collection!string dataObjectNames, bool isLocal, string locale, bool withLocalizationFallback) {
        this.executionId = executionId;
        this.dataObjectNames = dataObjectNames;
        this.isLocal = isLocal;
        this.locale = locale;
        this.withLocalizationFallback = withLocalizationFallback;
    }

    @Override
    public Map<string, DataObject> execute(CommandContext commandContext) {

        // Verify existence of execution
        if (executionId is null) {
            throw new FlowableIllegalArgumentException("executionId is null");
        }

        ExecutionEntity execution = CommandContextUtil.getExecutionEntityManager(commandContext).findById(executionId);

        if (execution is null) {
            throw new FlowableObjectNotFoundException("execution " + executionId + " doesn't exist", Execution.class);
        }

        Map<string, VariableInstance> variables = null;

        if (Flowable5Util.isFlowable5ProcessDefinitionId(commandContext, execution.getProcessDefinitionId())) {
            Flowable5CompatibilityHandler compatibilityHandler = Flowable5Util.getFlowable5CompatibilityHandler();
            variables = compatibilityHandler.getExecutionVariableInstances(executionId, dataObjectNames, isLocal);

        } else {

            if (dataObjectNames is null || dataObjectNames.isEmpty()) {
                // Fetch all
                if (isLocal) {
                    variables = execution.getVariableInstancesLocal();
                } else {
                    variables = execution.getVariableInstances();
                }

            } else {
                // Fetch specific collection of variables
                if (isLocal) {
                    variables = execution.getVariableInstancesLocal(dataObjectNames, false);
                } else {
                    variables = execution.getVariableInstances(dataObjectNames, false);
                }
            }
        }

        Map<string, DataObject> dataObjects = null;
        if (variables !is null) {
            dataObjects = new HashMap<>(variables.size());

            for (Entry<string, VariableInstance> entry : variables.entrySet()) {
                string name = entry.getKey();
                VariableInstance variableEntity = entry.getValue();

                ExecutionEntity executionEntity = CommandContextUtil.getExecutionEntityManager(commandContext).findById(variableEntity.getExecutionId());
                while (!executionEntity.isScope()) {
                    executionEntity = executionEntity.getParent();
                }

                BpmnModel bpmnModel = ProcessDefinitionUtil.getBpmnModel(execution.getProcessDefinitionId());
                ValuedDataObject foundDataObject = null;
                if (executionEntity.getParentId() is null) {
                    for (ValuedDataObject dataObject : bpmnModel.getMainProcess().getDataObjects()) {
                        if (dataObject.getName().equals(variableEntity.getName())) {
                            foundDataObject = dataObject;
                            break;
                        }
                    }
                } else {
                    SubProcess subProcess = (SubProcess) bpmnModel.getFlowElement(executionEntity.getActivityId());
                    for (ValuedDataObject dataObject : subProcess.getDataObjects()) {
                        if (dataObject.getName().equals(variableEntity.getName())) {
                            foundDataObject = dataObject;
                            break;
                        }
                    }
                }

                string localizedName = null;
                string localizedDescription = null;

                if (locale !is null && foundDataObject !is null) {
                    ObjectNode languageNode = BpmnOverrideContext.getLocalizationElementProperties(locale, foundDataObject.getId(),
                            execution.getProcessDefinitionId(), withLocalizationFallback);

                    if (languageNode !is null) {
                        JsonNode nameNode = languageNode.get(DynamicBpmnConstants.LOCALIZATION_NAME);
                        if (nameNode !is null) {
                            localizedName = nameNode.asText();
                        }
                        JsonNode descriptionNode = languageNode.get(DynamicBpmnConstants.LOCALIZATION_DESCRIPTION);
                        if (descriptionNode !is null) {
                            localizedDescription = descriptionNode.asText();
                        }
                    }
                }

                if (foundDataObject !is null) {
                    dataObjects.put(name, new DataObjectImpl(variableEntity.getId(), variableEntity.getProcessInstanceId(),
                            variableEntity.getExecutionId(), variableEntity.getName(), variableEntity.getValue(),
                            foundDataObject.getDocumentation(), foundDataObject.getType(), localizedName,
                            localizedDescription, foundDataObject.getId()));
                }
            }
        }

        return dataObjects;
    }
}
