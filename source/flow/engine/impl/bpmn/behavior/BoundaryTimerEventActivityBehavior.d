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
module flow.engine.impl.bpmn.behavior.BoundaryTimerEventActivityBehavior;

import flow.bpmn.model.BoundaryEvent;
import flow.bpmn.model.TimerEventDefinition;
import flow.common.api.FlowableException;
import flow.engine.deleg.DelegateExecution;
//import flow.engine.impl.jobexecutor.TimerEventHandler;
import flow.engine.impl.jobexecutor.TriggerTimerEventJobHandler;
import flow.engine.impl.persistence.entity.ExecutionEntity;
import flow.engine.impl.util.CommandContextUtil;
//import flow.engine.impl.util.TimerUtil;
import flow.job.service.impl.persistence.entity.TimerJobEntity;
import flow.engine.impl.bpmn.behavior.BoundaryEventActivityBehavior;
import hunt.Exceptions;

/**
 * @author Joram Barrez
 */
class BoundaryTimerEventActivityBehavior : BoundaryEventActivityBehavior {

    protected TimerEventDefinition timerEventDefinition;

    this(TimerEventDefinition timerEventDefinition, bool interrupting) {
        super(interrupting);
        this.timerEventDefinition = timerEventDefinition;
    }

    override
    public void execute(DelegateExecution execution) {

        ExecutionEntity executionEntity = cast(ExecutionEntity) execution;
        implementationMissing(false);
        //if (!(execution.getCurrentFlowElement() instanceof BoundaryEvent)) {
        //    throw new FlowableException("Programmatic error: " + this.getClass() + " should not be used for anything else than a boundary event");
        //}

        //TimerJobEntity timerJob = TimerUtil.createTimerEntityForTimerEventDefinition(timerEventDefinition, interrupting, executionEntity, TriggerTimerEventJobHandler.TYPE,
        //        TimerEventHandler.createConfiguration(execution.getCurrentActivityId(), timerEventDefinition.getEndDate(), timerEventDefinition.getCalendarName()));
        //if (timerJob !is null) {
        //    CommandContextUtil.getTimerJobService().scheduleTimerJob(timerJob);
        //}
    }

}
