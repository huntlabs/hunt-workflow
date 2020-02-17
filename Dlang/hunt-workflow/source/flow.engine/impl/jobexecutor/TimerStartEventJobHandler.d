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


import org.flowable.bpmn.model.FlowElement;
import flow.common.api.FlowableException;
import flow.common.api.delegate.event.FlowableEngineEventType;
import flow.common.api.delegate.event.FlowableEventDispatcher;
import flow.common.interceptor.CommandContext;
import flow.engine.delegate.event.impl.FlowableEventBuilder;
import flow.engine.impl.cmd.StartProcessInstanceCmd;
import flow.engine.impl.persistence.entity.ProcessDefinitionEntity;
import flow.engine.impl.util.CommandContextUtil;
import flow.engine.impl.util.ProcessDefinitionUtil;
import flow.engine.impl.util.ProcessInstanceHelper;
import org.flowable.job.service.JobHandler;
import org.flowable.job.service.impl.persistence.entity.JobEntity;
import org.flowable.variable.api.delegate.VariableScope;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

class TimerStartEventJobHandler extends TimerEventHandler implements JobHandler {

    private static final Logger LOGGER = LoggerFactory.getLogger(TimerStartEventJobHandler.class);

    public static final string TYPE = "timer-start-event";

    @Override
    public string getType() {
        return TYPE;
    }

    @Override
    public void execute(JobEntity job, string configuration, VariableScope variableScope, CommandContext commandContext) {

        ProcessDefinitionEntity processDefinitionEntity = ProcessDefinitionUtil
                .getProcessDefinitionFromDatabase(job.getProcessDefinitionId()); // From DB -> need to get latest suspended state
        if (processDefinitionEntity == null) {
            throw new FlowableException("Could not find process definition needed for timer start event");
        }

        try {
            if (!processDefinitionEntity.isSuspended()) {

                FlowableEventDispatcher eventDispatcher = CommandContextUtil.getEventDispatcher();
                if (eventDispatcher != null && eventDispatcher.isEnabled()) {
                    eventDispatcher.dispatchEvent(FlowableEventBuilder.createEntityEvent(FlowableEngineEventType.TIMER_FIRED, job));
                }

                // Find initial flow element matching the signal start event
                org.flowable.bpmn.model.Process process = ProcessDefinitionUtil.getProcess(job.getProcessDefinitionId());
                string activityId = TimerEventHandler.getActivityIdFromConfiguration(configuration);
                if (activityId != null) {
                    FlowElement flowElement = process.getFlowElement(activityId, true);
                    if (flowElement == null) {
                        throw new FlowableException("Could not find matching FlowElement for activityId " + activityId);
                    }
                    ProcessInstanceHelper processInstanceHelper = CommandContextUtil.getProcessEngineConfiguration(commandContext).getProcessInstanceHelper();
                    processInstanceHelper.createAndStartProcessInstanceWithInitialFlowElement(processDefinitionEntity, null, null, flowElement, process, null, null, true);
                } else {
                    new StartProcessInstanceCmd(processDefinitionEntity.getKey(), null, null, null, job.getTenantId()).execute(commandContext);
                }

            } else {
                LOGGER.debug("ignoring timer of suspended process definition {}", processDefinitionEntity.getName());
            }
        } catch (RuntimeException e) {
            LOGGER.error("exception during timer execution", e);
            throw e;
        } catch (Exception e) {
            LOGGER.error("exception during timer execution", e);
            throw new FlowableException("exception during timer execution: " + e.getMessage(), e);
        }
    }
}
