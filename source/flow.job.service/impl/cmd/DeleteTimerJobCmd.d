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
module flow.job.service.impl.cmd.DeleteTimerJobCmd;


import flow.common.api.FlowableException;
import flow.common.api.FlowableIllegalArgumentException;
import flow.common.api.FlowableObjectNotFoundException;
import flow.common.api.deleg.event.FlowableEngineEventType;
import flow.common.api.deleg.event.FlowableEventDispatcher;
import flow.common.interceptor.Command;
import flow.common.interceptor.CommandContext;
import flow.job.service.api.Job;
import flow.job.service.event.impl.FlowableJobEventBuilder;
import flow.job.service.impl.persistence.entity.TimerJobEntity;
import flow.job.service.impl.util.CommandContextUtil;

/**
 * @author Tijs Rademakers
 */

class DeleteTimerJobCmd : Command!Object {


    protected string timerJobId;

    this(string timerJobId) {
        this.timerJobId = timerJobId;
    }

    public Object execute(CommandContext commandContext) {
        TimerJobEntity jobToDelete = getJobToDelete(commandContext);

        sendCancelEvent(commandContext, jobToDelete);

        CommandContextUtil.getTimerJobEntityManager(commandContext).dele(jobToDelete);
        return null;
    }

    protected void sendCancelEvent(CommandContext commandContext, TimerJobEntity jobToDelete) {
        FlowableEventDispatcher eventDispatcher = CommandContextUtil.getJobServiceConfiguration(commandContext).getEventDispatcher();
        if (eventDispatcher !is null && eventDispatcher.isEnabled()) {
            eventDispatcher
                .dispatchEvent(FlowableJobEventBuilder.createEntityEvent(FlowableEngineEventType.JOB_CANCELED, cast(Object)jobToDelete));
        }
    }

    protected TimerJobEntity getJobToDelete(CommandContext commandContext) {
        if (timerJobId is null) {
            throw new FlowableIllegalArgumentException("jobId is null");
        }
        //if (LOGGER.isDebugEnabled()) {
        //    LOGGER.debug("Deleting job {}", timerJobId);
        //}

        TimerJobEntity job = CommandContextUtil.getTimerJobEntityManager(commandContext).findById(timerJobId);
        if (job is null) {
            throw new FlowableObjectNotFoundException("No timer job found with id '" ~ timerJobId ~ "'");
        }

        // We need to check if the job was locked, ie acquired by the job acquisition thread
        // This happens if the job was already acquired, but not yet executed.
        // In that case, we can't allow to delete the job.
        if (job.getLockOwner() !is null) {
            throw new FlowableException("Cannot delete timer job when the job is being executed. Try again later.");
        }
        return job;
    }

}
