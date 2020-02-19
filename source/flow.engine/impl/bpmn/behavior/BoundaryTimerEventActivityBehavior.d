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


import org.flowable.bpmn.model.BoundaryEvent;
import org.flowable.bpmn.model.TimerEventDefinition;
import flow.common.api.FlowableException;
import flow.engine.deleg.DelegateExecution;
import flow.engine.impl.jobexecutor.TimerEventHandler;
import flow.engine.impl.jobexecutor.TriggerTimerEventJobHandler;
import flow.engine.impl.persistence.entity.ExecutionEntity;
import flow.engine.impl.util.CommandContextUtil;
import flow.engine.impl.util.TimerUtil;
import org.flowable.job.service.impl.persistence.entity.TimerJobEntity;

/**
 * @author Joram Barrez
 */
class BoundaryTimerEventActivityBehavior extends BoundaryEventActivityBehavior {

    private static final long serialVersionUID = 1L;

    protected TimerEventDefinition timerEventDefinition;

    public BoundaryTimerEventActivityBehavior(TimerEventDefinition timerEventDefinition, bool interrupting) {
        super(interrupting);
        this.timerEventDefinition = timerEventDefinition;
    }

    @Override
    public void execute(DelegateExecution execution) {

        ExecutionEntity executionEntity = (ExecutionEntity) execution;
        if (!(execution.getCurrentFlowElement() instanceof BoundaryEvent)) {
            throw new FlowableException("Programmatic error: " + this.getClass() + " should not be used for anything else than a boundary event");
        }

        TimerJobEntity timerJob = TimerUtil.createTimerEntityForTimerEventDefinition(timerEventDefinition, interrupting, executionEntity, TriggerTimerEventJobHandler.TYPE,
                TimerEventHandler.createConfiguration(execution.getCurrentActivityId(), timerEventDefinition.getEndDate(), timerEventDefinition.getCalendarName()));
        if (timerJob !is null) {
            CommandContextUtil.getTimerJobService().scheduleTimerJob(timerJob);
        }
    }

}