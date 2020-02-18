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


import java.util.ArrayList;
import java.util.List;

import org.flowable.bpmn.model.EventDefinition;
import org.flowable.bpmn.model.FlowElement;
import org.flowable.bpmn.model.Process;
import org.flowable.bpmn.model.StartEvent;
import org.flowable.bpmn.model.TimerEventDefinition;
import flow.common.context.Context;
import flow.common.util.CollectionUtil;
import flow.engine.ProcessEngineConfiguration;
import flow.engine.impl.jobexecutor.TimerEventHandler;
import flow.engine.impl.jobexecutor.TimerStartEventJobHandler;
import flow.engine.impl.persistence.entity.ProcessDefinitionEntity;
import flow.engine.impl.util.CommandContextUtil;
import flow.engine.impl.util.TimerUtil;
import org.flowable.job.service.TimerJobService;
import org.flowable.job.service.impl.cmd.CancelJobsCmd;
import org.flowable.job.service.impl.persistence.entity.TimerJobEntity;

/**
 * Manages timers for newly-deployed process definitions and their previous versions.
 */
class TimerManager {

    protected void removeObsoleteTimers(ProcessDefinitionEntity processDefinition) {
        List<TimerJobEntity> jobsToDelete = null;

        if (processDefinition.getTenantId() !is null && !ProcessEngineConfiguration.NO_TENANT_ID.equals(processDefinition.getTenantId())) {
            jobsToDelete = CommandContextUtil.getTimerJobService().findJobsByTypeAndProcessDefinitionKeyAndTenantId(
                    TimerStartEventJobHandler.TYPE, processDefinition.getKey(), processDefinition.getTenantId());
        } else {
            jobsToDelete = CommandContextUtil.getTimerJobService()
                    .findJobsByTypeAndProcessDefinitionKeyNoTenantId(TimerStartEventJobHandler.TYPE, processDefinition.getKey());
        }

        if (jobsToDelete !is null) {
            for (TimerJobEntity job : jobsToDelete) {
                new CancelJobsCmd(job.getId()).execute(Context.getCommandContext());
            }
        }
    }

    protected void scheduleTimers(ProcessDefinitionEntity processDefinition, Process process) {
        TimerJobService timerJobService = CommandContextUtil.getTimerJobService();
        List<TimerJobEntity> timers = getTimerDeclarations(processDefinition, process);
        for (TimerJobEntity timer : timers) {
            timerJobService.scheduleTimerJob(timer);
        }
    }

    protected List<TimerJobEntity> getTimerDeclarations(ProcessDefinitionEntity processDefinition, Process process) {
        List<TimerJobEntity> timers = new ArrayList<>();
        if (CollectionUtil.isNotEmpty(process.getFlowElements())) {
            for (FlowElement element : process.getFlowElements()) {
                if (element instanceof StartEvent) {
                    StartEvent startEvent = (StartEvent) element;
                    if (CollectionUtil.isNotEmpty(startEvent.getEventDefinitions())) {
                        EventDefinition eventDefinition = startEvent.getEventDefinitions().get(0);
                        if (eventDefinition instanceof TimerEventDefinition) {
                            TimerEventDefinition timerEventDefinition = (TimerEventDefinition) eventDefinition;
                            TimerJobEntity timerJob = TimerUtil.createTimerEntityForTimerEventDefinition(timerEventDefinition, false, null, TimerStartEventJobHandler.TYPE,
                                    TimerEventHandler.createConfiguration(startEvent.getId(), timerEventDefinition.getEndDate(), timerEventDefinition.getCalendarName()));

                            if (timerJob !is null) {
                                timerJob.setProcessDefinitionId(processDefinition.getId());

                                if (processDefinition.getTenantId() !is null) {
                                    timerJob.setTenantId(processDefinition.getTenantId());
                                }
                                timers.add(timerJob);
                            }

                        }
                    }
                }
            }
        }

        return timers;
    }
}
