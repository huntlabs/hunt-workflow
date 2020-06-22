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
module flow.engine.impl.cmd.GetDataObjectCmd;


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
//import flow.engine.impl.context.BpmnOverrideContext;
import flow.engine.impl.persistence.entity.ExecutionEntity;
import flow.engine.impl.util.CommandContextUtil;
//import flow.engine.impl.util.Flowable5Util;
import flow.engine.impl.util.ProcessDefinitionUtil;
import flow.engine.runtime.DataObject;
import flow.engine.runtime.Execution;
import flow.variable.service.api.persistence.entity.VariableInstance;
import hunt.Exceptions;
//import com.fasterxml.jackson.databind.JsonNode;
//import com.fasterxml.jackson.databind.node.ObjectNode;

class GetDataObjectCmd : Command!DataObject {

    protected string executionId;
    protected string dataObjectName;
    protected bool isLocal;
    protected string locale;
    protected bool withLocalizationFallback;

    this(string executionId, string dataObjectName, bool isLocal) {
        this.executionId = executionId;
        this.dataObjectName = dataObjectName;
        this.isLocal = isLocal;
    }

    this(string executionId, string dataObjectName, bool isLocal, string locale, bool withLocalizationFallback) {
        this.executionId = executionId;
        this.dataObjectName = dataObjectName;
        this.isLocal = isLocal;
        this.locale = locale;
        this.withLocalizationFallback = withLocalizationFallback;
    }

    public DataObject execute(CommandContext commandContext) {
        if (executionId is null) {
            throw new FlowableIllegalArgumentException("executionId is null");
        }
        if (dataObjectName is null) {
            throw new FlowableIllegalArgumentException("dataObjectName is null");
        }

        ExecutionEntity execution = CommandContextUtil.getExecutionEntityManager(commandContext).findById(executionId);

        if (execution is null) {
            throw new FlowableObjectNotFoundException("execution " ~ executionId ~ " doesn't exist");
        }

        DataObject dataObject = null;

        VariableInstance variableEntity = null;
        //if (Flowable5Util.isFlowable5ProcessDefinitionId(commandContext, execution.getProcessDefinitionId())) {
        //    Flowable5CompatibilityHandler compatibilityHandler = Flowable5Util.getFlowable5CompatibilityHandler();
        //    variableEntity = compatibilityHandler.getExecutionVariableInstance(executionId, dataObjectName, isLocal);
        //
        //} else {
        //    if (isLocal) {
        //        variableEntity = execution.getVariableInstanceLocal(dataObjectName, false);
        //    } else {
        //        variableEntity = execution.getVariableInstance(dataObjectName, false);
        //    }
        //}

         if (isLocal) {
           variableEntity = execution.getVariableInstanceLocal(dataObjectName, false);
         } else {
           variableEntity = execution.getVariableInstance(dataObjectName, false);
         }

        string localizedName = null;
        string localizedDescription = null;

        if (variableEntity !is null) {
            ExecutionEntity executionEntity = CommandContextUtil.getExecutionEntityManager(commandContext).findById(variableEntity.getExecutionId());
            while (!executionEntity.isScope()) {
                executionEntity = executionEntity.getParent();
            }

            BpmnModel bpmnModel = ProcessDefinitionUtil.getBpmnModel(executionEntity.getProcessDefinitionId());
            ValuedDataObject foundDataObject = null;
            if (executionEntity.getParentId() is null) {
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
                //        execution.getProcessDefinitionId(), withLocalizationFallback);
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
                dataObject = new DataObjectImpl(variableEntity.getId(), variableEntity.getProcessInstanceId(), variableEntity.getExecutionId(),
                        variableEntity.getName(), variableEntity.getValue(), foundDataObject.getDocumentation(),
                        foundDataObject.getType(), localizedName, localizedDescription, foundDataObject.getId());
            }
        }

        return dataObject;
    }
}
