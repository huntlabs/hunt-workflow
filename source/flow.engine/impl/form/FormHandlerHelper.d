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
module flow.engine.impl.form.FormHandlerHelper;

import hunt.collection.List;

import flow.bpmn.model.FlowElement;
import flow.bpmn.model.FormProperty;
import flow.bpmn.model.StartEvent;
import flow.bpmn.model.UserTask;
import flow.common.interceptor.CommandContext;
import flow.engine.impl.persistence.entity.DeploymentEntity;
import flow.engine.impl.util.CommandContextUtil;
import flow.engine.impl.util.ProcessDefinitionUtil;
import flow.engine.repository.ProcessDefinition;
import flow.task.service.impl.persistence.entity.TaskEntity;
import flow.engine.impl.form.StartFormHandler;
import flow.bpmn.model.Process;
import flow.engine.impl.form.TaskFormHandler;
import flow.engine.impl.form.DefaultStartFormHandler;
import flow.engine.impl.form.DefaultTaskFormHandler;

/**
 * @author Joram Barrez
 */
class FormHandlerHelper {

    public StartFormHandler getStartFormHandler(CommandContext commandContext, ProcessDefinition processDefinition) {
        StartFormHandler startFormHandler = new DefaultStartFormHandler();
        flow.bpmn.model.Process.Process process = ProcessDefinitionUtil.getProcess(processDefinition.getId());

        FlowElement initialFlowElement = process.getInitialFlowElement();
        if (cast(StartEvent)initialFlowElement !is null) {

            StartEvent startEvent = cast(StartEvent) initialFlowElement;

            List!FormProperty formProperties = startEvent.getFormProperties();
            string formKey = startEvent.getFormKey();
            DeploymentEntity deploymentEntity = CommandContextUtil.getDeploymentEntityManager(commandContext).findById(processDefinition.getDeploymentId());

            startFormHandler.parseConfiguration(formProperties, formKey, deploymentEntity, processDefinition);
            return startFormHandler;
        }

        return null;

    }

    public TaskFormHandler getTaskFormHandlder(string processDefinitionId, string taskId) {
        flow.bpmn.model.Process.Process process = ProcessDefinitionUtil.getProcess(processDefinitionId);
        FlowElement flowElement = process.getFlowElement(taskId, true);
        if (cast(UserTask)flowElement !is null) {
            UserTask userTask = cast(UserTask) flowElement;

            ProcessDefinition processDefinitionEntity = ProcessDefinitionUtil.getProcessDefinition(processDefinitionId);
            DeploymentEntity deploymentEntity = CommandContextUtil.getProcessEngineConfiguration()
                    .getDeploymentEntityManager().findById(processDefinitionEntity.getDeploymentId());

            TaskFormHandler taskFormHandler = new DefaultTaskFormHandler();
            taskFormHandler.parseConfiguration(userTask.getFormProperties(), userTask.getFormKey(), deploymentEntity, processDefinitionEntity);

            return taskFormHandler;
        }

        return null;
    }

    public TaskFormHandler getTaskFormHandlder(TaskEntity taskEntity) {
        if (taskEntity.getProcessDefinitionId() !is null && taskEntity.getProcessDefinitionId().length != 0) {
            return getTaskFormHandlder(taskEntity.getProcessDefinitionId(), taskEntity.getTaskDefinitionKey());
        }
        return null;
    }

}
