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

import org.flowable.bpmn.model.BpmnModel;
import org.flowable.bpmn.model.SubProcess;
import org.flowable.bpmn.model.ValuedDataObject;
import flow.common.api.FlowableIllegalArgumentException;
import flow.common.api.FlowableObjectNotFoundException;
import flow.common.interceptor.Command;
import flow.common.interceptor.CommandContext;
import flow.engine.DynamicBpmnConstants;
import flow.engine.impl.DataObjectImpl;
import flow.engine.impl.context.BpmnOverrideContext;
import flow.engine.impl.persistence.entity.ExecutionEntity;
import flow.engine.impl.util.CommandContextUtil;
import flow.engine.impl.util.ProcessDefinitionUtil;
import flow.engine.runtime.DataObject;
import org.flowable.task.api.Task;
import org.flowable.task.service.impl.persistence.entity.TaskEntity;
import org.flowable.variable.api.persistence.entity.VariableInstance;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.node.ObjectNode;

class GetTaskDataObjectCmd implements Command<DataObject>, Serializable {

    private static final long serialVersionUID = 1L;
    protected string taskId;
    protected string variableName;
    protected string locale;
    protected bool withLocalizationFallback;

    public GetTaskDataObjectCmd(string taskId, string variableName) {
        this.taskId = taskId;
        this.variableName = variableName;
    }

    public GetTaskDataObjectCmd(string taskId, string variableName, string locale, bool withLocalizationFallback) {
        this.taskId = taskId;
        this.variableName = variableName;
        this.locale = locale;
        this.withLocalizationFallback = withLocalizationFallback;
    }

    @Override
    public DataObject execute(CommandContext commandContext) {
        if (taskId == null) {
            throw new FlowableIllegalArgumentException("taskId is null");
        }
        if (variableName == null) {
            throw new FlowableIllegalArgumentException("variableName is null");
        }

        TaskEntity task = CommandContextUtil.getTaskService().getTask(taskId);

        if (task == null) {
            throw new FlowableObjectNotFoundException("task " + taskId + " doesn't exist", Task.class);
        }

        DataObject dataObject = null;
        VariableInstance variableEntity = task.getVariableInstance(variableName, false);

        string localizedName = null;
        string localizedDescription = null;

        if (variableEntity != null) {
            ExecutionEntity executionEntity = CommandContextUtil.getExecutionEntityManager(commandContext).findById(variableEntity.getExecutionId());
            while (!executionEntity.isScope()) {
                executionEntity = executionEntity.getParent();
            }

            BpmnModel bpmnModel = ProcessDefinitionUtil.getBpmnModel(executionEntity.getProcessDefinitionId());
            ValuedDataObject foundDataObject = null;
            if (executionEntity.getParentId() == null) {
                for (ValuedDataObject dataObjectDefinition : bpmnModel.getMainProcess().getDataObjects()) {
                    if (dataObjectDefinition.getName().equals(variableEntity.getName())) {
                        foundDataObject = dataObjectDefinition;
                        break;
                    }
                }
            } else {
                SubProcess subProcess = (SubProcess) bpmnModel.getFlowElement(executionEntity.getActivityId());
                for (ValuedDataObject dataObjectDefinition : subProcess.getDataObjects()) {
                    if (dataObjectDefinition.getName().equals(variableEntity.getName())) {
                        foundDataObject = dataObjectDefinition;
                        break;
                    }
                }
            }

            if (locale != null && foundDataObject != null) {
                ObjectNode languageNode = BpmnOverrideContext.getLocalizationElementProperties(locale, foundDataObject.getId(),
                        task.getProcessDefinitionId(), withLocalizationFallback);

                if (languageNode != null) {
                    JsonNode nameNode = languageNode.get(DynamicBpmnConstants.LOCALIZATION_NAME);
                    if (nameNode != null) {
                        localizedName = nameNode.asText();
                    }
                    JsonNode descriptionNode = languageNode.get(DynamicBpmnConstants.LOCALIZATION_DESCRIPTION);
                    if (descriptionNode != null) {
                        localizedDescription = descriptionNode.asText();
                    }
                }
            }

            if (foundDataObject != null) {
                dataObject = new DataObjectImpl(variableEntity.getId(), variableEntity.getProcessInstanceId(),
                        variableEntity.getExecutionId(),
                        variableEntity.getName(), variableEntity.getValue(), foundDataObject.getDocumentation(),
                        foundDataObject.getType(), localizedName, localizedDescription, foundDataObject.getId());
            }
        }

        return dataObject;
    }
}
