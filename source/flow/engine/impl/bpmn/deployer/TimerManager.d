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
module flow.engine.impl.bpmn.deployer.TimerManager;

import hunt.collection.ArrayList;
import hunt.collection.List;

import flow.bpmn.model.EventDefinition;
import flow.bpmn.model.FlowElement;
import flow.bpmn.model.Process;
import flow.bpmn.model.StartEvent;
import flow.bpmn.model.TimerEventDefinition;
import flow.common.context.Context;
import flow.engine.ProcessEngineConfiguration;
//import flow.engine.impl.jobexecutor.TimerEventHandler;
//import flow.engine.impl.jobexecutor.TimerStartEventJobHandler;
import flow.engine.impl.persistence.entity.ProcessDefinitionEntity;
import flow.engine.impl.util.CommandContextUtil;
//import flow.engine.impl.util.TimerUtil;
import flow.job.service.TimerJobService;
import flow.job.service.impl.cmd.CancelJobsCmd;
import flow.job.service.impl.persistence.entity.TimerJobEntity;
import hunt.Exceptions;
/**
 * Manages timers for newly-deployed process definitions and their previous versions.
 */
class TimerManager {

    public void removeObsoleteTimers(ProcessDefinitionEntity processDefinition) {
        List!TimerJobEntity jobsToDelete = null;

        if (processDefinition.getTenantId() !is null && processDefinition.getTenantId().length != 0 && ProcessEngineConfiguration.NO_TENANT_ID != (processDefinition.getTenantId())) {
            implementationMissing(false);
            //jobsToDelete = CommandContextUtil.getTimerJobService().findJobsByTypeAndProcessDefinitionKeyAndTenantId(
            //        TimerStartEventJobHandler.TYPE, processDefinition.getKey(), processDefinition.getTenantId());
        } else {
            implementationMissing(false);
            //jobsToDelete = CommandContextUtil.getTimerJobService()
            //        .findJobsByTypeAndProcessDefinitionKeyNoTenantId(TimerStartEventJobHandler.TYPE, processDefinition.getKey());
        }

        if (jobsToDelete !is null) {
            foreach (TimerJobEntity job ; jobsToDelete) {
                new CancelJobsCmd(job.getId()).execute(Context.getCommandContext());
            }
        }
    }

    public void scheduleTimers(ProcessDefinitionEntity processDefinition, Process process) {
        TimerJobService timerJobService = CommandContextUtil.getTimerJobService();
        List!TimerJobEntity timers = getTimerDeclarations(processDefinition, process);
        foreach (TimerJobEntity timer ; timers) {
            timerJobService.scheduleTimerJob(timer);
        }
    }

    public List!TimerJobEntity getTimerDeclarations(ProcessDefinitionEntity processDefinition, Process process) {
        implementationMissing(false);
        return new ArrayList!TimerJobEntity;
        //List!TimerJobEntity timers = new ArrayList!TimerJobEntity;
        //if (process.getFlowElements() !is null &&  !process.getFlowElements().isEmpty()) {
        //    foreach (FlowElement element ; process.getFlowElements()) {
        //        if (cast(StartEvent)element !is null) {
        //            StartEvent startEvent = cast(StartEvent) element;
        //            if (startEvent.getEventDefinitions() !is null && !startEvent.getEventDefinitions().isEmpty()) {
        //                EventDefinition eventDefinition = startEvent.getEventDefinitions().get(0);
        //                if (cast(TimerEventDefinition)eventDefinition !is null) {
        //                    TimerEventDefinition timerEventDefinition = cast(TimerEventDefinition) eventDefinition;
        //                    TimerJobEntity timerJob = TimerUtil.createTimerEntityForTimerEventDefinition(timerEventDefinition, false, null, TimerStartEventJobHandler.TYPE,
        //                            TimerEventHandler.createConfiguration(startEvent.getId(), timerEventDefinition.getEndDate(), timerEventDefinition.getCalendarName()));
        //
        //                    if (timerJob !is null) {
        //                        timerJob.setProcessDefinitionId(processDefinition.getId());
        //
        //                        if (processDefinition.getTenantId() !is null && processDefinition.getTenantId().length != 0) {
        //                            timerJob.setTenantId(processDefinition.getTenantId());
        //                        }
        //                        timers.add(timerJob);
        //                    }
        //
        //                }
        //            }
        //        }
        //    }
        //}
        //
        //return timers;
    }
}
