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


import java.util.List;

import org.flowable.bpmn.model.FlowElement;
import org.flowable.bpmn.model.FormProperty;
import org.flowable.bpmn.model.StartEvent;
import org.flowable.bpmn.model.UserTask;
import flow.common.interceptor.CommandContext;
import flow.engine.impl.persistence.entity.DeploymentEntity;
import flow.engine.impl.util.CommandContextUtil;
import flow.engine.impl.util.ProcessDefinitionUtil;
import flow.engine.repository.ProcessDefinition;
import org.flowable.task.service.impl.persistence.entity.TaskEntity;

/**
 * @author Joram Barrez
 */
class FormHandlerHelper {

    public StartFormHandler getStartFormHandler(CommandContext commandContext, ProcessDefinition processDefinition) {
        StartFormHandler startFormHandler = new DefaultStartFormHandler();
        org.flowable.bpmn.model.Process process = ProcessDefinitionUtil.getProcess(processDefinition.getId());

        FlowElement initialFlowElement = process.getInitialFlowElement();
        if (initialFlowElement instanceof StartEvent) {

            StartEvent startEvent = (StartEvent) initialFlowElement;

            List<FormProperty> formProperties = startEvent.getFormProperties();
            string formKey = startEvent.getFormKey();
            DeploymentEntity deploymentEntity = CommandContextUtil.getDeploymentEntityManager(commandContext).findById(processDefinition.getDeploymentId());

            startFormHandler.parseConfiguration(formProperties, formKey, deploymentEntity, processDefinition);
            return startFormHandler;
        }

        return null;

    }

    public TaskFormHandler getTaskFormHandlder(string processDefinitionId, string taskId) {
        org.flowable.bpmn.model.Process process = ProcessDefinitionUtil.getProcess(processDefinitionId);
        FlowElement flowElement = process.getFlowElement(taskId, true);
        if (flowElement instanceof UserTask) {
            UserTask userTask = (UserTask) flowElement;

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
        if (taskEntity.getProcessDefinitionId() !is null) {
            return getTaskFormHandlder(taskEntity.getProcessDefinitionId(), taskEntity.getTaskDefinitionKey());
        }
        return null;
    }

}