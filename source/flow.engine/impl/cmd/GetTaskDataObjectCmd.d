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
module flow.engine.impl.cmd.GetTaskDataObjectCmd;



import flow.bpmn.model.BpmnModel;
import flow.bpmn.model.SubProcess;
import flow.bpmn.model.ValuedDataObject;
import flow.common.api.FlowableIllegalArgumentException;
import flow.common.api.FlowableObjectNotFoundException;
import flow.common.interceptor.Command;
import flow.common.interceptor.CommandContext;
import flow.engine.DynamicBpmnConstants;
import flow.engine.impl.DataObjectImpl;
//import flow.engine.impl.context.BpmnOverrideContext;
import flow.engine.impl.persistence.entity.ExecutionEntity;
import flow.engine.impl.util.CommandContextUtil;
import flow.engine.impl.util.ProcessDefinitionUtil;
import flow.engine.runtime.DataObject;
import flow.task.api.Task;
import flow.task.service.impl.persistence.entity.TaskEntity;
import flow.variable.service.api.persistence.entity.VariableInstance;
import hunt.Exceptions;
//import com.fasterxml.jackson.databind.JsonNode;
//import com.fasterxml.jackson.databind.node.ObjectNode;

class GetTaskDataObjectCmd : Command!DataObject {

    protected string taskId;
    protected string variableName;
    protected string locale;
    protected bool withLocalizationFallback;

    this(string taskId, string variableName) {
        this.taskId = taskId;
        this.variableName = variableName;
    }

    this(string taskId, string variableName, string locale, bool withLocalizationFallback) {
        this.taskId = taskId;
        this.variableName = variableName;
        this.locale = locale;
        this.withLocalizationFallback = withLocalizationFallback;
    }

    public DataObject execute(CommandContext commandContext) {
        if (taskId is null) {
            throw new FlowableIllegalArgumentException("taskId is null");
        }
        if (variableName is null) {
            throw new FlowableIllegalArgumentException("variableName is null");
        }

        TaskEntity task = CommandContextUtil.getTaskService().getTask(taskId);

        if (task is null) {
            throw new FlowableObjectNotFoundException("task " ~ taskId ~ " doesn't exist");
        }

        DataObject dataObject = null;
        VariableInstance variableEntity = task.getVariableInstance(variableName, false);

        string localizedName = null;
        string localizedDescription = null;

        if (variableEntity !is null) {
            ExecutionEntity executionEntity = CommandContextUtil.getExecutionEntityManager(commandContext).findById(variableEntity.getExecutionId());
            while (!executionEntity.isScope()) {
                executionEntity = executionEntity.getParent();
            }

            BpmnModel bpmnModel = ProcessDefinitionUtil.getBpmnModel(executionEntity.getProcessDefinitionId());
            ValuedDataObject foundDataObject = null;
            if (executionEntity.getParentId() is null || executionEntity.getParentId().length == 0) {
                foreach (ValuedDataObject dataObjectDefinition ; bpmnModel.getMainProcess().getDataObjects()) {
                    if (dataObjectDefinition.getName() == (variableEntity.getName())) {
                        foundDataObject = dataObjectDefinition;
                        break;
                    }
                }
            } else {
                SubProcess subProcess = cast(SubProcess) bpmnModel.getFlowElement(executionEntity.getActivityId());
                foreach (ValuedDataObject dataObjectDefinition ; subProcess.getDataObjects()) {
                    if (dataObjectDefinition.getName() == (variableEntity.getName())) {
                        foundDataObject = dataObjectDefinition;
                        break;
                    }
                }
            }

            if (locale !is null && foundDataObject !is null) {
                implementationMissing(false);
                //ObjectNode languageNode = BpmnOverrideContext.getLocalizationElementProperties(locale, foundDataObject.getId(),
                //        task.getProcessDefinitionId(), withLocalizationFallback);
                //
                //if (languageNode !is null) {
                //    JsonNode nameNode = languageNode.get(DynamicBpmnConstants.LOCALIZATION_NAME);
                //    if (nameNode !is null) {
                //        localizedName = nameNode.asText();
                //    }
                //    JsonNode descriptionNode = languageNode.get(DynamicBpmnConstants.LOCALIZATION_DESCRIPTION);
                //    if (descriptionNode !is null) {
                //        localizedDescription = descriptionNode.asText();
                //    }
                //}
            }

            if (foundDataObject !is null) {
                dataObject = new DataObjectImpl(variableEntity.getId(), variableEntity.getProcessInstanceId(),
                        variableEntity.getExecutionId(),
                        variableEntity.getName(), variableEntity.getValue(), foundDataObject.getDocumentation(),
                        foundDataObject.getType(), localizedName, localizedDescription, foundDataObject.getId());
            }
        }

        return dataObject;
    }
}
