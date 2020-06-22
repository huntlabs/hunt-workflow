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
module flow.engine.impl.bpmn.behavior.IntermediateCatchTimerEventActivityBehavior;

import hunt.collection.List;

import flow.bpmn.model.TimerEventDefinition;
import flow.engine.deleg.DelegateExecution;
import flow.engine.history.DeleteReason;
//import flow.engine.impl.jobexecutor.TimerEventHandler;
import flow.engine.impl.jobexecutor.TriggerTimerEventJobHandler;
import flow.engine.impl.persistence.entity.ExecutionEntity;
import flow.engine.impl.util.CommandContextUtil;
//import flow.engine.impl.util.TimerUtil;
import flow.job.service.JobService;
import flow.job.service.impl.persistence.entity.JobEntity;
import flow.job.service.impl.persistence.entity.TimerJobEntity;
import flow.engine.impl.bpmn.behavior.IntermediateCatchEventActivityBehavior;
import hunt.Exceptions;

class IntermediateCatchTimerEventActivityBehavior : IntermediateCatchEventActivityBehavior {

    protected TimerEventDefinition timerEventDefinition;

    this(TimerEventDefinition timerEventDefinition) {
        this.timerEventDefinition = timerEventDefinition;
    }

    override
    public void execute(DelegateExecution execution) {
         implementationMissing(false);
        // end date should be ignored for intermediate timer events.
        //TimerJobEntity timerJob = TimerUtil.createTimerEntityForTimerEventDefinition(timerEventDefinition, false, cast(ExecutionEntity) execution, TriggerTimerEventJobHandler.TYPE,
        //        TimerEventHandler.createConfiguration(execution.getCurrentActivityId(), null, timerEventDefinition.getCalendarName()));
        //
        //if (timerJob !is null) {
        //    CommandContextUtil.getTimerJobService().scheduleTimerJob(timerJob);
        //}
    }

    override
    public void eventCancelledByEventGateway(DelegateExecution execution) {
        JobService jobService = CommandContextUtil.getJobService();
        List!JobEntity jobEntities = jobService.findJobsByExecutionId(execution.getId());

        foreach (JobEntity jobEntity ; jobEntities) { // Should be only one
            jobService.deleteJob(jobEntity);
        }

        CommandContextUtil.getExecutionEntityManager().deleteExecutionAndRelatedData(cast(ExecutionEntity) execution,
                DeleteReason.EVENT_BASED_GATEWAY_CANCEL, false);
    }

}
