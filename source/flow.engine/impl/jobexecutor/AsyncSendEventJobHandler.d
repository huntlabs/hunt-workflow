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
module flow.engine.impl.jobexecutor.AsyncSendEventJobHandler;

import hunt.collection;

import flow.bpmn.model.FlowElement;
import flow.bpmn.model.SendEventServiceTask;
import flow.common.api.FlowableException;
import flow.common.interceptor.CommandContext;
import flow.engine.ProcessEngineConfiguration;
import flow.engine.impl.persistence.entity.ExecutionEntity;
import flow.engine.impl.util.CommandContextUtil;
import flow.engine.impl.util.EventInstanceBpmnUtil;
import flow.event.registry.api.runtime.EventPayloadInstance;
import flow.event.registry.runtime.EventInstanceImpl;
import flow.event.registry.model.EventModel;
import flow.job.service.JobHandler;
import flow.job.service.impl.persistence.entity.JobEntity;
import flow.variable.service.api.deleg.VariableScope;

/**
 *
 * @author Tijs Rademakers
 */
class AsyncSendEventJobHandler : JobHandler {

    public static  string TYPE = "async-send-event";

    public string getType() {
        return TYPE;
    }

    public void execute(JobEntity job, string configuration, VariableScope variableScope, CommandContext commandContext) {
        ExecutionEntity executionEntity = cast(ExecutionEntity) variableScope;
        FlowElement flowElement = executionEntity.getCurrentFlowElement();

        //if (!(flowElement instanceof SendEventServiceTask)) {
        //    throw new FlowableException(string.format("unexpected activity type found for job %s, at activity %s", job.getId(), flowElement.getId()));
        //}
        SendEventServiceTask sendEventServiceTask = cast(SendEventServiceTask) flowElement;

        EventModel eventModel = null;
        if (ProcessEngineConfiguration.NO_TENANT_ID == job.getTenantId()) {
            eventModel = CommandContextUtil.getEventRepositoryService(commandContext).getEventModelByKey(sendEventServiceTask.getEventType());
        } else {
            eventModel = CommandContextUtil.getEventRepositoryService(commandContext).getEventModelByKey(sendEventServiceTask.getEventType(), job.getTenantId());
        }

        if (eventModel is null) {
            throw new FlowableException("No event model found for event key " );
        }

        EventInstanceImpl eventInstance = new EventInstanceImpl();
        eventInstance.setEventModel(eventModel);

        Collection!EventPayloadInstance eventPayloadInstances = EventInstanceBpmnUtil.createEventPayloadInstances(executionEntity,
                        CommandContextUtil.getProcessEngineConfiguration().getExpressionManager(), sendEventServiceTask, eventModel);
        eventInstance.setPayloadInstances(eventPayloadInstances);

        CommandContextUtil.getEventRegistry(commandContext).sendEventOutbound(eventInstance);

        if (!sendEventServiceTask.isTriggerable()) {
            CommandContextUtil.getAgenda(commandContext).planTakeOutgoingSequenceFlowsOperation(executionEntity, true);
        }
    }

}
